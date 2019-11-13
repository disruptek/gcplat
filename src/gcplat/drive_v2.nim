
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579380 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579380](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579380): Option[Scheme] {.used.} =
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
  gcpServiceName = "drive"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DriveAboutGet_579650 = ref object of OpenApiRestCall_579380
proc url_DriveAboutGet_579652(protocol: Scheme; host: string; base: string;
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

proc validate_DriveAboutGet_579651(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the current user along with Drive API settings
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
  ##   maxChangeIdCount: JString
  ##                   : Maximum number of remaining change IDs to count
  ##   includeSubscribed: JBool
  ##                    : Whether to count changes outside the My Drive hierarchy. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the maxChangeIdCount.
  ##   startChangeId: JString
  ##                : Change ID to start counting from when calculating number of remaining change IDs
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("alt")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("json"))
  if valid_579780 != nil:
    section.add "alt", valid_579780
  var valid_579781 = query.getOrDefault("userIp")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "userIp", valid_579781
  var valid_579782 = query.getOrDefault("quotaUser")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "quotaUser", valid_579782
  var valid_579783 = query.getOrDefault("maxChangeIdCount")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = newJString("1"))
  if valid_579783 != nil:
    section.add "maxChangeIdCount", valid_579783
  var valid_579784 = query.getOrDefault("includeSubscribed")
  valid_579784 = validateParameter(valid_579784, JBool, required = false,
                                 default = newJBool(true))
  if valid_579784 != nil:
    section.add "includeSubscribed", valid_579784
  var valid_579785 = query.getOrDefault("startChangeId")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "startChangeId", valid_579785
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
  if body != nil:
    result.add "body", body

proc call*(call_579809: Call_DriveAboutGet_579650; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the current user along with Drive API settings
  ## 
  let valid = call_579809.validator(path, query, header, formData, body)
  let scheme = call_579809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579809.url(scheme.get, call_579809.host, call_579809.base,
                         call_579809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579809, url, valid)

proc call*(call_579880: Call_DriveAboutGet_579650; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; maxChangeIdCount: string = "1";
          includeSubscribed: bool = true; startChangeId: string = "";
          fields: string = ""): Recallable =
  ## driveAboutGet
  ## Gets the information about the current user along with Drive API settings
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
  ##   maxChangeIdCount: string
  ##                   : Maximum number of remaining change IDs to count
  ##   includeSubscribed: bool
  ##                    : Whether to count changes outside the My Drive hierarchy. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the maxChangeIdCount.
  ##   startChangeId: string
  ##                : Change ID to start counting from when calculating number of remaining change IDs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579881 = newJObject()
  add(query_579881, "key", newJString(key))
  add(query_579881, "prettyPrint", newJBool(prettyPrint))
  add(query_579881, "oauth_token", newJString(oauthToken))
  add(query_579881, "alt", newJString(alt))
  add(query_579881, "userIp", newJString(userIp))
  add(query_579881, "quotaUser", newJString(quotaUser))
  add(query_579881, "maxChangeIdCount", newJString(maxChangeIdCount))
  add(query_579881, "includeSubscribed", newJBool(includeSubscribed))
  add(query_579881, "startChangeId", newJString(startChangeId))
  add(query_579881, "fields", newJString(fields))
  result = call_579880.call(nil, query_579881, nil, nil, nil)

var driveAboutGet* = Call_DriveAboutGet_579650(name: "driveAboutGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/about",
    validator: validate_DriveAboutGet_579651, base: "/drive/v2",
    url: url_DriveAboutGet_579652, schemes: {Scheme.Https})
type
  Call_DriveAppsList_579921 = ref object of OpenApiRestCall_579380
proc url_DriveAppsList_579923(protocol: Scheme; host: string; base: string;
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

proc validate_DriveAppsList_579922(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a user's installed apps.
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
  ##   appFilterExtensions: JString
  ##                      : A comma-separated list of file extensions for open with filtering. All apps within the given app query scope which can open any of the given file extensions will be included in the response. If appFilterMimeTypes are provided as well, the result is a union of the two resulting app lists.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   appFilterMimeTypes: JString
  ##                     : A comma-separated list of MIME types for open with filtering. All apps within the given app query scope which can open any of the given MIME types will be included in the response. If appFilterExtensions are provided as well, the result is a union of the two resulting app lists.
  ##   languageCode: JString
  ##               : A language or locale code, as defined by BCP 47, with some extensions from Unicode's LDML format (http://www.unicode.org/reports/tr35/).
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
  var valid_579927 = query.getOrDefault("appFilterExtensions")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = newJString(""))
  if valid_579927 != nil:
    section.add "appFilterExtensions", valid_579927
  var valid_579928 = query.getOrDefault("alt")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = newJString("json"))
  if valid_579928 != nil:
    section.add "alt", valid_579928
  var valid_579929 = query.getOrDefault("userIp")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "userIp", valid_579929
  var valid_579930 = query.getOrDefault("quotaUser")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "quotaUser", valid_579930
  var valid_579931 = query.getOrDefault("appFilterMimeTypes")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = newJString(""))
  if valid_579931 != nil:
    section.add "appFilterMimeTypes", valid_579931
  var valid_579932 = query.getOrDefault("languageCode")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "languageCode", valid_579932
  var valid_579933 = query.getOrDefault("fields")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "fields", valid_579933
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579934: Call_DriveAppsList_579921; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a user's installed apps.
  ## 
  let valid = call_579934.validator(path, query, header, formData, body)
  let scheme = call_579934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579934.url(scheme.get, call_579934.host, call_579934.base,
                         call_579934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579934, url, valid)

proc call*(call_579935: Call_DriveAppsList_579921; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          appFilterExtensions: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; appFilterMimeTypes: string = "";
          languageCode: string = ""; fields: string = ""): Recallable =
  ## driveAppsList
  ## Lists a user's installed apps.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   appFilterExtensions: string
  ##                      : A comma-separated list of file extensions for open with filtering. All apps within the given app query scope which can open any of the given file extensions will be included in the response. If appFilterMimeTypes are provided as well, the result is a union of the two resulting app lists.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   appFilterMimeTypes: string
  ##                     : A comma-separated list of MIME types for open with filtering. All apps within the given app query scope which can open any of the given MIME types will be included in the response. If appFilterExtensions are provided as well, the result is a union of the two resulting app lists.
  ##   languageCode: string
  ##               : A language or locale code, as defined by BCP 47, with some extensions from Unicode's LDML format (http://www.unicode.org/reports/tr35/).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579936 = newJObject()
  add(query_579936, "key", newJString(key))
  add(query_579936, "prettyPrint", newJBool(prettyPrint))
  add(query_579936, "oauth_token", newJString(oauthToken))
  add(query_579936, "appFilterExtensions", newJString(appFilterExtensions))
  add(query_579936, "alt", newJString(alt))
  add(query_579936, "userIp", newJString(userIp))
  add(query_579936, "quotaUser", newJString(quotaUser))
  add(query_579936, "appFilterMimeTypes", newJString(appFilterMimeTypes))
  add(query_579936, "languageCode", newJString(languageCode))
  add(query_579936, "fields", newJString(fields))
  result = call_579935.call(nil, query_579936, nil, nil, nil)

var driveAppsList* = Call_DriveAppsList_579921(name: "driveAppsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/apps",
    validator: validate_DriveAppsList_579922, base: "/drive/v2",
    url: url_DriveAppsList_579923, schemes: {Scheme.Https})
type
  Call_DriveAppsGet_579937 = ref object of OpenApiRestCall_579380
proc url_DriveAppsGet_579939(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveAppsGet_579938(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579954 = path.getOrDefault("appId")
  valid_579954 = validateParameter(valid_579954, JString, required = true,
                                 default = nil)
  if valid_579954 != nil:
    section.add "appId", valid_579954
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_579955 = query.getOrDefault("key")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "key", valid_579955
  var valid_579956 = query.getOrDefault("prettyPrint")
  valid_579956 = validateParameter(valid_579956, JBool, required = false,
                                 default = newJBool(true))
  if valid_579956 != nil:
    section.add "prettyPrint", valid_579956
  var valid_579957 = query.getOrDefault("oauth_token")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "oauth_token", valid_579957
  var valid_579958 = query.getOrDefault("alt")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = newJString("json"))
  if valid_579958 != nil:
    section.add "alt", valid_579958
  var valid_579959 = query.getOrDefault("userIp")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "userIp", valid_579959
  var valid_579960 = query.getOrDefault("quotaUser")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "quotaUser", valid_579960
  var valid_579961 = query.getOrDefault("fields")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "fields", valid_579961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579962: Call_DriveAppsGet_579937; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific app.
  ## 
  let valid = call_579962.validator(path, query, header, formData, body)
  let scheme = call_579962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579962.url(scheme.get, call_579962.host, call_579962.base,
                         call_579962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579962, url, valid)

proc call*(call_579963: Call_DriveAppsGet_579937; appId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveAppsGet
  ## Gets a specific app.
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
  ##   appId: string (required)
  ##        : The ID of the app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579964 = newJObject()
  var query_579965 = newJObject()
  add(query_579965, "key", newJString(key))
  add(query_579965, "prettyPrint", newJBool(prettyPrint))
  add(query_579965, "oauth_token", newJString(oauthToken))
  add(query_579965, "alt", newJString(alt))
  add(query_579965, "userIp", newJString(userIp))
  add(query_579965, "quotaUser", newJString(quotaUser))
  add(path_579964, "appId", newJString(appId))
  add(query_579965, "fields", newJString(fields))
  result = call_579963.call(path_579964, query_579965, nil, nil, nil)

var driveAppsGet* = Call_DriveAppsGet_579937(name: "driveAppsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/apps/{appId}",
    validator: validate_DriveAppsGet_579938, base: "/drive/v2",
    url: url_DriveAppsGet_579939, schemes: {Scheme.Https})
type
  Call_DriveChangesList_579966 = ref object of OpenApiRestCall_579380
proc url_DriveChangesList_579968(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChangesList_579967(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the changes for a user or shared drive.
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
  ##   driveId: JString
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeCorpusRemovals: JBool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   includeDeleted: JBool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   includeSubscribed: JBool
  ##                    : Whether to include changes outside the My Drive hierarchy in the result. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the result.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   startChangeId: JString
  ##                : Deprecated - use pageToken instead.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of changes to return.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  section = newJObject()
  var valid_579969 = query.getOrDefault("key")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "key", valid_579969
  var valid_579970 = query.getOrDefault("prettyPrint")
  valid_579970 = validateParameter(valid_579970, JBool, required = false,
                                 default = newJBool(true))
  if valid_579970 != nil:
    section.add "prettyPrint", valid_579970
  var valid_579971 = query.getOrDefault("oauth_token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "oauth_token", valid_579971
  var valid_579972 = query.getOrDefault("driveId")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "driveId", valid_579972
  var valid_579973 = query.getOrDefault("includeItemsFromAllDrives")
  valid_579973 = validateParameter(valid_579973, JBool, required = false,
                                 default = newJBool(false))
  if valid_579973 != nil:
    section.add "includeItemsFromAllDrives", valid_579973
  var valid_579974 = query.getOrDefault("spaces")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "spaces", valid_579974
  var valid_579975 = query.getOrDefault("alt")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = newJString("json"))
  if valid_579975 != nil:
    section.add "alt", valid_579975
  var valid_579976 = query.getOrDefault("userIp")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "userIp", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("includeCorpusRemovals")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(false))
  if valid_579978 != nil:
    section.add "includeCorpusRemovals", valid_579978
  var valid_579979 = query.getOrDefault("pageToken")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "pageToken", valid_579979
  var valid_579980 = query.getOrDefault("supportsTeamDrives")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(false))
  if valid_579980 != nil:
    section.add "supportsTeamDrives", valid_579980
  var valid_579981 = query.getOrDefault("includeDeleted")
  valid_579981 = validateParameter(valid_579981, JBool, required = false,
                                 default = newJBool(true))
  if valid_579981 != nil:
    section.add "includeDeleted", valid_579981
  var valid_579982 = query.getOrDefault("supportsAllDrives")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(false))
  if valid_579982 != nil:
    section.add "supportsAllDrives", valid_579982
  var valid_579983 = query.getOrDefault("includeSubscribed")
  valid_579983 = validateParameter(valid_579983, JBool, required = false,
                                 default = newJBool(true))
  if valid_579983 != nil:
    section.add "includeSubscribed", valid_579983
  var valid_579984 = query.getOrDefault("includeTeamDriveItems")
  valid_579984 = validateParameter(valid_579984, JBool, required = false,
                                 default = newJBool(false))
  if valid_579984 != nil:
    section.add "includeTeamDriveItems", valid_579984
  var valid_579985 = query.getOrDefault("startChangeId")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "startChangeId", valid_579985
  var valid_579986 = query.getOrDefault("fields")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "fields", valid_579986
  var valid_579988 = query.getOrDefault("maxResults")
  valid_579988 = validateParameter(valid_579988, JInt, required = false,
                                 default = newJInt(100))
  if valid_579988 != nil:
    section.add "maxResults", valid_579988
  var valid_579989 = query.getOrDefault("teamDriveId")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "teamDriveId", valid_579989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579990: Call_DriveChangesList_579966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the changes for a user or shared drive.
  ## 
  let valid = call_579990.validator(path, query, header, formData, body)
  let scheme = call_579990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579990.url(scheme.get, call_579990.host, call_579990.base,
                         call_579990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579990, url, valid)

proc call*(call_579991: Call_DriveChangesList_579966; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; driveId: string = "";
          includeItemsFromAllDrives: bool = false; spaces: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          includeCorpusRemovals: bool = false; pageToken: string = "";
          supportsTeamDrives: bool = false; includeDeleted: bool = true;
          supportsAllDrives: bool = false; includeSubscribed: bool = true;
          includeTeamDriveItems: bool = false; startChangeId: string = "";
          fields: string = ""; maxResults: int = 100; teamDriveId: string = ""): Recallable =
  ## driveChangesList
  ## Lists the changes for a user or shared drive.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   driveId: string
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeCorpusRemovals: bool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   includeDeleted: bool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   includeSubscribed: bool
  ##                    : Whether to include changes outside the My Drive hierarchy in the result. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the result.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   startChangeId: string
  ##                : Deprecated - use pageToken instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of changes to return.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  var query_579992 = newJObject()
  add(query_579992, "key", newJString(key))
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(query_579992, "driveId", newJString(driveId))
  add(query_579992, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_579992, "spaces", newJString(spaces))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "userIp", newJString(userIp))
  add(query_579992, "quotaUser", newJString(quotaUser))
  add(query_579992, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  add(query_579992, "pageToken", newJString(pageToken))
  add(query_579992, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579992, "includeDeleted", newJBool(includeDeleted))
  add(query_579992, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579992, "includeSubscribed", newJBool(includeSubscribed))
  add(query_579992, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_579992, "startChangeId", newJString(startChangeId))
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "maxResults", newJInt(maxResults))
  add(query_579992, "teamDriveId", newJString(teamDriveId))
  result = call_579991.call(nil, query_579992, nil, nil, nil)

var driveChangesList* = Call_DriveChangesList_579966(name: "driveChangesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/changes",
    validator: validate_DriveChangesList_579967, base: "/drive/v2",
    url: url_DriveChangesList_579968, schemes: {Scheme.Https})
type
  Call_DriveChangesGetStartPageToken_579993 = ref object of OpenApiRestCall_579380
proc url_DriveChangesGetStartPageToken_579995(protocol: Scheme; host: string;
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

proc validate_DriveChangesGetStartPageToken_579994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the starting pageToken for listing future changes.
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
  ##   driveId: JString
  ##          : The ID of the shared drive for which the starting pageToken for listing future changes from that shared drive will be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  section = newJObject()
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("prettyPrint")
  valid_579997 = validateParameter(valid_579997, JBool, required = false,
                                 default = newJBool(true))
  if valid_579997 != nil:
    section.add "prettyPrint", valid_579997
  var valid_579998 = query.getOrDefault("oauth_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "oauth_token", valid_579998
  var valid_579999 = query.getOrDefault("driveId")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "driveId", valid_579999
  var valid_580000 = query.getOrDefault("alt")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("json"))
  if valid_580000 != nil:
    section.add "alt", valid_580000
  var valid_580001 = query.getOrDefault("userIp")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "userIp", valid_580001
  var valid_580002 = query.getOrDefault("quotaUser")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "quotaUser", valid_580002
  var valid_580003 = query.getOrDefault("supportsTeamDrives")
  valid_580003 = validateParameter(valid_580003, JBool, required = false,
                                 default = newJBool(false))
  if valid_580003 != nil:
    section.add "supportsTeamDrives", valid_580003
  var valid_580004 = query.getOrDefault("supportsAllDrives")
  valid_580004 = validateParameter(valid_580004, JBool, required = false,
                                 default = newJBool(false))
  if valid_580004 != nil:
    section.add "supportsAllDrives", valid_580004
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
  var valid_580006 = query.getOrDefault("teamDriveId")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "teamDriveId", valid_580006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580007: Call_DriveChangesGetStartPageToken_579993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the starting pageToken for listing future changes.
  ## 
  let valid = call_580007.validator(path, query, header, formData, body)
  let scheme = call_580007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580007.url(scheme.get, call_580007.host, call_580007.base,
                         call_580007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580007, url, valid)

proc call*(call_580008: Call_DriveChangesGetStartPageToken_579993;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          driveId: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsTeamDrives: bool = false;
          supportsAllDrives: bool = false; fields: string = ""; teamDriveId: string = ""): Recallable =
  ## driveChangesGetStartPageToken
  ## Gets the starting pageToken for listing future changes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   driveId: string
  ##          : The ID of the shared drive for which the starting pageToken for listing future changes from that shared drive will be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  var query_580009 = newJObject()
  add(query_580009, "key", newJString(key))
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(query_580009, "driveId", newJString(driveId))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "userIp", newJString(userIp))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(query_580009, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580009, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "teamDriveId", newJString(teamDriveId))
  result = call_580008.call(nil, query_580009, nil, nil, nil)

var driveChangesGetStartPageToken* = Call_DriveChangesGetStartPageToken_579993(
    name: "driveChangesGetStartPageToken", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/changes/startPageToken",
    validator: validate_DriveChangesGetStartPageToken_579994, base: "/drive/v2",
    url: url_DriveChangesGetStartPageToken_579995, schemes: {Scheme.Https})
type
  Call_DriveChangesWatch_580010 = ref object of OpenApiRestCall_579380
proc url_DriveChangesWatch_580012(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChangesWatch_580011(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Subscribe to changes for a user.
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
  ##   driveId: JString
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeCorpusRemovals: JBool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   includeDeleted: JBool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   includeSubscribed: JBool
  ##                    : Whether to include changes outside the My Drive hierarchy in the result. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the result.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   startChangeId: JString
  ##                : Deprecated - use pageToken instead.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of changes to return.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  section = newJObject()
  var valid_580013 = query.getOrDefault("key")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "key", valid_580013
  var valid_580014 = query.getOrDefault("prettyPrint")
  valid_580014 = validateParameter(valid_580014, JBool, required = false,
                                 default = newJBool(true))
  if valid_580014 != nil:
    section.add "prettyPrint", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("driveId")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "driveId", valid_580016
  var valid_580017 = query.getOrDefault("includeItemsFromAllDrives")
  valid_580017 = validateParameter(valid_580017, JBool, required = false,
                                 default = newJBool(false))
  if valid_580017 != nil:
    section.add "includeItemsFromAllDrives", valid_580017
  var valid_580018 = query.getOrDefault("spaces")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "spaces", valid_580018
  var valid_580019 = query.getOrDefault("alt")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("json"))
  if valid_580019 != nil:
    section.add "alt", valid_580019
  var valid_580020 = query.getOrDefault("userIp")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "userIp", valid_580020
  var valid_580021 = query.getOrDefault("quotaUser")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "quotaUser", valid_580021
  var valid_580022 = query.getOrDefault("includeCorpusRemovals")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(false))
  if valid_580022 != nil:
    section.add "includeCorpusRemovals", valid_580022
  var valid_580023 = query.getOrDefault("pageToken")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "pageToken", valid_580023
  var valid_580024 = query.getOrDefault("supportsTeamDrives")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(false))
  if valid_580024 != nil:
    section.add "supportsTeamDrives", valid_580024
  var valid_580025 = query.getOrDefault("includeDeleted")
  valid_580025 = validateParameter(valid_580025, JBool, required = false,
                                 default = newJBool(true))
  if valid_580025 != nil:
    section.add "includeDeleted", valid_580025
  var valid_580026 = query.getOrDefault("supportsAllDrives")
  valid_580026 = validateParameter(valid_580026, JBool, required = false,
                                 default = newJBool(false))
  if valid_580026 != nil:
    section.add "supportsAllDrives", valid_580026
  var valid_580027 = query.getOrDefault("includeSubscribed")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "includeSubscribed", valid_580027
  var valid_580028 = query.getOrDefault("includeTeamDriveItems")
  valid_580028 = validateParameter(valid_580028, JBool, required = false,
                                 default = newJBool(false))
  if valid_580028 != nil:
    section.add "includeTeamDriveItems", valid_580028
  var valid_580029 = query.getOrDefault("startChangeId")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "startChangeId", valid_580029
  var valid_580030 = query.getOrDefault("fields")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "fields", valid_580030
  var valid_580031 = query.getOrDefault("maxResults")
  valid_580031 = validateParameter(valid_580031, JInt, required = false,
                                 default = newJInt(100))
  if valid_580031 != nil:
    section.add "maxResults", valid_580031
  var valid_580032 = query.getOrDefault("teamDriveId")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "teamDriveId", valid_580032
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

proc call*(call_580034: Call_DriveChangesWatch_580010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe to changes for a user.
  ## 
  let valid = call_580034.validator(path, query, header, formData, body)
  let scheme = call_580034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580034.url(scheme.get, call_580034.host, call_580034.base,
                         call_580034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580034, url, valid)

proc call*(call_580035: Call_DriveChangesWatch_580010; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; driveId: string = "";
          includeItemsFromAllDrives: bool = false; spaces: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          includeCorpusRemovals: bool = false; pageToken: string = "";
          supportsTeamDrives: bool = false; includeDeleted: bool = true;
          supportsAllDrives: bool = false; includeSubscribed: bool = true;
          includeTeamDriveItems: bool = false; resource: JsonNode = nil;
          startChangeId: string = ""; fields: string = ""; maxResults: int = 100;
          teamDriveId: string = ""): Recallable =
  ## driveChangesWatch
  ## Subscribe to changes for a user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   driveId: string
  ##          : The shared drive from which changes will be returned. If specified the change IDs will be reflective of the shared drive; use the combined drive ID and change ID as an identifier.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeCorpusRemovals: bool
  ##                        : Whether changes should include the file resource if the file is still accessible by the user at the time of the request, even when a file was removed from the list of changes and there will be no further change entries for this file.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   includeDeleted: bool
  ##                 : Whether to include changes indicating that items have been removed from the list of changes, for example by deletion or loss of access.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   includeSubscribed: bool
  ##                    : Whether to include changes outside the My Drive hierarchy in the result. When set to false, changes to files such as those in the Application Data folder or shared files which have not been added to My Drive will be omitted from the result.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   resource: JObject
  ##   startChangeId: string
  ##                : Deprecated - use pageToken instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of changes to return.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  var query_580036 = newJObject()
  var body_580037 = newJObject()
  add(query_580036, "key", newJString(key))
  add(query_580036, "prettyPrint", newJBool(prettyPrint))
  add(query_580036, "oauth_token", newJString(oauthToken))
  add(query_580036, "driveId", newJString(driveId))
  add(query_580036, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_580036, "spaces", newJString(spaces))
  add(query_580036, "alt", newJString(alt))
  add(query_580036, "userIp", newJString(userIp))
  add(query_580036, "quotaUser", newJString(quotaUser))
  add(query_580036, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  add(query_580036, "pageToken", newJString(pageToken))
  add(query_580036, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580036, "includeDeleted", newJBool(includeDeleted))
  add(query_580036, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580036, "includeSubscribed", newJBool(includeSubscribed))
  add(query_580036, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  if resource != nil:
    body_580037 = resource
  add(query_580036, "startChangeId", newJString(startChangeId))
  add(query_580036, "fields", newJString(fields))
  add(query_580036, "maxResults", newJInt(maxResults))
  add(query_580036, "teamDriveId", newJString(teamDriveId))
  result = call_580035.call(nil, query_580036, nil, nil, body_580037)

var driveChangesWatch* = Call_DriveChangesWatch_580010(name: "driveChangesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/changes/watch",
    validator: validate_DriveChangesWatch_580011, base: "/drive/v2",
    url: url_DriveChangesWatch_580012, schemes: {Scheme.Https})
type
  Call_DriveChangesGet_580038 = ref object of OpenApiRestCall_579380
proc url_DriveChangesGet_580040(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveChangesGet_580039(path: JsonNode; query: JsonNode;
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
  var valid_580041 = path.getOrDefault("changeId")
  valid_580041 = validateParameter(valid_580041, JString, required = true,
                                 default = nil)
  if valid_580041 != nil:
    section.add "changeId", valid_580041
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   driveId: JString
  ##          : The shared drive from which the change will be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  section = newJObject()
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("prettyPrint")
  valid_580043 = validateParameter(valid_580043, JBool, required = false,
                                 default = newJBool(true))
  if valid_580043 != nil:
    section.add "prettyPrint", valid_580043
  var valid_580044 = query.getOrDefault("oauth_token")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "oauth_token", valid_580044
  var valid_580045 = query.getOrDefault("driveId")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "driveId", valid_580045
  var valid_580046 = query.getOrDefault("alt")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = newJString("json"))
  if valid_580046 != nil:
    section.add "alt", valid_580046
  var valid_580047 = query.getOrDefault("userIp")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "userIp", valid_580047
  var valid_580048 = query.getOrDefault("quotaUser")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "quotaUser", valid_580048
  var valid_580049 = query.getOrDefault("supportsTeamDrives")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(false))
  if valid_580049 != nil:
    section.add "supportsTeamDrives", valid_580049
  var valid_580050 = query.getOrDefault("supportsAllDrives")
  valid_580050 = validateParameter(valid_580050, JBool, required = false,
                                 default = newJBool(false))
  if valid_580050 != nil:
    section.add "supportsAllDrives", valid_580050
  var valid_580051 = query.getOrDefault("fields")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "fields", valid_580051
  var valid_580052 = query.getOrDefault("teamDriveId")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "teamDriveId", valid_580052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580053: Call_DriveChangesGet_580038; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated - Use changes.getStartPageToken and changes.list to retrieve recent changes.
  ## 
  let valid = call_580053.validator(path, query, header, formData, body)
  let scheme = call_580053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580053.url(scheme.get, call_580053.host, call_580053.base,
                         call_580053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580053, url, valid)

proc call*(call_580054: Call_DriveChangesGet_580038; changeId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          driveId: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsTeamDrives: bool = false;
          supportsAllDrives: bool = false; fields: string = ""; teamDriveId: string = ""): Recallable =
  ## driveChangesGet
  ## Deprecated - Use changes.getStartPageToken and changes.list to retrieve recent changes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   driveId: string
  ##          : The shared drive from which the change will be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   changeId: string (required)
  ##           : The ID of the change.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  var path_580055 = newJObject()
  var query_580056 = newJObject()
  add(query_580056, "key", newJString(key))
  add(query_580056, "prettyPrint", newJBool(prettyPrint))
  add(query_580056, "oauth_token", newJString(oauthToken))
  add(query_580056, "driveId", newJString(driveId))
  add(query_580056, "alt", newJString(alt))
  add(query_580056, "userIp", newJString(userIp))
  add(query_580056, "quotaUser", newJString(quotaUser))
  add(query_580056, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580056, "supportsAllDrives", newJBool(supportsAllDrives))
  add(path_580055, "changeId", newJString(changeId))
  add(query_580056, "fields", newJString(fields))
  add(query_580056, "teamDriveId", newJString(teamDriveId))
  result = call_580054.call(path_580055, query_580056, nil, nil, nil)

var driveChangesGet* = Call_DriveChangesGet_580038(name: "driveChangesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/changes/{changeId}", validator: validate_DriveChangesGet_580039,
    base: "/drive/v2", url: url_DriveChangesGet_580040, schemes: {Scheme.Https})
type
  Call_DriveChannelsStop_580057 = ref object of OpenApiRestCall_579380
proc url_DriveChannelsStop_580059(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChannelsStop_580058(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
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
  var valid_580060 = query.getOrDefault("key")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "key", valid_580060
  var valid_580061 = query.getOrDefault("prettyPrint")
  valid_580061 = validateParameter(valid_580061, JBool, required = false,
                                 default = newJBool(true))
  if valid_580061 != nil:
    section.add "prettyPrint", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("alt")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("json"))
  if valid_580063 != nil:
    section.add "alt", valid_580063
  var valid_580064 = query.getOrDefault("userIp")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "userIp", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("fields")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "fields", valid_580066
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

proc call*(call_580068: Call_DriveChannelsStop_580057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_580068.validator(path, query, header, formData, body)
  let scheme = call_580068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580068.url(scheme.get, call_580068.host, call_580068.base,
                         call_580068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580068, url, valid)

proc call*(call_580069: Call_DriveChannelsStop_580057; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; resource: JsonNode = nil;
          fields: string = ""): Recallable =
  ## driveChannelsStop
  ## Stop watching resources through this channel
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
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580070 = newJObject()
  var body_580071 = newJObject()
  add(query_580070, "key", newJString(key))
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "alt", newJString(alt))
  add(query_580070, "userIp", newJString(userIp))
  add(query_580070, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_580071 = resource
  add(query_580070, "fields", newJString(fields))
  result = call_580069.call(nil, query_580070, nil, nil, body_580071)

var driveChannelsStop* = Call_DriveChannelsStop_580057(name: "driveChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_DriveChannelsStop_580058, base: "/drive/v2",
    url: url_DriveChannelsStop_580059, schemes: {Scheme.Https})
type
  Call_DriveDrivesInsert_580089 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesInsert_580091(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesInsert_580090(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new shared drive.
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
  ##   requestId: JString (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a shared drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same shared drive. If the shared drive already exists a 409 error will be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580092 = query.getOrDefault("key")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "key", valid_580092
  var valid_580093 = query.getOrDefault("prettyPrint")
  valid_580093 = validateParameter(valid_580093, JBool, required = false,
                                 default = newJBool(true))
  if valid_580093 != nil:
    section.add "prettyPrint", valid_580093
  var valid_580094 = query.getOrDefault("oauth_token")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "oauth_token", valid_580094
  var valid_580095 = query.getOrDefault("alt")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("json"))
  if valid_580095 != nil:
    section.add "alt", valid_580095
  var valid_580096 = query.getOrDefault("userIp")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "userIp", valid_580096
  var valid_580097 = query.getOrDefault("quotaUser")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "quotaUser", valid_580097
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_580098 = query.getOrDefault("requestId")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = nil)
  if valid_580098 != nil:
    section.add "requestId", valid_580098
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

proc call*(call_580101: Call_DriveDrivesInsert_580089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new shared drive.
  ## 
  let valid = call_580101.validator(path, query, header, formData, body)
  let scheme = call_580101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580101.url(scheme.get, call_580101.host, call_580101.base,
                         call_580101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580101, url, valid)

proc call*(call_580102: Call_DriveDrivesInsert_580089; requestId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveDrivesInsert
  ## Creates a new shared drive.
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
  ##   requestId: string (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a shared drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same shared drive. If the shared drive already exists a 409 error will be returned.
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
  add(query_580103, "requestId", newJString(requestId))
  add(query_580103, "fields", newJString(fields))
  result = call_580102.call(nil, query_580103, nil, nil, body_580104)

var driveDrivesInsert* = Call_DriveDrivesInsert_580089(name: "driveDrivesInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesInsert_580090, base: "/drive/v2",
    url: url_DriveDrivesInsert_580091, schemes: {Scheme.Https})
type
  Call_DriveDrivesList_580072 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesList_580074(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesList_580073(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists the user's shared drives.
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
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then all shared drives of the domain in which the requester is an administrator are returned.
  ##   q: JString
  ##    : Query string for searching shared drives.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Page token for shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of shared drives to return.
  section = newJObject()
  var valid_580075 = query.getOrDefault("key")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "key", valid_580075
  var valid_580076 = query.getOrDefault("prettyPrint")
  valid_580076 = validateParameter(valid_580076, JBool, required = false,
                                 default = newJBool(true))
  if valid_580076 != nil:
    section.add "prettyPrint", valid_580076
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("useDomainAdminAccess")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(false))
  if valid_580078 != nil:
    section.add "useDomainAdminAccess", valid_580078
  var valid_580079 = query.getOrDefault("q")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "q", valid_580079
  var valid_580080 = query.getOrDefault("alt")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("json"))
  if valid_580080 != nil:
    section.add "alt", valid_580080
  var valid_580081 = query.getOrDefault("userIp")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "userIp", valid_580081
  var valid_580082 = query.getOrDefault("quotaUser")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "quotaUser", valid_580082
  var valid_580083 = query.getOrDefault("pageToken")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "pageToken", valid_580083
  var valid_580084 = query.getOrDefault("fields")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "fields", valid_580084
  var valid_580085 = query.getOrDefault("maxResults")
  valid_580085 = validateParameter(valid_580085, JInt, required = false,
                                 default = newJInt(10))
  if valid_580085 != nil:
    section.add "maxResults", valid_580085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580086: Call_DriveDrivesList_580072; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's shared drives.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_DriveDrivesList_580072; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; q: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 10): Recallable =
  ## driveDrivesList
  ## Lists the user's shared drives.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then all shared drives of the domain in which the requester is an administrator are returned.
  ##   q: string
  ##    : Query string for searching shared drives.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Page token for shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of shared drives to return.
  var query_580088 = newJObject()
  add(query_580088, "key", newJString(key))
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(query_580088, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580088, "q", newJString(q))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "userIp", newJString(userIp))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(query_580088, "pageToken", newJString(pageToken))
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "maxResults", newJInt(maxResults))
  result = call_580087.call(nil, query_580088, nil, nil, nil)

var driveDrivesList* = Call_DriveDrivesList_580072(name: "driveDrivesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesList_580073, base: "/drive/v2",
    url: url_DriveDrivesList_580074, schemes: {Scheme.Https})
type
  Call_DriveDrivesUpdate_580121 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesUpdate_580123(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveDrivesUpdate_580122(path: JsonNode; query: JsonNode;
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
  var valid_580124 = path.getOrDefault("driveId")
  valid_580124 = validateParameter(valid_580124, JString, required = true,
                                 default = nil)
  if valid_580124 != nil:
    section.add "driveId", valid_580124
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580125 = query.getOrDefault("key")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "key", valid_580125
  var valid_580126 = query.getOrDefault("prettyPrint")
  valid_580126 = validateParameter(valid_580126, JBool, required = false,
                                 default = newJBool(true))
  if valid_580126 != nil:
    section.add "prettyPrint", valid_580126
  var valid_580127 = query.getOrDefault("oauth_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "oauth_token", valid_580127
  var valid_580128 = query.getOrDefault("useDomainAdminAccess")
  valid_580128 = validateParameter(valid_580128, JBool, required = false,
                                 default = newJBool(false))
  if valid_580128 != nil:
    section.add "useDomainAdminAccess", valid_580128
  var valid_580129 = query.getOrDefault("alt")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = newJString("json"))
  if valid_580129 != nil:
    section.add "alt", valid_580129
  var valid_580130 = query.getOrDefault("userIp")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "userIp", valid_580130
  var valid_580131 = query.getOrDefault("quotaUser")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "quotaUser", valid_580131
  var valid_580132 = query.getOrDefault("fields")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "fields", valid_580132
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

proc call*(call_580134: Call_DriveDrivesUpdate_580121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadata for a shared drive.
  ## 
  let valid = call_580134.validator(path, query, header, formData, body)
  let scheme = call_580134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580134.url(scheme.get, call_580134.host, call_580134.base,
                         call_580134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580134, url, valid)

proc call*(call_580135: Call_DriveDrivesUpdate_580121; driveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveDrivesUpdate
  ## Updates the metadata for a shared drive.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580136 = newJObject()
  var query_580137 = newJObject()
  var body_580138 = newJObject()
  add(query_580137, "key", newJString(key))
  add(query_580137, "prettyPrint", newJBool(prettyPrint))
  add(query_580137, "oauth_token", newJString(oauthToken))
  add(query_580137, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580137, "alt", newJString(alt))
  add(query_580137, "userIp", newJString(userIp))
  add(query_580137, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580138 = body
  add(path_580136, "driveId", newJString(driveId))
  add(query_580137, "fields", newJString(fields))
  result = call_580135.call(path_580136, query_580137, nil, nil, body_580138)

var driveDrivesUpdate* = Call_DriveDrivesUpdate_580121(name: "driveDrivesUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesUpdate_580122,
    base: "/drive/v2", url: url_DriveDrivesUpdate_580123, schemes: {Scheme.Https})
type
  Call_DriveDrivesGet_580105 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesGet_580107(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveDrivesGet_580106(path: JsonNode; query: JsonNode;
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
  var valid_580108 = path.getOrDefault("driveId")
  valid_580108 = validateParameter(valid_580108, JString, required = true,
                                 default = nil)
  if valid_580108 != nil:
    section.add "driveId", valid_580108
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580109 = query.getOrDefault("key")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "key", valid_580109
  var valid_580110 = query.getOrDefault("prettyPrint")
  valid_580110 = validateParameter(valid_580110, JBool, required = false,
                                 default = newJBool(true))
  if valid_580110 != nil:
    section.add "prettyPrint", valid_580110
  var valid_580111 = query.getOrDefault("oauth_token")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "oauth_token", valid_580111
  var valid_580112 = query.getOrDefault("useDomainAdminAccess")
  valid_580112 = validateParameter(valid_580112, JBool, required = false,
                                 default = newJBool(false))
  if valid_580112 != nil:
    section.add "useDomainAdminAccess", valid_580112
  var valid_580113 = query.getOrDefault("alt")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("json"))
  if valid_580113 != nil:
    section.add "alt", valid_580113
  var valid_580114 = query.getOrDefault("userIp")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "userIp", valid_580114
  var valid_580115 = query.getOrDefault("quotaUser")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "quotaUser", valid_580115
  var valid_580116 = query.getOrDefault("fields")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "fields", valid_580116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580117: Call_DriveDrivesGet_580105; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a shared drive's metadata by ID.
  ## 
  let valid = call_580117.validator(path, query, header, formData, body)
  let scheme = call_580117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580117.url(scheme.get, call_580117.host, call_580117.base,
                         call_580117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580117, url, valid)

proc call*(call_580118: Call_DriveDrivesGet_580105; driveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveDrivesGet
  ## Gets a shared drive's metadata by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the shared drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580119 = newJObject()
  var query_580120 = newJObject()
  add(query_580120, "key", newJString(key))
  add(query_580120, "prettyPrint", newJBool(prettyPrint))
  add(query_580120, "oauth_token", newJString(oauthToken))
  add(query_580120, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580120, "alt", newJString(alt))
  add(query_580120, "userIp", newJString(userIp))
  add(query_580120, "quotaUser", newJString(quotaUser))
  add(path_580119, "driveId", newJString(driveId))
  add(query_580120, "fields", newJString(fields))
  result = call_580118.call(path_580119, query_580120, nil, nil, nil)

var driveDrivesGet* = Call_DriveDrivesGet_580105(name: "driveDrivesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesGet_580106,
    base: "/drive/v2", url: url_DriveDrivesGet_580107, schemes: {Scheme.Https})
type
  Call_DriveDrivesDelete_580139 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesDelete_580141(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveDrivesDelete_580140(path: JsonNode; query: JsonNode;
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
  var valid_580142 = path.getOrDefault("driveId")
  valid_580142 = validateParameter(valid_580142, JString, required = true,
                                 default = nil)
  if valid_580142 != nil:
    section.add "driveId", valid_580142
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580143 = query.getOrDefault("key")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "key", valid_580143
  var valid_580144 = query.getOrDefault("prettyPrint")
  valid_580144 = validateParameter(valid_580144, JBool, required = false,
                                 default = newJBool(true))
  if valid_580144 != nil:
    section.add "prettyPrint", valid_580144
  var valid_580145 = query.getOrDefault("oauth_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "oauth_token", valid_580145
  var valid_580146 = query.getOrDefault("alt")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("json"))
  if valid_580146 != nil:
    section.add "alt", valid_580146
  var valid_580147 = query.getOrDefault("userIp")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "userIp", valid_580147
  var valid_580148 = query.getOrDefault("quotaUser")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "quotaUser", valid_580148
  var valid_580149 = query.getOrDefault("fields")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "fields", valid_580149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580150: Call_DriveDrivesDelete_580139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  let valid = call_580150.validator(path, query, header, formData, body)
  let scheme = call_580150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580150.url(scheme.get, call_580150.host, call_580150.base,
                         call_580150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580150, url, valid)

proc call*(call_580151: Call_DriveDrivesDelete_580139; driveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## driveDrivesDelete
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
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
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580152 = newJObject()
  var query_580153 = newJObject()
  add(query_580153, "key", newJString(key))
  add(query_580153, "prettyPrint", newJBool(prettyPrint))
  add(query_580153, "oauth_token", newJString(oauthToken))
  add(query_580153, "alt", newJString(alt))
  add(query_580153, "userIp", newJString(userIp))
  add(query_580153, "quotaUser", newJString(quotaUser))
  add(path_580152, "driveId", newJString(driveId))
  add(query_580153, "fields", newJString(fields))
  result = call_580151.call(path_580152, query_580153, nil, nil, nil)

var driveDrivesDelete* = Call_DriveDrivesDelete_580139(name: "driveDrivesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesDelete_580140,
    base: "/drive/v2", url: url_DriveDrivesDelete_580141, schemes: {Scheme.Https})
type
  Call_DriveDrivesHide_580154 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesHide_580156(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveDrivesHide_580155(path: JsonNode; query: JsonNode;
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
  var valid_580157 = path.getOrDefault("driveId")
  valid_580157 = validateParameter(valid_580157, JString, required = true,
                                 default = nil)
  if valid_580157 != nil:
    section.add "driveId", valid_580157
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580158 = query.getOrDefault("key")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "key", valid_580158
  var valid_580159 = query.getOrDefault("prettyPrint")
  valid_580159 = validateParameter(valid_580159, JBool, required = false,
                                 default = newJBool(true))
  if valid_580159 != nil:
    section.add "prettyPrint", valid_580159
  var valid_580160 = query.getOrDefault("oauth_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "oauth_token", valid_580160
  var valid_580161 = query.getOrDefault("alt")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("json"))
  if valid_580161 != nil:
    section.add "alt", valid_580161
  var valid_580162 = query.getOrDefault("userIp")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "userIp", valid_580162
  var valid_580163 = query.getOrDefault("quotaUser")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "quotaUser", valid_580163
  var valid_580164 = query.getOrDefault("fields")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "fields", valid_580164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580165: Call_DriveDrivesHide_580154; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hides a shared drive from the default view.
  ## 
  let valid = call_580165.validator(path, query, header, formData, body)
  let scheme = call_580165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580165.url(scheme.get, call_580165.host, call_580165.base,
                         call_580165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580165, url, valid)

proc call*(call_580166: Call_DriveDrivesHide_580154; driveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## driveDrivesHide
  ## Hides a shared drive from the default view.
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
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580167 = newJObject()
  var query_580168 = newJObject()
  add(query_580168, "key", newJString(key))
  add(query_580168, "prettyPrint", newJBool(prettyPrint))
  add(query_580168, "oauth_token", newJString(oauthToken))
  add(query_580168, "alt", newJString(alt))
  add(query_580168, "userIp", newJString(userIp))
  add(query_580168, "quotaUser", newJString(quotaUser))
  add(path_580167, "driveId", newJString(driveId))
  add(query_580168, "fields", newJString(fields))
  result = call_580166.call(path_580167, query_580168, nil, nil, nil)

var driveDrivesHide* = Call_DriveDrivesHide_580154(name: "driveDrivesHide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/hide", validator: validate_DriveDrivesHide_580155,
    base: "/drive/v2", url: url_DriveDrivesHide_580156, schemes: {Scheme.Https})
type
  Call_DriveDrivesUnhide_580169 = ref object of OpenApiRestCall_579380
proc url_DriveDrivesUnhide_580171(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveDrivesUnhide_580170(path: JsonNode; query: JsonNode;
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
  var valid_580172 = path.getOrDefault("driveId")
  valid_580172 = validateParameter(valid_580172, JString, required = true,
                                 default = nil)
  if valid_580172 != nil:
    section.add "driveId", valid_580172
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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

proc call*(call_580180: Call_DriveDrivesUnhide_580169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a shared drive to the default view.
  ## 
  let valid = call_580180.validator(path, query, header, formData, body)
  let scheme = call_580180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580180.url(scheme.get, call_580180.host, call_580180.base,
                         call_580180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580180, url, valid)

proc call*(call_580181: Call_DriveDrivesUnhide_580169; driveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## driveDrivesUnhide
  ## Restores a shared drive to the default view.
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
  ##   driveId: string (required)
  ##          : The ID of the shared drive.
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
  add(path_580182, "driveId", newJString(driveId))
  add(query_580183, "fields", newJString(fields))
  result = call_580181.call(path_580182, query_580183, nil, nil, nil)

var driveDrivesUnhide* = Call_DriveDrivesUnhide_580169(name: "driveDrivesUnhide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/unhide", validator: validate_DriveDrivesUnhide_580170,
    base: "/drive/v2", url: url_DriveDrivesUnhide_580171, schemes: {Scheme.Https})
type
  Call_DriveFilesInsert_580211 = ref object of OpenApiRestCall_579380
proc url_DriveFilesInsert_580213(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesInsert_580212(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Insert a new file.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: JBool
  ##                            : Whether to use the content as indexable text.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   ocr: JBool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   ocrLanguage: JString
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextLanguage: JString
  ##                    : The language of the timed text.
  ##   convert: JBool
  ##          : Whether to convert this file to the corresponding Google Docs format.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   timedTextTrackName: JString
  ##                     : The timed text track name.
  ##   visibility: JString
  ##             : The visibility of the new file. This parameter is only relevant when convert=false.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pinned: JBool
  ##         : Whether to pin the head revision of the uploaded file. A file can have a maximum of 200 pinned revisions.
  section = newJObject()
  var valid_580214 = query.getOrDefault("key")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "key", valid_580214
  var valid_580215 = query.getOrDefault("useContentAsIndexableText")
  valid_580215 = validateParameter(valid_580215, JBool, required = false,
                                 default = newJBool(false))
  if valid_580215 != nil:
    section.add "useContentAsIndexableText", valid_580215
  var valid_580216 = query.getOrDefault("prettyPrint")
  valid_580216 = validateParameter(valid_580216, JBool, required = false,
                                 default = newJBool(true))
  if valid_580216 != nil:
    section.add "prettyPrint", valid_580216
  var valid_580217 = query.getOrDefault("oauth_token")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "oauth_token", valid_580217
  var valid_580218 = query.getOrDefault("ocr")
  valid_580218 = validateParameter(valid_580218, JBool, required = false,
                                 default = newJBool(false))
  if valid_580218 != nil:
    section.add "ocr", valid_580218
  var valid_580219 = query.getOrDefault("ocrLanguage")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "ocrLanguage", valid_580219
  var valid_580220 = query.getOrDefault("timedTextLanguage")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "timedTextLanguage", valid_580220
  var valid_580221 = query.getOrDefault("convert")
  valid_580221 = validateParameter(valid_580221, JBool, required = false,
                                 default = newJBool(false))
  if valid_580221 != nil:
    section.add "convert", valid_580221
  var valid_580222 = query.getOrDefault("alt")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = newJString("json"))
  if valid_580222 != nil:
    section.add "alt", valid_580222
  var valid_580223 = query.getOrDefault("userIp")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "userIp", valid_580223
  var valid_580224 = query.getOrDefault("quotaUser")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "quotaUser", valid_580224
  var valid_580225 = query.getOrDefault("supportsTeamDrives")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(false))
  if valid_580225 != nil:
    section.add "supportsTeamDrives", valid_580225
  var valid_580226 = query.getOrDefault("timedTextTrackName")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "timedTextTrackName", valid_580226
  var valid_580227 = query.getOrDefault("visibility")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_580227 != nil:
    section.add "visibility", valid_580227
  var valid_580228 = query.getOrDefault("supportsAllDrives")
  valid_580228 = validateParameter(valid_580228, JBool, required = false,
                                 default = newJBool(false))
  if valid_580228 != nil:
    section.add "supportsAllDrives", valid_580228
  var valid_580229 = query.getOrDefault("fields")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "fields", valid_580229
  var valid_580230 = query.getOrDefault("pinned")
  valid_580230 = validateParameter(valid_580230, JBool, required = false,
                                 default = newJBool(false))
  if valid_580230 != nil:
    section.add "pinned", valid_580230
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

proc call*(call_580232: Call_DriveFilesInsert_580211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Insert a new file.
  ## 
  let valid = call_580232.validator(path, query, header, formData, body)
  let scheme = call_580232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580232.url(scheme.get, call_580232.host, call_580232.base,
                         call_580232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580232, url, valid)

proc call*(call_580233: Call_DriveFilesInsert_580211; key: string = "";
          useContentAsIndexableText: bool = false; prettyPrint: bool = true;
          oauthToken: string = ""; ocr: bool = false; ocrLanguage: string = "";
          timedTextLanguage: string = ""; convert: bool = false; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; supportsTeamDrives: bool = false;
          timedTextTrackName: string = ""; visibility: string = "DEFAULT";
          supportsAllDrives: bool = false; body: JsonNode = nil; fields: string = "";
          pinned: bool = false): Recallable =
  ## driveFilesInsert
  ## Insert a new file.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: bool
  ##                            : Whether to use the content as indexable text.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   ocr: bool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   ocrLanguage: string
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextLanguage: string
  ##                    : The language of the timed text.
  ##   convert: bool
  ##          : Whether to convert this file to the corresponding Google Docs format.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   timedTextTrackName: string
  ##                     : The timed text track name.
  ##   visibility: string
  ##             : The visibility of the new file. This parameter is only relevant when convert=false.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pinned: bool
  ##         : Whether to pin the head revision of the uploaded file. A file can have a maximum of 200 pinned revisions.
  var query_580234 = newJObject()
  var body_580235 = newJObject()
  add(query_580234, "key", newJString(key))
  add(query_580234, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_580234, "prettyPrint", newJBool(prettyPrint))
  add(query_580234, "oauth_token", newJString(oauthToken))
  add(query_580234, "ocr", newJBool(ocr))
  add(query_580234, "ocrLanguage", newJString(ocrLanguage))
  add(query_580234, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_580234, "convert", newJBool(convert))
  add(query_580234, "alt", newJString(alt))
  add(query_580234, "userIp", newJString(userIp))
  add(query_580234, "quotaUser", newJString(quotaUser))
  add(query_580234, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580234, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_580234, "visibility", newJString(visibility))
  add(query_580234, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_580235 = body
  add(query_580234, "fields", newJString(fields))
  add(query_580234, "pinned", newJBool(pinned))
  result = call_580233.call(nil, query_580234, nil, nil, body_580235)

var driveFilesInsert* = Call_DriveFilesInsert_580211(name: "driveFilesInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesInsert_580212, base: "/drive/v2",
    url: url_DriveFilesInsert_580213, schemes: {Scheme.Https})
type
  Call_DriveFilesList_580184 = ref object of OpenApiRestCall_579380
proc url_DriveFilesList_580186(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesList_580185(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the user's files.
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
  ##   driveId: JString
  ##          : ID of the shared drive to search.
  ##   includeItemsFromAllDrives: JBool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   q: JString
  ##    : Query string for searching files.
  ##   spaces: JString
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : A comma-separated list of sort keys. Valid keys are 'createdDate', 'folder', 'lastViewedByMeDate', 'modifiedByMeDate', 'modifiedDate', 'quotaBytesUsed', 'recency', 'sharedWithMeDate', 'starred', 'title', and 'title_natural'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedDate desc,title. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   pageToken: JString
  ##            : Page token for files.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   corpus: JString
  ##         : The body of items (files/documents) to which the query applies. Deprecated: use 'corpora' instead.
  ##   includeTeamDriveItems: JBool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   corpora: JString
  ##          : Bodies of items (files/documents) to which the query applies. Supported bodies are 'default', 'domain', 'drive' and 'allDrives'. Prefer 'default' or 'drive' to 'allDrives' for efficiency.
  ##   projection: JString
  ##             : This parameter is deprecated and has no function.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of files to return per page. Partial or empty result pages are possible even before the end of the files list has been reached.
  ##   teamDriveId: JString
  ##              : Deprecated use driveId instead.
  section = newJObject()
  var valid_580187 = query.getOrDefault("key")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "key", valid_580187
  var valid_580188 = query.getOrDefault("prettyPrint")
  valid_580188 = validateParameter(valid_580188, JBool, required = false,
                                 default = newJBool(true))
  if valid_580188 != nil:
    section.add "prettyPrint", valid_580188
  var valid_580189 = query.getOrDefault("oauth_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "oauth_token", valid_580189
  var valid_580190 = query.getOrDefault("driveId")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "driveId", valid_580190
  var valid_580191 = query.getOrDefault("includeItemsFromAllDrives")
  valid_580191 = validateParameter(valid_580191, JBool, required = false,
                                 default = newJBool(false))
  if valid_580191 != nil:
    section.add "includeItemsFromAllDrives", valid_580191
  var valid_580192 = query.getOrDefault("q")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "q", valid_580192
  var valid_580193 = query.getOrDefault("spaces")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "spaces", valid_580193
  var valid_580194 = query.getOrDefault("alt")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = newJString("json"))
  if valid_580194 != nil:
    section.add "alt", valid_580194
  var valid_580195 = query.getOrDefault("userIp")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "userIp", valid_580195
  var valid_580196 = query.getOrDefault("quotaUser")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "quotaUser", valid_580196
  var valid_580197 = query.getOrDefault("orderBy")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "orderBy", valid_580197
  var valid_580198 = query.getOrDefault("pageToken")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "pageToken", valid_580198
  var valid_580199 = query.getOrDefault("supportsTeamDrives")
  valid_580199 = validateParameter(valid_580199, JBool, required = false,
                                 default = newJBool(false))
  if valid_580199 != nil:
    section.add "supportsTeamDrives", valid_580199
  var valid_580200 = query.getOrDefault("supportsAllDrives")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(false))
  if valid_580200 != nil:
    section.add "supportsAllDrives", valid_580200
  var valid_580201 = query.getOrDefault("corpus")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_580201 != nil:
    section.add "corpus", valid_580201
  var valid_580202 = query.getOrDefault("includeTeamDriveItems")
  valid_580202 = validateParameter(valid_580202, JBool, required = false,
                                 default = newJBool(false))
  if valid_580202 != nil:
    section.add "includeTeamDriveItems", valid_580202
  var valid_580203 = query.getOrDefault("corpora")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "corpora", valid_580203
  var valid_580204 = query.getOrDefault("projection")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580204 != nil:
    section.add "projection", valid_580204
  var valid_580205 = query.getOrDefault("fields")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "fields", valid_580205
  var valid_580206 = query.getOrDefault("maxResults")
  valid_580206 = validateParameter(valid_580206, JInt, required = false,
                                 default = newJInt(100))
  if valid_580206 != nil:
    section.add "maxResults", valid_580206
  var valid_580207 = query.getOrDefault("teamDriveId")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "teamDriveId", valid_580207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580208: Call_DriveFilesList_580184; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's files.
  ## 
  let valid = call_580208.validator(path, query, header, formData, body)
  let scheme = call_580208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580208.url(scheme.get, call_580208.host, call_580208.base,
                         call_580208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580208, url, valid)

proc call*(call_580209: Call_DriveFilesList_580184; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; driveId: string = "";
          includeItemsFromAllDrives: bool = false; q: string = ""; spaces: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = ""; pageToken: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          corpus: string = "DEFAULT"; includeTeamDriveItems: bool = false;
          corpora: string = ""; projection: string = "BASIC"; fields: string = "";
          maxResults: int = 100; teamDriveId: string = ""): Recallable =
  ## driveFilesList
  ## Lists the user's files.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   driveId: string
  ##          : ID of the shared drive to search.
  ##   includeItemsFromAllDrives: bool
  ##                            : Deprecated - Whether both My Drive and shared drive items should be included in results. This parameter will only be effective until June 1, 2020. Afterwards shared drive items will be included in the results.
  ##   q: string
  ##    : Query string for searching files.
  ##   spaces: string
  ##         : A comma-separated list of spaces to query. Supported values are 'drive', 'appDataFolder' and 'photos'.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : A comma-separated list of sort keys. Valid keys are 'createdDate', 'folder', 'lastViewedByMeDate', 'modifiedByMeDate', 'modifiedDate', 'quotaBytesUsed', 'recency', 'sharedWithMeDate', 'starred', 'title', and 'title_natural'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedDate desc,title. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   pageToken: string
  ##            : Page token for files.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   corpus: string
  ##         : The body of items (files/documents) to which the query applies. Deprecated: use 'corpora' instead.
  ##   includeTeamDriveItems: bool
  ##                        : Deprecated use includeItemsFromAllDrives instead.
  ##   corpora: string
  ##          : Bodies of items (files/documents) to which the query applies. Supported bodies are 'default', 'domain', 'drive' and 'allDrives'. Prefer 'default' or 'drive' to 'allDrives' for efficiency.
  ##   projection: string
  ##             : This parameter is deprecated and has no function.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of files to return per page. Partial or empty result pages are possible even before the end of the files list has been reached.
  ##   teamDriveId: string
  ##              : Deprecated use driveId instead.
  var query_580210 = newJObject()
  add(query_580210, "key", newJString(key))
  add(query_580210, "prettyPrint", newJBool(prettyPrint))
  add(query_580210, "oauth_token", newJString(oauthToken))
  add(query_580210, "driveId", newJString(driveId))
  add(query_580210, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_580210, "q", newJString(q))
  add(query_580210, "spaces", newJString(spaces))
  add(query_580210, "alt", newJString(alt))
  add(query_580210, "userIp", newJString(userIp))
  add(query_580210, "quotaUser", newJString(quotaUser))
  add(query_580210, "orderBy", newJString(orderBy))
  add(query_580210, "pageToken", newJString(pageToken))
  add(query_580210, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580210, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580210, "corpus", newJString(corpus))
  add(query_580210, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_580210, "corpora", newJString(corpora))
  add(query_580210, "projection", newJString(projection))
  add(query_580210, "fields", newJString(fields))
  add(query_580210, "maxResults", newJInt(maxResults))
  add(query_580210, "teamDriveId", newJString(teamDriveId))
  result = call_580209.call(nil, query_580210, nil, nil, nil)

var driveFilesList* = Call_DriveFilesList_580184(name: "driveFilesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesList_580185, base: "/drive/v2",
    url: url_DriveFilesList_580186, schemes: {Scheme.Https})
type
  Call_DriveFilesGenerateIds_580236 = ref object of OpenApiRestCall_579380
proc url_DriveFilesGenerateIds_580238(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesGenerateIds_580237(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a set of file IDs which can be provided in insert or copy requests.
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
  ##   space: JString
  ##        : The space in which the IDs can be used to create new files. Supported values are 'drive' and 'appDataFolder'.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of IDs to return.
  section = newJObject()
  var valid_580239 = query.getOrDefault("key")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "key", valid_580239
  var valid_580240 = query.getOrDefault("prettyPrint")
  valid_580240 = validateParameter(valid_580240, JBool, required = false,
                                 default = newJBool(true))
  if valid_580240 != nil:
    section.add "prettyPrint", valid_580240
  var valid_580241 = query.getOrDefault("oauth_token")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "oauth_token", valid_580241
  var valid_580242 = query.getOrDefault("alt")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = newJString("json"))
  if valid_580242 != nil:
    section.add "alt", valid_580242
  var valid_580243 = query.getOrDefault("userIp")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "userIp", valid_580243
  var valid_580244 = query.getOrDefault("quotaUser")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "quotaUser", valid_580244
  var valid_580245 = query.getOrDefault("space")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = newJString("drive"))
  if valid_580245 != nil:
    section.add "space", valid_580245
  var valid_580246 = query.getOrDefault("fields")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "fields", valid_580246
  var valid_580247 = query.getOrDefault("maxResults")
  valid_580247 = validateParameter(valid_580247, JInt, required = false,
                                 default = newJInt(10))
  if valid_580247 != nil:
    section.add "maxResults", valid_580247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580248: Call_DriveFilesGenerateIds_580236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a set of file IDs which can be provided in insert or copy requests.
  ## 
  let valid = call_580248.validator(path, query, header, formData, body)
  let scheme = call_580248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580248.url(scheme.get, call_580248.host, call_580248.base,
                         call_580248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580248, url, valid)

proc call*(call_580249: Call_DriveFilesGenerateIds_580236; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; space: string = "drive";
          fields: string = ""; maxResults: int = 10): Recallable =
  ## driveFilesGenerateIds
  ## Generates a set of file IDs which can be provided in insert or copy requests.
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
  ##   space: string
  ##        : The space in which the IDs can be used to create new files. Supported values are 'drive' and 'appDataFolder'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of IDs to return.
  var query_580250 = newJObject()
  add(query_580250, "key", newJString(key))
  add(query_580250, "prettyPrint", newJBool(prettyPrint))
  add(query_580250, "oauth_token", newJString(oauthToken))
  add(query_580250, "alt", newJString(alt))
  add(query_580250, "userIp", newJString(userIp))
  add(query_580250, "quotaUser", newJString(quotaUser))
  add(query_580250, "space", newJString(space))
  add(query_580250, "fields", newJString(fields))
  add(query_580250, "maxResults", newJInt(maxResults))
  result = call_580249.call(nil, query_580250, nil, nil, nil)

var driveFilesGenerateIds* = Call_DriveFilesGenerateIds_580236(
    name: "driveFilesGenerateIds", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/generateIds",
    validator: validate_DriveFilesGenerateIds_580237, base: "/drive/v2",
    url: url_DriveFilesGenerateIds_580238, schemes: {Scheme.Https})
type
  Call_DriveFilesEmptyTrash_580251 = ref object of OpenApiRestCall_579380
proc url_DriveFilesEmptyTrash_580253(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesEmptyTrash_580252(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes all of the user's trashed files.
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
  var valid_580254 = query.getOrDefault("key")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "key", valid_580254
  var valid_580255 = query.getOrDefault("prettyPrint")
  valid_580255 = validateParameter(valid_580255, JBool, required = false,
                                 default = newJBool(true))
  if valid_580255 != nil:
    section.add "prettyPrint", valid_580255
  var valid_580256 = query.getOrDefault("oauth_token")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "oauth_token", valid_580256
  var valid_580257 = query.getOrDefault("alt")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = newJString("json"))
  if valid_580257 != nil:
    section.add "alt", valid_580257
  var valid_580258 = query.getOrDefault("userIp")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "userIp", valid_580258
  var valid_580259 = query.getOrDefault("quotaUser")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "quotaUser", valid_580259
  var valid_580260 = query.getOrDefault("fields")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "fields", valid_580260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580261: Call_DriveFilesEmptyTrash_580251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes all of the user's trashed files.
  ## 
  let valid = call_580261.validator(path, query, header, formData, body)
  let scheme = call_580261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580261.url(scheme.get, call_580261.host, call_580261.base,
                         call_580261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580261, url, valid)

proc call*(call_580262: Call_DriveFilesEmptyTrash_580251; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveFilesEmptyTrash
  ## Permanently deletes all of the user's trashed files.
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
  var query_580263 = newJObject()
  add(query_580263, "key", newJString(key))
  add(query_580263, "prettyPrint", newJBool(prettyPrint))
  add(query_580263, "oauth_token", newJString(oauthToken))
  add(query_580263, "alt", newJString(alt))
  add(query_580263, "userIp", newJString(userIp))
  add(query_580263, "quotaUser", newJString(quotaUser))
  add(query_580263, "fields", newJString(fields))
  result = call_580262.call(nil, query_580263, nil, nil, nil)

var driveFilesEmptyTrash* = Call_DriveFilesEmptyTrash_580251(
    name: "driveFilesEmptyTrash", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/trash",
    validator: validate_DriveFilesEmptyTrash_580252, base: "/drive/v2",
    url: url_DriveFilesEmptyTrash_580253, schemes: {Scheme.Https})
type
  Call_DriveFilesUpdate_580285 = ref object of OpenApiRestCall_579380
proc url_DriveFilesUpdate_580287(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesUpdate_580286(path: JsonNode; query: JsonNode;
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
  var valid_580288 = path.getOrDefault("fileId")
  valid_580288 = validateParameter(valid_580288, JString, required = true,
                                 default = nil)
  if valid_580288 != nil:
    section.add "fileId", valid_580288
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: JBool
  ##                            : Whether to use the content as indexable text.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   addParents: JString
  ##             : Comma-separated list of parent IDs to add.
  ##   ocr: JBool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   modifiedDateBehavior: JString
  ##                       : Determines the behavior in which modifiedDate is updated. This overrides setModifiedDate.
  ##   ocrLanguage: JString
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextLanguage: JString
  ##                    : The language of the timed text.
  ##   setModifiedDate: JBool
  ##                  : Whether to set the modified date using the value supplied in the request body. Setting this field to true is equivalent to modifiedDateBehavior=fromBodyOrNow, and false is equivalent to modifiedDateBehavior=now. To prevent any changes to the modified date set modifiedDateBehavior=noChange.
  ##   newRevision: JBool
  ##              : Whether a blob upload should create a new revision. If false, the blob data in the current head revision is replaced. If true or not set, a new blob is created as head revision, and previous unpinned revisions are preserved for a short period of time. Pinned revisions are stored indefinitely, using additional storage quota, up to a maximum of 200 revisions. For details on how revisions are retained, see the Drive Help Center.
  ##   convert: JBool
  ##          : This parameter is deprecated and has no function.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   timedTextTrackName: JString
  ##                     : The timed text track name.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   removeParents: JString
  ##                : Comma-separated list of parent IDs to remove.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   updateViewedDate: JBool
  ##                   : Whether to update the view date after successfully updating the file.
  ##   pinned: JBool
  ##         : Whether to pin the new revision. A file can have a maximum of 200 pinned revisions.
  section = newJObject()
  var valid_580289 = query.getOrDefault("key")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "key", valid_580289
  var valid_580290 = query.getOrDefault("useContentAsIndexableText")
  valid_580290 = validateParameter(valid_580290, JBool, required = false,
                                 default = newJBool(false))
  if valid_580290 != nil:
    section.add "useContentAsIndexableText", valid_580290
  var valid_580291 = query.getOrDefault("prettyPrint")
  valid_580291 = validateParameter(valid_580291, JBool, required = false,
                                 default = newJBool(true))
  if valid_580291 != nil:
    section.add "prettyPrint", valid_580291
  var valid_580292 = query.getOrDefault("oauth_token")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "oauth_token", valid_580292
  var valid_580293 = query.getOrDefault("addParents")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "addParents", valid_580293
  var valid_580294 = query.getOrDefault("ocr")
  valid_580294 = validateParameter(valid_580294, JBool, required = false,
                                 default = newJBool(false))
  if valid_580294 != nil:
    section.add "ocr", valid_580294
  var valid_580295 = query.getOrDefault("modifiedDateBehavior")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = newJString("fromBody"))
  if valid_580295 != nil:
    section.add "modifiedDateBehavior", valid_580295
  var valid_580296 = query.getOrDefault("ocrLanguage")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "ocrLanguage", valid_580296
  var valid_580297 = query.getOrDefault("timedTextLanguage")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "timedTextLanguage", valid_580297
  var valid_580298 = query.getOrDefault("setModifiedDate")
  valid_580298 = validateParameter(valid_580298, JBool, required = false,
                                 default = newJBool(false))
  if valid_580298 != nil:
    section.add "setModifiedDate", valid_580298
  var valid_580299 = query.getOrDefault("newRevision")
  valid_580299 = validateParameter(valid_580299, JBool, required = false,
                                 default = newJBool(true))
  if valid_580299 != nil:
    section.add "newRevision", valid_580299
  var valid_580300 = query.getOrDefault("convert")
  valid_580300 = validateParameter(valid_580300, JBool, required = false,
                                 default = newJBool(false))
  if valid_580300 != nil:
    section.add "convert", valid_580300
  var valid_580301 = query.getOrDefault("alt")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = newJString("json"))
  if valid_580301 != nil:
    section.add "alt", valid_580301
  var valid_580302 = query.getOrDefault("userIp")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "userIp", valid_580302
  var valid_580303 = query.getOrDefault("quotaUser")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "quotaUser", valid_580303
  var valid_580304 = query.getOrDefault("supportsTeamDrives")
  valid_580304 = validateParameter(valid_580304, JBool, required = false,
                                 default = newJBool(false))
  if valid_580304 != nil:
    section.add "supportsTeamDrives", valid_580304
  var valid_580305 = query.getOrDefault("timedTextTrackName")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "timedTextTrackName", valid_580305
  var valid_580306 = query.getOrDefault("supportsAllDrives")
  valid_580306 = validateParameter(valid_580306, JBool, required = false,
                                 default = newJBool(false))
  if valid_580306 != nil:
    section.add "supportsAllDrives", valid_580306
  var valid_580307 = query.getOrDefault("removeParents")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "removeParents", valid_580307
  var valid_580308 = query.getOrDefault("fields")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "fields", valid_580308
  var valid_580309 = query.getOrDefault("updateViewedDate")
  valid_580309 = validateParameter(valid_580309, JBool, required = false,
                                 default = newJBool(true))
  if valid_580309 != nil:
    section.add "updateViewedDate", valid_580309
  var valid_580310 = query.getOrDefault("pinned")
  valid_580310 = validateParameter(valid_580310, JBool, required = false,
                                 default = newJBool(false))
  if valid_580310 != nil:
    section.add "pinned", valid_580310
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

proc call*(call_580312: Call_DriveFilesUpdate_580285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates file metadata and/or content.
  ## 
  let valid = call_580312.validator(path, query, header, formData, body)
  let scheme = call_580312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580312.url(scheme.get, call_580312.host, call_580312.base,
                         call_580312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580312, url, valid)

proc call*(call_580313: Call_DriveFilesUpdate_580285; fileId: string;
          key: string = ""; useContentAsIndexableText: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; addParents: string = "";
          ocr: bool = false; modifiedDateBehavior: string = "fromBody";
          ocrLanguage: string = ""; timedTextLanguage: string = "";
          setModifiedDate: bool = false; newRevision: bool = true;
          convert: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsTeamDrives: bool = false;
          timedTextTrackName: string = ""; supportsAllDrives: bool = false;
          body: JsonNode = nil; removeParents: string = ""; fields: string = "";
          updateViewedDate: bool = true; pinned: bool = false): Recallable =
  ## driveFilesUpdate
  ## Updates file metadata and/or content.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: bool
  ##                            : Whether to use the content as indexable text.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   addParents: string
  ##             : Comma-separated list of parent IDs to add.
  ##   ocr: bool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   modifiedDateBehavior: string
  ##                       : Determines the behavior in which modifiedDate is updated. This overrides setModifiedDate.
  ##   ocrLanguage: string
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextLanguage: string
  ##                    : The language of the timed text.
  ##   setModifiedDate: bool
  ##                  : Whether to set the modified date using the value supplied in the request body. Setting this field to true is equivalent to modifiedDateBehavior=fromBodyOrNow, and false is equivalent to modifiedDateBehavior=now. To prevent any changes to the modified date set modifiedDateBehavior=noChange.
  ##   newRevision: bool
  ##              : Whether a blob upload should create a new revision. If false, the blob data in the current head revision is replaced. If true or not set, a new blob is created as head revision, and previous unpinned revisions are preserved for a short period of time. Pinned revisions are stored indefinitely, using additional storage quota, up to a maximum of 200 revisions. For details on how revisions are retained, see the Drive Help Center.
  ##   convert: bool
  ##          : This parameter is deprecated and has no function.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file to update.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   timedTextTrackName: string
  ##                     : The timed text track name.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   body: JObject
  ##   removeParents: string
  ##                : Comma-separated list of parent IDs to remove.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   updateViewedDate: bool
  ##                   : Whether to update the view date after successfully updating the file.
  ##   pinned: bool
  ##         : Whether to pin the new revision. A file can have a maximum of 200 pinned revisions.
  var path_580314 = newJObject()
  var query_580315 = newJObject()
  var body_580316 = newJObject()
  add(query_580315, "key", newJString(key))
  add(query_580315, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_580315, "prettyPrint", newJBool(prettyPrint))
  add(query_580315, "oauth_token", newJString(oauthToken))
  add(query_580315, "addParents", newJString(addParents))
  add(query_580315, "ocr", newJBool(ocr))
  add(query_580315, "modifiedDateBehavior", newJString(modifiedDateBehavior))
  add(query_580315, "ocrLanguage", newJString(ocrLanguage))
  add(query_580315, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_580315, "setModifiedDate", newJBool(setModifiedDate))
  add(query_580315, "newRevision", newJBool(newRevision))
  add(query_580315, "convert", newJBool(convert))
  add(query_580315, "alt", newJString(alt))
  add(query_580315, "userIp", newJString(userIp))
  add(query_580315, "quotaUser", newJString(quotaUser))
  add(path_580314, "fileId", newJString(fileId))
  add(query_580315, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580315, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_580315, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_580316 = body
  add(query_580315, "removeParents", newJString(removeParents))
  add(query_580315, "fields", newJString(fields))
  add(query_580315, "updateViewedDate", newJBool(updateViewedDate))
  add(query_580315, "pinned", newJBool(pinned))
  result = call_580313.call(path_580314, query_580315, nil, nil, body_580316)

var driveFilesUpdate* = Call_DriveFilesUpdate_580285(name: "driveFilesUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesUpdate_580286, base: "/drive/v2",
    url: url_DriveFilesUpdate_580287, schemes: {Scheme.Https})
type
  Call_DriveFilesGet_580264 = ref object of OpenApiRestCall_579380
proc url_DriveFilesGet_580266(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesGet_580265(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580267 = path.getOrDefault("fileId")
  valid_580267 = validateParameter(valid_580267, JString, required = true,
                                 default = nil)
  if valid_580267 != nil:
    section.add "fileId", valid_580267
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   acknowledgeAbuse: JBool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   revisionId: JString
  ##             : Specifies the Revision ID that should be downloaded. Ignored unless alt=media is specified.
  ##   projection: JString
  ##             : This parameter is deprecated and has no function.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   updateViewedDate: JBool
  ##                   : Deprecated: Use files.update with modifiedDateBehavior=noChange, updateViewedDate=true and an empty request body.
  section = newJObject()
  var valid_580268 = query.getOrDefault("key")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "key", valid_580268
  var valid_580269 = query.getOrDefault("prettyPrint")
  valid_580269 = validateParameter(valid_580269, JBool, required = false,
                                 default = newJBool(true))
  if valid_580269 != nil:
    section.add "prettyPrint", valid_580269
  var valid_580270 = query.getOrDefault("oauth_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "oauth_token", valid_580270
  var valid_580271 = query.getOrDefault("alt")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = newJString("json"))
  if valid_580271 != nil:
    section.add "alt", valid_580271
  var valid_580272 = query.getOrDefault("userIp")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "userIp", valid_580272
  var valid_580273 = query.getOrDefault("quotaUser")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "quotaUser", valid_580273
  var valid_580274 = query.getOrDefault("supportsTeamDrives")
  valid_580274 = validateParameter(valid_580274, JBool, required = false,
                                 default = newJBool(false))
  if valid_580274 != nil:
    section.add "supportsTeamDrives", valid_580274
  var valid_580275 = query.getOrDefault("acknowledgeAbuse")
  valid_580275 = validateParameter(valid_580275, JBool, required = false,
                                 default = newJBool(false))
  if valid_580275 != nil:
    section.add "acknowledgeAbuse", valid_580275
  var valid_580276 = query.getOrDefault("supportsAllDrives")
  valid_580276 = validateParameter(valid_580276, JBool, required = false,
                                 default = newJBool(false))
  if valid_580276 != nil:
    section.add "supportsAllDrives", valid_580276
  var valid_580277 = query.getOrDefault("revisionId")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "revisionId", valid_580277
  var valid_580278 = query.getOrDefault("projection")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580278 != nil:
    section.add "projection", valid_580278
  var valid_580279 = query.getOrDefault("fields")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "fields", valid_580279
  var valid_580280 = query.getOrDefault("updateViewedDate")
  valid_580280 = validateParameter(valid_580280, JBool, required = false,
                                 default = newJBool(false))
  if valid_580280 != nil:
    section.add "updateViewedDate", valid_580280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580281: Call_DriveFilesGet_580264; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a file's metadata by ID.
  ## 
  let valid = call_580281.validator(path, query, header, formData, body)
  let scheme = call_580281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580281.url(scheme.get, call_580281.host, call_580281.base,
                         call_580281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580281, url, valid)

proc call*(call_580282: Call_DriveFilesGet_580264; fileId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; supportsTeamDrives: bool = false;
          acknowledgeAbuse: bool = false; supportsAllDrives: bool = false;
          revisionId: string = ""; projection: string = "BASIC"; fields: string = "";
          updateViewedDate: bool = false): Recallable =
  ## driveFilesGet
  ## Gets a file's metadata by ID.
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
  ##   fileId: string (required)
  ##         : The ID for the file in question.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   acknowledgeAbuse: bool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   revisionId: string
  ##             : Specifies the Revision ID that should be downloaded. Ignored unless alt=media is specified.
  ##   projection: string
  ##             : This parameter is deprecated and has no function.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   updateViewedDate: bool
  ##                   : Deprecated: Use files.update with modifiedDateBehavior=noChange, updateViewedDate=true and an empty request body.
  var path_580283 = newJObject()
  var query_580284 = newJObject()
  add(query_580284, "key", newJString(key))
  add(query_580284, "prettyPrint", newJBool(prettyPrint))
  add(query_580284, "oauth_token", newJString(oauthToken))
  add(query_580284, "alt", newJString(alt))
  add(query_580284, "userIp", newJString(userIp))
  add(query_580284, "quotaUser", newJString(quotaUser))
  add(path_580283, "fileId", newJString(fileId))
  add(query_580284, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580284, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_580284, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580284, "revisionId", newJString(revisionId))
  add(query_580284, "projection", newJString(projection))
  add(query_580284, "fields", newJString(fields))
  add(query_580284, "updateViewedDate", newJBool(updateViewedDate))
  result = call_580282.call(path_580283, query_580284, nil, nil, nil)

var driveFilesGet* = Call_DriveFilesGet_580264(name: "driveFilesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesGet_580265, base: "/drive/v2",
    url: url_DriveFilesGet_580266, schemes: {Scheme.Https})
type
  Call_DriveFilesPatch_580334 = ref object of OpenApiRestCall_579380
proc url_DriveFilesPatch_580336(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesPatch_580335(path: JsonNode; query: JsonNode;
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
  var valid_580337 = path.getOrDefault("fileId")
  valid_580337 = validateParameter(valid_580337, JString, required = true,
                                 default = nil)
  if valid_580337 != nil:
    section.add "fileId", valid_580337
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: JBool
  ##                            : Whether to use the content as indexable text.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   addParents: JString
  ##             : Comma-separated list of parent IDs to add.
  ##   ocr: JBool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   modifiedDateBehavior: JString
  ##                       : Determines the behavior in which modifiedDate is updated. This overrides setModifiedDate.
  ##   ocrLanguage: JString
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextLanguage: JString
  ##                    : The language of the timed text.
  ##   setModifiedDate: JBool
  ##                  : Whether to set the modified date using the value supplied in the request body. Setting this field to true is equivalent to modifiedDateBehavior=fromBodyOrNow, and false is equivalent to modifiedDateBehavior=now. To prevent any changes to the modified date set modifiedDateBehavior=noChange.
  ##   newRevision: JBool
  ##              : Whether a blob upload should create a new revision. If false, the blob data in the current head revision is replaced. If true or not set, a new blob is created as head revision, and previous unpinned revisions are preserved for a short period of time. Pinned revisions are stored indefinitely, using additional storage quota, up to a maximum of 200 revisions. For details on how revisions are retained, see the Drive Help Center.
  ##   convert: JBool
  ##          : This parameter is deprecated and has no function.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   timedTextTrackName: JString
  ##                     : The timed text track name.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   removeParents: JString
  ##                : Comma-separated list of parent IDs to remove.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   updateViewedDate: JBool
  ##                   : Whether to update the view date after successfully updating the file.
  ##   pinned: JBool
  ##         : Whether to pin the new revision. A file can have a maximum of 200 pinned revisions.
  section = newJObject()
  var valid_580338 = query.getOrDefault("key")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "key", valid_580338
  var valid_580339 = query.getOrDefault("useContentAsIndexableText")
  valid_580339 = validateParameter(valid_580339, JBool, required = false,
                                 default = newJBool(false))
  if valid_580339 != nil:
    section.add "useContentAsIndexableText", valid_580339
  var valid_580340 = query.getOrDefault("prettyPrint")
  valid_580340 = validateParameter(valid_580340, JBool, required = false,
                                 default = newJBool(true))
  if valid_580340 != nil:
    section.add "prettyPrint", valid_580340
  var valid_580341 = query.getOrDefault("oauth_token")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "oauth_token", valid_580341
  var valid_580342 = query.getOrDefault("addParents")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "addParents", valid_580342
  var valid_580343 = query.getOrDefault("ocr")
  valid_580343 = validateParameter(valid_580343, JBool, required = false,
                                 default = newJBool(false))
  if valid_580343 != nil:
    section.add "ocr", valid_580343
  var valid_580344 = query.getOrDefault("modifiedDateBehavior")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = newJString("fromBody"))
  if valid_580344 != nil:
    section.add "modifiedDateBehavior", valid_580344
  var valid_580345 = query.getOrDefault("ocrLanguage")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "ocrLanguage", valid_580345
  var valid_580346 = query.getOrDefault("timedTextLanguage")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "timedTextLanguage", valid_580346
  var valid_580347 = query.getOrDefault("setModifiedDate")
  valid_580347 = validateParameter(valid_580347, JBool, required = false,
                                 default = newJBool(false))
  if valid_580347 != nil:
    section.add "setModifiedDate", valid_580347
  var valid_580348 = query.getOrDefault("newRevision")
  valid_580348 = validateParameter(valid_580348, JBool, required = false,
                                 default = newJBool(true))
  if valid_580348 != nil:
    section.add "newRevision", valid_580348
  var valid_580349 = query.getOrDefault("convert")
  valid_580349 = validateParameter(valid_580349, JBool, required = false,
                                 default = newJBool(false))
  if valid_580349 != nil:
    section.add "convert", valid_580349
  var valid_580350 = query.getOrDefault("alt")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = newJString("json"))
  if valid_580350 != nil:
    section.add "alt", valid_580350
  var valid_580351 = query.getOrDefault("userIp")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "userIp", valid_580351
  var valid_580352 = query.getOrDefault("quotaUser")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "quotaUser", valid_580352
  var valid_580353 = query.getOrDefault("supportsTeamDrives")
  valid_580353 = validateParameter(valid_580353, JBool, required = false,
                                 default = newJBool(false))
  if valid_580353 != nil:
    section.add "supportsTeamDrives", valid_580353
  var valid_580354 = query.getOrDefault("timedTextTrackName")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "timedTextTrackName", valid_580354
  var valid_580355 = query.getOrDefault("supportsAllDrives")
  valid_580355 = validateParameter(valid_580355, JBool, required = false,
                                 default = newJBool(false))
  if valid_580355 != nil:
    section.add "supportsAllDrives", valid_580355
  var valid_580356 = query.getOrDefault("removeParents")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "removeParents", valid_580356
  var valid_580357 = query.getOrDefault("fields")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "fields", valid_580357
  var valid_580358 = query.getOrDefault("updateViewedDate")
  valid_580358 = validateParameter(valid_580358, JBool, required = false,
                                 default = newJBool(true))
  if valid_580358 != nil:
    section.add "updateViewedDate", valid_580358
  var valid_580359 = query.getOrDefault("pinned")
  valid_580359 = validateParameter(valid_580359, JBool, required = false,
                                 default = newJBool(false))
  if valid_580359 != nil:
    section.add "pinned", valid_580359
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

proc call*(call_580361: Call_DriveFilesPatch_580334; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates file metadata and/or content. This method supports patch semantics.
  ## 
  let valid = call_580361.validator(path, query, header, formData, body)
  let scheme = call_580361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580361.url(scheme.get, call_580361.host, call_580361.base,
                         call_580361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580361, url, valid)

proc call*(call_580362: Call_DriveFilesPatch_580334; fileId: string;
          key: string = ""; useContentAsIndexableText: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; addParents: string = "";
          ocr: bool = false; modifiedDateBehavior: string = "fromBody";
          ocrLanguage: string = ""; timedTextLanguage: string = "";
          setModifiedDate: bool = false; newRevision: bool = true;
          convert: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsTeamDrives: bool = false;
          timedTextTrackName: string = ""; supportsAllDrives: bool = false;
          body: JsonNode = nil; removeParents: string = ""; fields: string = "";
          updateViewedDate: bool = true; pinned: bool = false): Recallable =
  ## driveFilesPatch
  ## Updates file metadata and/or content. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   useContentAsIndexableText: bool
  ##                            : Whether to use the content as indexable text.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   addParents: string
  ##             : Comma-separated list of parent IDs to add.
  ##   ocr: bool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   modifiedDateBehavior: string
  ##                       : Determines the behavior in which modifiedDate is updated. This overrides setModifiedDate.
  ##   ocrLanguage: string
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextLanguage: string
  ##                    : The language of the timed text.
  ##   setModifiedDate: bool
  ##                  : Whether to set the modified date using the value supplied in the request body. Setting this field to true is equivalent to modifiedDateBehavior=fromBodyOrNow, and false is equivalent to modifiedDateBehavior=now. To prevent any changes to the modified date set modifiedDateBehavior=noChange.
  ##   newRevision: bool
  ##              : Whether a blob upload should create a new revision. If false, the blob data in the current head revision is replaced. If true or not set, a new blob is created as head revision, and previous unpinned revisions are preserved for a short period of time. Pinned revisions are stored indefinitely, using additional storage quota, up to a maximum of 200 revisions. For details on how revisions are retained, see the Drive Help Center.
  ##   convert: bool
  ##          : This parameter is deprecated and has no function.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file to update.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   timedTextTrackName: string
  ##                     : The timed text track name.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   body: JObject
  ##   removeParents: string
  ##                : Comma-separated list of parent IDs to remove.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   updateViewedDate: bool
  ##                   : Whether to update the view date after successfully updating the file.
  ##   pinned: bool
  ##         : Whether to pin the new revision. A file can have a maximum of 200 pinned revisions.
  var path_580363 = newJObject()
  var query_580364 = newJObject()
  var body_580365 = newJObject()
  add(query_580364, "key", newJString(key))
  add(query_580364, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_580364, "prettyPrint", newJBool(prettyPrint))
  add(query_580364, "oauth_token", newJString(oauthToken))
  add(query_580364, "addParents", newJString(addParents))
  add(query_580364, "ocr", newJBool(ocr))
  add(query_580364, "modifiedDateBehavior", newJString(modifiedDateBehavior))
  add(query_580364, "ocrLanguage", newJString(ocrLanguage))
  add(query_580364, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_580364, "setModifiedDate", newJBool(setModifiedDate))
  add(query_580364, "newRevision", newJBool(newRevision))
  add(query_580364, "convert", newJBool(convert))
  add(query_580364, "alt", newJString(alt))
  add(query_580364, "userIp", newJString(userIp))
  add(query_580364, "quotaUser", newJString(quotaUser))
  add(path_580363, "fileId", newJString(fileId))
  add(query_580364, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580364, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_580364, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_580365 = body
  add(query_580364, "removeParents", newJString(removeParents))
  add(query_580364, "fields", newJString(fields))
  add(query_580364, "updateViewedDate", newJBool(updateViewedDate))
  add(query_580364, "pinned", newJBool(pinned))
  result = call_580362.call(path_580363, query_580364, nil, nil, body_580365)

var driveFilesPatch* = Call_DriveFilesPatch_580334(name: "driveFilesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesPatch_580335,
    base: "/drive/v2", url: url_DriveFilesPatch_580336, schemes: {Scheme.Https})
type
  Call_DriveFilesDelete_580317 = ref object of OpenApiRestCall_579380
proc url_DriveFilesDelete_580319(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesDelete_580318(path: JsonNode; query: JsonNode;
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
  var valid_580320 = path.getOrDefault("fileId")
  valid_580320 = validateParameter(valid_580320, JString, required = true,
                                 default = nil)
  if valid_580320 != nil:
    section.add "fileId", valid_580320
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580321 = query.getOrDefault("key")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "key", valid_580321
  var valid_580322 = query.getOrDefault("prettyPrint")
  valid_580322 = validateParameter(valid_580322, JBool, required = false,
                                 default = newJBool(true))
  if valid_580322 != nil:
    section.add "prettyPrint", valid_580322
  var valid_580323 = query.getOrDefault("oauth_token")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "oauth_token", valid_580323
  var valid_580324 = query.getOrDefault("alt")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = newJString("json"))
  if valid_580324 != nil:
    section.add "alt", valid_580324
  var valid_580325 = query.getOrDefault("userIp")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "userIp", valid_580325
  var valid_580326 = query.getOrDefault("quotaUser")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "quotaUser", valid_580326
  var valid_580327 = query.getOrDefault("supportsTeamDrives")
  valid_580327 = validateParameter(valid_580327, JBool, required = false,
                                 default = newJBool(false))
  if valid_580327 != nil:
    section.add "supportsTeamDrives", valid_580327
  var valid_580328 = query.getOrDefault("supportsAllDrives")
  valid_580328 = validateParameter(valid_580328, JBool, required = false,
                                 default = newJBool(false))
  if valid_580328 != nil:
    section.add "supportsAllDrives", valid_580328
  var valid_580329 = query.getOrDefault("fields")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "fields", valid_580329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580330: Call_DriveFilesDelete_580317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file by ID. Skips the trash. The currently authenticated user must own the file or be an organizer on the parent for shared drive files.
  ## 
  let valid = call_580330.validator(path, query, header, formData, body)
  let scheme = call_580330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580330.url(scheme.get, call_580330.host, call_580330.base,
                         call_580330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580330, url, valid)

proc call*(call_580331: Call_DriveFilesDelete_580317; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          fields: string = ""): Recallable =
  ## driveFilesDelete
  ## Permanently deletes a file by ID. Skips the trash. The currently authenticated user must own the file or be an organizer on the parent for shared drive files.
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
  ##   fileId: string (required)
  ##         : The ID of the file to delete.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580332 = newJObject()
  var query_580333 = newJObject()
  add(query_580333, "key", newJString(key))
  add(query_580333, "prettyPrint", newJBool(prettyPrint))
  add(query_580333, "oauth_token", newJString(oauthToken))
  add(query_580333, "alt", newJString(alt))
  add(query_580333, "userIp", newJString(userIp))
  add(query_580333, "quotaUser", newJString(quotaUser))
  add(path_580332, "fileId", newJString(fileId))
  add(query_580333, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580333, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580333, "fields", newJString(fields))
  result = call_580331.call(path_580332, query_580333, nil, nil, nil)

var driveFilesDelete* = Call_DriveFilesDelete_580317(name: "driveFilesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesDelete_580318,
    base: "/drive/v2", url: url_DriveFilesDelete_580319, schemes: {Scheme.Https})
type
  Call_DriveCommentsInsert_580385 = ref object of OpenApiRestCall_579380
proc url_DriveCommentsInsert_580387(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveCommentsInsert_580386(path: JsonNode; query: JsonNode;
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
  var valid_580388 = path.getOrDefault("fileId")
  valid_580388 = validateParameter(valid_580388, JString, required = true,
                                 default = nil)
  if valid_580388 != nil:
    section.add "fileId", valid_580388
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580389 = query.getOrDefault("key")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "key", valid_580389
  var valid_580390 = query.getOrDefault("prettyPrint")
  valid_580390 = validateParameter(valid_580390, JBool, required = false,
                                 default = newJBool(true))
  if valid_580390 != nil:
    section.add "prettyPrint", valid_580390
  var valid_580391 = query.getOrDefault("oauth_token")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "oauth_token", valid_580391
  var valid_580392 = query.getOrDefault("alt")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = newJString("json"))
  if valid_580392 != nil:
    section.add "alt", valid_580392
  var valid_580393 = query.getOrDefault("userIp")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "userIp", valid_580393
  var valid_580394 = query.getOrDefault("quotaUser")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "quotaUser", valid_580394
  var valid_580395 = query.getOrDefault("fields")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "fields", valid_580395
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

proc call*(call_580397: Call_DriveCommentsInsert_580385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new comment on the given file.
  ## 
  let valid = call_580397.validator(path, query, header, formData, body)
  let scheme = call_580397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580397.url(scheme.get, call_580397.host, call_580397.base,
                         call_580397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580397, url, valid)

proc call*(call_580398: Call_DriveCommentsInsert_580385; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveCommentsInsert
  ## Creates a new comment on the given file.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580399 = newJObject()
  var query_580400 = newJObject()
  var body_580401 = newJObject()
  add(query_580400, "key", newJString(key))
  add(query_580400, "prettyPrint", newJBool(prettyPrint))
  add(query_580400, "oauth_token", newJString(oauthToken))
  add(query_580400, "alt", newJString(alt))
  add(query_580400, "userIp", newJString(userIp))
  add(query_580400, "quotaUser", newJString(quotaUser))
  add(path_580399, "fileId", newJString(fileId))
  if body != nil:
    body_580401 = body
  add(query_580400, "fields", newJString(fields))
  result = call_580398.call(path_580399, query_580400, nil, nil, body_580401)

var driveCommentsInsert* = Call_DriveCommentsInsert_580385(
    name: "driveCommentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/comments",
    validator: validate_DriveCommentsInsert_580386, base: "/drive/v2",
    url: url_DriveCommentsInsert_580387, schemes: {Scheme.Https})
type
  Call_DriveCommentsList_580366 = ref object of OpenApiRestCall_579380
proc url_DriveCommentsList_580368(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveCommentsList_580367(path: JsonNode; query: JsonNode;
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
  var valid_580369 = path.getOrDefault("fileId")
  valid_580369 = validateParameter(valid_580369, JString, required = true,
                                 default = nil)
  if valid_580369 != nil:
    section.add "fileId", valid_580369
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  ##            : The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeDeleted: JBool
  ##                 : If set, all comments and replies, including deleted comments and replies (with content stripped) will be returned.
  ##   updatedMin: JString
  ##             : Only discussions that were updated after this timestamp will be returned. Formatted as an RFC 3339 timestamp.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of discussions to include in the response, used for paging.
  section = newJObject()
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
  var valid_580372 = query.getOrDefault("oauth_token")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "oauth_token", valid_580372
  var valid_580373 = query.getOrDefault("alt")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = newJString("json"))
  if valid_580373 != nil:
    section.add "alt", valid_580373
  var valid_580374 = query.getOrDefault("userIp")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "userIp", valid_580374
  var valid_580375 = query.getOrDefault("quotaUser")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "quotaUser", valid_580375
  var valid_580376 = query.getOrDefault("pageToken")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "pageToken", valid_580376
  var valid_580377 = query.getOrDefault("includeDeleted")
  valid_580377 = validateParameter(valid_580377, JBool, required = false,
                                 default = newJBool(false))
  if valid_580377 != nil:
    section.add "includeDeleted", valid_580377
  var valid_580378 = query.getOrDefault("updatedMin")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "updatedMin", valid_580378
  var valid_580379 = query.getOrDefault("fields")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "fields", valid_580379
  var valid_580380 = query.getOrDefault("maxResults")
  valid_580380 = validateParameter(valid_580380, JInt, required = false,
                                 default = newJInt(20))
  if valid_580380 != nil:
    section.add "maxResults", valid_580380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580381: Call_DriveCommentsList_580366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's comments.
  ## 
  let valid = call_580381.validator(path, query, header, formData, body)
  let scheme = call_580381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580381.url(scheme.get, call_580381.host, call_580381.base,
                         call_580381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580381, url, valid)

proc call*(call_580382: Call_DriveCommentsList_580366; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; includeDeleted: bool = false; updatedMin: string = "";
          fields: string = ""; maxResults: int = 20): Recallable =
  ## driveCommentsList
  ## Lists a file's comments.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   pageToken: string
  ##            : The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeDeleted: bool
  ##                 : If set, all comments and replies, including deleted comments and replies (with content stripped) will be returned.
  ##   updatedMin: string
  ##             : Only discussions that were updated after this timestamp will be returned. Formatted as an RFC 3339 timestamp.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of discussions to include in the response, used for paging.
  var path_580383 = newJObject()
  var query_580384 = newJObject()
  add(query_580384, "key", newJString(key))
  add(query_580384, "prettyPrint", newJBool(prettyPrint))
  add(query_580384, "oauth_token", newJString(oauthToken))
  add(query_580384, "alt", newJString(alt))
  add(query_580384, "userIp", newJString(userIp))
  add(query_580384, "quotaUser", newJString(quotaUser))
  add(path_580383, "fileId", newJString(fileId))
  add(query_580384, "pageToken", newJString(pageToken))
  add(query_580384, "includeDeleted", newJBool(includeDeleted))
  add(query_580384, "updatedMin", newJString(updatedMin))
  add(query_580384, "fields", newJString(fields))
  add(query_580384, "maxResults", newJInt(maxResults))
  result = call_580382.call(path_580383, query_580384, nil, nil, nil)

var driveCommentsList* = Call_DriveCommentsList_580366(name: "driveCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments", validator: validate_DriveCommentsList_580367,
    base: "/drive/v2", url: url_DriveCommentsList_580368, schemes: {Scheme.Https})
type
  Call_DriveCommentsUpdate_580419 = ref object of OpenApiRestCall_579380
proc url_DriveCommentsUpdate_580421(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveCommentsUpdate_580420(path: JsonNode; query: JsonNode;
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
  var valid_580422 = path.getOrDefault("fileId")
  valid_580422 = validateParameter(valid_580422, JString, required = true,
                                 default = nil)
  if valid_580422 != nil:
    section.add "fileId", valid_580422
  var valid_580423 = path.getOrDefault("commentId")
  valid_580423 = validateParameter(valid_580423, JString, required = true,
                                 default = nil)
  if valid_580423 != nil:
    section.add "commentId", valid_580423
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580424 = query.getOrDefault("key")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "key", valid_580424
  var valid_580425 = query.getOrDefault("prettyPrint")
  valid_580425 = validateParameter(valid_580425, JBool, required = false,
                                 default = newJBool(true))
  if valid_580425 != nil:
    section.add "prettyPrint", valid_580425
  var valid_580426 = query.getOrDefault("oauth_token")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "oauth_token", valid_580426
  var valid_580427 = query.getOrDefault("alt")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = newJString("json"))
  if valid_580427 != nil:
    section.add "alt", valid_580427
  var valid_580428 = query.getOrDefault("userIp")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "userIp", valid_580428
  var valid_580429 = query.getOrDefault("quotaUser")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "quotaUser", valid_580429
  var valid_580430 = query.getOrDefault("fields")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "fields", valid_580430
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

proc call*(call_580432: Call_DriveCommentsUpdate_580419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing comment.
  ## 
  let valid = call_580432.validator(path, query, header, formData, body)
  let scheme = call_580432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580432.url(scheme.get, call_580432.host, call_580432.base,
                         call_580432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580432, url, valid)

proc call*(call_580433: Call_DriveCommentsUpdate_580419; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveCommentsUpdate
  ## Updates an existing comment.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580434 = newJObject()
  var query_580435 = newJObject()
  var body_580436 = newJObject()
  add(query_580435, "key", newJString(key))
  add(query_580435, "prettyPrint", newJBool(prettyPrint))
  add(query_580435, "oauth_token", newJString(oauthToken))
  add(query_580435, "alt", newJString(alt))
  add(query_580435, "userIp", newJString(userIp))
  add(query_580435, "quotaUser", newJString(quotaUser))
  add(path_580434, "fileId", newJString(fileId))
  add(path_580434, "commentId", newJString(commentId))
  if body != nil:
    body_580436 = body
  add(query_580435, "fields", newJString(fields))
  result = call_580433.call(path_580434, query_580435, nil, nil, body_580436)

var driveCommentsUpdate* = Call_DriveCommentsUpdate_580419(
    name: "driveCommentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsUpdate_580420, base: "/drive/v2",
    url: url_DriveCommentsUpdate_580421, schemes: {Scheme.Https})
type
  Call_DriveCommentsGet_580402 = ref object of OpenApiRestCall_579380
proc url_DriveCommentsGet_580404(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveCommentsGet_580403(path: JsonNode; query: JsonNode;
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
  var valid_580405 = path.getOrDefault("fileId")
  valid_580405 = validateParameter(valid_580405, JString, required = true,
                                 default = nil)
  if valid_580405 != nil:
    section.add "fileId", valid_580405
  var valid_580406 = path.getOrDefault("commentId")
  valid_580406 = validateParameter(valid_580406, JString, required = true,
                                 default = nil)
  if valid_580406 != nil:
    section.add "commentId", valid_580406
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeDeleted: JBool
  ##                 : If set, this will succeed when retrieving a deleted comment, and will include any deleted replies.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580407 = query.getOrDefault("key")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "key", valid_580407
  var valid_580408 = query.getOrDefault("prettyPrint")
  valid_580408 = validateParameter(valid_580408, JBool, required = false,
                                 default = newJBool(true))
  if valid_580408 != nil:
    section.add "prettyPrint", valid_580408
  var valid_580409 = query.getOrDefault("oauth_token")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "oauth_token", valid_580409
  var valid_580410 = query.getOrDefault("alt")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = newJString("json"))
  if valid_580410 != nil:
    section.add "alt", valid_580410
  var valid_580411 = query.getOrDefault("userIp")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "userIp", valid_580411
  var valid_580412 = query.getOrDefault("quotaUser")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "quotaUser", valid_580412
  var valid_580413 = query.getOrDefault("includeDeleted")
  valid_580413 = validateParameter(valid_580413, JBool, required = false,
                                 default = newJBool(false))
  if valid_580413 != nil:
    section.add "includeDeleted", valid_580413
  var valid_580414 = query.getOrDefault("fields")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "fields", valid_580414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580415: Call_DriveCommentsGet_580402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a comment by ID.
  ## 
  let valid = call_580415.validator(path, query, header, formData, body)
  let scheme = call_580415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580415.url(scheme.get, call_580415.host, call_580415.base,
                         call_580415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580415, url, valid)

proc call*(call_580416: Call_DriveCommentsGet_580402; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; includeDeleted: bool = false; fields: string = ""): Recallable =
  ## driveCommentsGet
  ## Gets a comment by ID.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : If set, this will succeed when retrieving a deleted comment, and will include any deleted replies.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580417 = newJObject()
  var query_580418 = newJObject()
  add(query_580418, "key", newJString(key))
  add(query_580418, "prettyPrint", newJBool(prettyPrint))
  add(query_580418, "oauth_token", newJString(oauthToken))
  add(query_580418, "alt", newJString(alt))
  add(query_580418, "userIp", newJString(userIp))
  add(query_580418, "quotaUser", newJString(quotaUser))
  add(path_580417, "fileId", newJString(fileId))
  add(path_580417, "commentId", newJString(commentId))
  add(query_580418, "includeDeleted", newJBool(includeDeleted))
  add(query_580418, "fields", newJString(fields))
  result = call_580416.call(path_580417, query_580418, nil, nil, nil)

var driveCommentsGet* = Call_DriveCommentsGet_580402(name: "driveCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsGet_580403, base: "/drive/v2",
    url: url_DriveCommentsGet_580404, schemes: {Scheme.Https})
type
  Call_DriveCommentsPatch_580453 = ref object of OpenApiRestCall_579380
proc url_DriveCommentsPatch_580455(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveCommentsPatch_580454(path: JsonNode; query: JsonNode;
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
  var valid_580456 = path.getOrDefault("fileId")
  valid_580456 = validateParameter(valid_580456, JString, required = true,
                                 default = nil)
  if valid_580456 != nil:
    section.add "fileId", valid_580456
  var valid_580457 = path.getOrDefault("commentId")
  valid_580457 = validateParameter(valid_580457, JString, required = true,
                                 default = nil)
  if valid_580457 != nil:
    section.add "commentId", valid_580457
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580458 = query.getOrDefault("key")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "key", valid_580458
  var valid_580459 = query.getOrDefault("prettyPrint")
  valid_580459 = validateParameter(valid_580459, JBool, required = false,
                                 default = newJBool(true))
  if valid_580459 != nil:
    section.add "prettyPrint", valid_580459
  var valid_580460 = query.getOrDefault("oauth_token")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "oauth_token", valid_580460
  var valid_580461 = query.getOrDefault("alt")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = newJString("json"))
  if valid_580461 != nil:
    section.add "alt", valid_580461
  var valid_580462 = query.getOrDefault("userIp")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "userIp", valid_580462
  var valid_580463 = query.getOrDefault("quotaUser")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "quotaUser", valid_580463
  var valid_580464 = query.getOrDefault("fields")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "fields", valid_580464
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

proc call*(call_580466: Call_DriveCommentsPatch_580453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing comment.
  ## 
  let valid = call_580466.validator(path, query, header, formData, body)
  let scheme = call_580466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580466.url(scheme.get, call_580466.host, call_580466.base,
                         call_580466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580466, url, valid)

proc call*(call_580467: Call_DriveCommentsPatch_580453; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveCommentsPatch
  ## Updates an existing comment.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580468 = newJObject()
  var query_580469 = newJObject()
  var body_580470 = newJObject()
  add(query_580469, "key", newJString(key))
  add(query_580469, "prettyPrint", newJBool(prettyPrint))
  add(query_580469, "oauth_token", newJString(oauthToken))
  add(query_580469, "alt", newJString(alt))
  add(query_580469, "userIp", newJString(userIp))
  add(query_580469, "quotaUser", newJString(quotaUser))
  add(path_580468, "fileId", newJString(fileId))
  add(path_580468, "commentId", newJString(commentId))
  if body != nil:
    body_580470 = body
  add(query_580469, "fields", newJString(fields))
  result = call_580467.call(path_580468, query_580469, nil, nil, body_580470)

var driveCommentsPatch* = Call_DriveCommentsPatch_580453(
    name: "driveCommentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsPatch_580454, base: "/drive/v2",
    url: url_DriveCommentsPatch_580455, schemes: {Scheme.Https})
type
  Call_DriveCommentsDelete_580437 = ref object of OpenApiRestCall_579380
proc url_DriveCommentsDelete_580439(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveCommentsDelete_580438(path: JsonNode; query: JsonNode;
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
  var valid_580440 = path.getOrDefault("fileId")
  valid_580440 = validateParameter(valid_580440, JString, required = true,
                                 default = nil)
  if valid_580440 != nil:
    section.add "fileId", valid_580440
  var valid_580441 = path.getOrDefault("commentId")
  valid_580441 = validateParameter(valid_580441, JString, required = true,
                                 default = nil)
  if valid_580441 != nil:
    section.add "commentId", valid_580441
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580442 = query.getOrDefault("key")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "key", valid_580442
  var valid_580443 = query.getOrDefault("prettyPrint")
  valid_580443 = validateParameter(valid_580443, JBool, required = false,
                                 default = newJBool(true))
  if valid_580443 != nil:
    section.add "prettyPrint", valid_580443
  var valid_580444 = query.getOrDefault("oauth_token")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "oauth_token", valid_580444
  var valid_580445 = query.getOrDefault("alt")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = newJString("json"))
  if valid_580445 != nil:
    section.add "alt", valid_580445
  var valid_580446 = query.getOrDefault("userIp")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "userIp", valid_580446
  var valid_580447 = query.getOrDefault("quotaUser")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "quotaUser", valid_580447
  var valid_580448 = query.getOrDefault("fields")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "fields", valid_580448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580449: Call_DriveCommentsDelete_580437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_580449.validator(path, query, header, formData, body)
  let scheme = call_580449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580449.url(scheme.get, call_580449.host, call_580449.base,
                         call_580449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580449, url, valid)

proc call*(call_580450: Call_DriveCommentsDelete_580437; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveCommentsDelete
  ## Deletes a comment.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580451 = newJObject()
  var query_580452 = newJObject()
  add(query_580452, "key", newJString(key))
  add(query_580452, "prettyPrint", newJBool(prettyPrint))
  add(query_580452, "oauth_token", newJString(oauthToken))
  add(query_580452, "alt", newJString(alt))
  add(query_580452, "userIp", newJString(userIp))
  add(query_580452, "quotaUser", newJString(quotaUser))
  add(path_580451, "fileId", newJString(fileId))
  add(path_580451, "commentId", newJString(commentId))
  add(query_580452, "fields", newJString(fields))
  result = call_580450.call(path_580451, query_580452, nil, nil, nil)

var driveCommentsDelete* = Call_DriveCommentsDelete_580437(
    name: "driveCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsDelete_580438, base: "/drive/v2",
    url: url_DriveCommentsDelete_580439, schemes: {Scheme.Https})
type
  Call_DriveRepliesInsert_580490 = ref object of OpenApiRestCall_579380
proc url_DriveRepliesInsert_580492(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRepliesInsert_580491(path: JsonNode; query: JsonNode;
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
  var valid_580493 = path.getOrDefault("fileId")
  valid_580493 = validateParameter(valid_580493, JString, required = true,
                                 default = nil)
  if valid_580493 != nil:
    section.add "fileId", valid_580493
  var valid_580494 = path.getOrDefault("commentId")
  valid_580494 = validateParameter(valid_580494, JString, required = true,
                                 default = nil)
  if valid_580494 != nil:
    section.add "commentId", valid_580494
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580495 = query.getOrDefault("key")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "key", valid_580495
  var valid_580496 = query.getOrDefault("prettyPrint")
  valid_580496 = validateParameter(valid_580496, JBool, required = false,
                                 default = newJBool(true))
  if valid_580496 != nil:
    section.add "prettyPrint", valid_580496
  var valid_580497 = query.getOrDefault("oauth_token")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "oauth_token", valid_580497
  var valid_580498 = query.getOrDefault("alt")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = newJString("json"))
  if valid_580498 != nil:
    section.add "alt", valid_580498
  var valid_580499 = query.getOrDefault("userIp")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "userIp", valid_580499
  var valid_580500 = query.getOrDefault("quotaUser")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "quotaUser", valid_580500
  var valid_580501 = query.getOrDefault("fields")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "fields", valid_580501
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

proc call*(call_580503: Call_DriveRepliesInsert_580490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new reply to the given comment.
  ## 
  let valid = call_580503.validator(path, query, header, formData, body)
  let scheme = call_580503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580503.url(scheme.get, call_580503.host, call_580503.base,
                         call_580503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580503, url, valid)

proc call*(call_580504: Call_DriveRepliesInsert_580490; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveRepliesInsert
  ## Creates a new reply to the given comment.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580505 = newJObject()
  var query_580506 = newJObject()
  var body_580507 = newJObject()
  add(query_580506, "key", newJString(key))
  add(query_580506, "prettyPrint", newJBool(prettyPrint))
  add(query_580506, "oauth_token", newJString(oauthToken))
  add(query_580506, "alt", newJString(alt))
  add(query_580506, "userIp", newJString(userIp))
  add(query_580506, "quotaUser", newJString(quotaUser))
  add(path_580505, "fileId", newJString(fileId))
  add(path_580505, "commentId", newJString(commentId))
  if body != nil:
    body_580507 = body
  add(query_580506, "fields", newJString(fields))
  result = call_580504.call(path_580505, query_580506, nil, nil, body_580507)

var driveRepliesInsert* = Call_DriveRepliesInsert_580490(
    name: "driveRepliesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesInsert_580491, base: "/drive/v2",
    url: url_DriveRepliesInsert_580492, schemes: {Scheme.Https})
type
  Call_DriveRepliesList_580471 = ref object of OpenApiRestCall_579380
proc url_DriveRepliesList_580473(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRepliesList_580472(path: JsonNode; query: JsonNode;
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
  var valid_580474 = path.getOrDefault("fileId")
  valid_580474 = validateParameter(valid_580474, JString, required = true,
                                 default = nil)
  if valid_580474 != nil:
    section.add "fileId", valid_580474
  var valid_580475 = path.getOrDefault("commentId")
  valid_580475 = validateParameter(valid_580475, JString, required = true,
                                 default = nil)
  if valid_580475 != nil:
    section.add "commentId", valid_580475
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  ##            : The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeDeleted: JBool
  ##                 : If set, all replies, including deleted replies (with content stripped) will be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of replies to include in the response, used for paging.
  section = newJObject()
  var valid_580476 = query.getOrDefault("key")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "key", valid_580476
  var valid_580477 = query.getOrDefault("prettyPrint")
  valid_580477 = validateParameter(valid_580477, JBool, required = false,
                                 default = newJBool(true))
  if valid_580477 != nil:
    section.add "prettyPrint", valid_580477
  var valid_580478 = query.getOrDefault("oauth_token")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "oauth_token", valid_580478
  var valid_580479 = query.getOrDefault("alt")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = newJString("json"))
  if valid_580479 != nil:
    section.add "alt", valid_580479
  var valid_580480 = query.getOrDefault("userIp")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "userIp", valid_580480
  var valid_580481 = query.getOrDefault("quotaUser")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "quotaUser", valid_580481
  var valid_580482 = query.getOrDefault("pageToken")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "pageToken", valid_580482
  var valid_580483 = query.getOrDefault("includeDeleted")
  valid_580483 = validateParameter(valid_580483, JBool, required = false,
                                 default = newJBool(false))
  if valid_580483 != nil:
    section.add "includeDeleted", valid_580483
  var valid_580484 = query.getOrDefault("fields")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "fields", valid_580484
  var valid_580485 = query.getOrDefault("maxResults")
  valid_580485 = validateParameter(valid_580485, JInt, required = false,
                                 default = newJInt(20))
  if valid_580485 != nil:
    section.add "maxResults", valid_580485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580486: Call_DriveRepliesList_580471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the replies to a comment.
  ## 
  let valid = call_580486.validator(path, query, header, formData, body)
  let scheme = call_580486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580486.url(scheme.get, call_580486.host, call_580486.base,
                         call_580486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580486, url, valid)

proc call*(call_580487: Call_DriveRepliesList_580471; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; includeDeleted: bool = false;
          fields: string = ""; maxResults: int = 20): Recallable =
  ## driveRepliesList
  ## Lists all of the replies to a comment.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   pageToken: string
  ##            : The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : If set, all replies, including deleted replies (with content stripped) will be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of replies to include in the response, used for paging.
  var path_580488 = newJObject()
  var query_580489 = newJObject()
  add(query_580489, "key", newJString(key))
  add(query_580489, "prettyPrint", newJBool(prettyPrint))
  add(query_580489, "oauth_token", newJString(oauthToken))
  add(query_580489, "alt", newJString(alt))
  add(query_580489, "userIp", newJString(userIp))
  add(query_580489, "quotaUser", newJString(quotaUser))
  add(path_580488, "fileId", newJString(fileId))
  add(query_580489, "pageToken", newJString(pageToken))
  add(path_580488, "commentId", newJString(commentId))
  add(query_580489, "includeDeleted", newJBool(includeDeleted))
  add(query_580489, "fields", newJString(fields))
  add(query_580489, "maxResults", newJInt(maxResults))
  result = call_580487.call(path_580488, query_580489, nil, nil, nil)

var driveRepliesList* = Call_DriveRepliesList_580471(name: "driveRepliesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesList_580472, base: "/drive/v2",
    url: url_DriveRepliesList_580473, schemes: {Scheme.Https})
type
  Call_DriveRepliesUpdate_580526 = ref object of OpenApiRestCall_579380
proc url_DriveRepliesUpdate_580528(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRepliesUpdate_580527(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates an existing reply.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replyId` field"
  var valid_580529 = path.getOrDefault("replyId")
  valid_580529 = validateParameter(valid_580529, JString, required = true,
                                 default = nil)
  if valid_580529 != nil:
    section.add "replyId", valid_580529
  var valid_580530 = path.getOrDefault("fileId")
  valid_580530 = validateParameter(valid_580530, JString, required = true,
                                 default = nil)
  if valid_580530 != nil:
    section.add "fileId", valid_580530
  var valid_580531 = path.getOrDefault("commentId")
  valid_580531 = validateParameter(valid_580531, JString, required = true,
                                 default = nil)
  if valid_580531 != nil:
    section.add "commentId", valid_580531
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580532 = query.getOrDefault("key")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "key", valid_580532
  var valid_580533 = query.getOrDefault("prettyPrint")
  valid_580533 = validateParameter(valid_580533, JBool, required = false,
                                 default = newJBool(true))
  if valid_580533 != nil:
    section.add "prettyPrint", valid_580533
  var valid_580534 = query.getOrDefault("oauth_token")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "oauth_token", valid_580534
  var valid_580535 = query.getOrDefault("alt")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = newJString("json"))
  if valid_580535 != nil:
    section.add "alt", valid_580535
  var valid_580536 = query.getOrDefault("userIp")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "userIp", valid_580536
  var valid_580537 = query.getOrDefault("quotaUser")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "quotaUser", valid_580537
  var valid_580538 = query.getOrDefault("fields")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "fields", valid_580538
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

proc call*(call_580540: Call_DriveRepliesUpdate_580526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing reply.
  ## 
  let valid = call_580540.validator(path, query, header, formData, body)
  let scheme = call_580540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580540.url(scheme.get, call_580540.host, call_580540.base,
                         call_580540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580540, url, valid)

proc call*(call_580541: Call_DriveRepliesUpdate_580526; replyId: string;
          fileId: string; commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveRepliesUpdate
  ## Updates an existing reply.
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
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580542 = newJObject()
  var query_580543 = newJObject()
  var body_580544 = newJObject()
  add(query_580543, "key", newJString(key))
  add(query_580543, "prettyPrint", newJBool(prettyPrint))
  add(query_580543, "oauth_token", newJString(oauthToken))
  add(query_580543, "alt", newJString(alt))
  add(query_580543, "userIp", newJString(userIp))
  add(path_580542, "replyId", newJString(replyId))
  add(query_580543, "quotaUser", newJString(quotaUser))
  add(path_580542, "fileId", newJString(fileId))
  add(path_580542, "commentId", newJString(commentId))
  if body != nil:
    body_580544 = body
  add(query_580543, "fields", newJString(fields))
  result = call_580541.call(path_580542, query_580543, nil, nil, body_580544)

var driveRepliesUpdate* = Call_DriveRepliesUpdate_580526(
    name: "driveRepliesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesUpdate_580527, base: "/drive/v2",
    url: url_DriveRepliesUpdate_580528, schemes: {Scheme.Https})
type
  Call_DriveRepliesGet_580508 = ref object of OpenApiRestCall_579380
proc url_DriveRepliesGet_580510(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRepliesGet_580509(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a reply.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replyId` field"
  var valid_580511 = path.getOrDefault("replyId")
  valid_580511 = validateParameter(valid_580511, JString, required = true,
                                 default = nil)
  if valid_580511 != nil:
    section.add "replyId", valid_580511
  var valid_580512 = path.getOrDefault("fileId")
  valid_580512 = validateParameter(valid_580512, JString, required = true,
                                 default = nil)
  if valid_580512 != nil:
    section.add "fileId", valid_580512
  var valid_580513 = path.getOrDefault("commentId")
  valid_580513 = validateParameter(valid_580513, JString, required = true,
                                 default = nil)
  if valid_580513 != nil:
    section.add "commentId", valid_580513
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeDeleted: JBool
  ##                 : If set, this will succeed when retrieving a deleted reply.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580514 = query.getOrDefault("key")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "key", valid_580514
  var valid_580515 = query.getOrDefault("prettyPrint")
  valid_580515 = validateParameter(valid_580515, JBool, required = false,
                                 default = newJBool(true))
  if valid_580515 != nil:
    section.add "prettyPrint", valid_580515
  var valid_580516 = query.getOrDefault("oauth_token")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "oauth_token", valid_580516
  var valid_580517 = query.getOrDefault("alt")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = newJString("json"))
  if valid_580517 != nil:
    section.add "alt", valid_580517
  var valid_580518 = query.getOrDefault("userIp")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "userIp", valid_580518
  var valid_580519 = query.getOrDefault("quotaUser")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "quotaUser", valid_580519
  var valid_580520 = query.getOrDefault("includeDeleted")
  valid_580520 = validateParameter(valid_580520, JBool, required = false,
                                 default = newJBool(false))
  if valid_580520 != nil:
    section.add "includeDeleted", valid_580520
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

proc call*(call_580522: Call_DriveRepliesGet_580508; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a reply.
  ## 
  let valid = call_580522.validator(path, query, header, formData, body)
  let scheme = call_580522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580522.url(scheme.get, call_580522.host, call_580522.base,
                         call_580522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580522, url, valid)

proc call*(call_580523: Call_DriveRepliesGet_580508; replyId: string; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; includeDeleted: bool = false; fields: string = ""): Recallable =
  ## driveRepliesGet
  ## Gets a reply.
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
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   includeDeleted: bool
  ##                 : If set, this will succeed when retrieving a deleted reply.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580524 = newJObject()
  var query_580525 = newJObject()
  add(query_580525, "key", newJString(key))
  add(query_580525, "prettyPrint", newJBool(prettyPrint))
  add(query_580525, "oauth_token", newJString(oauthToken))
  add(query_580525, "alt", newJString(alt))
  add(query_580525, "userIp", newJString(userIp))
  add(path_580524, "replyId", newJString(replyId))
  add(query_580525, "quotaUser", newJString(quotaUser))
  add(path_580524, "fileId", newJString(fileId))
  add(path_580524, "commentId", newJString(commentId))
  add(query_580525, "includeDeleted", newJBool(includeDeleted))
  add(query_580525, "fields", newJString(fields))
  result = call_580523.call(path_580524, query_580525, nil, nil, nil)

var driveRepliesGet* = Call_DriveRepliesGet_580508(name: "driveRepliesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesGet_580509, base: "/drive/v2",
    url: url_DriveRepliesGet_580510, schemes: {Scheme.Https})
type
  Call_DriveRepliesPatch_580562 = ref object of OpenApiRestCall_579380
proc url_DriveRepliesPatch_580564(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRepliesPatch_580563(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates an existing reply.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replyId` field"
  var valid_580565 = path.getOrDefault("replyId")
  valid_580565 = validateParameter(valid_580565, JString, required = true,
                                 default = nil)
  if valid_580565 != nil:
    section.add "replyId", valid_580565
  var valid_580566 = path.getOrDefault("fileId")
  valid_580566 = validateParameter(valid_580566, JString, required = true,
                                 default = nil)
  if valid_580566 != nil:
    section.add "fileId", valid_580566
  var valid_580567 = path.getOrDefault("commentId")
  valid_580567 = validateParameter(valid_580567, JString, required = true,
                                 default = nil)
  if valid_580567 != nil:
    section.add "commentId", valid_580567
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580568 = query.getOrDefault("key")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "key", valid_580568
  var valid_580569 = query.getOrDefault("prettyPrint")
  valid_580569 = validateParameter(valid_580569, JBool, required = false,
                                 default = newJBool(true))
  if valid_580569 != nil:
    section.add "prettyPrint", valid_580569
  var valid_580570 = query.getOrDefault("oauth_token")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "oauth_token", valid_580570
  var valid_580571 = query.getOrDefault("alt")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = newJString("json"))
  if valid_580571 != nil:
    section.add "alt", valid_580571
  var valid_580572 = query.getOrDefault("userIp")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "userIp", valid_580572
  var valid_580573 = query.getOrDefault("quotaUser")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = nil)
  if valid_580573 != nil:
    section.add "quotaUser", valid_580573
  var valid_580574 = query.getOrDefault("fields")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "fields", valid_580574
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

proc call*(call_580576: Call_DriveRepliesPatch_580562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing reply.
  ## 
  let valid = call_580576.validator(path, query, header, formData, body)
  let scheme = call_580576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580576.url(scheme.get, call_580576.host, call_580576.base,
                         call_580576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580576, url, valid)

proc call*(call_580577: Call_DriveRepliesPatch_580562; replyId: string;
          fileId: string; commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveRepliesPatch
  ## Updates an existing reply.
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
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580578 = newJObject()
  var query_580579 = newJObject()
  var body_580580 = newJObject()
  add(query_580579, "key", newJString(key))
  add(query_580579, "prettyPrint", newJBool(prettyPrint))
  add(query_580579, "oauth_token", newJString(oauthToken))
  add(query_580579, "alt", newJString(alt))
  add(query_580579, "userIp", newJString(userIp))
  add(path_580578, "replyId", newJString(replyId))
  add(query_580579, "quotaUser", newJString(quotaUser))
  add(path_580578, "fileId", newJString(fileId))
  add(path_580578, "commentId", newJString(commentId))
  if body != nil:
    body_580580 = body
  add(query_580579, "fields", newJString(fields))
  result = call_580577.call(path_580578, query_580579, nil, nil, body_580580)

var driveRepliesPatch* = Call_DriveRepliesPatch_580562(name: "driveRepliesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesPatch_580563, base: "/drive/v2",
    url: url_DriveRepliesPatch_580564, schemes: {Scheme.Https})
type
  Call_DriveRepliesDelete_580545 = ref object of OpenApiRestCall_579380
proc url_DriveRepliesDelete_580547(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRepliesDelete_580546(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a reply.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replyId: JString (required)
  ##          : The ID of the reply.
  ##   fileId: JString (required)
  ##         : The ID of the file.
  ##   commentId: JString (required)
  ##            : The ID of the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replyId` field"
  var valid_580548 = path.getOrDefault("replyId")
  valid_580548 = validateParameter(valid_580548, JString, required = true,
                                 default = nil)
  if valid_580548 != nil:
    section.add "replyId", valid_580548
  var valid_580549 = path.getOrDefault("fileId")
  valid_580549 = validateParameter(valid_580549, JString, required = true,
                                 default = nil)
  if valid_580549 != nil:
    section.add "fileId", valid_580549
  var valid_580550 = path.getOrDefault("commentId")
  valid_580550 = validateParameter(valid_580550, JString, required = true,
                                 default = nil)
  if valid_580550 != nil:
    section.add "commentId", valid_580550
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580551 = query.getOrDefault("key")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "key", valid_580551
  var valid_580552 = query.getOrDefault("prettyPrint")
  valid_580552 = validateParameter(valid_580552, JBool, required = false,
                                 default = newJBool(true))
  if valid_580552 != nil:
    section.add "prettyPrint", valid_580552
  var valid_580553 = query.getOrDefault("oauth_token")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "oauth_token", valid_580553
  var valid_580554 = query.getOrDefault("alt")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = newJString("json"))
  if valid_580554 != nil:
    section.add "alt", valid_580554
  var valid_580555 = query.getOrDefault("userIp")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "userIp", valid_580555
  var valid_580556 = query.getOrDefault("quotaUser")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "quotaUser", valid_580556
  var valid_580557 = query.getOrDefault("fields")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "fields", valid_580557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580558: Call_DriveRepliesDelete_580545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a reply.
  ## 
  let valid = call_580558.validator(path, query, header, formData, body)
  let scheme = call_580558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580558.url(scheme.get, call_580558.host, call_580558.base,
                         call_580558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580558, url, valid)

proc call*(call_580559: Call_DriveRepliesDelete_580545; replyId: string;
          fileId: string; commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveRepliesDelete
  ## Deletes a reply.
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
  ##   replyId: string (required)
  ##          : The ID of the reply.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   commentId: string (required)
  ##            : The ID of the comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580560 = newJObject()
  var query_580561 = newJObject()
  add(query_580561, "key", newJString(key))
  add(query_580561, "prettyPrint", newJBool(prettyPrint))
  add(query_580561, "oauth_token", newJString(oauthToken))
  add(query_580561, "alt", newJString(alt))
  add(query_580561, "userIp", newJString(userIp))
  add(path_580560, "replyId", newJString(replyId))
  add(query_580561, "quotaUser", newJString(quotaUser))
  add(path_580560, "fileId", newJString(fileId))
  add(path_580560, "commentId", newJString(commentId))
  add(query_580561, "fields", newJString(fields))
  result = call_580559.call(path_580560, query_580561, nil, nil, nil)

var driveRepliesDelete* = Call_DriveRepliesDelete_580545(
    name: "driveRepliesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesDelete_580546, base: "/drive/v2",
    url: url_DriveRepliesDelete_580547, schemes: {Scheme.Https})
type
  Call_DriveFilesCopy_580581 = ref object of OpenApiRestCall_579380
proc url_DriveFilesCopy_580583(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesCopy_580582(path: JsonNode; query: JsonNode;
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
  var valid_580584 = path.getOrDefault("fileId")
  valid_580584 = validateParameter(valid_580584, JString, required = true,
                                 default = nil)
  if valid_580584 != nil:
    section.add "fileId", valid_580584
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   ocr: JBool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   ocrLanguage: JString
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextLanguage: JString
  ##                    : The language of the timed text.
  ##   convert: JBool
  ##          : Whether to convert this file to the corresponding Google Docs format.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   timedTextTrackName: JString
  ##                     : The timed text track name.
  ##   visibility: JString
  ##             : The visibility of the new file. This parameter is only relevant when the source is not a native Google Doc and convert=false.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pinned: JBool
  ##         : Whether to pin the head revision of the new copy. A file can have a maximum of 200 pinned revisions.
  section = newJObject()
  var valid_580585 = query.getOrDefault("key")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "key", valid_580585
  var valid_580586 = query.getOrDefault("prettyPrint")
  valid_580586 = validateParameter(valid_580586, JBool, required = false,
                                 default = newJBool(true))
  if valid_580586 != nil:
    section.add "prettyPrint", valid_580586
  var valid_580587 = query.getOrDefault("oauth_token")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "oauth_token", valid_580587
  var valid_580588 = query.getOrDefault("ocr")
  valid_580588 = validateParameter(valid_580588, JBool, required = false,
                                 default = newJBool(false))
  if valid_580588 != nil:
    section.add "ocr", valid_580588
  var valid_580589 = query.getOrDefault("ocrLanguage")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "ocrLanguage", valid_580589
  var valid_580590 = query.getOrDefault("timedTextLanguage")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "timedTextLanguage", valid_580590
  var valid_580591 = query.getOrDefault("convert")
  valid_580591 = validateParameter(valid_580591, JBool, required = false,
                                 default = newJBool(false))
  if valid_580591 != nil:
    section.add "convert", valid_580591
  var valid_580592 = query.getOrDefault("alt")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = newJString("json"))
  if valid_580592 != nil:
    section.add "alt", valid_580592
  var valid_580593 = query.getOrDefault("userIp")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "userIp", valid_580593
  var valid_580594 = query.getOrDefault("quotaUser")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "quotaUser", valid_580594
  var valid_580595 = query.getOrDefault("supportsTeamDrives")
  valid_580595 = validateParameter(valid_580595, JBool, required = false,
                                 default = newJBool(false))
  if valid_580595 != nil:
    section.add "supportsTeamDrives", valid_580595
  var valid_580596 = query.getOrDefault("timedTextTrackName")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "timedTextTrackName", valid_580596
  var valid_580597 = query.getOrDefault("visibility")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_580597 != nil:
    section.add "visibility", valid_580597
  var valid_580598 = query.getOrDefault("supportsAllDrives")
  valid_580598 = validateParameter(valid_580598, JBool, required = false,
                                 default = newJBool(false))
  if valid_580598 != nil:
    section.add "supportsAllDrives", valid_580598
  var valid_580599 = query.getOrDefault("fields")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "fields", valid_580599
  var valid_580600 = query.getOrDefault("pinned")
  valid_580600 = validateParameter(valid_580600, JBool, required = false,
                                 default = newJBool(false))
  if valid_580600 != nil:
    section.add "pinned", valid_580600
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

proc call*(call_580602: Call_DriveFilesCopy_580581; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a copy of the specified file.
  ## 
  let valid = call_580602.validator(path, query, header, formData, body)
  let scheme = call_580602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580602.url(scheme.get, call_580602.host, call_580602.base,
                         call_580602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580602, url, valid)

proc call*(call_580603: Call_DriveFilesCopy_580581; fileId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; ocr: bool = false;
          ocrLanguage: string = ""; timedTextLanguage: string = "";
          convert: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsTeamDrives: bool = false;
          timedTextTrackName: string = ""; visibility: string = "DEFAULT";
          supportsAllDrives: bool = false; body: JsonNode = nil; fields: string = "";
          pinned: bool = false): Recallable =
  ## driveFilesCopy
  ## Creates a copy of the specified file.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   ocr: bool
  ##      : Whether to attempt OCR on .jpg, .png, .gif, or .pdf uploads.
  ##   ocrLanguage: string
  ##              : If ocr is true, hints at the language to use. Valid values are BCP 47 codes.
  ##   timedTextLanguage: string
  ##                    : The language of the timed text.
  ##   convert: bool
  ##          : Whether to convert this file to the corresponding Google Docs format.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file to copy.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   timedTextTrackName: string
  ##                     : The timed text track name.
  ##   visibility: string
  ##             : The visibility of the new file. This parameter is only relevant when the source is not a native Google Doc and convert=false.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pinned: bool
  ##         : Whether to pin the head revision of the new copy. A file can have a maximum of 200 pinned revisions.
  var path_580604 = newJObject()
  var query_580605 = newJObject()
  var body_580606 = newJObject()
  add(query_580605, "key", newJString(key))
  add(query_580605, "prettyPrint", newJBool(prettyPrint))
  add(query_580605, "oauth_token", newJString(oauthToken))
  add(query_580605, "ocr", newJBool(ocr))
  add(query_580605, "ocrLanguage", newJString(ocrLanguage))
  add(query_580605, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_580605, "convert", newJBool(convert))
  add(query_580605, "alt", newJString(alt))
  add(query_580605, "userIp", newJString(userIp))
  add(query_580605, "quotaUser", newJString(quotaUser))
  add(path_580604, "fileId", newJString(fileId))
  add(query_580605, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580605, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_580605, "visibility", newJString(visibility))
  add(query_580605, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_580606 = body
  add(query_580605, "fields", newJString(fields))
  add(query_580605, "pinned", newJBool(pinned))
  result = call_580603.call(path_580604, query_580605, nil, nil, body_580606)

var driveFilesCopy* = Call_DriveFilesCopy_580581(name: "driveFilesCopy",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/copy", validator: validate_DriveFilesCopy_580582,
    base: "/drive/v2", url: url_DriveFilesCopy_580583, schemes: {Scheme.Https})
type
  Call_DriveFilesExport_580607 = ref object of OpenApiRestCall_579380
proc url_DriveFilesExport_580609(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesExport_580608(path: JsonNode; query: JsonNode;
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
  var valid_580610 = path.getOrDefault("fileId")
  valid_580610 = validateParameter(valid_580610, JString, required = true,
                                 default = nil)
  if valid_580610 != nil:
    section.add "fileId", valid_580610
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   mimeType: JString (required)
  ##           : The MIME type of the format requested for this export.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580611 = query.getOrDefault("key")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "key", valid_580611
  var valid_580612 = query.getOrDefault("prettyPrint")
  valid_580612 = validateParameter(valid_580612, JBool, required = false,
                                 default = newJBool(true))
  if valid_580612 != nil:
    section.add "prettyPrint", valid_580612
  var valid_580613 = query.getOrDefault("oauth_token")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "oauth_token", valid_580613
  var valid_580614 = query.getOrDefault("alt")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = newJString("json"))
  if valid_580614 != nil:
    section.add "alt", valid_580614
  var valid_580615 = query.getOrDefault("userIp")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "userIp", valid_580615
  var valid_580616 = query.getOrDefault("quotaUser")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = nil)
  if valid_580616 != nil:
    section.add "quotaUser", valid_580616
  assert query != nil,
        "query argument is necessary due to required `mimeType` field"
  var valid_580617 = query.getOrDefault("mimeType")
  valid_580617 = validateParameter(valid_580617, JString, required = true,
                                 default = nil)
  if valid_580617 != nil:
    section.add "mimeType", valid_580617
  var valid_580618 = query.getOrDefault("fields")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "fields", valid_580618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580619: Call_DriveFilesExport_580607; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  let valid = call_580619.validator(path, query, header, formData, body)
  let scheme = call_580619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580619.url(scheme.get, call_580619.host, call_580619.base,
                         call_580619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580619, url, valid)

proc call*(call_580620: Call_DriveFilesExport_580607; fileId: string;
          mimeType: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveFilesExport
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   mimeType: string (required)
  ##           : The MIME type of the format requested for this export.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580621 = newJObject()
  var query_580622 = newJObject()
  add(query_580622, "key", newJString(key))
  add(query_580622, "prettyPrint", newJBool(prettyPrint))
  add(query_580622, "oauth_token", newJString(oauthToken))
  add(query_580622, "alt", newJString(alt))
  add(query_580622, "userIp", newJString(userIp))
  add(query_580622, "quotaUser", newJString(quotaUser))
  add(path_580621, "fileId", newJString(fileId))
  add(query_580622, "mimeType", newJString(mimeType))
  add(query_580622, "fields", newJString(fields))
  result = call_580620.call(path_580621, query_580622, nil, nil, nil)

var driveFilesExport* = Call_DriveFilesExport_580607(name: "driveFilesExport",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/export", validator: validate_DriveFilesExport_580608,
    base: "/drive/v2", url: url_DriveFilesExport_580609, schemes: {Scheme.Https})
type
  Call_DriveParentsInsert_580638 = ref object of OpenApiRestCall_579380
proc url_DriveParentsInsert_580640(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveParentsInsert_580639(path: JsonNode; query: JsonNode;
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
  var valid_580641 = path.getOrDefault("fileId")
  valid_580641 = validateParameter(valid_580641, JString, required = true,
                                 default = nil)
  if valid_580641 != nil:
    section.add "fileId", valid_580641
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580642 = query.getOrDefault("key")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "key", valid_580642
  var valid_580643 = query.getOrDefault("prettyPrint")
  valid_580643 = validateParameter(valid_580643, JBool, required = false,
                                 default = newJBool(true))
  if valid_580643 != nil:
    section.add "prettyPrint", valid_580643
  var valid_580644 = query.getOrDefault("oauth_token")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "oauth_token", valid_580644
  var valid_580645 = query.getOrDefault("alt")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = newJString("json"))
  if valid_580645 != nil:
    section.add "alt", valid_580645
  var valid_580646 = query.getOrDefault("userIp")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "userIp", valid_580646
  var valid_580647 = query.getOrDefault("quotaUser")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "quotaUser", valid_580647
  var valid_580648 = query.getOrDefault("supportsTeamDrives")
  valid_580648 = validateParameter(valid_580648, JBool, required = false,
                                 default = newJBool(false))
  if valid_580648 != nil:
    section.add "supportsTeamDrives", valid_580648
  var valid_580649 = query.getOrDefault("supportsAllDrives")
  valid_580649 = validateParameter(valid_580649, JBool, required = false,
                                 default = newJBool(false))
  if valid_580649 != nil:
    section.add "supportsAllDrives", valid_580649
  var valid_580650 = query.getOrDefault("fields")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = nil)
  if valid_580650 != nil:
    section.add "fields", valid_580650
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

proc call*(call_580652: Call_DriveParentsInsert_580638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a parent folder for a file.
  ## 
  let valid = call_580652.validator(path, query, header, formData, body)
  let scheme = call_580652.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580652.url(scheme.get, call_580652.host, call_580652.base,
                         call_580652.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580652, url, valid)

proc call*(call_580653: Call_DriveParentsInsert_580638; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveParentsInsert
  ## Adds a parent folder for a file.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580654 = newJObject()
  var query_580655 = newJObject()
  var body_580656 = newJObject()
  add(query_580655, "key", newJString(key))
  add(query_580655, "prettyPrint", newJBool(prettyPrint))
  add(query_580655, "oauth_token", newJString(oauthToken))
  add(query_580655, "alt", newJString(alt))
  add(query_580655, "userIp", newJString(userIp))
  add(query_580655, "quotaUser", newJString(quotaUser))
  add(path_580654, "fileId", newJString(fileId))
  add(query_580655, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580655, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_580656 = body
  add(query_580655, "fields", newJString(fields))
  result = call_580653.call(path_580654, query_580655, nil, nil, body_580656)

var driveParentsInsert* = Call_DriveParentsInsert_580638(
    name: "driveParentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/parents",
    validator: validate_DriveParentsInsert_580639, base: "/drive/v2",
    url: url_DriveParentsInsert_580640, schemes: {Scheme.Https})
type
  Call_DriveParentsList_580623 = ref object of OpenApiRestCall_579380
proc url_DriveParentsList_580625(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveParentsList_580624(path: JsonNode; query: JsonNode;
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
  var valid_580626 = path.getOrDefault("fileId")
  valid_580626 = validateParameter(valid_580626, JString, required = true,
                                 default = nil)
  if valid_580626 != nil:
    section.add "fileId", valid_580626
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580627 = query.getOrDefault("key")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "key", valid_580627
  var valid_580628 = query.getOrDefault("prettyPrint")
  valid_580628 = validateParameter(valid_580628, JBool, required = false,
                                 default = newJBool(true))
  if valid_580628 != nil:
    section.add "prettyPrint", valid_580628
  var valid_580629 = query.getOrDefault("oauth_token")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "oauth_token", valid_580629
  var valid_580630 = query.getOrDefault("alt")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = newJString("json"))
  if valid_580630 != nil:
    section.add "alt", valid_580630
  var valid_580631 = query.getOrDefault("userIp")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "userIp", valid_580631
  var valid_580632 = query.getOrDefault("quotaUser")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "quotaUser", valid_580632
  var valid_580633 = query.getOrDefault("fields")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "fields", valid_580633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580634: Call_DriveParentsList_580623; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's parents.
  ## 
  let valid = call_580634.validator(path, query, header, formData, body)
  let scheme = call_580634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580634.url(scheme.get, call_580634.host, call_580634.base,
                         call_580634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580634, url, valid)

proc call*(call_580635: Call_DriveParentsList_580623; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## driveParentsList
  ## Lists a file's parents.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580636 = newJObject()
  var query_580637 = newJObject()
  add(query_580637, "key", newJString(key))
  add(query_580637, "prettyPrint", newJBool(prettyPrint))
  add(query_580637, "oauth_token", newJString(oauthToken))
  add(query_580637, "alt", newJString(alt))
  add(query_580637, "userIp", newJString(userIp))
  add(query_580637, "quotaUser", newJString(quotaUser))
  add(path_580636, "fileId", newJString(fileId))
  add(query_580637, "fields", newJString(fields))
  result = call_580635.call(path_580636, query_580637, nil, nil, nil)

var driveParentsList* = Call_DriveParentsList_580623(name: "driveParentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/parents", validator: validate_DriveParentsList_580624,
    base: "/drive/v2", url: url_DriveParentsList_580625, schemes: {Scheme.Https})
type
  Call_DriveParentsGet_580657 = ref object of OpenApiRestCall_579380
proc url_DriveParentsGet_580659(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveParentsGet_580658(path: JsonNode; query: JsonNode;
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
  var valid_580660 = path.getOrDefault("fileId")
  valid_580660 = validateParameter(valid_580660, JString, required = true,
                                 default = nil)
  if valid_580660 != nil:
    section.add "fileId", valid_580660
  var valid_580661 = path.getOrDefault("parentId")
  valid_580661 = validateParameter(valid_580661, JString, required = true,
                                 default = nil)
  if valid_580661 != nil:
    section.add "parentId", valid_580661
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580662 = query.getOrDefault("key")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "key", valid_580662
  var valid_580663 = query.getOrDefault("prettyPrint")
  valid_580663 = validateParameter(valid_580663, JBool, required = false,
                                 default = newJBool(true))
  if valid_580663 != nil:
    section.add "prettyPrint", valid_580663
  var valid_580664 = query.getOrDefault("oauth_token")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "oauth_token", valid_580664
  var valid_580665 = query.getOrDefault("alt")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = newJString("json"))
  if valid_580665 != nil:
    section.add "alt", valid_580665
  var valid_580666 = query.getOrDefault("userIp")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = nil)
  if valid_580666 != nil:
    section.add "userIp", valid_580666
  var valid_580667 = query.getOrDefault("quotaUser")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "quotaUser", valid_580667
  var valid_580668 = query.getOrDefault("fields")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "fields", valid_580668
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580669: Call_DriveParentsGet_580657; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific parent reference.
  ## 
  let valid = call_580669.validator(path, query, header, formData, body)
  let scheme = call_580669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580669.url(scheme.get, call_580669.host, call_580669.base,
                         call_580669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580669, url, valid)

proc call*(call_580670: Call_DriveParentsGet_580657; fileId: string;
          parentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveParentsGet
  ## Gets a specific parent reference.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   parentId: string (required)
  ##           : The ID of the parent.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580671 = newJObject()
  var query_580672 = newJObject()
  add(query_580672, "key", newJString(key))
  add(query_580672, "prettyPrint", newJBool(prettyPrint))
  add(query_580672, "oauth_token", newJString(oauthToken))
  add(query_580672, "alt", newJString(alt))
  add(query_580672, "userIp", newJString(userIp))
  add(query_580672, "quotaUser", newJString(quotaUser))
  add(path_580671, "fileId", newJString(fileId))
  add(path_580671, "parentId", newJString(parentId))
  add(query_580672, "fields", newJString(fields))
  result = call_580670.call(path_580671, query_580672, nil, nil, nil)

var driveParentsGet* = Call_DriveParentsGet_580657(name: "driveParentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/parents/{parentId}",
    validator: validate_DriveParentsGet_580658, base: "/drive/v2",
    url: url_DriveParentsGet_580659, schemes: {Scheme.Https})
type
  Call_DriveParentsDelete_580673 = ref object of OpenApiRestCall_579380
proc url_DriveParentsDelete_580675(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveParentsDelete_580674(path: JsonNode; query: JsonNode;
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
  var valid_580676 = path.getOrDefault("fileId")
  valid_580676 = validateParameter(valid_580676, JString, required = true,
                                 default = nil)
  if valid_580676 != nil:
    section.add "fileId", valid_580676
  var valid_580677 = path.getOrDefault("parentId")
  valid_580677 = validateParameter(valid_580677, JString, required = true,
                                 default = nil)
  if valid_580677 != nil:
    section.add "parentId", valid_580677
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580678 = query.getOrDefault("key")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "key", valid_580678
  var valid_580679 = query.getOrDefault("prettyPrint")
  valid_580679 = validateParameter(valid_580679, JBool, required = false,
                                 default = newJBool(true))
  if valid_580679 != nil:
    section.add "prettyPrint", valid_580679
  var valid_580680 = query.getOrDefault("oauth_token")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "oauth_token", valid_580680
  var valid_580681 = query.getOrDefault("alt")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = newJString("json"))
  if valid_580681 != nil:
    section.add "alt", valid_580681
  var valid_580682 = query.getOrDefault("userIp")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = nil)
  if valid_580682 != nil:
    section.add "userIp", valid_580682
  var valid_580683 = query.getOrDefault("quotaUser")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "quotaUser", valid_580683
  var valid_580684 = query.getOrDefault("fields")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "fields", valid_580684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580685: Call_DriveParentsDelete_580673; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a parent from a file.
  ## 
  let valid = call_580685.validator(path, query, header, formData, body)
  let scheme = call_580685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580685.url(scheme.get, call_580685.host, call_580685.base,
                         call_580685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580685, url, valid)

proc call*(call_580686: Call_DriveParentsDelete_580673; fileId: string;
          parentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveParentsDelete
  ## Removes a parent from a file.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   parentId: string (required)
  ##           : The ID of the parent.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580687 = newJObject()
  var query_580688 = newJObject()
  add(query_580688, "key", newJString(key))
  add(query_580688, "prettyPrint", newJBool(prettyPrint))
  add(query_580688, "oauth_token", newJString(oauthToken))
  add(query_580688, "alt", newJString(alt))
  add(query_580688, "userIp", newJString(userIp))
  add(query_580688, "quotaUser", newJString(quotaUser))
  add(path_580687, "fileId", newJString(fileId))
  add(path_580687, "parentId", newJString(parentId))
  add(query_580688, "fields", newJString(fields))
  result = call_580686.call(path_580687, query_580688, nil, nil, nil)

var driveParentsDelete* = Call_DriveParentsDelete_580673(
    name: "driveParentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/parents/{parentId}",
    validator: validate_DriveParentsDelete_580674, base: "/drive/v2",
    url: url_DriveParentsDelete_580675, schemes: {Scheme.Https})
type
  Call_DrivePermissionsInsert_580709 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsInsert_580711(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsInsert_580710(path: JsonNode; query: JsonNode;
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
  var valid_580712 = path.getOrDefault("fileId")
  valid_580712 = validateParameter(valid_580712, JString, required = true,
                                 default = nil)
  if valid_580712 != nil:
    section.add "fileId", valid_580712
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sendNotificationEmails: JBool
  ##                         : Whether to send notification emails when sharing to users or groups. This parameter is ignored and an email is sent if the role is owner.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   emailMessage: JString
  ##               : A plain text custom message to include in notification emails.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580713 = query.getOrDefault("key")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "key", valid_580713
  var valid_580714 = query.getOrDefault("prettyPrint")
  valid_580714 = validateParameter(valid_580714, JBool, required = false,
                                 default = newJBool(true))
  if valid_580714 != nil:
    section.add "prettyPrint", valid_580714
  var valid_580715 = query.getOrDefault("oauth_token")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "oauth_token", valid_580715
  var valid_580716 = query.getOrDefault("useDomainAdminAccess")
  valid_580716 = validateParameter(valid_580716, JBool, required = false,
                                 default = newJBool(false))
  if valid_580716 != nil:
    section.add "useDomainAdminAccess", valid_580716
  var valid_580717 = query.getOrDefault("alt")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = newJString("json"))
  if valid_580717 != nil:
    section.add "alt", valid_580717
  var valid_580718 = query.getOrDefault("userIp")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "userIp", valid_580718
  var valid_580719 = query.getOrDefault("quotaUser")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "quotaUser", valid_580719
  var valid_580720 = query.getOrDefault("sendNotificationEmails")
  valid_580720 = validateParameter(valid_580720, JBool, required = false,
                                 default = newJBool(true))
  if valid_580720 != nil:
    section.add "sendNotificationEmails", valid_580720
  var valid_580721 = query.getOrDefault("supportsTeamDrives")
  valid_580721 = validateParameter(valid_580721, JBool, required = false,
                                 default = newJBool(false))
  if valid_580721 != nil:
    section.add "supportsTeamDrives", valid_580721
  var valid_580722 = query.getOrDefault("emailMessage")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "emailMessage", valid_580722
  var valid_580723 = query.getOrDefault("supportsAllDrives")
  valid_580723 = validateParameter(valid_580723, JBool, required = false,
                                 default = newJBool(false))
  if valid_580723 != nil:
    section.add "supportsAllDrives", valid_580723
  var valid_580724 = query.getOrDefault("fields")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = nil)
  if valid_580724 != nil:
    section.add "fields", valid_580724
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

proc call*(call_580726: Call_DrivePermissionsInsert_580709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a permission for a file or shared drive.
  ## 
  let valid = call_580726.validator(path, query, header, formData, body)
  let scheme = call_580726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580726.url(scheme.get, call_580726.host, call_580726.base,
                         call_580726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580726, url, valid)

proc call*(call_580727: Call_DrivePermissionsInsert_580709; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; sendNotificationEmails: bool = true;
          supportsTeamDrives: bool = false; emailMessage: string = "";
          supportsAllDrives: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## drivePermissionsInsert
  ## Inserts a permission for a file or shared drive.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   sendNotificationEmails: bool
  ##                         : Whether to send notification emails when sharing to users or groups. This parameter is ignored and an email is sent if the role is owner.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   emailMessage: string
  ##               : A plain text custom message to include in notification emails.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580728 = newJObject()
  var query_580729 = newJObject()
  var body_580730 = newJObject()
  add(query_580729, "key", newJString(key))
  add(query_580729, "prettyPrint", newJBool(prettyPrint))
  add(query_580729, "oauth_token", newJString(oauthToken))
  add(query_580729, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580729, "alt", newJString(alt))
  add(query_580729, "userIp", newJString(userIp))
  add(query_580729, "quotaUser", newJString(quotaUser))
  add(path_580728, "fileId", newJString(fileId))
  add(query_580729, "sendNotificationEmails", newJBool(sendNotificationEmails))
  add(query_580729, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580729, "emailMessage", newJString(emailMessage))
  add(query_580729, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_580730 = body
  add(query_580729, "fields", newJString(fields))
  result = call_580727.call(path_580728, query_580729, nil, nil, body_580730)

var drivePermissionsInsert* = Call_DrivePermissionsInsert_580709(
    name: "drivePermissionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsInsert_580710, base: "/drive/v2",
    url: url_DrivePermissionsInsert_580711, schemes: {Scheme.Https})
type
  Call_DrivePermissionsList_580689 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsList_580691(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsList_580690(path: JsonNode; query: JsonNode;
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
  var valid_580692 = path.getOrDefault("fileId")
  valid_580692 = validateParameter(valid_580692, JString, required = true,
                                 default = nil)
  if valid_580692 != nil:
    section.add "fileId", valid_580692
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of permissions to return per page. When not set for files in a shared drive, at most 100 results will be returned. When not set for files that are not in a shared drive, the entire list will be returned.
  section = newJObject()
  var valid_580693 = query.getOrDefault("key")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = nil)
  if valid_580693 != nil:
    section.add "key", valid_580693
  var valid_580694 = query.getOrDefault("prettyPrint")
  valid_580694 = validateParameter(valid_580694, JBool, required = false,
                                 default = newJBool(true))
  if valid_580694 != nil:
    section.add "prettyPrint", valid_580694
  var valid_580695 = query.getOrDefault("oauth_token")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "oauth_token", valid_580695
  var valid_580696 = query.getOrDefault("useDomainAdminAccess")
  valid_580696 = validateParameter(valid_580696, JBool, required = false,
                                 default = newJBool(false))
  if valid_580696 != nil:
    section.add "useDomainAdminAccess", valid_580696
  var valid_580697 = query.getOrDefault("alt")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = newJString("json"))
  if valid_580697 != nil:
    section.add "alt", valid_580697
  var valid_580698 = query.getOrDefault("userIp")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "userIp", valid_580698
  var valid_580699 = query.getOrDefault("quotaUser")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "quotaUser", valid_580699
  var valid_580700 = query.getOrDefault("pageToken")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "pageToken", valid_580700
  var valid_580701 = query.getOrDefault("supportsTeamDrives")
  valid_580701 = validateParameter(valid_580701, JBool, required = false,
                                 default = newJBool(false))
  if valid_580701 != nil:
    section.add "supportsTeamDrives", valid_580701
  var valid_580702 = query.getOrDefault("supportsAllDrives")
  valid_580702 = validateParameter(valid_580702, JBool, required = false,
                                 default = newJBool(false))
  if valid_580702 != nil:
    section.add "supportsAllDrives", valid_580702
  var valid_580703 = query.getOrDefault("fields")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "fields", valid_580703
  var valid_580704 = query.getOrDefault("maxResults")
  valid_580704 = validateParameter(valid_580704, JInt, required = false, default = nil)
  if valid_580704 != nil:
    section.add "maxResults", valid_580704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580705: Call_DrivePermissionsList_580689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's or shared drive's permissions.
  ## 
  let valid = call_580705.validator(path, query, header, formData, body)
  let scheme = call_580705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580705.url(scheme.get, call_580705.host, call_580705.base,
                         call_580705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580705, url, valid)

proc call*(call_580706: Call_DrivePermissionsList_580689; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          fields: string = ""; maxResults: int = 0): Recallable =
  ## drivePermissionsList
  ## Lists a file's or shared drive's permissions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of permissions to return per page. When not set for files in a shared drive, at most 100 results will be returned. When not set for files that are not in a shared drive, the entire list will be returned.
  var path_580707 = newJObject()
  var query_580708 = newJObject()
  add(query_580708, "key", newJString(key))
  add(query_580708, "prettyPrint", newJBool(prettyPrint))
  add(query_580708, "oauth_token", newJString(oauthToken))
  add(query_580708, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580708, "alt", newJString(alt))
  add(query_580708, "userIp", newJString(userIp))
  add(query_580708, "quotaUser", newJString(quotaUser))
  add(path_580707, "fileId", newJString(fileId))
  add(query_580708, "pageToken", newJString(pageToken))
  add(query_580708, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580708, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580708, "fields", newJString(fields))
  add(query_580708, "maxResults", newJInt(maxResults))
  result = call_580706.call(path_580707, query_580708, nil, nil, nil)

var drivePermissionsList* = Call_DrivePermissionsList_580689(
    name: "drivePermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsList_580690, base: "/drive/v2",
    url: url_DrivePermissionsList_580691, schemes: {Scheme.Https})
type
  Call_DrivePermissionsUpdate_580750 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsUpdate_580752(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsUpdate_580751(path: JsonNode; query: JsonNode;
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
  var valid_580753 = path.getOrDefault("fileId")
  valid_580753 = validateParameter(valid_580753, JString, required = true,
                                 default = nil)
  if valid_580753 != nil:
    section.add "fileId", valid_580753
  var valid_580754 = path.getOrDefault("permissionId")
  valid_580754 = validateParameter(valid_580754, JString, required = true,
                                 default = nil)
  if valid_580754 != nil:
    section.add "permissionId", valid_580754
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   removeExpiration: JBool
  ##                   : Whether to remove the expiration date.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   transferOwnership: JBool
  ##                    : Whether changing a role to 'owner' downgrades the current owners to writers. Does nothing if the specified role is not 'owner'.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580755 = query.getOrDefault("key")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "key", valid_580755
  var valid_580756 = query.getOrDefault("prettyPrint")
  valid_580756 = validateParameter(valid_580756, JBool, required = false,
                                 default = newJBool(true))
  if valid_580756 != nil:
    section.add "prettyPrint", valid_580756
  var valid_580757 = query.getOrDefault("oauth_token")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "oauth_token", valid_580757
  var valid_580758 = query.getOrDefault("useDomainAdminAccess")
  valid_580758 = validateParameter(valid_580758, JBool, required = false,
                                 default = newJBool(false))
  if valid_580758 != nil:
    section.add "useDomainAdminAccess", valid_580758
  var valid_580759 = query.getOrDefault("removeExpiration")
  valid_580759 = validateParameter(valid_580759, JBool, required = false,
                                 default = newJBool(false))
  if valid_580759 != nil:
    section.add "removeExpiration", valid_580759
  var valid_580760 = query.getOrDefault("alt")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = newJString("json"))
  if valid_580760 != nil:
    section.add "alt", valid_580760
  var valid_580761 = query.getOrDefault("userIp")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "userIp", valid_580761
  var valid_580762 = query.getOrDefault("quotaUser")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "quotaUser", valid_580762
  var valid_580763 = query.getOrDefault("supportsTeamDrives")
  valid_580763 = validateParameter(valid_580763, JBool, required = false,
                                 default = newJBool(false))
  if valid_580763 != nil:
    section.add "supportsTeamDrives", valid_580763
  var valid_580764 = query.getOrDefault("transferOwnership")
  valid_580764 = validateParameter(valid_580764, JBool, required = false,
                                 default = newJBool(false))
  if valid_580764 != nil:
    section.add "transferOwnership", valid_580764
  var valid_580765 = query.getOrDefault("supportsAllDrives")
  valid_580765 = validateParameter(valid_580765, JBool, required = false,
                                 default = newJBool(false))
  if valid_580765 != nil:
    section.add "supportsAllDrives", valid_580765
  var valid_580766 = query.getOrDefault("fields")
  valid_580766 = validateParameter(valid_580766, JString, required = false,
                                 default = nil)
  if valid_580766 != nil:
    section.add "fields", valid_580766
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

proc call*(call_580768: Call_DrivePermissionsUpdate_580750; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission.
  ## 
  let valid = call_580768.validator(path, query, header, formData, body)
  let scheme = call_580768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580768.url(scheme.get, call_580768.host, call_580768.base,
                         call_580768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580768, url, valid)

proc call*(call_580769: Call_DrivePermissionsUpdate_580750; fileId: string;
          permissionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; useDomainAdminAccess: bool = false;
          removeExpiration: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsTeamDrives: bool = false;
          transferOwnership: bool = false; supportsAllDrives: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## drivePermissionsUpdate
  ## Updates a permission.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   removeExpiration: bool
  ##                   : Whether to remove the expiration date.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   transferOwnership: bool
  ##                    : Whether changing a role to 'owner' downgrades the current owners to writers. Does nothing if the specified role is not 'owner'.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   permissionId: string (required)
  ##               : The ID for the permission.
  var path_580770 = newJObject()
  var query_580771 = newJObject()
  var body_580772 = newJObject()
  add(query_580771, "key", newJString(key))
  add(query_580771, "prettyPrint", newJBool(prettyPrint))
  add(query_580771, "oauth_token", newJString(oauthToken))
  add(query_580771, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580771, "removeExpiration", newJBool(removeExpiration))
  add(query_580771, "alt", newJString(alt))
  add(query_580771, "userIp", newJString(userIp))
  add(query_580771, "quotaUser", newJString(quotaUser))
  add(path_580770, "fileId", newJString(fileId))
  add(query_580771, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580771, "transferOwnership", newJBool(transferOwnership))
  add(query_580771, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_580772 = body
  add(query_580771, "fields", newJString(fields))
  add(path_580770, "permissionId", newJString(permissionId))
  result = call_580769.call(path_580770, query_580771, nil, nil, body_580772)

var drivePermissionsUpdate* = Call_DrivePermissionsUpdate_580750(
    name: "drivePermissionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsUpdate_580751, base: "/drive/v2",
    url: url_DrivePermissionsUpdate_580752, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGet_580731 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsGet_580733(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsGet_580732(path: JsonNode; query: JsonNode;
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
  var valid_580734 = path.getOrDefault("fileId")
  valid_580734 = validateParameter(valid_580734, JString, required = true,
                                 default = nil)
  if valid_580734 != nil:
    section.add "fileId", valid_580734
  var valid_580735 = path.getOrDefault("permissionId")
  valid_580735 = validateParameter(valid_580735, JString, required = true,
                                 default = nil)
  if valid_580735 != nil:
    section.add "permissionId", valid_580735
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580736 = query.getOrDefault("key")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "key", valid_580736
  var valid_580737 = query.getOrDefault("prettyPrint")
  valid_580737 = validateParameter(valid_580737, JBool, required = false,
                                 default = newJBool(true))
  if valid_580737 != nil:
    section.add "prettyPrint", valid_580737
  var valid_580738 = query.getOrDefault("oauth_token")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "oauth_token", valid_580738
  var valid_580739 = query.getOrDefault("useDomainAdminAccess")
  valid_580739 = validateParameter(valid_580739, JBool, required = false,
                                 default = newJBool(false))
  if valid_580739 != nil:
    section.add "useDomainAdminAccess", valid_580739
  var valid_580740 = query.getOrDefault("alt")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = newJString("json"))
  if valid_580740 != nil:
    section.add "alt", valid_580740
  var valid_580741 = query.getOrDefault("userIp")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "userIp", valid_580741
  var valid_580742 = query.getOrDefault("quotaUser")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "quotaUser", valid_580742
  var valid_580743 = query.getOrDefault("supportsTeamDrives")
  valid_580743 = validateParameter(valid_580743, JBool, required = false,
                                 default = newJBool(false))
  if valid_580743 != nil:
    section.add "supportsTeamDrives", valid_580743
  var valid_580744 = query.getOrDefault("supportsAllDrives")
  valid_580744 = validateParameter(valid_580744, JBool, required = false,
                                 default = newJBool(false))
  if valid_580744 != nil:
    section.add "supportsAllDrives", valid_580744
  var valid_580745 = query.getOrDefault("fields")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = nil)
  if valid_580745 != nil:
    section.add "fields", valid_580745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580746: Call_DrivePermissionsGet_580731; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a permission by ID.
  ## 
  let valid = call_580746.validator(path, query, header, formData, body)
  let scheme = call_580746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580746.url(scheme.get, call_580746.host, call_580746.base,
                         call_580746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580746, url, valid)

proc call*(call_580747: Call_DrivePermissionsGet_580731; fileId: string;
          permissionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; useDomainAdminAccess: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          fields: string = ""): Recallable =
  ## drivePermissionsGet
  ## Gets a permission by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   permissionId: string (required)
  ##               : The ID for the permission.
  var path_580748 = newJObject()
  var query_580749 = newJObject()
  add(query_580749, "key", newJString(key))
  add(query_580749, "prettyPrint", newJBool(prettyPrint))
  add(query_580749, "oauth_token", newJString(oauthToken))
  add(query_580749, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580749, "alt", newJString(alt))
  add(query_580749, "userIp", newJString(userIp))
  add(query_580749, "quotaUser", newJString(quotaUser))
  add(path_580748, "fileId", newJString(fileId))
  add(query_580749, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580749, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580749, "fields", newJString(fields))
  add(path_580748, "permissionId", newJString(permissionId))
  result = call_580747.call(path_580748, query_580749, nil, nil, nil)

var drivePermissionsGet* = Call_DrivePermissionsGet_580731(
    name: "drivePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsGet_580732, base: "/drive/v2",
    url: url_DrivePermissionsGet_580733, schemes: {Scheme.Https})
type
  Call_DrivePermissionsPatch_580792 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsPatch_580794(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsPatch_580793(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   removeExpiration: JBool
  ##                   : Whether to remove the expiration date.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   transferOwnership: JBool
  ##                    : Whether changing a role to 'owner' downgrades the current owners to writers. Does nothing if the specified role is not 'owner'.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580797 = query.getOrDefault("key")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "key", valid_580797
  var valid_580798 = query.getOrDefault("prettyPrint")
  valid_580798 = validateParameter(valid_580798, JBool, required = false,
                                 default = newJBool(true))
  if valid_580798 != nil:
    section.add "prettyPrint", valid_580798
  var valid_580799 = query.getOrDefault("oauth_token")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "oauth_token", valid_580799
  var valid_580800 = query.getOrDefault("useDomainAdminAccess")
  valid_580800 = validateParameter(valid_580800, JBool, required = false,
                                 default = newJBool(false))
  if valid_580800 != nil:
    section.add "useDomainAdminAccess", valid_580800
  var valid_580801 = query.getOrDefault("removeExpiration")
  valid_580801 = validateParameter(valid_580801, JBool, required = false,
                                 default = newJBool(false))
  if valid_580801 != nil:
    section.add "removeExpiration", valid_580801
  var valid_580802 = query.getOrDefault("alt")
  valid_580802 = validateParameter(valid_580802, JString, required = false,
                                 default = newJString("json"))
  if valid_580802 != nil:
    section.add "alt", valid_580802
  var valid_580803 = query.getOrDefault("userIp")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = nil)
  if valid_580803 != nil:
    section.add "userIp", valid_580803
  var valid_580804 = query.getOrDefault("quotaUser")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = nil)
  if valid_580804 != nil:
    section.add "quotaUser", valid_580804
  var valid_580805 = query.getOrDefault("supportsTeamDrives")
  valid_580805 = validateParameter(valid_580805, JBool, required = false,
                                 default = newJBool(false))
  if valid_580805 != nil:
    section.add "supportsTeamDrives", valid_580805
  var valid_580806 = query.getOrDefault("transferOwnership")
  valid_580806 = validateParameter(valid_580806, JBool, required = false,
                                 default = newJBool(false))
  if valid_580806 != nil:
    section.add "transferOwnership", valid_580806
  var valid_580807 = query.getOrDefault("supportsAllDrives")
  valid_580807 = validateParameter(valid_580807, JBool, required = false,
                                 default = newJBool(false))
  if valid_580807 != nil:
    section.add "supportsAllDrives", valid_580807
  var valid_580808 = query.getOrDefault("fields")
  valid_580808 = validateParameter(valid_580808, JString, required = false,
                                 default = nil)
  if valid_580808 != nil:
    section.add "fields", valid_580808
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

proc call*(call_580810: Call_DrivePermissionsPatch_580792; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission using patch semantics.
  ## 
  let valid = call_580810.validator(path, query, header, formData, body)
  let scheme = call_580810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580810.url(scheme.get, call_580810.host, call_580810.base,
                         call_580810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580810, url, valid)

proc call*(call_580811: Call_DrivePermissionsPatch_580792; fileId: string;
          permissionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; useDomainAdminAccess: bool = false;
          removeExpiration: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsTeamDrives: bool = false;
          transferOwnership: bool = false; supportsAllDrives: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## drivePermissionsPatch
  ## Updates a permission using patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   removeExpiration: bool
  ##                   : Whether to remove the expiration date.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   transferOwnership: bool
  ##                    : Whether changing a role to 'owner' downgrades the current owners to writers. Does nothing if the specified role is not 'owner'.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   permissionId: string (required)
  ##               : The ID for the permission.
  var path_580812 = newJObject()
  var query_580813 = newJObject()
  var body_580814 = newJObject()
  add(query_580813, "key", newJString(key))
  add(query_580813, "prettyPrint", newJBool(prettyPrint))
  add(query_580813, "oauth_token", newJString(oauthToken))
  add(query_580813, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580813, "removeExpiration", newJBool(removeExpiration))
  add(query_580813, "alt", newJString(alt))
  add(query_580813, "userIp", newJString(userIp))
  add(query_580813, "quotaUser", newJString(quotaUser))
  add(path_580812, "fileId", newJString(fileId))
  add(query_580813, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580813, "transferOwnership", newJBool(transferOwnership))
  add(query_580813, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_580814 = body
  add(query_580813, "fields", newJString(fields))
  add(path_580812, "permissionId", newJString(permissionId))
  result = call_580811.call(path_580812, query_580813, nil, nil, body_580814)

var drivePermissionsPatch* = Call_DrivePermissionsPatch_580792(
    name: "drivePermissionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsPatch_580793, base: "/drive/v2",
    url: url_DrivePermissionsPatch_580794, schemes: {Scheme.Https})
type
  Call_DrivePermissionsDelete_580773 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsDelete_580775(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsDelete_580774(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580778 = query.getOrDefault("key")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "key", valid_580778
  var valid_580779 = query.getOrDefault("prettyPrint")
  valid_580779 = validateParameter(valid_580779, JBool, required = false,
                                 default = newJBool(true))
  if valid_580779 != nil:
    section.add "prettyPrint", valid_580779
  var valid_580780 = query.getOrDefault("oauth_token")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "oauth_token", valid_580780
  var valid_580781 = query.getOrDefault("useDomainAdminAccess")
  valid_580781 = validateParameter(valid_580781, JBool, required = false,
                                 default = newJBool(false))
  if valid_580781 != nil:
    section.add "useDomainAdminAccess", valid_580781
  var valid_580782 = query.getOrDefault("alt")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = newJString("json"))
  if valid_580782 != nil:
    section.add "alt", valid_580782
  var valid_580783 = query.getOrDefault("userIp")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "userIp", valid_580783
  var valid_580784 = query.getOrDefault("quotaUser")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = nil)
  if valid_580784 != nil:
    section.add "quotaUser", valid_580784
  var valid_580785 = query.getOrDefault("supportsTeamDrives")
  valid_580785 = validateParameter(valid_580785, JBool, required = false,
                                 default = newJBool(false))
  if valid_580785 != nil:
    section.add "supportsTeamDrives", valid_580785
  var valid_580786 = query.getOrDefault("supportsAllDrives")
  valid_580786 = validateParameter(valid_580786, JBool, required = false,
                                 default = newJBool(false))
  if valid_580786 != nil:
    section.add "supportsAllDrives", valid_580786
  var valid_580787 = query.getOrDefault("fields")
  valid_580787 = validateParameter(valid_580787, JString, required = false,
                                 default = nil)
  if valid_580787 != nil:
    section.add "fields", valid_580787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580788: Call_DrivePermissionsDelete_580773; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a permission from a file or shared drive.
  ## 
  let valid = call_580788.validator(path, query, header, formData, body)
  let scheme = call_580788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580788.url(scheme.get, call_580788.host, call_580788.base,
                         call_580788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580788, url, valid)

proc call*(call_580789: Call_DrivePermissionsDelete_580773; fileId: string;
          permissionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; useDomainAdminAccess: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          fields: string = ""): Recallable =
  ## drivePermissionsDelete
  ## Deletes a permission from a file or shared drive.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if the file ID parameter refers to a shared drive and the requester is an administrator of the domain to which the shared drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID for the file or shared drive.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   permissionId: string (required)
  ##               : The ID for the permission.
  var path_580790 = newJObject()
  var query_580791 = newJObject()
  add(query_580791, "key", newJString(key))
  add(query_580791, "prettyPrint", newJBool(prettyPrint))
  add(query_580791, "oauth_token", newJString(oauthToken))
  add(query_580791, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580791, "alt", newJString(alt))
  add(query_580791, "userIp", newJString(userIp))
  add(query_580791, "quotaUser", newJString(quotaUser))
  add(path_580790, "fileId", newJString(fileId))
  add(query_580791, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580791, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580791, "fields", newJString(fields))
  add(path_580790, "permissionId", newJString(permissionId))
  result = call_580789.call(path_580790, query_580791, nil, nil, nil)

var drivePermissionsDelete* = Call_DrivePermissionsDelete_580773(
    name: "drivePermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsDelete_580774, base: "/drive/v2",
    url: url_DrivePermissionsDelete_580775, schemes: {Scheme.Https})
type
  Call_DrivePropertiesInsert_580830 = ref object of OpenApiRestCall_579380
proc url_DrivePropertiesInsert_580832(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePropertiesInsert_580831(path: JsonNode; query: JsonNode;
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
  var valid_580833 = path.getOrDefault("fileId")
  valid_580833 = validateParameter(valid_580833, JString, required = true,
                                 default = nil)
  if valid_580833 != nil:
    section.add "fileId", valid_580833
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580834 = query.getOrDefault("key")
  valid_580834 = validateParameter(valid_580834, JString, required = false,
                                 default = nil)
  if valid_580834 != nil:
    section.add "key", valid_580834
  var valid_580835 = query.getOrDefault("prettyPrint")
  valid_580835 = validateParameter(valid_580835, JBool, required = false,
                                 default = newJBool(true))
  if valid_580835 != nil:
    section.add "prettyPrint", valid_580835
  var valid_580836 = query.getOrDefault("oauth_token")
  valid_580836 = validateParameter(valid_580836, JString, required = false,
                                 default = nil)
  if valid_580836 != nil:
    section.add "oauth_token", valid_580836
  var valid_580837 = query.getOrDefault("alt")
  valid_580837 = validateParameter(valid_580837, JString, required = false,
                                 default = newJString("json"))
  if valid_580837 != nil:
    section.add "alt", valid_580837
  var valid_580838 = query.getOrDefault("userIp")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = nil)
  if valid_580838 != nil:
    section.add "userIp", valid_580838
  var valid_580839 = query.getOrDefault("quotaUser")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = nil)
  if valid_580839 != nil:
    section.add "quotaUser", valid_580839
  var valid_580840 = query.getOrDefault("fields")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = nil)
  if valid_580840 != nil:
    section.add "fields", valid_580840
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

proc call*(call_580842: Call_DrivePropertiesInsert_580830; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a property to a file, or updates it if it already exists.
  ## 
  let valid = call_580842.validator(path, query, header, formData, body)
  let scheme = call_580842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580842.url(scheme.get, call_580842.host, call_580842.base,
                         call_580842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580842, url, valid)

proc call*(call_580843: Call_DrivePropertiesInsert_580830; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## drivePropertiesInsert
  ## Adds a property to a file, or updates it if it already exists.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580844 = newJObject()
  var query_580845 = newJObject()
  var body_580846 = newJObject()
  add(query_580845, "key", newJString(key))
  add(query_580845, "prettyPrint", newJBool(prettyPrint))
  add(query_580845, "oauth_token", newJString(oauthToken))
  add(query_580845, "alt", newJString(alt))
  add(query_580845, "userIp", newJString(userIp))
  add(query_580845, "quotaUser", newJString(quotaUser))
  add(path_580844, "fileId", newJString(fileId))
  if body != nil:
    body_580846 = body
  add(query_580845, "fields", newJString(fields))
  result = call_580843.call(path_580844, query_580845, nil, nil, body_580846)

var drivePropertiesInsert* = Call_DrivePropertiesInsert_580830(
    name: "drivePropertiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/properties",
    validator: validate_DrivePropertiesInsert_580831, base: "/drive/v2",
    url: url_DrivePropertiesInsert_580832, schemes: {Scheme.Https})
type
  Call_DrivePropertiesList_580815 = ref object of OpenApiRestCall_579380
proc url_DrivePropertiesList_580817(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePropertiesList_580816(path: JsonNode; query: JsonNode;
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
  var valid_580818 = path.getOrDefault("fileId")
  valid_580818 = validateParameter(valid_580818, JString, required = true,
                                 default = nil)
  if valid_580818 != nil:
    section.add "fileId", valid_580818
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580819 = query.getOrDefault("key")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "key", valid_580819
  var valid_580820 = query.getOrDefault("prettyPrint")
  valid_580820 = validateParameter(valid_580820, JBool, required = false,
                                 default = newJBool(true))
  if valid_580820 != nil:
    section.add "prettyPrint", valid_580820
  var valid_580821 = query.getOrDefault("oauth_token")
  valid_580821 = validateParameter(valid_580821, JString, required = false,
                                 default = nil)
  if valid_580821 != nil:
    section.add "oauth_token", valid_580821
  var valid_580822 = query.getOrDefault("alt")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = newJString("json"))
  if valid_580822 != nil:
    section.add "alt", valid_580822
  var valid_580823 = query.getOrDefault("userIp")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "userIp", valid_580823
  var valid_580824 = query.getOrDefault("quotaUser")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = nil)
  if valid_580824 != nil:
    section.add "quotaUser", valid_580824
  var valid_580825 = query.getOrDefault("fields")
  valid_580825 = validateParameter(valid_580825, JString, required = false,
                                 default = nil)
  if valid_580825 != nil:
    section.add "fields", valid_580825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580826: Call_DrivePropertiesList_580815; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's properties.
  ## 
  let valid = call_580826.validator(path, query, header, formData, body)
  let scheme = call_580826.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580826.url(scheme.get, call_580826.host, call_580826.base,
                         call_580826.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580826, url, valid)

proc call*(call_580827: Call_DrivePropertiesList_580815; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## drivePropertiesList
  ## Lists a file's properties.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580828 = newJObject()
  var query_580829 = newJObject()
  add(query_580829, "key", newJString(key))
  add(query_580829, "prettyPrint", newJBool(prettyPrint))
  add(query_580829, "oauth_token", newJString(oauthToken))
  add(query_580829, "alt", newJString(alt))
  add(query_580829, "userIp", newJString(userIp))
  add(query_580829, "quotaUser", newJString(quotaUser))
  add(path_580828, "fileId", newJString(fileId))
  add(query_580829, "fields", newJString(fields))
  result = call_580827.call(path_580828, query_580829, nil, nil, nil)

var drivePropertiesList* = Call_DrivePropertiesList_580815(
    name: "drivePropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/properties",
    validator: validate_DrivePropertiesList_580816, base: "/drive/v2",
    url: url_DrivePropertiesList_580817, schemes: {Scheme.Https})
type
  Call_DrivePropertiesUpdate_580864 = ref object of OpenApiRestCall_579380
proc url_DrivePropertiesUpdate_580866(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePropertiesUpdate_580865(path: JsonNode; query: JsonNode;
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
  var valid_580867 = path.getOrDefault("fileId")
  valid_580867 = validateParameter(valid_580867, JString, required = true,
                                 default = nil)
  if valid_580867 != nil:
    section.add "fileId", valid_580867
  var valid_580868 = path.getOrDefault("propertyKey")
  valid_580868 = validateParameter(valid_580868, JString, required = true,
                                 default = nil)
  if valid_580868 != nil:
    section.add "propertyKey", valid_580868
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   visibility: JString
  ##             : The visibility of the property. Allowed values are PRIVATE and PUBLIC. (Default: PRIVATE)
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580869 = query.getOrDefault("key")
  valid_580869 = validateParameter(valid_580869, JString, required = false,
                                 default = nil)
  if valid_580869 != nil:
    section.add "key", valid_580869
  var valid_580870 = query.getOrDefault("prettyPrint")
  valid_580870 = validateParameter(valid_580870, JBool, required = false,
                                 default = newJBool(true))
  if valid_580870 != nil:
    section.add "prettyPrint", valid_580870
  var valid_580871 = query.getOrDefault("oauth_token")
  valid_580871 = validateParameter(valid_580871, JString, required = false,
                                 default = nil)
  if valid_580871 != nil:
    section.add "oauth_token", valid_580871
  var valid_580872 = query.getOrDefault("alt")
  valid_580872 = validateParameter(valid_580872, JString, required = false,
                                 default = newJString("json"))
  if valid_580872 != nil:
    section.add "alt", valid_580872
  var valid_580873 = query.getOrDefault("userIp")
  valid_580873 = validateParameter(valid_580873, JString, required = false,
                                 default = nil)
  if valid_580873 != nil:
    section.add "userIp", valid_580873
  var valid_580874 = query.getOrDefault("quotaUser")
  valid_580874 = validateParameter(valid_580874, JString, required = false,
                                 default = nil)
  if valid_580874 != nil:
    section.add "quotaUser", valid_580874
  var valid_580875 = query.getOrDefault("visibility")
  valid_580875 = validateParameter(valid_580875, JString, required = false,
                                 default = newJString("private"))
  if valid_580875 != nil:
    section.add "visibility", valid_580875
  var valid_580876 = query.getOrDefault("fields")
  valid_580876 = validateParameter(valid_580876, JString, required = false,
                                 default = nil)
  if valid_580876 != nil:
    section.add "fields", valid_580876
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

proc call*(call_580878: Call_DrivePropertiesUpdate_580864; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a property.
  ## 
  let valid = call_580878.validator(path, query, header, formData, body)
  let scheme = call_580878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580878.url(scheme.get, call_580878.host, call_580878.base,
                         call_580878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580878, url, valid)

proc call*(call_580879: Call_DrivePropertiesUpdate_580864; fileId: string;
          propertyKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; visibility: string = "private"; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## drivePropertiesUpdate
  ## Updates a property.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   visibility: string
  ##             : The visibility of the property. Allowed values are PRIVATE and PUBLIC. (Default: PRIVATE)
  ##   propertyKey: string (required)
  ##              : The key of the property.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580880 = newJObject()
  var query_580881 = newJObject()
  var body_580882 = newJObject()
  add(query_580881, "key", newJString(key))
  add(query_580881, "prettyPrint", newJBool(prettyPrint))
  add(query_580881, "oauth_token", newJString(oauthToken))
  add(query_580881, "alt", newJString(alt))
  add(query_580881, "userIp", newJString(userIp))
  add(query_580881, "quotaUser", newJString(quotaUser))
  add(path_580880, "fileId", newJString(fileId))
  add(query_580881, "visibility", newJString(visibility))
  add(path_580880, "propertyKey", newJString(propertyKey))
  if body != nil:
    body_580882 = body
  add(query_580881, "fields", newJString(fields))
  result = call_580879.call(path_580880, query_580881, nil, nil, body_580882)

var drivePropertiesUpdate* = Call_DrivePropertiesUpdate_580864(
    name: "drivePropertiesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesUpdate_580865, base: "/drive/v2",
    url: url_DrivePropertiesUpdate_580866, schemes: {Scheme.Https})
type
  Call_DrivePropertiesGet_580847 = ref object of OpenApiRestCall_579380
proc url_DrivePropertiesGet_580849(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePropertiesGet_580848(path: JsonNode; query: JsonNode;
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
  var valid_580850 = path.getOrDefault("fileId")
  valid_580850 = validateParameter(valid_580850, JString, required = true,
                                 default = nil)
  if valid_580850 != nil:
    section.add "fileId", valid_580850
  var valid_580851 = path.getOrDefault("propertyKey")
  valid_580851 = validateParameter(valid_580851, JString, required = true,
                                 default = nil)
  if valid_580851 != nil:
    section.add "propertyKey", valid_580851
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   visibility: JString
  ##             : The visibility of the property.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580852 = query.getOrDefault("key")
  valid_580852 = validateParameter(valid_580852, JString, required = false,
                                 default = nil)
  if valid_580852 != nil:
    section.add "key", valid_580852
  var valid_580853 = query.getOrDefault("prettyPrint")
  valid_580853 = validateParameter(valid_580853, JBool, required = false,
                                 default = newJBool(true))
  if valid_580853 != nil:
    section.add "prettyPrint", valid_580853
  var valid_580854 = query.getOrDefault("oauth_token")
  valid_580854 = validateParameter(valid_580854, JString, required = false,
                                 default = nil)
  if valid_580854 != nil:
    section.add "oauth_token", valid_580854
  var valid_580855 = query.getOrDefault("alt")
  valid_580855 = validateParameter(valid_580855, JString, required = false,
                                 default = newJString("json"))
  if valid_580855 != nil:
    section.add "alt", valid_580855
  var valid_580856 = query.getOrDefault("userIp")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = nil)
  if valid_580856 != nil:
    section.add "userIp", valid_580856
  var valid_580857 = query.getOrDefault("quotaUser")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "quotaUser", valid_580857
  var valid_580858 = query.getOrDefault("visibility")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = newJString("private"))
  if valid_580858 != nil:
    section.add "visibility", valid_580858
  var valid_580859 = query.getOrDefault("fields")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "fields", valid_580859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580860: Call_DrivePropertiesGet_580847; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a property by its key.
  ## 
  let valid = call_580860.validator(path, query, header, formData, body)
  let scheme = call_580860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580860.url(scheme.get, call_580860.host, call_580860.base,
                         call_580860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580860, url, valid)

proc call*(call_580861: Call_DrivePropertiesGet_580847; fileId: string;
          propertyKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; visibility: string = "private"; fields: string = ""): Recallable =
  ## drivePropertiesGet
  ## Gets a property by its key.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   visibility: string
  ##             : The visibility of the property.
  ##   propertyKey: string (required)
  ##              : The key of the property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580862 = newJObject()
  var query_580863 = newJObject()
  add(query_580863, "key", newJString(key))
  add(query_580863, "prettyPrint", newJBool(prettyPrint))
  add(query_580863, "oauth_token", newJString(oauthToken))
  add(query_580863, "alt", newJString(alt))
  add(query_580863, "userIp", newJString(userIp))
  add(query_580863, "quotaUser", newJString(quotaUser))
  add(path_580862, "fileId", newJString(fileId))
  add(query_580863, "visibility", newJString(visibility))
  add(path_580862, "propertyKey", newJString(propertyKey))
  add(query_580863, "fields", newJString(fields))
  result = call_580861.call(path_580862, query_580863, nil, nil, nil)

var drivePropertiesGet* = Call_DrivePropertiesGet_580847(
    name: "drivePropertiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesGet_580848, base: "/drive/v2",
    url: url_DrivePropertiesGet_580849, schemes: {Scheme.Https})
type
  Call_DrivePropertiesPatch_580900 = ref object of OpenApiRestCall_579380
proc url_DrivePropertiesPatch_580902(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePropertiesPatch_580901(path: JsonNode; query: JsonNode;
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
  var valid_580903 = path.getOrDefault("fileId")
  valid_580903 = validateParameter(valid_580903, JString, required = true,
                                 default = nil)
  if valid_580903 != nil:
    section.add "fileId", valid_580903
  var valid_580904 = path.getOrDefault("propertyKey")
  valid_580904 = validateParameter(valid_580904, JString, required = true,
                                 default = nil)
  if valid_580904 != nil:
    section.add "propertyKey", valid_580904
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   visibility: JString
  ##             : The visibility of the property. Allowed values are PRIVATE and PUBLIC. (Default: PRIVATE)
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580905 = query.getOrDefault("key")
  valid_580905 = validateParameter(valid_580905, JString, required = false,
                                 default = nil)
  if valid_580905 != nil:
    section.add "key", valid_580905
  var valid_580906 = query.getOrDefault("prettyPrint")
  valid_580906 = validateParameter(valid_580906, JBool, required = false,
                                 default = newJBool(true))
  if valid_580906 != nil:
    section.add "prettyPrint", valid_580906
  var valid_580907 = query.getOrDefault("oauth_token")
  valid_580907 = validateParameter(valid_580907, JString, required = false,
                                 default = nil)
  if valid_580907 != nil:
    section.add "oauth_token", valid_580907
  var valid_580908 = query.getOrDefault("alt")
  valid_580908 = validateParameter(valid_580908, JString, required = false,
                                 default = newJString("json"))
  if valid_580908 != nil:
    section.add "alt", valid_580908
  var valid_580909 = query.getOrDefault("userIp")
  valid_580909 = validateParameter(valid_580909, JString, required = false,
                                 default = nil)
  if valid_580909 != nil:
    section.add "userIp", valid_580909
  var valid_580910 = query.getOrDefault("quotaUser")
  valid_580910 = validateParameter(valid_580910, JString, required = false,
                                 default = nil)
  if valid_580910 != nil:
    section.add "quotaUser", valid_580910
  var valid_580911 = query.getOrDefault("visibility")
  valid_580911 = validateParameter(valid_580911, JString, required = false,
                                 default = newJString("private"))
  if valid_580911 != nil:
    section.add "visibility", valid_580911
  var valid_580912 = query.getOrDefault("fields")
  valid_580912 = validateParameter(valid_580912, JString, required = false,
                                 default = nil)
  if valid_580912 != nil:
    section.add "fields", valid_580912
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

proc call*(call_580914: Call_DrivePropertiesPatch_580900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a property.
  ## 
  let valid = call_580914.validator(path, query, header, formData, body)
  let scheme = call_580914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580914.url(scheme.get, call_580914.host, call_580914.base,
                         call_580914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580914, url, valid)

proc call*(call_580915: Call_DrivePropertiesPatch_580900; fileId: string;
          propertyKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; visibility: string = "private"; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## drivePropertiesPatch
  ## Updates a property.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   visibility: string
  ##             : The visibility of the property. Allowed values are PRIVATE and PUBLIC. (Default: PRIVATE)
  ##   propertyKey: string (required)
  ##              : The key of the property.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580916 = newJObject()
  var query_580917 = newJObject()
  var body_580918 = newJObject()
  add(query_580917, "key", newJString(key))
  add(query_580917, "prettyPrint", newJBool(prettyPrint))
  add(query_580917, "oauth_token", newJString(oauthToken))
  add(query_580917, "alt", newJString(alt))
  add(query_580917, "userIp", newJString(userIp))
  add(query_580917, "quotaUser", newJString(quotaUser))
  add(path_580916, "fileId", newJString(fileId))
  add(query_580917, "visibility", newJString(visibility))
  add(path_580916, "propertyKey", newJString(propertyKey))
  if body != nil:
    body_580918 = body
  add(query_580917, "fields", newJString(fields))
  result = call_580915.call(path_580916, query_580917, nil, nil, body_580918)

var drivePropertiesPatch* = Call_DrivePropertiesPatch_580900(
    name: "drivePropertiesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesPatch_580901, base: "/drive/v2",
    url: url_DrivePropertiesPatch_580902, schemes: {Scheme.Https})
type
  Call_DrivePropertiesDelete_580883 = ref object of OpenApiRestCall_579380
proc url_DrivePropertiesDelete_580885(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePropertiesDelete_580884(path: JsonNode; query: JsonNode;
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
  var valid_580886 = path.getOrDefault("fileId")
  valid_580886 = validateParameter(valid_580886, JString, required = true,
                                 default = nil)
  if valid_580886 != nil:
    section.add "fileId", valid_580886
  var valid_580887 = path.getOrDefault("propertyKey")
  valid_580887 = validateParameter(valid_580887, JString, required = true,
                                 default = nil)
  if valid_580887 != nil:
    section.add "propertyKey", valid_580887
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   visibility: JString
  ##             : The visibility of the property.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580888 = query.getOrDefault("key")
  valid_580888 = validateParameter(valid_580888, JString, required = false,
                                 default = nil)
  if valid_580888 != nil:
    section.add "key", valid_580888
  var valid_580889 = query.getOrDefault("prettyPrint")
  valid_580889 = validateParameter(valid_580889, JBool, required = false,
                                 default = newJBool(true))
  if valid_580889 != nil:
    section.add "prettyPrint", valid_580889
  var valid_580890 = query.getOrDefault("oauth_token")
  valid_580890 = validateParameter(valid_580890, JString, required = false,
                                 default = nil)
  if valid_580890 != nil:
    section.add "oauth_token", valid_580890
  var valid_580891 = query.getOrDefault("alt")
  valid_580891 = validateParameter(valid_580891, JString, required = false,
                                 default = newJString("json"))
  if valid_580891 != nil:
    section.add "alt", valid_580891
  var valid_580892 = query.getOrDefault("userIp")
  valid_580892 = validateParameter(valid_580892, JString, required = false,
                                 default = nil)
  if valid_580892 != nil:
    section.add "userIp", valid_580892
  var valid_580893 = query.getOrDefault("quotaUser")
  valid_580893 = validateParameter(valid_580893, JString, required = false,
                                 default = nil)
  if valid_580893 != nil:
    section.add "quotaUser", valid_580893
  var valid_580894 = query.getOrDefault("visibility")
  valid_580894 = validateParameter(valid_580894, JString, required = false,
                                 default = newJString("private"))
  if valid_580894 != nil:
    section.add "visibility", valid_580894
  var valid_580895 = query.getOrDefault("fields")
  valid_580895 = validateParameter(valid_580895, JString, required = false,
                                 default = nil)
  if valid_580895 != nil:
    section.add "fields", valid_580895
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580896: Call_DrivePropertiesDelete_580883; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a property.
  ## 
  let valid = call_580896.validator(path, query, header, formData, body)
  let scheme = call_580896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580896.url(scheme.get, call_580896.host, call_580896.base,
                         call_580896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580896, url, valid)

proc call*(call_580897: Call_DrivePropertiesDelete_580883; fileId: string;
          propertyKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; visibility: string = "private"; fields: string = ""): Recallable =
  ## drivePropertiesDelete
  ## Deletes a property.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   visibility: string
  ##             : The visibility of the property.
  ##   propertyKey: string (required)
  ##              : The key of the property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580898 = newJObject()
  var query_580899 = newJObject()
  add(query_580899, "key", newJString(key))
  add(query_580899, "prettyPrint", newJBool(prettyPrint))
  add(query_580899, "oauth_token", newJString(oauthToken))
  add(query_580899, "alt", newJString(alt))
  add(query_580899, "userIp", newJString(userIp))
  add(query_580899, "quotaUser", newJString(quotaUser))
  add(path_580898, "fileId", newJString(fileId))
  add(query_580899, "visibility", newJString(visibility))
  add(path_580898, "propertyKey", newJString(propertyKey))
  add(query_580899, "fields", newJString(fields))
  result = call_580897.call(path_580898, query_580899, nil, nil, nil)

var drivePropertiesDelete* = Call_DrivePropertiesDelete_580883(
    name: "drivePropertiesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesDelete_580884, base: "/drive/v2",
    url: url_DrivePropertiesDelete_580885, schemes: {Scheme.Https})
type
  Call_DriveRealtimeUpdate_580935 = ref object of OpenApiRestCall_579380
proc url_DriveRealtimeUpdate_580937(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRealtimeUpdate_580936(path: JsonNode; query: JsonNode;
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
  var valid_580938 = path.getOrDefault("fileId")
  valid_580938 = validateParameter(valid_580938, JString, required = true,
                                 default = nil)
  if valid_580938 != nil:
    section.add "fileId", valid_580938
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   baseRevision: JString
  ##               : The revision of the model to diff the uploaded model against. If set, the uploaded model is diffed against the provided revision and those differences are merged with any changes made to the model after the provided revision. If not set, the uploaded model replaces the current model on the server.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580939 = query.getOrDefault("key")
  valid_580939 = validateParameter(valid_580939, JString, required = false,
                                 default = nil)
  if valid_580939 != nil:
    section.add "key", valid_580939
  var valid_580940 = query.getOrDefault("prettyPrint")
  valid_580940 = validateParameter(valid_580940, JBool, required = false,
                                 default = newJBool(true))
  if valid_580940 != nil:
    section.add "prettyPrint", valid_580940
  var valid_580941 = query.getOrDefault("oauth_token")
  valid_580941 = validateParameter(valid_580941, JString, required = false,
                                 default = nil)
  if valid_580941 != nil:
    section.add "oauth_token", valid_580941
  var valid_580942 = query.getOrDefault("baseRevision")
  valid_580942 = validateParameter(valid_580942, JString, required = false,
                                 default = nil)
  if valid_580942 != nil:
    section.add "baseRevision", valid_580942
  var valid_580943 = query.getOrDefault("alt")
  valid_580943 = validateParameter(valid_580943, JString, required = false,
                                 default = newJString("json"))
  if valid_580943 != nil:
    section.add "alt", valid_580943
  var valid_580944 = query.getOrDefault("userIp")
  valid_580944 = validateParameter(valid_580944, JString, required = false,
                                 default = nil)
  if valid_580944 != nil:
    section.add "userIp", valid_580944
  var valid_580945 = query.getOrDefault("quotaUser")
  valid_580945 = validateParameter(valid_580945, JString, required = false,
                                 default = nil)
  if valid_580945 != nil:
    section.add "quotaUser", valid_580945
  var valid_580946 = query.getOrDefault("fields")
  valid_580946 = validateParameter(valid_580946, JString, required = false,
                                 default = nil)
  if valid_580946 != nil:
    section.add "fields", valid_580946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580947: Call_DriveRealtimeUpdate_580935; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Overwrites the Realtime API data model associated with this file with the provided JSON data model.
  ## 
  let valid = call_580947.validator(path, query, header, formData, body)
  let scheme = call_580947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580947.url(scheme.get, call_580947.host, call_580947.base,
                         call_580947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580947, url, valid)

proc call*(call_580948: Call_DriveRealtimeUpdate_580935; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          baseRevision: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveRealtimeUpdate
  ## Overwrites the Realtime API data model associated with this file with the provided JSON data model.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   baseRevision: string
  ##               : The revision of the model to diff the uploaded model against. If set, the uploaded model is diffed against the provided revision and those differences are merged with any changes made to the model after the provided revision. If not set, the uploaded model replaces the current model on the server.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fileId: string (required)
  ##         : The ID of the file that the Realtime API data model is associated with.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580949 = newJObject()
  var query_580950 = newJObject()
  add(query_580950, "key", newJString(key))
  add(query_580950, "prettyPrint", newJBool(prettyPrint))
  add(query_580950, "oauth_token", newJString(oauthToken))
  add(query_580950, "baseRevision", newJString(baseRevision))
  add(query_580950, "alt", newJString(alt))
  add(query_580950, "userIp", newJString(userIp))
  add(query_580950, "quotaUser", newJString(quotaUser))
  add(path_580949, "fileId", newJString(fileId))
  add(query_580950, "fields", newJString(fields))
  result = call_580948.call(path_580949, query_580950, nil, nil, nil)

var driveRealtimeUpdate* = Call_DriveRealtimeUpdate_580935(
    name: "driveRealtimeUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/realtime",
    validator: validate_DriveRealtimeUpdate_580936, base: "/drive/v2",
    url: url_DriveRealtimeUpdate_580937, schemes: {Scheme.Https})
type
  Call_DriveRealtimeGet_580919 = ref object of OpenApiRestCall_579380
proc url_DriveRealtimeGet_580921(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRealtimeGet_580920(path: JsonNode; query: JsonNode;
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
  var valid_580922 = path.getOrDefault("fileId")
  valid_580922 = validateParameter(valid_580922, JString, required = true,
                                 default = nil)
  if valid_580922 != nil:
    section.add "fileId", valid_580922
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   revision: JInt
  ##           : The revision of the Realtime API data model to export. Revisions start at 1 (the initial empty data model) and are incremented with each change. If this parameter is excluded, the most recent data model will be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580923 = query.getOrDefault("key")
  valid_580923 = validateParameter(valid_580923, JString, required = false,
                                 default = nil)
  if valid_580923 != nil:
    section.add "key", valid_580923
  var valid_580924 = query.getOrDefault("prettyPrint")
  valid_580924 = validateParameter(valid_580924, JBool, required = false,
                                 default = newJBool(true))
  if valid_580924 != nil:
    section.add "prettyPrint", valid_580924
  var valid_580925 = query.getOrDefault("oauth_token")
  valid_580925 = validateParameter(valid_580925, JString, required = false,
                                 default = nil)
  if valid_580925 != nil:
    section.add "oauth_token", valid_580925
  var valid_580926 = query.getOrDefault("alt")
  valid_580926 = validateParameter(valid_580926, JString, required = false,
                                 default = newJString("json"))
  if valid_580926 != nil:
    section.add "alt", valid_580926
  var valid_580927 = query.getOrDefault("userIp")
  valid_580927 = validateParameter(valid_580927, JString, required = false,
                                 default = nil)
  if valid_580927 != nil:
    section.add "userIp", valid_580927
  var valid_580928 = query.getOrDefault("quotaUser")
  valid_580928 = validateParameter(valid_580928, JString, required = false,
                                 default = nil)
  if valid_580928 != nil:
    section.add "quotaUser", valid_580928
  var valid_580929 = query.getOrDefault("revision")
  valid_580929 = validateParameter(valid_580929, JInt, required = false, default = nil)
  if valid_580929 != nil:
    section.add "revision", valid_580929
  var valid_580930 = query.getOrDefault("fields")
  valid_580930 = validateParameter(valid_580930, JString, required = false,
                                 default = nil)
  if valid_580930 != nil:
    section.add "fields", valid_580930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580931: Call_DriveRealtimeGet_580919; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the contents of the Realtime API data model associated with this file as JSON.
  ## 
  let valid = call_580931.validator(path, query, header, formData, body)
  let scheme = call_580931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580931.url(scheme.get, call_580931.host, call_580931.base,
                         call_580931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580931, url, valid)

proc call*(call_580932: Call_DriveRealtimeGet_580919; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          revision: int = 0; fields: string = ""): Recallable =
  ## driveRealtimeGet
  ## Exports the contents of the Realtime API data model associated with this file as JSON.
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
  ##   fileId: string (required)
  ##         : The ID of the file that the Realtime API data model is associated with.
  ##   revision: int
  ##           : The revision of the Realtime API data model to export. Revisions start at 1 (the initial empty data model) and are incremented with each change. If this parameter is excluded, the most recent data model will be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580933 = newJObject()
  var query_580934 = newJObject()
  add(query_580934, "key", newJString(key))
  add(query_580934, "prettyPrint", newJBool(prettyPrint))
  add(query_580934, "oauth_token", newJString(oauthToken))
  add(query_580934, "alt", newJString(alt))
  add(query_580934, "userIp", newJString(userIp))
  add(query_580934, "quotaUser", newJString(quotaUser))
  add(path_580933, "fileId", newJString(fileId))
  add(query_580934, "revision", newJInt(revision))
  add(query_580934, "fields", newJString(fields))
  result = call_580932.call(path_580933, query_580934, nil, nil, nil)

var driveRealtimeGet* = Call_DriveRealtimeGet_580919(name: "driveRealtimeGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/realtime", validator: validate_DriveRealtimeGet_580920,
    base: "/drive/v2", url: url_DriveRealtimeGet_580921, schemes: {Scheme.Https})
type
  Call_DriveRevisionsList_580951 = ref object of OpenApiRestCall_579380
proc url_DriveRevisionsList_580953(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRevisionsList_580952(path: JsonNode; query: JsonNode;
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
  var valid_580954 = path.getOrDefault("fileId")
  valid_580954 = validateParameter(valid_580954, JString, required = true,
                                 default = nil)
  if valid_580954 != nil:
    section.add "fileId", valid_580954
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  ##            : Page token for revisions. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of revisions to return.
  section = newJObject()
  var valid_580955 = query.getOrDefault("key")
  valid_580955 = validateParameter(valid_580955, JString, required = false,
                                 default = nil)
  if valid_580955 != nil:
    section.add "key", valid_580955
  var valid_580956 = query.getOrDefault("prettyPrint")
  valid_580956 = validateParameter(valid_580956, JBool, required = false,
                                 default = newJBool(true))
  if valid_580956 != nil:
    section.add "prettyPrint", valid_580956
  var valid_580957 = query.getOrDefault("oauth_token")
  valid_580957 = validateParameter(valid_580957, JString, required = false,
                                 default = nil)
  if valid_580957 != nil:
    section.add "oauth_token", valid_580957
  var valid_580958 = query.getOrDefault("alt")
  valid_580958 = validateParameter(valid_580958, JString, required = false,
                                 default = newJString("json"))
  if valid_580958 != nil:
    section.add "alt", valid_580958
  var valid_580959 = query.getOrDefault("userIp")
  valid_580959 = validateParameter(valid_580959, JString, required = false,
                                 default = nil)
  if valid_580959 != nil:
    section.add "userIp", valid_580959
  var valid_580960 = query.getOrDefault("quotaUser")
  valid_580960 = validateParameter(valid_580960, JString, required = false,
                                 default = nil)
  if valid_580960 != nil:
    section.add "quotaUser", valid_580960
  var valid_580961 = query.getOrDefault("pageToken")
  valid_580961 = validateParameter(valid_580961, JString, required = false,
                                 default = nil)
  if valid_580961 != nil:
    section.add "pageToken", valid_580961
  var valid_580962 = query.getOrDefault("fields")
  valid_580962 = validateParameter(valid_580962, JString, required = false,
                                 default = nil)
  if valid_580962 != nil:
    section.add "fields", valid_580962
  var valid_580963 = query.getOrDefault("maxResults")
  valid_580963 = validateParameter(valid_580963, JInt, required = false,
                                 default = newJInt(200))
  if valid_580963 != nil:
    section.add "maxResults", valid_580963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580964: Call_DriveRevisionsList_580951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's revisions.
  ## 
  let valid = call_580964.validator(path, query, header, formData, body)
  let scheme = call_580964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580964.url(scheme.get, call_580964.host, call_580964.base,
                         call_580964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580964, url, valid)

proc call*(call_580965: Call_DriveRevisionsList_580951; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 200): Recallable =
  ## driveRevisionsList
  ## Lists a file's revisions.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   pageToken: string
  ##            : Page token for revisions. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of revisions to return.
  var path_580966 = newJObject()
  var query_580967 = newJObject()
  add(query_580967, "key", newJString(key))
  add(query_580967, "prettyPrint", newJBool(prettyPrint))
  add(query_580967, "oauth_token", newJString(oauthToken))
  add(query_580967, "alt", newJString(alt))
  add(query_580967, "userIp", newJString(userIp))
  add(query_580967, "quotaUser", newJString(quotaUser))
  add(path_580966, "fileId", newJString(fileId))
  add(query_580967, "pageToken", newJString(pageToken))
  add(query_580967, "fields", newJString(fields))
  add(query_580967, "maxResults", newJInt(maxResults))
  result = call_580965.call(path_580966, query_580967, nil, nil, nil)

var driveRevisionsList* = Call_DriveRevisionsList_580951(
    name: "driveRevisionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions",
    validator: validate_DriveRevisionsList_580952, base: "/drive/v2",
    url: url_DriveRevisionsList_580953, schemes: {Scheme.Https})
type
  Call_DriveRevisionsUpdate_580984 = ref object of OpenApiRestCall_579380
proc url_DriveRevisionsUpdate_580986(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRevisionsUpdate_580985(path: JsonNode; query: JsonNode;
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
  var valid_580987 = path.getOrDefault("fileId")
  valid_580987 = validateParameter(valid_580987, JString, required = true,
                                 default = nil)
  if valid_580987 != nil:
    section.add "fileId", valid_580987
  var valid_580988 = path.getOrDefault("revisionId")
  valid_580988 = validateParameter(valid_580988, JString, required = true,
                                 default = nil)
  if valid_580988 != nil:
    section.add "revisionId", valid_580988
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580989 = query.getOrDefault("key")
  valid_580989 = validateParameter(valid_580989, JString, required = false,
                                 default = nil)
  if valid_580989 != nil:
    section.add "key", valid_580989
  var valid_580990 = query.getOrDefault("prettyPrint")
  valid_580990 = validateParameter(valid_580990, JBool, required = false,
                                 default = newJBool(true))
  if valid_580990 != nil:
    section.add "prettyPrint", valid_580990
  var valid_580991 = query.getOrDefault("oauth_token")
  valid_580991 = validateParameter(valid_580991, JString, required = false,
                                 default = nil)
  if valid_580991 != nil:
    section.add "oauth_token", valid_580991
  var valid_580992 = query.getOrDefault("alt")
  valid_580992 = validateParameter(valid_580992, JString, required = false,
                                 default = newJString("json"))
  if valid_580992 != nil:
    section.add "alt", valid_580992
  var valid_580993 = query.getOrDefault("userIp")
  valid_580993 = validateParameter(valid_580993, JString, required = false,
                                 default = nil)
  if valid_580993 != nil:
    section.add "userIp", valid_580993
  var valid_580994 = query.getOrDefault("quotaUser")
  valid_580994 = validateParameter(valid_580994, JString, required = false,
                                 default = nil)
  if valid_580994 != nil:
    section.add "quotaUser", valid_580994
  var valid_580995 = query.getOrDefault("fields")
  valid_580995 = validateParameter(valid_580995, JString, required = false,
                                 default = nil)
  if valid_580995 != nil:
    section.add "fields", valid_580995
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

proc call*(call_580997: Call_DriveRevisionsUpdate_580984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision.
  ## 
  let valid = call_580997.validator(path, query, header, formData, body)
  let scheme = call_580997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580997.url(scheme.get, call_580997.host, call_580997.base,
                         call_580997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580997, url, valid)

proc call*(call_580998: Call_DriveRevisionsUpdate_580984; fileId: string;
          revisionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveRevisionsUpdate
  ## Updates a revision.
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
  ##   fileId: string (required)
  ##         : The ID for the file.
  ##   body: JObject
  ##   revisionId: string (required)
  ##             : The ID for the revision.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580999 = newJObject()
  var query_581000 = newJObject()
  var body_581001 = newJObject()
  add(query_581000, "key", newJString(key))
  add(query_581000, "prettyPrint", newJBool(prettyPrint))
  add(query_581000, "oauth_token", newJString(oauthToken))
  add(query_581000, "alt", newJString(alt))
  add(query_581000, "userIp", newJString(userIp))
  add(query_581000, "quotaUser", newJString(quotaUser))
  add(path_580999, "fileId", newJString(fileId))
  if body != nil:
    body_581001 = body
  add(path_580999, "revisionId", newJString(revisionId))
  add(query_581000, "fields", newJString(fields))
  result = call_580998.call(path_580999, query_581000, nil, nil, body_581001)

var driveRevisionsUpdate* = Call_DriveRevisionsUpdate_580984(
    name: "driveRevisionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsUpdate_580985, base: "/drive/v2",
    url: url_DriveRevisionsUpdate_580986, schemes: {Scheme.Https})
type
  Call_DriveRevisionsGet_580968 = ref object of OpenApiRestCall_579380
proc url_DriveRevisionsGet_580970(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRevisionsGet_580969(path: JsonNode; query: JsonNode;
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
  var valid_580971 = path.getOrDefault("fileId")
  valid_580971 = validateParameter(valid_580971, JString, required = true,
                                 default = nil)
  if valid_580971 != nil:
    section.add "fileId", valid_580971
  var valid_580972 = path.getOrDefault("revisionId")
  valid_580972 = validateParameter(valid_580972, JString, required = true,
                                 default = nil)
  if valid_580972 != nil:
    section.add "revisionId", valid_580972
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_580973 = query.getOrDefault("key")
  valid_580973 = validateParameter(valid_580973, JString, required = false,
                                 default = nil)
  if valid_580973 != nil:
    section.add "key", valid_580973
  var valid_580974 = query.getOrDefault("prettyPrint")
  valid_580974 = validateParameter(valid_580974, JBool, required = false,
                                 default = newJBool(true))
  if valid_580974 != nil:
    section.add "prettyPrint", valid_580974
  var valid_580975 = query.getOrDefault("oauth_token")
  valid_580975 = validateParameter(valid_580975, JString, required = false,
                                 default = nil)
  if valid_580975 != nil:
    section.add "oauth_token", valid_580975
  var valid_580976 = query.getOrDefault("alt")
  valid_580976 = validateParameter(valid_580976, JString, required = false,
                                 default = newJString("json"))
  if valid_580976 != nil:
    section.add "alt", valid_580976
  var valid_580977 = query.getOrDefault("userIp")
  valid_580977 = validateParameter(valid_580977, JString, required = false,
                                 default = nil)
  if valid_580977 != nil:
    section.add "userIp", valid_580977
  var valid_580978 = query.getOrDefault("quotaUser")
  valid_580978 = validateParameter(valid_580978, JString, required = false,
                                 default = nil)
  if valid_580978 != nil:
    section.add "quotaUser", valid_580978
  var valid_580979 = query.getOrDefault("fields")
  valid_580979 = validateParameter(valid_580979, JString, required = false,
                                 default = nil)
  if valid_580979 != nil:
    section.add "fields", valid_580979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580980: Call_DriveRevisionsGet_580968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific revision.
  ## 
  let valid = call_580980.validator(path, query, header, formData, body)
  let scheme = call_580980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580980.url(scheme.get, call_580980.host, call_580980.base,
                         call_580980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580980, url, valid)

proc call*(call_580981: Call_DriveRevisionsGet_580968; fileId: string;
          revisionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveRevisionsGet
  ## Gets a specific revision.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   revisionId: string (required)
  ##             : The ID of the revision.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580982 = newJObject()
  var query_580983 = newJObject()
  add(query_580983, "key", newJString(key))
  add(query_580983, "prettyPrint", newJBool(prettyPrint))
  add(query_580983, "oauth_token", newJString(oauthToken))
  add(query_580983, "alt", newJString(alt))
  add(query_580983, "userIp", newJString(userIp))
  add(query_580983, "quotaUser", newJString(quotaUser))
  add(path_580982, "fileId", newJString(fileId))
  add(path_580982, "revisionId", newJString(revisionId))
  add(query_580983, "fields", newJString(fields))
  result = call_580981.call(path_580982, query_580983, nil, nil, nil)

var driveRevisionsGet* = Call_DriveRevisionsGet_580968(name: "driveRevisionsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsGet_580969, base: "/drive/v2",
    url: url_DriveRevisionsGet_580970, schemes: {Scheme.Https})
type
  Call_DriveRevisionsPatch_581018 = ref object of OpenApiRestCall_579380
proc url_DriveRevisionsPatch_581020(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRevisionsPatch_581019(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
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
  var valid_581021 = path.getOrDefault("fileId")
  valid_581021 = validateParameter(valid_581021, JString, required = true,
                                 default = nil)
  if valid_581021 != nil:
    section.add "fileId", valid_581021
  var valid_581022 = path.getOrDefault("revisionId")
  valid_581022 = validateParameter(valid_581022, JString, required = true,
                                 default = nil)
  if valid_581022 != nil:
    section.add "revisionId", valid_581022
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_581023 = query.getOrDefault("key")
  valid_581023 = validateParameter(valid_581023, JString, required = false,
                                 default = nil)
  if valid_581023 != nil:
    section.add "key", valid_581023
  var valid_581024 = query.getOrDefault("prettyPrint")
  valid_581024 = validateParameter(valid_581024, JBool, required = false,
                                 default = newJBool(true))
  if valid_581024 != nil:
    section.add "prettyPrint", valid_581024
  var valid_581025 = query.getOrDefault("oauth_token")
  valid_581025 = validateParameter(valid_581025, JString, required = false,
                                 default = nil)
  if valid_581025 != nil:
    section.add "oauth_token", valid_581025
  var valid_581026 = query.getOrDefault("alt")
  valid_581026 = validateParameter(valid_581026, JString, required = false,
                                 default = newJString("json"))
  if valid_581026 != nil:
    section.add "alt", valid_581026
  var valid_581027 = query.getOrDefault("userIp")
  valid_581027 = validateParameter(valid_581027, JString, required = false,
                                 default = nil)
  if valid_581027 != nil:
    section.add "userIp", valid_581027
  var valid_581028 = query.getOrDefault("quotaUser")
  valid_581028 = validateParameter(valid_581028, JString, required = false,
                                 default = nil)
  if valid_581028 != nil:
    section.add "quotaUser", valid_581028
  var valid_581029 = query.getOrDefault("fields")
  valid_581029 = validateParameter(valid_581029, JString, required = false,
                                 default = nil)
  if valid_581029 != nil:
    section.add "fields", valid_581029
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

proc call*(call_581031: Call_DriveRevisionsPatch_581018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision.
  ## 
  let valid = call_581031.validator(path, query, header, formData, body)
  let scheme = call_581031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581031.url(scheme.get, call_581031.host, call_581031.base,
                         call_581031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581031, url, valid)

proc call*(call_581032: Call_DriveRevisionsPatch_581018; fileId: string;
          revisionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveRevisionsPatch
  ## Updates a revision.
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
  ##   fileId: string (required)
  ##         : The ID for the file.
  ##   body: JObject
  ##   revisionId: string (required)
  ##             : The ID for the revision.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581033 = newJObject()
  var query_581034 = newJObject()
  var body_581035 = newJObject()
  add(query_581034, "key", newJString(key))
  add(query_581034, "prettyPrint", newJBool(prettyPrint))
  add(query_581034, "oauth_token", newJString(oauthToken))
  add(query_581034, "alt", newJString(alt))
  add(query_581034, "userIp", newJString(userIp))
  add(query_581034, "quotaUser", newJString(quotaUser))
  add(path_581033, "fileId", newJString(fileId))
  if body != nil:
    body_581035 = body
  add(path_581033, "revisionId", newJString(revisionId))
  add(query_581034, "fields", newJString(fields))
  result = call_581032.call(path_581033, query_581034, nil, nil, body_581035)

var driveRevisionsPatch* = Call_DriveRevisionsPatch_581018(
    name: "driveRevisionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsPatch_581019, base: "/drive/v2",
    url: url_DriveRevisionsPatch_581020, schemes: {Scheme.Https})
type
  Call_DriveRevisionsDelete_581002 = ref object of OpenApiRestCall_579380
proc url_DriveRevisionsDelete_581004(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveRevisionsDelete_581003(path: JsonNode; query: JsonNode;
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
  var valid_581005 = path.getOrDefault("fileId")
  valid_581005 = validateParameter(valid_581005, JString, required = true,
                                 default = nil)
  if valid_581005 != nil:
    section.add "fileId", valid_581005
  var valid_581006 = path.getOrDefault("revisionId")
  valid_581006 = validateParameter(valid_581006, JString, required = true,
                                 default = nil)
  if valid_581006 != nil:
    section.add "revisionId", valid_581006
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_581007 = query.getOrDefault("key")
  valid_581007 = validateParameter(valid_581007, JString, required = false,
                                 default = nil)
  if valid_581007 != nil:
    section.add "key", valid_581007
  var valid_581008 = query.getOrDefault("prettyPrint")
  valid_581008 = validateParameter(valid_581008, JBool, required = false,
                                 default = newJBool(true))
  if valid_581008 != nil:
    section.add "prettyPrint", valid_581008
  var valid_581009 = query.getOrDefault("oauth_token")
  valid_581009 = validateParameter(valid_581009, JString, required = false,
                                 default = nil)
  if valid_581009 != nil:
    section.add "oauth_token", valid_581009
  var valid_581010 = query.getOrDefault("alt")
  valid_581010 = validateParameter(valid_581010, JString, required = false,
                                 default = newJString("json"))
  if valid_581010 != nil:
    section.add "alt", valid_581010
  var valid_581011 = query.getOrDefault("userIp")
  valid_581011 = validateParameter(valid_581011, JString, required = false,
                                 default = nil)
  if valid_581011 != nil:
    section.add "userIp", valid_581011
  var valid_581012 = query.getOrDefault("quotaUser")
  valid_581012 = validateParameter(valid_581012, JString, required = false,
                                 default = nil)
  if valid_581012 != nil:
    section.add "quotaUser", valid_581012
  var valid_581013 = query.getOrDefault("fields")
  valid_581013 = validateParameter(valid_581013, JString, required = false,
                                 default = nil)
  if valid_581013 != nil:
    section.add "fields", valid_581013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581014: Call_DriveRevisionsDelete_581002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  let valid = call_581014.validator(path, query, header, formData, body)
  let scheme = call_581014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581014.url(scheme.get, call_581014.host, call_581014.base,
                         call_581014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581014, url, valid)

proc call*(call_581015: Call_DriveRevisionsDelete_581002; fileId: string;
          revisionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveRevisionsDelete
  ## Permanently deletes a file version. You can only delete revisions for files with binary content, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
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
  ##   fileId: string (required)
  ##         : The ID of the file.
  ##   revisionId: string (required)
  ##             : The ID of the revision.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581016 = newJObject()
  var query_581017 = newJObject()
  add(query_581017, "key", newJString(key))
  add(query_581017, "prettyPrint", newJBool(prettyPrint))
  add(query_581017, "oauth_token", newJString(oauthToken))
  add(query_581017, "alt", newJString(alt))
  add(query_581017, "userIp", newJString(userIp))
  add(query_581017, "quotaUser", newJString(quotaUser))
  add(path_581016, "fileId", newJString(fileId))
  add(path_581016, "revisionId", newJString(revisionId))
  add(query_581017, "fields", newJString(fields))
  result = call_581015.call(path_581016, query_581017, nil, nil, nil)

var driveRevisionsDelete* = Call_DriveRevisionsDelete_581002(
    name: "driveRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsDelete_581003, base: "/drive/v2",
    url: url_DriveRevisionsDelete_581004, schemes: {Scheme.Https})
type
  Call_DriveFilesTouch_581036 = ref object of OpenApiRestCall_579380
proc url_DriveFilesTouch_581038(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesTouch_581037(path: JsonNode; query: JsonNode;
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
  var valid_581039 = path.getOrDefault("fileId")
  valid_581039 = validateParameter(valid_581039, JString, required = true,
                                 default = nil)
  if valid_581039 != nil:
    section.add "fileId", valid_581039
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581040 = query.getOrDefault("key")
  valid_581040 = validateParameter(valid_581040, JString, required = false,
                                 default = nil)
  if valid_581040 != nil:
    section.add "key", valid_581040
  var valid_581041 = query.getOrDefault("prettyPrint")
  valid_581041 = validateParameter(valid_581041, JBool, required = false,
                                 default = newJBool(true))
  if valid_581041 != nil:
    section.add "prettyPrint", valid_581041
  var valid_581042 = query.getOrDefault("oauth_token")
  valid_581042 = validateParameter(valid_581042, JString, required = false,
                                 default = nil)
  if valid_581042 != nil:
    section.add "oauth_token", valid_581042
  var valid_581043 = query.getOrDefault("alt")
  valid_581043 = validateParameter(valid_581043, JString, required = false,
                                 default = newJString("json"))
  if valid_581043 != nil:
    section.add "alt", valid_581043
  var valid_581044 = query.getOrDefault("userIp")
  valid_581044 = validateParameter(valid_581044, JString, required = false,
                                 default = nil)
  if valid_581044 != nil:
    section.add "userIp", valid_581044
  var valid_581045 = query.getOrDefault("quotaUser")
  valid_581045 = validateParameter(valid_581045, JString, required = false,
                                 default = nil)
  if valid_581045 != nil:
    section.add "quotaUser", valid_581045
  var valid_581046 = query.getOrDefault("supportsTeamDrives")
  valid_581046 = validateParameter(valid_581046, JBool, required = false,
                                 default = newJBool(false))
  if valid_581046 != nil:
    section.add "supportsTeamDrives", valid_581046
  var valid_581047 = query.getOrDefault("supportsAllDrives")
  valid_581047 = validateParameter(valid_581047, JBool, required = false,
                                 default = newJBool(false))
  if valid_581047 != nil:
    section.add "supportsAllDrives", valid_581047
  var valid_581048 = query.getOrDefault("fields")
  valid_581048 = validateParameter(valid_581048, JString, required = false,
                                 default = nil)
  if valid_581048 != nil:
    section.add "fields", valid_581048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581049: Call_DriveFilesTouch_581036; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set the file's updated time to the current server time.
  ## 
  let valid = call_581049.validator(path, query, header, formData, body)
  let scheme = call_581049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581049.url(scheme.get, call_581049.host, call_581049.base,
                         call_581049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581049, url, valid)

proc call*(call_581050: Call_DriveFilesTouch_581036; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          fields: string = ""): Recallable =
  ## driveFilesTouch
  ## Set the file's updated time to the current server time.
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
  ##   fileId: string (required)
  ##         : The ID of the file to update.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581051 = newJObject()
  var query_581052 = newJObject()
  add(query_581052, "key", newJString(key))
  add(query_581052, "prettyPrint", newJBool(prettyPrint))
  add(query_581052, "oauth_token", newJString(oauthToken))
  add(query_581052, "alt", newJString(alt))
  add(query_581052, "userIp", newJString(userIp))
  add(query_581052, "quotaUser", newJString(quotaUser))
  add(path_581051, "fileId", newJString(fileId))
  add(query_581052, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_581052, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_581052, "fields", newJString(fields))
  result = call_581050.call(path_581051, query_581052, nil, nil, nil)

var driveFilesTouch* = Call_DriveFilesTouch_581036(name: "driveFilesTouch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/touch", validator: validate_DriveFilesTouch_581037,
    base: "/drive/v2", url: url_DriveFilesTouch_581038, schemes: {Scheme.Https})
type
  Call_DriveFilesTrash_581053 = ref object of OpenApiRestCall_579380
proc url_DriveFilesTrash_581055(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesTrash_581054(path: JsonNode; query: JsonNode;
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
  var valid_581056 = path.getOrDefault("fileId")
  valid_581056 = validateParameter(valid_581056, JString, required = true,
                                 default = nil)
  if valid_581056 != nil:
    section.add "fileId", valid_581056
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581057 = query.getOrDefault("key")
  valid_581057 = validateParameter(valid_581057, JString, required = false,
                                 default = nil)
  if valid_581057 != nil:
    section.add "key", valid_581057
  var valid_581058 = query.getOrDefault("prettyPrint")
  valid_581058 = validateParameter(valid_581058, JBool, required = false,
                                 default = newJBool(true))
  if valid_581058 != nil:
    section.add "prettyPrint", valid_581058
  var valid_581059 = query.getOrDefault("oauth_token")
  valid_581059 = validateParameter(valid_581059, JString, required = false,
                                 default = nil)
  if valid_581059 != nil:
    section.add "oauth_token", valid_581059
  var valid_581060 = query.getOrDefault("alt")
  valid_581060 = validateParameter(valid_581060, JString, required = false,
                                 default = newJString("json"))
  if valid_581060 != nil:
    section.add "alt", valid_581060
  var valid_581061 = query.getOrDefault("userIp")
  valid_581061 = validateParameter(valid_581061, JString, required = false,
                                 default = nil)
  if valid_581061 != nil:
    section.add "userIp", valid_581061
  var valid_581062 = query.getOrDefault("quotaUser")
  valid_581062 = validateParameter(valid_581062, JString, required = false,
                                 default = nil)
  if valid_581062 != nil:
    section.add "quotaUser", valid_581062
  var valid_581063 = query.getOrDefault("supportsTeamDrives")
  valid_581063 = validateParameter(valid_581063, JBool, required = false,
                                 default = newJBool(false))
  if valid_581063 != nil:
    section.add "supportsTeamDrives", valid_581063
  var valid_581064 = query.getOrDefault("supportsAllDrives")
  valid_581064 = validateParameter(valid_581064, JBool, required = false,
                                 default = newJBool(false))
  if valid_581064 != nil:
    section.add "supportsAllDrives", valid_581064
  var valid_581065 = query.getOrDefault("fields")
  valid_581065 = validateParameter(valid_581065, JString, required = false,
                                 default = nil)
  if valid_581065 != nil:
    section.add "fields", valid_581065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581066: Call_DriveFilesTrash_581053; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves a file to the trash. The currently authenticated user must own the file or be at least a fileOrganizer on the parent for shared drive files.
  ## 
  let valid = call_581066.validator(path, query, header, formData, body)
  let scheme = call_581066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581066.url(scheme.get, call_581066.host, call_581066.base,
                         call_581066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581066, url, valid)

proc call*(call_581067: Call_DriveFilesTrash_581053; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          fields: string = ""): Recallable =
  ## driveFilesTrash
  ## Moves a file to the trash. The currently authenticated user must own the file or be at least a fileOrganizer on the parent for shared drive files.
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
  ##   fileId: string (required)
  ##         : The ID of the file to trash.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581068 = newJObject()
  var query_581069 = newJObject()
  add(query_581069, "key", newJString(key))
  add(query_581069, "prettyPrint", newJBool(prettyPrint))
  add(query_581069, "oauth_token", newJString(oauthToken))
  add(query_581069, "alt", newJString(alt))
  add(query_581069, "userIp", newJString(userIp))
  add(query_581069, "quotaUser", newJString(quotaUser))
  add(path_581068, "fileId", newJString(fileId))
  add(query_581069, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_581069, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_581069, "fields", newJString(fields))
  result = call_581067.call(path_581068, query_581069, nil, nil, nil)

var driveFilesTrash* = Call_DriveFilesTrash_581053(name: "driveFilesTrash",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/trash", validator: validate_DriveFilesTrash_581054,
    base: "/drive/v2", url: url_DriveFilesTrash_581055, schemes: {Scheme.Https})
type
  Call_DriveFilesUntrash_581070 = ref object of OpenApiRestCall_579380
proc url_DriveFilesUntrash_581072(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesUntrash_581071(path: JsonNode; query: JsonNode;
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
  var valid_581073 = path.getOrDefault("fileId")
  valid_581073 = validateParameter(valid_581073, JString, required = true,
                                 default = nil)
  if valid_581073 != nil:
    section.add "fileId", valid_581073
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581074 = query.getOrDefault("key")
  valid_581074 = validateParameter(valid_581074, JString, required = false,
                                 default = nil)
  if valid_581074 != nil:
    section.add "key", valid_581074
  var valid_581075 = query.getOrDefault("prettyPrint")
  valid_581075 = validateParameter(valid_581075, JBool, required = false,
                                 default = newJBool(true))
  if valid_581075 != nil:
    section.add "prettyPrint", valid_581075
  var valid_581076 = query.getOrDefault("oauth_token")
  valid_581076 = validateParameter(valid_581076, JString, required = false,
                                 default = nil)
  if valid_581076 != nil:
    section.add "oauth_token", valid_581076
  var valid_581077 = query.getOrDefault("alt")
  valid_581077 = validateParameter(valid_581077, JString, required = false,
                                 default = newJString("json"))
  if valid_581077 != nil:
    section.add "alt", valid_581077
  var valid_581078 = query.getOrDefault("userIp")
  valid_581078 = validateParameter(valid_581078, JString, required = false,
                                 default = nil)
  if valid_581078 != nil:
    section.add "userIp", valid_581078
  var valid_581079 = query.getOrDefault("quotaUser")
  valid_581079 = validateParameter(valid_581079, JString, required = false,
                                 default = nil)
  if valid_581079 != nil:
    section.add "quotaUser", valid_581079
  var valid_581080 = query.getOrDefault("supportsTeamDrives")
  valid_581080 = validateParameter(valid_581080, JBool, required = false,
                                 default = newJBool(false))
  if valid_581080 != nil:
    section.add "supportsTeamDrives", valid_581080
  var valid_581081 = query.getOrDefault("supportsAllDrives")
  valid_581081 = validateParameter(valid_581081, JBool, required = false,
                                 default = newJBool(false))
  if valid_581081 != nil:
    section.add "supportsAllDrives", valid_581081
  var valid_581082 = query.getOrDefault("fields")
  valid_581082 = validateParameter(valid_581082, JString, required = false,
                                 default = nil)
  if valid_581082 != nil:
    section.add "fields", valid_581082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581083: Call_DriveFilesUntrash_581070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a file from the trash.
  ## 
  let valid = call_581083.validator(path, query, header, formData, body)
  let scheme = call_581083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581083.url(scheme.get, call_581083.host, call_581083.base,
                         call_581083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581083, url, valid)

proc call*(call_581084: Call_DriveFilesUntrash_581070; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          fields: string = ""): Recallable =
  ## driveFilesUntrash
  ## Restores a file from the trash.
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
  ##   fileId: string (required)
  ##         : The ID of the file to untrash.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581085 = newJObject()
  var query_581086 = newJObject()
  add(query_581086, "key", newJString(key))
  add(query_581086, "prettyPrint", newJBool(prettyPrint))
  add(query_581086, "oauth_token", newJString(oauthToken))
  add(query_581086, "alt", newJString(alt))
  add(query_581086, "userIp", newJString(userIp))
  add(query_581086, "quotaUser", newJString(quotaUser))
  add(path_581085, "fileId", newJString(fileId))
  add(query_581086, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_581086, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_581086, "fields", newJString(fields))
  result = call_581084.call(path_581085, query_581086, nil, nil, nil)

var driveFilesUntrash* = Call_DriveFilesUntrash_581070(name: "driveFilesUntrash",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/untrash", validator: validate_DriveFilesUntrash_581071,
    base: "/drive/v2", url: url_DriveFilesUntrash_581072, schemes: {Scheme.Https})
type
  Call_DriveFilesWatch_581087 = ref object of OpenApiRestCall_579380
proc url_DriveFilesWatch_581089(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveFilesWatch_581088(path: JsonNode; query: JsonNode;
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
  var valid_581090 = path.getOrDefault("fileId")
  valid_581090 = validateParameter(valid_581090, JString, required = true,
                                 default = nil)
  if valid_581090 != nil:
    section.add "fileId", valid_581090
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   acknowledgeAbuse: JBool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   revisionId: JString
  ##             : Specifies the Revision ID that should be downloaded. Ignored unless alt=media is specified.
  ##   projection: JString
  ##             : This parameter is deprecated and has no function.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   updateViewedDate: JBool
  ##                   : Deprecated: Use files.update with modifiedDateBehavior=noChange, updateViewedDate=true and an empty request body.
  section = newJObject()
  var valid_581091 = query.getOrDefault("key")
  valid_581091 = validateParameter(valid_581091, JString, required = false,
                                 default = nil)
  if valid_581091 != nil:
    section.add "key", valid_581091
  var valid_581092 = query.getOrDefault("prettyPrint")
  valid_581092 = validateParameter(valid_581092, JBool, required = false,
                                 default = newJBool(true))
  if valid_581092 != nil:
    section.add "prettyPrint", valid_581092
  var valid_581093 = query.getOrDefault("oauth_token")
  valid_581093 = validateParameter(valid_581093, JString, required = false,
                                 default = nil)
  if valid_581093 != nil:
    section.add "oauth_token", valid_581093
  var valid_581094 = query.getOrDefault("alt")
  valid_581094 = validateParameter(valid_581094, JString, required = false,
                                 default = newJString("json"))
  if valid_581094 != nil:
    section.add "alt", valid_581094
  var valid_581095 = query.getOrDefault("userIp")
  valid_581095 = validateParameter(valid_581095, JString, required = false,
                                 default = nil)
  if valid_581095 != nil:
    section.add "userIp", valid_581095
  var valid_581096 = query.getOrDefault("quotaUser")
  valid_581096 = validateParameter(valid_581096, JString, required = false,
                                 default = nil)
  if valid_581096 != nil:
    section.add "quotaUser", valid_581096
  var valid_581097 = query.getOrDefault("supportsTeamDrives")
  valid_581097 = validateParameter(valid_581097, JBool, required = false,
                                 default = newJBool(false))
  if valid_581097 != nil:
    section.add "supportsTeamDrives", valid_581097
  var valid_581098 = query.getOrDefault("acknowledgeAbuse")
  valid_581098 = validateParameter(valid_581098, JBool, required = false,
                                 default = newJBool(false))
  if valid_581098 != nil:
    section.add "acknowledgeAbuse", valid_581098
  var valid_581099 = query.getOrDefault("supportsAllDrives")
  valid_581099 = validateParameter(valid_581099, JBool, required = false,
                                 default = newJBool(false))
  if valid_581099 != nil:
    section.add "supportsAllDrives", valid_581099
  var valid_581100 = query.getOrDefault("revisionId")
  valid_581100 = validateParameter(valid_581100, JString, required = false,
                                 default = nil)
  if valid_581100 != nil:
    section.add "revisionId", valid_581100
  var valid_581101 = query.getOrDefault("projection")
  valid_581101 = validateParameter(valid_581101, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_581101 != nil:
    section.add "projection", valid_581101
  var valid_581102 = query.getOrDefault("fields")
  valid_581102 = validateParameter(valid_581102, JString, required = false,
                                 default = nil)
  if valid_581102 != nil:
    section.add "fields", valid_581102
  var valid_581103 = query.getOrDefault("updateViewedDate")
  valid_581103 = validateParameter(valid_581103, JBool, required = false,
                                 default = newJBool(false))
  if valid_581103 != nil:
    section.add "updateViewedDate", valid_581103
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

proc call*(call_581105: Call_DriveFilesWatch_581087; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe to changes on a file
  ## 
  let valid = call_581105.validator(path, query, header, formData, body)
  let scheme = call_581105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581105.url(scheme.get, call_581105.host, call_581105.base,
                         call_581105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581105, url, valid)

proc call*(call_581106: Call_DriveFilesWatch_581087; fileId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; acknowledgeAbuse: bool = false;
          supportsAllDrives: bool = false; revisionId: string = "";
          resource: JsonNode = nil; projection: string = "BASIC"; fields: string = "";
          updateViewedDate: bool = false): Recallable =
  ## driveFilesWatch
  ## Subscribe to changes on a file
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
  ##   fileId: string (required)
  ##         : The ID for the file in question.
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   acknowledgeAbuse: bool
  ##                   : Whether the user is acknowledging the risk of downloading known malware or other abusive files.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   revisionId: string
  ##             : Specifies the Revision ID that should be downloaded. Ignored unless alt=media is specified.
  ##   resource: JObject
  ##   projection: string
  ##             : This parameter is deprecated and has no function.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   updateViewedDate: bool
  ##                   : Deprecated: Use files.update with modifiedDateBehavior=noChange, updateViewedDate=true and an empty request body.
  var path_581107 = newJObject()
  var query_581108 = newJObject()
  var body_581109 = newJObject()
  add(query_581108, "key", newJString(key))
  add(query_581108, "prettyPrint", newJBool(prettyPrint))
  add(query_581108, "oauth_token", newJString(oauthToken))
  add(query_581108, "alt", newJString(alt))
  add(query_581108, "userIp", newJString(userIp))
  add(query_581108, "quotaUser", newJString(quotaUser))
  add(path_581107, "fileId", newJString(fileId))
  add(query_581108, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_581108, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_581108, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_581108, "revisionId", newJString(revisionId))
  if resource != nil:
    body_581109 = resource
  add(query_581108, "projection", newJString(projection))
  add(query_581108, "fields", newJString(fields))
  add(query_581108, "updateViewedDate", newJBool(updateViewedDate))
  result = call_581106.call(path_581107, query_581108, nil, nil, body_581109)

var driveFilesWatch* = Call_DriveFilesWatch_581087(name: "driveFilesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/watch", validator: validate_DriveFilesWatch_581088,
    base: "/drive/v2", url: url_DriveFilesWatch_581089, schemes: {Scheme.Https})
type
  Call_DriveChildrenInsert_581129 = ref object of OpenApiRestCall_579380
proc url_DriveChildrenInsert_581131(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveChildrenInsert_581130(path: JsonNode; query: JsonNode;
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
  var valid_581132 = path.getOrDefault("folderId")
  valid_581132 = validateParameter(valid_581132, JString, required = true,
                                 default = nil)
  if valid_581132 != nil:
    section.add "folderId", valid_581132
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsTeamDrives: JBool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: JBool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581133 = query.getOrDefault("key")
  valid_581133 = validateParameter(valid_581133, JString, required = false,
                                 default = nil)
  if valid_581133 != nil:
    section.add "key", valid_581133
  var valid_581134 = query.getOrDefault("prettyPrint")
  valid_581134 = validateParameter(valid_581134, JBool, required = false,
                                 default = newJBool(true))
  if valid_581134 != nil:
    section.add "prettyPrint", valid_581134
  var valid_581135 = query.getOrDefault("oauth_token")
  valid_581135 = validateParameter(valid_581135, JString, required = false,
                                 default = nil)
  if valid_581135 != nil:
    section.add "oauth_token", valid_581135
  var valid_581136 = query.getOrDefault("alt")
  valid_581136 = validateParameter(valid_581136, JString, required = false,
                                 default = newJString("json"))
  if valid_581136 != nil:
    section.add "alt", valid_581136
  var valid_581137 = query.getOrDefault("userIp")
  valid_581137 = validateParameter(valid_581137, JString, required = false,
                                 default = nil)
  if valid_581137 != nil:
    section.add "userIp", valid_581137
  var valid_581138 = query.getOrDefault("quotaUser")
  valid_581138 = validateParameter(valid_581138, JString, required = false,
                                 default = nil)
  if valid_581138 != nil:
    section.add "quotaUser", valid_581138
  var valid_581139 = query.getOrDefault("supportsTeamDrives")
  valid_581139 = validateParameter(valid_581139, JBool, required = false,
                                 default = newJBool(false))
  if valid_581139 != nil:
    section.add "supportsTeamDrives", valid_581139
  var valid_581140 = query.getOrDefault("supportsAllDrives")
  valid_581140 = validateParameter(valid_581140, JBool, required = false,
                                 default = newJBool(false))
  if valid_581140 != nil:
    section.add "supportsAllDrives", valid_581140
  var valid_581141 = query.getOrDefault("fields")
  valid_581141 = validateParameter(valid_581141, JString, required = false,
                                 default = nil)
  if valid_581141 != nil:
    section.add "fields", valid_581141
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

proc call*(call_581143: Call_DriveChildrenInsert_581129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a file into a folder.
  ## 
  let valid = call_581143.validator(path, query, header, formData, body)
  let scheme = call_581143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581143.url(scheme.get, call_581143.host, call_581143.base,
                         call_581143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581143, url, valid)

proc call*(call_581144: Call_DriveChildrenInsert_581129; folderId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsTeamDrives: bool = false; supportsAllDrives: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveChildrenInsert
  ## Inserts a file into a folder.
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
  ##   supportsTeamDrives: bool
  ##                     : Deprecated use supportsAllDrives instead.
  ##   supportsAllDrives: bool
  ##                    : Deprecated - Whether the requesting application supports both My Drives and shared drives. This parameter will only be effective until June 1, 2020. Afterwards all applications are assumed to support shared drives.
  ##   folderId: string (required)
  ##           : The ID of the folder.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581145 = newJObject()
  var query_581146 = newJObject()
  var body_581147 = newJObject()
  add(query_581146, "key", newJString(key))
  add(query_581146, "prettyPrint", newJBool(prettyPrint))
  add(query_581146, "oauth_token", newJString(oauthToken))
  add(query_581146, "alt", newJString(alt))
  add(query_581146, "userIp", newJString(userIp))
  add(query_581146, "quotaUser", newJString(quotaUser))
  add(query_581146, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_581146, "supportsAllDrives", newJBool(supportsAllDrives))
  add(path_581145, "folderId", newJString(folderId))
  if body != nil:
    body_581147 = body
  add(query_581146, "fields", newJString(fields))
  result = call_581144.call(path_581145, query_581146, nil, nil, body_581147)

var driveChildrenInsert* = Call_DriveChildrenInsert_581129(
    name: "driveChildrenInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{folderId}/children",
    validator: validate_DriveChildrenInsert_581130, base: "/drive/v2",
    url: url_DriveChildrenInsert_581131, schemes: {Scheme.Https})
type
  Call_DriveChildrenList_581110 = ref object of OpenApiRestCall_579380
proc url_DriveChildrenList_581112(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveChildrenList_581111(path: JsonNode; query: JsonNode;
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
  var valid_581113 = path.getOrDefault("folderId")
  valid_581113 = validateParameter(valid_581113, JString, required = true,
                                 default = nil)
  if valid_581113 != nil:
    section.add "folderId", valid_581113
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   q: JString
  ##    : Query string for searching children.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : A comma-separated list of sort keys. Valid keys are 'createdDate', 'folder', 'lastViewedByMeDate', 'modifiedByMeDate', 'modifiedDate', 'quotaBytesUsed', 'recency', 'sharedWithMeDate', 'starred', and 'title'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedDate desc,title. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   pageToken: JString
  ##            : Page token for children.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of children to return.
  section = newJObject()
  var valid_581114 = query.getOrDefault("key")
  valid_581114 = validateParameter(valid_581114, JString, required = false,
                                 default = nil)
  if valid_581114 != nil:
    section.add "key", valid_581114
  var valid_581115 = query.getOrDefault("prettyPrint")
  valid_581115 = validateParameter(valid_581115, JBool, required = false,
                                 default = newJBool(true))
  if valid_581115 != nil:
    section.add "prettyPrint", valid_581115
  var valid_581116 = query.getOrDefault("oauth_token")
  valid_581116 = validateParameter(valid_581116, JString, required = false,
                                 default = nil)
  if valid_581116 != nil:
    section.add "oauth_token", valid_581116
  var valid_581117 = query.getOrDefault("q")
  valid_581117 = validateParameter(valid_581117, JString, required = false,
                                 default = nil)
  if valid_581117 != nil:
    section.add "q", valid_581117
  var valid_581118 = query.getOrDefault("alt")
  valid_581118 = validateParameter(valid_581118, JString, required = false,
                                 default = newJString("json"))
  if valid_581118 != nil:
    section.add "alt", valid_581118
  var valid_581119 = query.getOrDefault("userIp")
  valid_581119 = validateParameter(valid_581119, JString, required = false,
                                 default = nil)
  if valid_581119 != nil:
    section.add "userIp", valid_581119
  var valid_581120 = query.getOrDefault("quotaUser")
  valid_581120 = validateParameter(valid_581120, JString, required = false,
                                 default = nil)
  if valid_581120 != nil:
    section.add "quotaUser", valid_581120
  var valid_581121 = query.getOrDefault("orderBy")
  valid_581121 = validateParameter(valid_581121, JString, required = false,
                                 default = nil)
  if valid_581121 != nil:
    section.add "orderBy", valid_581121
  var valid_581122 = query.getOrDefault("pageToken")
  valid_581122 = validateParameter(valid_581122, JString, required = false,
                                 default = nil)
  if valid_581122 != nil:
    section.add "pageToken", valid_581122
  var valid_581123 = query.getOrDefault("fields")
  valid_581123 = validateParameter(valid_581123, JString, required = false,
                                 default = nil)
  if valid_581123 != nil:
    section.add "fields", valid_581123
  var valid_581124 = query.getOrDefault("maxResults")
  valid_581124 = validateParameter(valid_581124, JInt, required = false,
                                 default = newJInt(100))
  if valid_581124 != nil:
    section.add "maxResults", valid_581124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581125: Call_DriveChildrenList_581110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a folder's children.
  ## 
  let valid = call_581125.validator(path, query, header, formData, body)
  let scheme = call_581125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581125.url(scheme.get, call_581125.host, call_581125.base,
                         call_581125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581125, url, valid)

proc call*(call_581126: Call_DriveChildrenList_581110; folderId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          q: string = ""; alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 100): Recallable =
  ## driveChildrenList
  ## Lists a folder's children.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   q: string
  ##    : Query string for searching children.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : A comma-separated list of sort keys. Valid keys are 'createdDate', 'folder', 'lastViewedByMeDate', 'modifiedByMeDate', 'modifiedDate', 'quotaBytesUsed', 'recency', 'sharedWithMeDate', 'starred', and 'title'. Each key sorts ascending by default, but may be reversed with the 'desc' modifier. Example usage: ?orderBy=folder,modifiedDate desc,title. Please note that there is a current limitation for users with approximately one million files in which the requested sort order is ignored.
  ##   pageToken: string
  ##            : Page token for children.
  ##   folderId: string (required)
  ##           : The ID of the folder.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of children to return.
  var path_581127 = newJObject()
  var query_581128 = newJObject()
  add(query_581128, "key", newJString(key))
  add(query_581128, "prettyPrint", newJBool(prettyPrint))
  add(query_581128, "oauth_token", newJString(oauthToken))
  add(query_581128, "q", newJString(q))
  add(query_581128, "alt", newJString(alt))
  add(query_581128, "userIp", newJString(userIp))
  add(query_581128, "quotaUser", newJString(quotaUser))
  add(query_581128, "orderBy", newJString(orderBy))
  add(query_581128, "pageToken", newJString(pageToken))
  add(path_581127, "folderId", newJString(folderId))
  add(query_581128, "fields", newJString(fields))
  add(query_581128, "maxResults", newJInt(maxResults))
  result = call_581126.call(path_581127, query_581128, nil, nil, nil)

var driveChildrenList* = Call_DriveChildrenList_581110(name: "driveChildrenList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{folderId}/children", validator: validate_DriveChildrenList_581111,
    base: "/drive/v2", url: url_DriveChildrenList_581112, schemes: {Scheme.Https})
type
  Call_DriveChildrenGet_581148 = ref object of OpenApiRestCall_579380
proc url_DriveChildrenGet_581150(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveChildrenGet_581149(path: JsonNode; query: JsonNode;
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
  var valid_581151 = path.getOrDefault("childId")
  valid_581151 = validateParameter(valid_581151, JString, required = true,
                                 default = nil)
  if valid_581151 != nil:
    section.add "childId", valid_581151
  var valid_581152 = path.getOrDefault("folderId")
  valid_581152 = validateParameter(valid_581152, JString, required = true,
                                 default = nil)
  if valid_581152 != nil:
    section.add "folderId", valid_581152
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_581153 = query.getOrDefault("key")
  valid_581153 = validateParameter(valid_581153, JString, required = false,
                                 default = nil)
  if valid_581153 != nil:
    section.add "key", valid_581153
  var valid_581154 = query.getOrDefault("prettyPrint")
  valid_581154 = validateParameter(valid_581154, JBool, required = false,
                                 default = newJBool(true))
  if valid_581154 != nil:
    section.add "prettyPrint", valid_581154
  var valid_581155 = query.getOrDefault("oauth_token")
  valid_581155 = validateParameter(valid_581155, JString, required = false,
                                 default = nil)
  if valid_581155 != nil:
    section.add "oauth_token", valid_581155
  var valid_581156 = query.getOrDefault("alt")
  valid_581156 = validateParameter(valid_581156, JString, required = false,
                                 default = newJString("json"))
  if valid_581156 != nil:
    section.add "alt", valid_581156
  var valid_581157 = query.getOrDefault("userIp")
  valid_581157 = validateParameter(valid_581157, JString, required = false,
                                 default = nil)
  if valid_581157 != nil:
    section.add "userIp", valid_581157
  var valid_581158 = query.getOrDefault("quotaUser")
  valid_581158 = validateParameter(valid_581158, JString, required = false,
                                 default = nil)
  if valid_581158 != nil:
    section.add "quotaUser", valid_581158
  var valid_581159 = query.getOrDefault("fields")
  valid_581159 = validateParameter(valid_581159, JString, required = false,
                                 default = nil)
  if valid_581159 != nil:
    section.add "fields", valid_581159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581160: Call_DriveChildrenGet_581148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific child reference.
  ## 
  let valid = call_581160.validator(path, query, header, formData, body)
  let scheme = call_581160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581160.url(scheme.get, call_581160.host, call_581160.base,
                         call_581160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581160, url, valid)

proc call*(call_581161: Call_DriveChildrenGet_581148; childId: string;
          folderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveChildrenGet
  ## Gets a specific child reference.
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
  ##   childId: string (required)
  ##          : The ID of the child.
  ##   folderId: string (required)
  ##           : The ID of the folder.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581162 = newJObject()
  var query_581163 = newJObject()
  add(query_581163, "key", newJString(key))
  add(query_581163, "prettyPrint", newJBool(prettyPrint))
  add(query_581163, "oauth_token", newJString(oauthToken))
  add(query_581163, "alt", newJString(alt))
  add(query_581163, "userIp", newJString(userIp))
  add(query_581163, "quotaUser", newJString(quotaUser))
  add(path_581162, "childId", newJString(childId))
  add(path_581162, "folderId", newJString(folderId))
  add(query_581163, "fields", newJString(fields))
  result = call_581161.call(path_581162, query_581163, nil, nil, nil)

var driveChildrenGet* = Call_DriveChildrenGet_581148(name: "driveChildrenGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{folderId}/children/{childId}",
    validator: validate_DriveChildrenGet_581149, base: "/drive/v2",
    url: url_DriveChildrenGet_581150, schemes: {Scheme.Https})
type
  Call_DriveChildrenDelete_581164 = ref object of OpenApiRestCall_579380
proc url_DriveChildrenDelete_581166(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveChildrenDelete_581165(path: JsonNode; query: JsonNode;
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
  var valid_581167 = path.getOrDefault("childId")
  valid_581167 = validateParameter(valid_581167, JString, required = true,
                                 default = nil)
  if valid_581167 != nil:
    section.add "childId", valid_581167
  var valid_581168 = path.getOrDefault("folderId")
  valid_581168 = validateParameter(valid_581168, JString, required = true,
                                 default = nil)
  if valid_581168 != nil:
    section.add "folderId", valid_581168
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_581169 = query.getOrDefault("key")
  valid_581169 = validateParameter(valid_581169, JString, required = false,
                                 default = nil)
  if valid_581169 != nil:
    section.add "key", valid_581169
  var valid_581170 = query.getOrDefault("prettyPrint")
  valid_581170 = validateParameter(valid_581170, JBool, required = false,
                                 default = newJBool(true))
  if valid_581170 != nil:
    section.add "prettyPrint", valid_581170
  var valid_581171 = query.getOrDefault("oauth_token")
  valid_581171 = validateParameter(valid_581171, JString, required = false,
                                 default = nil)
  if valid_581171 != nil:
    section.add "oauth_token", valid_581171
  var valid_581172 = query.getOrDefault("alt")
  valid_581172 = validateParameter(valid_581172, JString, required = false,
                                 default = newJString("json"))
  if valid_581172 != nil:
    section.add "alt", valid_581172
  var valid_581173 = query.getOrDefault("userIp")
  valid_581173 = validateParameter(valid_581173, JString, required = false,
                                 default = nil)
  if valid_581173 != nil:
    section.add "userIp", valid_581173
  var valid_581174 = query.getOrDefault("quotaUser")
  valid_581174 = validateParameter(valid_581174, JString, required = false,
                                 default = nil)
  if valid_581174 != nil:
    section.add "quotaUser", valid_581174
  var valid_581175 = query.getOrDefault("fields")
  valid_581175 = validateParameter(valid_581175, JString, required = false,
                                 default = nil)
  if valid_581175 != nil:
    section.add "fields", valid_581175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581176: Call_DriveChildrenDelete_581164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a child from a folder.
  ## 
  let valid = call_581176.validator(path, query, header, formData, body)
  let scheme = call_581176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581176.url(scheme.get, call_581176.host, call_581176.base,
                         call_581176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581176, url, valid)

proc call*(call_581177: Call_DriveChildrenDelete_581164; childId: string;
          folderId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveChildrenDelete
  ## Removes a child from a folder.
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
  ##   childId: string (required)
  ##          : The ID of the child.
  ##   folderId: string (required)
  ##           : The ID of the folder.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581178 = newJObject()
  var query_581179 = newJObject()
  add(query_581179, "key", newJString(key))
  add(query_581179, "prettyPrint", newJBool(prettyPrint))
  add(query_581179, "oauth_token", newJString(oauthToken))
  add(query_581179, "alt", newJString(alt))
  add(query_581179, "userIp", newJString(userIp))
  add(query_581179, "quotaUser", newJString(quotaUser))
  add(path_581178, "childId", newJString(childId))
  add(path_581178, "folderId", newJString(folderId))
  add(query_581179, "fields", newJString(fields))
  result = call_581177.call(path_581178, query_581179, nil, nil, nil)

var driveChildrenDelete* = Call_DriveChildrenDelete_581164(
    name: "driveChildrenDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{folderId}/children/{childId}",
    validator: validate_DriveChildrenDelete_581165, base: "/drive/v2",
    url: url_DriveChildrenDelete_581166, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGetIdForEmail_581180 = ref object of OpenApiRestCall_579380
proc url_DrivePermissionsGetIdForEmail_581182(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DrivePermissionsGetIdForEmail_581181(path: JsonNode; query: JsonNode;
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
  var valid_581183 = path.getOrDefault("email")
  valid_581183 = validateParameter(valid_581183, JString, required = true,
                                 default = nil)
  if valid_581183 != nil:
    section.add "email", valid_581183
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_581184 = query.getOrDefault("key")
  valid_581184 = validateParameter(valid_581184, JString, required = false,
                                 default = nil)
  if valid_581184 != nil:
    section.add "key", valid_581184
  var valid_581185 = query.getOrDefault("prettyPrint")
  valid_581185 = validateParameter(valid_581185, JBool, required = false,
                                 default = newJBool(true))
  if valid_581185 != nil:
    section.add "prettyPrint", valid_581185
  var valid_581186 = query.getOrDefault("oauth_token")
  valid_581186 = validateParameter(valid_581186, JString, required = false,
                                 default = nil)
  if valid_581186 != nil:
    section.add "oauth_token", valid_581186
  var valid_581187 = query.getOrDefault("alt")
  valid_581187 = validateParameter(valid_581187, JString, required = false,
                                 default = newJString("json"))
  if valid_581187 != nil:
    section.add "alt", valid_581187
  var valid_581188 = query.getOrDefault("userIp")
  valid_581188 = validateParameter(valid_581188, JString, required = false,
                                 default = nil)
  if valid_581188 != nil:
    section.add "userIp", valid_581188
  var valid_581189 = query.getOrDefault("quotaUser")
  valid_581189 = validateParameter(valid_581189, JString, required = false,
                                 default = nil)
  if valid_581189 != nil:
    section.add "quotaUser", valid_581189
  var valid_581190 = query.getOrDefault("fields")
  valid_581190 = validateParameter(valid_581190, JString, required = false,
                                 default = nil)
  if valid_581190 != nil:
    section.add "fields", valid_581190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581191: Call_DrivePermissionsGetIdForEmail_581180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the permission ID for an email address.
  ## 
  let valid = call_581191.validator(path, query, header, formData, body)
  let scheme = call_581191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581191.url(scheme.get, call_581191.host, call_581191.base,
                         call_581191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581191, url, valid)

proc call*(call_581192: Call_DrivePermissionsGetIdForEmail_581180; email: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## drivePermissionsGetIdForEmail
  ## Returns the permission ID for an email address.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   email: string (required)
  ##        : The email address for which to return a permission ID
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581193 = newJObject()
  var query_581194 = newJObject()
  add(query_581194, "key", newJString(key))
  add(query_581194, "prettyPrint", newJBool(prettyPrint))
  add(query_581194, "oauth_token", newJString(oauthToken))
  add(path_581193, "email", newJString(email))
  add(query_581194, "alt", newJString(alt))
  add(query_581194, "userIp", newJString(userIp))
  add(query_581194, "quotaUser", newJString(quotaUser))
  add(query_581194, "fields", newJString(fields))
  result = call_581192.call(path_581193, query_581194, nil, nil, nil)

var drivePermissionsGetIdForEmail* = Call_DrivePermissionsGetIdForEmail_581180(
    name: "drivePermissionsGetIdForEmail", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/permissionIds/{email}",
    validator: validate_DrivePermissionsGetIdForEmail_581181, base: "/drive/v2",
    url: url_DrivePermissionsGetIdForEmail_581182, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesInsert_581212 = ref object of OpenApiRestCall_579380
proc url_DriveTeamdrivesInsert_581214(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesInsert_581213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated use drives.insert instead.
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
  ##   requestId: JString (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a Team Drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same Team Drive. If the Team Drive already exists a 409 error will be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581215 = query.getOrDefault("key")
  valid_581215 = validateParameter(valid_581215, JString, required = false,
                                 default = nil)
  if valid_581215 != nil:
    section.add "key", valid_581215
  var valid_581216 = query.getOrDefault("prettyPrint")
  valid_581216 = validateParameter(valid_581216, JBool, required = false,
                                 default = newJBool(true))
  if valid_581216 != nil:
    section.add "prettyPrint", valid_581216
  var valid_581217 = query.getOrDefault("oauth_token")
  valid_581217 = validateParameter(valid_581217, JString, required = false,
                                 default = nil)
  if valid_581217 != nil:
    section.add "oauth_token", valid_581217
  var valid_581218 = query.getOrDefault("alt")
  valid_581218 = validateParameter(valid_581218, JString, required = false,
                                 default = newJString("json"))
  if valid_581218 != nil:
    section.add "alt", valid_581218
  var valid_581219 = query.getOrDefault("userIp")
  valid_581219 = validateParameter(valid_581219, JString, required = false,
                                 default = nil)
  if valid_581219 != nil:
    section.add "userIp", valid_581219
  var valid_581220 = query.getOrDefault("quotaUser")
  valid_581220 = validateParameter(valid_581220, JString, required = false,
                                 default = nil)
  if valid_581220 != nil:
    section.add "quotaUser", valid_581220
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_581221 = query.getOrDefault("requestId")
  valid_581221 = validateParameter(valid_581221, JString, required = true,
                                 default = nil)
  if valid_581221 != nil:
    section.add "requestId", valid_581221
  var valid_581222 = query.getOrDefault("fields")
  valid_581222 = validateParameter(valid_581222, JString, required = false,
                                 default = nil)
  if valid_581222 != nil:
    section.add "fields", valid_581222
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

proc call*(call_581224: Call_DriveTeamdrivesInsert_581212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.insert instead.
  ## 
  let valid = call_581224.validator(path, query, header, formData, body)
  let scheme = call_581224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581224.url(scheme.get, call_581224.host, call_581224.base,
                         call_581224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581224, url, valid)

proc call*(call_581225: Call_DriveTeamdrivesInsert_581212; requestId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveTeamdrivesInsert
  ## Deprecated use drives.insert instead.
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
  ##   requestId: string (required)
  ##            : An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a Team Drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same Team Drive. If the Team Drive already exists a 409 error will be returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_581226 = newJObject()
  var body_581227 = newJObject()
  add(query_581226, "key", newJString(key))
  add(query_581226, "prettyPrint", newJBool(prettyPrint))
  add(query_581226, "oauth_token", newJString(oauthToken))
  add(query_581226, "alt", newJString(alt))
  add(query_581226, "userIp", newJString(userIp))
  add(query_581226, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581227 = body
  add(query_581226, "requestId", newJString(requestId))
  add(query_581226, "fields", newJString(fields))
  result = call_581225.call(nil, query_581226, nil, nil, body_581227)

var driveTeamdrivesInsert* = Call_DriveTeamdrivesInsert_581212(
    name: "driveTeamdrivesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesInsert_581213, base: "/drive/v2",
    url: url_DriveTeamdrivesInsert_581214, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesList_581195 = ref object of OpenApiRestCall_579380
proc url_DriveTeamdrivesList_581197(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesList_581196(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deprecated use drives.list instead.
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
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then all Team Drives of the domain in which the requester is an administrator are returned.
  ##   q: JString
  ##    : Query string for searching Team Drives.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Page token for Team Drives.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of Team Drives to return.
  section = newJObject()
  var valid_581198 = query.getOrDefault("key")
  valid_581198 = validateParameter(valid_581198, JString, required = false,
                                 default = nil)
  if valid_581198 != nil:
    section.add "key", valid_581198
  var valid_581199 = query.getOrDefault("prettyPrint")
  valid_581199 = validateParameter(valid_581199, JBool, required = false,
                                 default = newJBool(true))
  if valid_581199 != nil:
    section.add "prettyPrint", valid_581199
  var valid_581200 = query.getOrDefault("oauth_token")
  valid_581200 = validateParameter(valid_581200, JString, required = false,
                                 default = nil)
  if valid_581200 != nil:
    section.add "oauth_token", valid_581200
  var valid_581201 = query.getOrDefault("useDomainAdminAccess")
  valid_581201 = validateParameter(valid_581201, JBool, required = false,
                                 default = newJBool(false))
  if valid_581201 != nil:
    section.add "useDomainAdminAccess", valid_581201
  var valid_581202 = query.getOrDefault("q")
  valid_581202 = validateParameter(valid_581202, JString, required = false,
                                 default = nil)
  if valid_581202 != nil:
    section.add "q", valid_581202
  var valid_581203 = query.getOrDefault("alt")
  valid_581203 = validateParameter(valid_581203, JString, required = false,
                                 default = newJString("json"))
  if valid_581203 != nil:
    section.add "alt", valid_581203
  var valid_581204 = query.getOrDefault("userIp")
  valid_581204 = validateParameter(valid_581204, JString, required = false,
                                 default = nil)
  if valid_581204 != nil:
    section.add "userIp", valid_581204
  var valid_581205 = query.getOrDefault("quotaUser")
  valid_581205 = validateParameter(valid_581205, JString, required = false,
                                 default = nil)
  if valid_581205 != nil:
    section.add "quotaUser", valid_581205
  var valid_581206 = query.getOrDefault("pageToken")
  valid_581206 = validateParameter(valid_581206, JString, required = false,
                                 default = nil)
  if valid_581206 != nil:
    section.add "pageToken", valid_581206
  var valid_581207 = query.getOrDefault("fields")
  valid_581207 = validateParameter(valid_581207, JString, required = false,
                                 default = nil)
  if valid_581207 != nil:
    section.add "fields", valid_581207
  var valid_581208 = query.getOrDefault("maxResults")
  valid_581208 = validateParameter(valid_581208, JInt, required = false,
                                 default = newJInt(10))
  if valid_581208 != nil:
    section.add "maxResults", valid_581208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581209: Call_DriveTeamdrivesList_581195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.list instead.
  ## 
  let valid = call_581209.validator(path, query, header, formData, body)
  let scheme = call_581209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581209.url(scheme.get, call_581209.host, call_581209.base,
                         call_581209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581209, url, valid)

proc call*(call_581210: Call_DriveTeamdrivesList_581195; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; q: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 10): Recallable =
  ## driveTeamdrivesList
  ## Deprecated use drives.list instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then all Team Drives of the domain in which the requester is an administrator are returned.
  ##   q: string
  ##    : Query string for searching Team Drives.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Page token for Team Drives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of Team Drives to return.
  var query_581211 = newJObject()
  add(query_581211, "key", newJString(key))
  add(query_581211, "prettyPrint", newJBool(prettyPrint))
  add(query_581211, "oauth_token", newJString(oauthToken))
  add(query_581211, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_581211, "q", newJString(q))
  add(query_581211, "alt", newJString(alt))
  add(query_581211, "userIp", newJString(userIp))
  add(query_581211, "quotaUser", newJString(quotaUser))
  add(query_581211, "pageToken", newJString(pageToken))
  add(query_581211, "fields", newJString(fields))
  add(query_581211, "maxResults", newJInt(maxResults))
  result = call_581210.call(nil, query_581211, nil, nil, nil)

var driveTeamdrivesList* = Call_DriveTeamdrivesList_581195(
    name: "driveTeamdrivesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesList_581196, base: "/drive/v2",
    url: url_DriveTeamdrivesList_581197, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesUpdate_581244 = ref object of OpenApiRestCall_579380
proc url_DriveTeamdrivesUpdate_581246(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveTeamdrivesUpdate_581245(path: JsonNode; query: JsonNode;
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
  var valid_581247 = path.getOrDefault("teamDriveId")
  valid_581247 = validateParameter(valid_581247, JString, required = true,
                                 default = nil)
  if valid_581247 != nil:
    section.add "teamDriveId", valid_581247
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581248 = query.getOrDefault("key")
  valid_581248 = validateParameter(valid_581248, JString, required = false,
                                 default = nil)
  if valid_581248 != nil:
    section.add "key", valid_581248
  var valid_581249 = query.getOrDefault("prettyPrint")
  valid_581249 = validateParameter(valid_581249, JBool, required = false,
                                 default = newJBool(true))
  if valid_581249 != nil:
    section.add "prettyPrint", valid_581249
  var valid_581250 = query.getOrDefault("oauth_token")
  valid_581250 = validateParameter(valid_581250, JString, required = false,
                                 default = nil)
  if valid_581250 != nil:
    section.add "oauth_token", valid_581250
  var valid_581251 = query.getOrDefault("useDomainAdminAccess")
  valid_581251 = validateParameter(valid_581251, JBool, required = false,
                                 default = newJBool(false))
  if valid_581251 != nil:
    section.add "useDomainAdminAccess", valid_581251
  var valid_581252 = query.getOrDefault("alt")
  valid_581252 = validateParameter(valid_581252, JString, required = false,
                                 default = newJString("json"))
  if valid_581252 != nil:
    section.add "alt", valid_581252
  var valid_581253 = query.getOrDefault("userIp")
  valid_581253 = validateParameter(valid_581253, JString, required = false,
                                 default = nil)
  if valid_581253 != nil:
    section.add "userIp", valid_581253
  var valid_581254 = query.getOrDefault("quotaUser")
  valid_581254 = validateParameter(valid_581254, JString, required = false,
                                 default = nil)
  if valid_581254 != nil:
    section.add "quotaUser", valid_581254
  var valid_581255 = query.getOrDefault("fields")
  valid_581255 = validateParameter(valid_581255, JString, required = false,
                                 default = nil)
  if valid_581255 != nil:
    section.add "fields", valid_581255
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

proc call*(call_581257: Call_DriveTeamdrivesUpdate_581244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.update instead.
  ## 
  let valid = call_581257.validator(path, query, header, formData, body)
  let scheme = call_581257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581257.url(scheme.get, call_581257.host, call_581257.base,
                         call_581257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581257, url, valid)

proc call*(call_581258: Call_DriveTeamdrivesUpdate_581244; teamDriveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveTeamdrivesUpdate
  ## Deprecated use drives.update instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581259 = newJObject()
  var query_581260 = newJObject()
  var body_581261 = newJObject()
  add(query_581260, "key", newJString(key))
  add(path_581259, "teamDriveId", newJString(teamDriveId))
  add(query_581260, "prettyPrint", newJBool(prettyPrint))
  add(query_581260, "oauth_token", newJString(oauthToken))
  add(query_581260, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_581260, "alt", newJString(alt))
  add(query_581260, "userIp", newJString(userIp))
  add(query_581260, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581261 = body
  add(query_581260, "fields", newJString(fields))
  result = call_581258.call(path_581259, query_581260, nil, nil, body_581261)

var driveTeamdrivesUpdate* = Call_DriveTeamdrivesUpdate_581244(
    name: "driveTeamdrivesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesUpdate_581245, base: "/drive/v2",
    url: url_DriveTeamdrivesUpdate_581246, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesGet_581228 = ref object of OpenApiRestCall_579380
proc url_DriveTeamdrivesGet_581230(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveTeamdrivesGet_581229(path: JsonNode; query: JsonNode;
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
  var valid_581231 = path.getOrDefault("teamDriveId")
  valid_581231 = validateParameter(valid_581231, JString, required = true,
                                 default = nil)
  if valid_581231 != nil:
    section.add "teamDriveId", valid_581231
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: JBool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581232 = query.getOrDefault("key")
  valid_581232 = validateParameter(valid_581232, JString, required = false,
                                 default = nil)
  if valid_581232 != nil:
    section.add "key", valid_581232
  var valid_581233 = query.getOrDefault("prettyPrint")
  valid_581233 = validateParameter(valid_581233, JBool, required = false,
                                 default = newJBool(true))
  if valid_581233 != nil:
    section.add "prettyPrint", valid_581233
  var valid_581234 = query.getOrDefault("oauth_token")
  valid_581234 = validateParameter(valid_581234, JString, required = false,
                                 default = nil)
  if valid_581234 != nil:
    section.add "oauth_token", valid_581234
  var valid_581235 = query.getOrDefault("useDomainAdminAccess")
  valid_581235 = validateParameter(valid_581235, JBool, required = false,
                                 default = newJBool(false))
  if valid_581235 != nil:
    section.add "useDomainAdminAccess", valid_581235
  var valid_581236 = query.getOrDefault("alt")
  valid_581236 = validateParameter(valid_581236, JString, required = false,
                                 default = newJString("json"))
  if valid_581236 != nil:
    section.add "alt", valid_581236
  var valid_581237 = query.getOrDefault("userIp")
  valid_581237 = validateParameter(valid_581237, JString, required = false,
                                 default = nil)
  if valid_581237 != nil:
    section.add "userIp", valid_581237
  var valid_581238 = query.getOrDefault("quotaUser")
  valid_581238 = validateParameter(valid_581238, JString, required = false,
                                 default = nil)
  if valid_581238 != nil:
    section.add "quotaUser", valid_581238
  var valid_581239 = query.getOrDefault("fields")
  valid_581239 = validateParameter(valid_581239, JString, required = false,
                                 default = nil)
  if valid_581239 != nil:
    section.add "fields", valid_581239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581240: Call_DriveTeamdrivesGet_581228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.get instead.
  ## 
  let valid = call_581240.validator(path, query, header, formData, body)
  let scheme = call_581240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581240.url(scheme.get, call_581240.host, call_581240.base,
                         call_581240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581240, url, valid)

proc call*(call_581241: Call_DriveTeamdrivesGet_581228; teamDriveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          useDomainAdminAccess: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## driveTeamdrivesGet
  ## Deprecated use drives.get instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   useDomainAdminAccess: bool
  ##                       : Issue the request as a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the Team Drive belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581242 = newJObject()
  var query_581243 = newJObject()
  add(query_581243, "key", newJString(key))
  add(path_581242, "teamDriveId", newJString(teamDriveId))
  add(query_581243, "prettyPrint", newJBool(prettyPrint))
  add(query_581243, "oauth_token", newJString(oauthToken))
  add(query_581243, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_581243, "alt", newJString(alt))
  add(query_581243, "userIp", newJString(userIp))
  add(query_581243, "quotaUser", newJString(quotaUser))
  add(query_581243, "fields", newJString(fields))
  result = call_581241.call(path_581242, query_581243, nil, nil, nil)

var driveTeamdrivesGet* = Call_DriveTeamdrivesGet_581228(
    name: "driveTeamdrivesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesGet_581229, base: "/drive/v2",
    url: url_DriveTeamdrivesGet_581230, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesDelete_581262 = ref object of OpenApiRestCall_579380
proc url_DriveTeamdrivesDelete_581264(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DriveTeamdrivesDelete_581263(path: JsonNode; query: JsonNode;
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
  var valid_581265 = path.getOrDefault("teamDriveId")
  valid_581265 = validateParameter(valid_581265, JString, required = true,
                                 default = nil)
  if valid_581265 != nil:
    section.add "teamDriveId", valid_581265
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
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
  var valid_581266 = query.getOrDefault("key")
  valid_581266 = validateParameter(valid_581266, JString, required = false,
                                 default = nil)
  if valid_581266 != nil:
    section.add "key", valid_581266
  var valid_581267 = query.getOrDefault("prettyPrint")
  valid_581267 = validateParameter(valid_581267, JBool, required = false,
                                 default = newJBool(true))
  if valid_581267 != nil:
    section.add "prettyPrint", valid_581267
  var valid_581268 = query.getOrDefault("oauth_token")
  valid_581268 = validateParameter(valid_581268, JString, required = false,
                                 default = nil)
  if valid_581268 != nil:
    section.add "oauth_token", valid_581268
  var valid_581269 = query.getOrDefault("alt")
  valid_581269 = validateParameter(valid_581269, JString, required = false,
                                 default = newJString("json"))
  if valid_581269 != nil:
    section.add "alt", valid_581269
  var valid_581270 = query.getOrDefault("userIp")
  valid_581270 = validateParameter(valid_581270, JString, required = false,
                                 default = nil)
  if valid_581270 != nil:
    section.add "userIp", valid_581270
  var valid_581271 = query.getOrDefault("quotaUser")
  valid_581271 = validateParameter(valid_581271, JString, required = false,
                                 default = nil)
  if valid_581271 != nil:
    section.add "quotaUser", valid_581271
  var valid_581272 = query.getOrDefault("fields")
  valid_581272 = validateParameter(valid_581272, JString, required = false,
                                 default = nil)
  if valid_581272 != nil:
    section.add "fields", valid_581272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581273: Call_DriveTeamdrivesDelete_581262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.delete instead.
  ## 
  let valid = call_581273.validator(path, query, header, formData, body)
  let scheme = call_581273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581273.url(scheme.get, call_581273.host, call_581273.base,
                         call_581273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581273, url, valid)

proc call*(call_581274: Call_DriveTeamdrivesDelete_581262; teamDriveId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## driveTeamdrivesDelete
  ## Deprecated use drives.delete instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   teamDriveId: string (required)
  ##              : The ID of the Team Drive
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
  var path_581275 = newJObject()
  var query_581276 = newJObject()
  add(query_581276, "key", newJString(key))
  add(path_581275, "teamDriveId", newJString(teamDriveId))
  add(query_581276, "prettyPrint", newJBool(prettyPrint))
  add(query_581276, "oauth_token", newJString(oauthToken))
  add(query_581276, "alt", newJString(alt))
  add(query_581276, "userIp", newJString(userIp))
  add(query_581276, "quotaUser", newJString(quotaUser))
  add(query_581276, "fields", newJString(fields))
  result = call_581274.call(path_581275, query_581276, nil, nil, nil)

var driveTeamdrivesDelete* = Call_DriveTeamdrivesDelete_581262(
    name: "driveTeamdrivesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesDelete_581263, base: "/drive/v2",
    url: url_DriveTeamdrivesDelete_581264, schemes: {Scheme.Https})
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
