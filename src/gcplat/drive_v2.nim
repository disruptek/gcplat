
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
  Call_DriveAboutGet_578625 = ref object of OpenApiRestCall_578355
proc url_DriveAboutGet_578627(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveAboutGet_578626(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("alt")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("json"))
  if valid_578755 != nil:
    section.add "alt", valid_578755
  var valid_578756 = query.getOrDefault("userIp")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "userIp", valid_578756
  var valid_578757 = query.getOrDefault("quotaUser")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "quotaUser", valid_578757
  var valid_578758 = query.getOrDefault("maxChangeIdCount")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = newJString("1"))
  if valid_578758 != nil:
    section.add "maxChangeIdCount", valid_578758
  var valid_578759 = query.getOrDefault("includeSubscribed")
  valid_578759 = validateParameter(valid_578759, JBool, required = false,
                                 default = newJBool(true))
  if valid_578759 != nil:
    section.add "includeSubscribed", valid_578759
  var valid_578760 = query.getOrDefault("startChangeId")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "startChangeId", valid_578760
  var valid_578761 = query.getOrDefault("fields")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "fields", valid_578761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578784: Call_DriveAboutGet_578625; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the current user along with Drive API settings
  ## 
  let valid = call_578784.validator(path, query, header, formData, body)
  let scheme = call_578784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578784.url(scheme.get, call_578784.host, call_578784.base,
                         call_578784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578784, url, valid)

proc call*(call_578855: Call_DriveAboutGet_578625; key: string = "";
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
  var query_578856 = newJObject()
  add(query_578856, "key", newJString(key))
  add(query_578856, "prettyPrint", newJBool(prettyPrint))
  add(query_578856, "oauth_token", newJString(oauthToken))
  add(query_578856, "alt", newJString(alt))
  add(query_578856, "userIp", newJString(userIp))
  add(query_578856, "quotaUser", newJString(quotaUser))
  add(query_578856, "maxChangeIdCount", newJString(maxChangeIdCount))
  add(query_578856, "includeSubscribed", newJBool(includeSubscribed))
  add(query_578856, "startChangeId", newJString(startChangeId))
  add(query_578856, "fields", newJString(fields))
  result = call_578855.call(nil, query_578856, nil, nil, nil)

var driveAboutGet* = Call_DriveAboutGet_578625(name: "driveAboutGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/about",
    validator: validate_DriveAboutGet_578626, base: "/drive/v2",
    url: url_DriveAboutGet_578627, schemes: {Scheme.Https})
type
  Call_DriveAppsList_578896 = ref object of OpenApiRestCall_578355
proc url_DriveAppsList_578898(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveAppsList_578897(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_578899 = query.getOrDefault("key")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "key", valid_578899
  var valid_578900 = query.getOrDefault("prettyPrint")
  valid_578900 = validateParameter(valid_578900, JBool, required = false,
                                 default = newJBool(true))
  if valid_578900 != nil:
    section.add "prettyPrint", valid_578900
  var valid_578901 = query.getOrDefault("oauth_token")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "oauth_token", valid_578901
  var valid_578902 = query.getOrDefault("appFilterExtensions")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = newJString(""))
  if valid_578902 != nil:
    section.add "appFilterExtensions", valid_578902
  var valid_578903 = query.getOrDefault("alt")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = newJString("json"))
  if valid_578903 != nil:
    section.add "alt", valid_578903
  var valid_578904 = query.getOrDefault("userIp")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "userIp", valid_578904
  var valid_578905 = query.getOrDefault("quotaUser")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "quotaUser", valid_578905
  var valid_578906 = query.getOrDefault("appFilterMimeTypes")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString(""))
  if valid_578906 != nil:
    section.add "appFilterMimeTypes", valid_578906
  var valid_578907 = query.getOrDefault("languageCode")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "languageCode", valid_578907
  var valid_578908 = query.getOrDefault("fields")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "fields", valid_578908
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578909: Call_DriveAppsList_578896; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a user's installed apps.
  ## 
  let valid = call_578909.validator(path, query, header, formData, body)
  let scheme = call_578909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578909.url(scheme.get, call_578909.host, call_578909.base,
                         call_578909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578909, url, valid)

proc call*(call_578910: Call_DriveAppsList_578896; key: string = "";
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
  var query_578911 = newJObject()
  add(query_578911, "key", newJString(key))
  add(query_578911, "prettyPrint", newJBool(prettyPrint))
  add(query_578911, "oauth_token", newJString(oauthToken))
  add(query_578911, "appFilterExtensions", newJString(appFilterExtensions))
  add(query_578911, "alt", newJString(alt))
  add(query_578911, "userIp", newJString(userIp))
  add(query_578911, "quotaUser", newJString(quotaUser))
  add(query_578911, "appFilterMimeTypes", newJString(appFilterMimeTypes))
  add(query_578911, "languageCode", newJString(languageCode))
  add(query_578911, "fields", newJString(fields))
  result = call_578910.call(nil, query_578911, nil, nil, nil)

var driveAppsList* = Call_DriveAppsList_578896(name: "driveAppsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/apps",
    validator: validate_DriveAppsList_578897, base: "/drive/v2",
    url: url_DriveAppsList_578898, schemes: {Scheme.Https})
type
  Call_DriveAppsGet_578912 = ref object of OpenApiRestCall_578355
proc url_DriveAppsGet_578914(protocol: Scheme; host: string; base: string;
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

proc validate_DriveAppsGet_578913(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_578929 = path.getOrDefault("appId")
  valid_578929 = validateParameter(valid_578929, JString, required = true,
                                 default = nil)
  if valid_578929 != nil:
    section.add "appId", valid_578929
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
  var valid_578930 = query.getOrDefault("key")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "key", valid_578930
  var valid_578931 = query.getOrDefault("prettyPrint")
  valid_578931 = validateParameter(valid_578931, JBool, required = false,
                                 default = newJBool(true))
  if valid_578931 != nil:
    section.add "prettyPrint", valid_578931
  var valid_578932 = query.getOrDefault("oauth_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "oauth_token", valid_578932
  var valid_578933 = query.getOrDefault("alt")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("json"))
  if valid_578933 != nil:
    section.add "alt", valid_578933
  var valid_578934 = query.getOrDefault("userIp")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "userIp", valid_578934
  var valid_578935 = query.getOrDefault("quotaUser")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "quotaUser", valid_578935
  var valid_578936 = query.getOrDefault("fields")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "fields", valid_578936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578937: Call_DriveAppsGet_578912; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific app.
  ## 
  let valid = call_578937.validator(path, query, header, formData, body)
  let scheme = call_578937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578937.url(scheme.get, call_578937.host, call_578937.base,
                         call_578937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578937, url, valid)

proc call*(call_578938: Call_DriveAppsGet_578912; appId: string; key: string = "";
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
  var path_578939 = newJObject()
  var query_578940 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "userIp", newJString(userIp))
  add(query_578940, "quotaUser", newJString(quotaUser))
  add(path_578939, "appId", newJString(appId))
  add(query_578940, "fields", newJString(fields))
  result = call_578938.call(path_578939, query_578940, nil, nil, nil)

var driveAppsGet* = Call_DriveAppsGet_578912(name: "driveAppsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/apps/{appId}",
    validator: validate_DriveAppsGet_578913, base: "/drive/v2",
    url: url_DriveAppsGet_578914, schemes: {Scheme.Https})
type
  Call_DriveChangesList_578941 = ref object of OpenApiRestCall_578355
proc url_DriveChangesList_578943(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesList_578942(path: JsonNode; query: JsonNode;
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
  var valid_578944 = query.getOrDefault("key")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "key", valid_578944
  var valid_578945 = query.getOrDefault("prettyPrint")
  valid_578945 = validateParameter(valid_578945, JBool, required = false,
                                 default = newJBool(true))
  if valid_578945 != nil:
    section.add "prettyPrint", valid_578945
  var valid_578946 = query.getOrDefault("oauth_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "oauth_token", valid_578946
  var valid_578947 = query.getOrDefault("driveId")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "driveId", valid_578947
  var valid_578948 = query.getOrDefault("includeItemsFromAllDrives")
  valid_578948 = validateParameter(valid_578948, JBool, required = false,
                                 default = newJBool(false))
  if valid_578948 != nil:
    section.add "includeItemsFromAllDrives", valid_578948
  var valid_578949 = query.getOrDefault("spaces")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "spaces", valid_578949
  var valid_578950 = query.getOrDefault("alt")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = newJString("json"))
  if valid_578950 != nil:
    section.add "alt", valid_578950
  var valid_578951 = query.getOrDefault("userIp")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "userIp", valid_578951
  var valid_578952 = query.getOrDefault("quotaUser")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "quotaUser", valid_578952
  var valid_578953 = query.getOrDefault("includeCorpusRemovals")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(false))
  if valid_578953 != nil:
    section.add "includeCorpusRemovals", valid_578953
  var valid_578954 = query.getOrDefault("pageToken")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "pageToken", valid_578954
  var valid_578955 = query.getOrDefault("supportsTeamDrives")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(false))
  if valid_578955 != nil:
    section.add "supportsTeamDrives", valid_578955
  var valid_578956 = query.getOrDefault("includeDeleted")
  valid_578956 = validateParameter(valid_578956, JBool, required = false,
                                 default = newJBool(true))
  if valid_578956 != nil:
    section.add "includeDeleted", valid_578956
  var valid_578957 = query.getOrDefault("supportsAllDrives")
  valid_578957 = validateParameter(valid_578957, JBool, required = false,
                                 default = newJBool(false))
  if valid_578957 != nil:
    section.add "supportsAllDrives", valid_578957
  var valid_578958 = query.getOrDefault("includeSubscribed")
  valid_578958 = validateParameter(valid_578958, JBool, required = false,
                                 default = newJBool(true))
  if valid_578958 != nil:
    section.add "includeSubscribed", valid_578958
  var valid_578959 = query.getOrDefault("includeTeamDriveItems")
  valid_578959 = validateParameter(valid_578959, JBool, required = false,
                                 default = newJBool(false))
  if valid_578959 != nil:
    section.add "includeTeamDriveItems", valid_578959
  var valid_578960 = query.getOrDefault("startChangeId")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "startChangeId", valid_578960
  var valid_578961 = query.getOrDefault("fields")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "fields", valid_578961
  var valid_578963 = query.getOrDefault("maxResults")
  valid_578963 = validateParameter(valid_578963, JInt, required = false,
                                 default = newJInt(100))
  if valid_578963 != nil:
    section.add "maxResults", valid_578963
  var valid_578964 = query.getOrDefault("teamDriveId")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "teamDriveId", valid_578964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578965: Call_DriveChangesList_578941; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the changes for a user or shared drive.
  ## 
  let valid = call_578965.validator(path, query, header, formData, body)
  let scheme = call_578965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578965.url(scheme.get, call_578965.host, call_578965.base,
                         call_578965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578965, url, valid)

proc call*(call_578966: Call_DriveChangesList_578941; key: string = "";
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
  var query_578967 = newJObject()
  add(query_578967, "key", newJString(key))
  add(query_578967, "prettyPrint", newJBool(prettyPrint))
  add(query_578967, "oauth_token", newJString(oauthToken))
  add(query_578967, "driveId", newJString(driveId))
  add(query_578967, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_578967, "spaces", newJString(spaces))
  add(query_578967, "alt", newJString(alt))
  add(query_578967, "userIp", newJString(userIp))
  add(query_578967, "quotaUser", newJString(quotaUser))
  add(query_578967, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  add(query_578967, "pageToken", newJString(pageToken))
  add(query_578967, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_578967, "includeDeleted", newJBool(includeDeleted))
  add(query_578967, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_578967, "includeSubscribed", newJBool(includeSubscribed))
  add(query_578967, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_578967, "startChangeId", newJString(startChangeId))
  add(query_578967, "fields", newJString(fields))
  add(query_578967, "maxResults", newJInt(maxResults))
  add(query_578967, "teamDriveId", newJString(teamDriveId))
  result = call_578966.call(nil, query_578967, nil, nil, nil)

var driveChangesList* = Call_DriveChangesList_578941(name: "driveChangesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/changes",
    validator: validate_DriveChangesList_578942, base: "/drive/v2",
    url: url_DriveChangesList_578943, schemes: {Scheme.Https})
type
  Call_DriveChangesGetStartPageToken_578968 = ref object of OpenApiRestCall_578355
proc url_DriveChangesGetStartPageToken_578970(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesGetStartPageToken_578969(path: JsonNode; query: JsonNode;
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
  var valid_578971 = query.getOrDefault("key")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "key", valid_578971
  var valid_578972 = query.getOrDefault("prettyPrint")
  valid_578972 = validateParameter(valid_578972, JBool, required = false,
                                 default = newJBool(true))
  if valid_578972 != nil:
    section.add "prettyPrint", valid_578972
  var valid_578973 = query.getOrDefault("oauth_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "oauth_token", valid_578973
  var valid_578974 = query.getOrDefault("driveId")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "driveId", valid_578974
  var valid_578975 = query.getOrDefault("alt")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = newJString("json"))
  if valid_578975 != nil:
    section.add "alt", valid_578975
  var valid_578976 = query.getOrDefault("userIp")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "userIp", valid_578976
  var valid_578977 = query.getOrDefault("quotaUser")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "quotaUser", valid_578977
  var valid_578978 = query.getOrDefault("supportsTeamDrives")
  valid_578978 = validateParameter(valid_578978, JBool, required = false,
                                 default = newJBool(false))
  if valid_578978 != nil:
    section.add "supportsTeamDrives", valid_578978
  var valid_578979 = query.getOrDefault("supportsAllDrives")
  valid_578979 = validateParameter(valid_578979, JBool, required = false,
                                 default = newJBool(false))
  if valid_578979 != nil:
    section.add "supportsAllDrives", valid_578979
  var valid_578980 = query.getOrDefault("fields")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "fields", valid_578980
  var valid_578981 = query.getOrDefault("teamDriveId")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "teamDriveId", valid_578981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578982: Call_DriveChangesGetStartPageToken_578968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the starting pageToken for listing future changes.
  ## 
  let valid = call_578982.validator(path, query, header, formData, body)
  let scheme = call_578982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578982.url(scheme.get, call_578982.host, call_578982.base,
                         call_578982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578982, url, valid)

proc call*(call_578983: Call_DriveChangesGetStartPageToken_578968;
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
  var query_578984 = newJObject()
  add(query_578984, "key", newJString(key))
  add(query_578984, "prettyPrint", newJBool(prettyPrint))
  add(query_578984, "oauth_token", newJString(oauthToken))
  add(query_578984, "driveId", newJString(driveId))
  add(query_578984, "alt", newJString(alt))
  add(query_578984, "userIp", newJString(userIp))
  add(query_578984, "quotaUser", newJString(quotaUser))
  add(query_578984, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_578984, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_578984, "fields", newJString(fields))
  add(query_578984, "teamDriveId", newJString(teamDriveId))
  result = call_578983.call(nil, query_578984, nil, nil, nil)

var driveChangesGetStartPageToken* = Call_DriveChangesGetStartPageToken_578968(
    name: "driveChangesGetStartPageToken", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/changes/startPageToken",
    validator: validate_DriveChangesGetStartPageToken_578969, base: "/drive/v2",
    url: url_DriveChangesGetStartPageToken_578970, schemes: {Scheme.Https})
type
  Call_DriveChangesWatch_578985 = ref object of OpenApiRestCall_578355
proc url_DriveChangesWatch_578987(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChangesWatch_578986(path: JsonNode; query: JsonNode;
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
  var valid_578988 = query.getOrDefault("key")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "key", valid_578988
  var valid_578989 = query.getOrDefault("prettyPrint")
  valid_578989 = validateParameter(valid_578989, JBool, required = false,
                                 default = newJBool(true))
  if valid_578989 != nil:
    section.add "prettyPrint", valid_578989
  var valid_578990 = query.getOrDefault("oauth_token")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "oauth_token", valid_578990
  var valid_578991 = query.getOrDefault("driveId")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "driveId", valid_578991
  var valid_578992 = query.getOrDefault("includeItemsFromAllDrives")
  valid_578992 = validateParameter(valid_578992, JBool, required = false,
                                 default = newJBool(false))
  if valid_578992 != nil:
    section.add "includeItemsFromAllDrives", valid_578992
  var valid_578993 = query.getOrDefault("spaces")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "spaces", valid_578993
  var valid_578994 = query.getOrDefault("alt")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = newJString("json"))
  if valid_578994 != nil:
    section.add "alt", valid_578994
  var valid_578995 = query.getOrDefault("userIp")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "userIp", valid_578995
  var valid_578996 = query.getOrDefault("quotaUser")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "quotaUser", valid_578996
  var valid_578997 = query.getOrDefault("includeCorpusRemovals")
  valid_578997 = validateParameter(valid_578997, JBool, required = false,
                                 default = newJBool(false))
  if valid_578997 != nil:
    section.add "includeCorpusRemovals", valid_578997
  var valid_578998 = query.getOrDefault("pageToken")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "pageToken", valid_578998
  var valid_578999 = query.getOrDefault("supportsTeamDrives")
  valid_578999 = validateParameter(valid_578999, JBool, required = false,
                                 default = newJBool(false))
  if valid_578999 != nil:
    section.add "supportsTeamDrives", valid_578999
  var valid_579000 = query.getOrDefault("includeDeleted")
  valid_579000 = validateParameter(valid_579000, JBool, required = false,
                                 default = newJBool(true))
  if valid_579000 != nil:
    section.add "includeDeleted", valid_579000
  var valid_579001 = query.getOrDefault("supportsAllDrives")
  valid_579001 = validateParameter(valid_579001, JBool, required = false,
                                 default = newJBool(false))
  if valid_579001 != nil:
    section.add "supportsAllDrives", valid_579001
  var valid_579002 = query.getOrDefault("includeSubscribed")
  valid_579002 = validateParameter(valid_579002, JBool, required = false,
                                 default = newJBool(true))
  if valid_579002 != nil:
    section.add "includeSubscribed", valid_579002
  var valid_579003 = query.getOrDefault("includeTeamDriveItems")
  valid_579003 = validateParameter(valid_579003, JBool, required = false,
                                 default = newJBool(false))
  if valid_579003 != nil:
    section.add "includeTeamDriveItems", valid_579003
  var valid_579004 = query.getOrDefault("startChangeId")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "startChangeId", valid_579004
  var valid_579005 = query.getOrDefault("fields")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "fields", valid_579005
  var valid_579006 = query.getOrDefault("maxResults")
  valid_579006 = validateParameter(valid_579006, JInt, required = false,
                                 default = newJInt(100))
  if valid_579006 != nil:
    section.add "maxResults", valid_579006
  var valid_579007 = query.getOrDefault("teamDriveId")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "teamDriveId", valid_579007
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

proc call*(call_579009: Call_DriveChangesWatch_578985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe to changes for a user.
  ## 
  let valid = call_579009.validator(path, query, header, formData, body)
  let scheme = call_579009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579009.url(scheme.get, call_579009.host, call_579009.base,
                         call_579009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579009, url, valid)

proc call*(call_579010: Call_DriveChangesWatch_578985; key: string = "";
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
  var query_579011 = newJObject()
  var body_579012 = newJObject()
  add(query_579011, "key", newJString(key))
  add(query_579011, "prettyPrint", newJBool(prettyPrint))
  add(query_579011, "oauth_token", newJString(oauthToken))
  add(query_579011, "driveId", newJString(driveId))
  add(query_579011, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_579011, "spaces", newJString(spaces))
  add(query_579011, "alt", newJString(alt))
  add(query_579011, "userIp", newJString(userIp))
  add(query_579011, "quotaUser", newJString(quotaUser))
  add(query_579011, "includeCorpusRemovals", newJBool(includeCorpusRemovals))
  add(query_579011, "pageToken", newJString(pageToken))
  add(query_579011, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579011, "includeDeleted", newJBool(includeDeleted))
  add(query_579011, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579011, "includeSubscribed", newJBool(includeSubscribed))
  add(query_579011, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  if resource != nil:
    body_579012 = resource
  add(query_579011, "startChangeId", newJString(startChangeId))
  add(query_579011, "fields", newJString(fields))
  add(query_579011, "maxResults", newJInt(maxResults))
  add(query_579011, "teamDriveId", newJString(teamDriveId))
  result = call_579010.call(nil, query_579011, nil, nil, body_579012)

var driveChangesWatch* = Call_DriveChangesWatch_578985(name: "driveChangesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/changes/watch",
    validator: validate_DriveChangesWatch_578986, base: "/drive/v2",
    url: url_DriveChangesWatch_578987, schemes: {Scheme.Https})
type
  Call_DriveChangesGet_579013 = ref object of OpenApiRestCall_578355
proc url_DriveChangesGet_579015(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChangesGet_579014(path: JsonNode; query: JsonNode;
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
  var valid_579016 = path.getOrDefault("changeId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "changeId", valid_579016
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
  var valid_579017 = query.getOrDefault("key")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "key", valid_579017
  var valid_579018 = query.getOrDefault("prettyPrint")
  valid_579018 = validateParameter(valid_579018, JBool, required = false,
                                 default = newJBool(true))
  if valid_579018 != nil:
    section.add "prettyPrint", valid_579018
  var valid_579019 = query.getOrDefault("oauth_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "oauth_token", valid_579019
  var valid_579020 = query.getOrDefault("driveId")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "driveId", valid_579020
  var valid_579021 = query.getOrDefault("alt")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("json"))
  if valid_579021 != nil:
    section.add "alt", valid_579021
  var valid_579022 = query.getOrDefault("userIp")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "userIp", valid_579022
  var valid_579023 = query.getOrDefault("quotaUser")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "quotaUser", valid_579023
  var valid_579024 = query.getOrDefault("supportsTeamDrives")
  valid_579024 = validateParameter(valid_579024, JBool, required = false,
                                 default = newJBool(false))
  if valid_579024 != nil:
    section.add "supportsTeamDrives", valid_579024
  var valid_579025 = query.getOrDefault("supportsAllDrives")
  valid_579025 = validateParameter(valid_579025, JBool, required = false,
                                 default = newJBool(false))
  if valid_579025 != nil:
    section.add "supportsAllDrives", valid_579025
  var valid_579026 = query.getOrDefault("fields")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "fields", valid_579026
  var valid_579027 = query.getOrDefault("teamDriveId")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "teamDriveId", valid_579027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579028: Call_DriveChangesGet_579013; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated - Use changes.getStartPageToken and changes.list to retrieve recent changes.
  ## 
  let valid = call_579028.validator(path, query, header, formData, body)
  let scheme = call_579028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579028.url(scheme.get, call_579028.host, call_579028.base,
                         call_579028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579028, url, valid)

proc call*(call_579029: Call_DriveChangesGet_579013; changeId: string;
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
  var path_579030 = newJObject()
  var query_579031 = newJObject()
  add(query_579031, "key", newJString(key))
  add(query_579031, "prettyPrint", newJBool(prettyPrint))
  add(query_579031, "oauth_token", newJString(oauthToken))
  add(query_579031, "driveId", newJString(driveId))
  add(query_579031, "alt", newJString(alt))
  add(query_579031, "userIp", newJString(userIp))
  add(query_579031, "quotaUser", newJString(quotaUser))
  add(query_579031, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579031, "supportsAllDrives", newJBool(supportsAllDrives))
  add(path_579030, "changeId", newJString(changeId))
  add(query_579031, "fields", newJString(fields))
  add(query_579031, "teamDriveId", newJString(teamDriveId))
  result = call_579029.call(path_579030, query_579031, nil, nil, nil)

var driveChangesGet* = Call_DriveChangesGet_579013(name: "driveChangesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/changes/{changeId}", validator: validate_DriveChangesGet_579014,
    base: "/drive/v2", url: url_DriveChangesGet_579015, schemes: {Scheme.Https})
type
  Call_DriveChannelsStop_579032 = ref object of OpenApiRestCall_578355
proc url_DriveChannelsStop_579034(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveChannelsStop_579033(path: JsonNode; query: JsonNode;
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
  var valid_579035 = query.getOrDefault("key")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "key", valid_579035
  var valid_579036 = query.getOrDefault("prettyPrint")
  valid_579036 = validateParameter(valid_579036, JBool, required = false,
                                 default = newJBool(true))
  if valid_579036 != nil:
    section.add "prettyPrint", valid_579036
  var valid_579037 = query.getOrDefault("oauth_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "oauth_token", valid_579037
  var valid_579038 = query.getOrDefault("alt")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("json"))
  if valid_579038 != nil:
    section.add "alt", valid_579038
  var valid_579039 = query.getOrDefault("userIp")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "userIp", valid_579039
  var valid_579040 = query.getOrDefault("quotaUser")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "quotaUser", valid_579040
  var valid_579041 = query.getOrDefault("fields")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "fields", valid_579041
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

proc call*(call_579043: Call_DriveChannelsStop_579032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_579043.validator(path, query, header, formData, body)
  let scheme = call_579043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579043.url(scheme.get, call_579043.host, call_579043.base,
                         call_579043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579043, url, valid)

proc call*(call_579044: Call_DriveChannelsStop_579032; key: string = "";
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
  var query_579045 = newJObject()
  var body_579046 = newJObject()
  add(query_579045, "key", newJString(key))
  add(query_579045, "prettyPrint", newJBool(prettyPrint))
  add(query_579045, "oauth_token", newJString(oauthToken))
  add(query_579045, "alt", newJString(alt))
  add(query_579045, "userIp", newJString(userIp))
  add(query_579045, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_579046 = resource
  add(query_579045, "fields", newJString(fields))
  result = call_579044.call(nil, query_579045, nil, nil, body_579046)

var driveChannelsStop* = Call_DriveChannelsStop_579032(name: "driveChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_DriveChannelsStop_579033, base: "/drive/v2",
    url: url_DriveChannelsStop_579034, schemes: {Scheme.Https})
type
  Call_DriveDrivesInsert_579064 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesInsert_579066(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesInsert_579065(path: JsonNode; query: JsonNode;
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
  var valid_579067 = query.getOrDefault("key")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "key", valid_579067
  var valid_579068 = query.getOrDefault("prettyPrint")
  valid_579068 = validateParameter(valid_579068, JBool, required = false,
                                 default = newJBool(true))
  if valid_579068 != nil:
    section.add "prettyPrint", valid_579068
  var valid_579069 = query.getOrDefault("oauth_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "oauth_token", valid_579069
  var valid_579070 = query.getOrDefault("alt")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("json"))
  if valid_579070 != nil:
    section.add "alt", valid_579070
  var valid_579071 = query.getOrDefault("userIp")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "userIp", valid_579071
  var valid_579072 = query.getOrDefault("quotaUser")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "quotaUser", valid_579072
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_579073 = query.getOrDefault("requestId")
  valid_579073 = validateParameter(valid_579073, JString, required = true,
                                 default = nil)
  if valid_579073 != nil:
    section.add "requestId", valid_579073
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

proc call*(call_579076: Call_DriveDrivesInsert_579064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new shared drive.
  ## 
  let valid = call_579076.validator(path, query, header, formData, body)
  let scheme = call_579076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579076.url(scheme.get, call_579076.host, call_579076.base,
                         call_579076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579076, url, valid)

proc call*(call_579077: Call_DriveDrivesInsert_579064; requestId: string;
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
  add(query_579078, "requestId", newJString(requestId))
  add(query_579078, "fields", newJString(fields))
  result = call_579077.call(nil, query_579078, nil, nil, body_579079)

var driveDrivesInsert* = Call_DriveDrivesInsert_579064(name: "driveDrivesInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesInsert_579065, base: "/drive/v2",
    url: url_DriveDrivesInsert_579066, schemes: {Scheme.Https})
type
  Call_DriveDrivesList_579047 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesList_579049(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveDrivesList_579048(path: JsonNode; query: JsonNode;
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
  var valid_579050 = query.getOrDefault("key")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "key", valid_579050
  var valid_579051 = query.getOrDefault("prettyPrint")
  valid_579051 = validateParameter(valid_579051, JBool, required = false,
                                 default = newJBool(true))
  if valid_579051 != nil:
    section.add "prettyPrint", valid_579051
  var valid_579052 = query.getOrDefault("oauth_token")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "oauth_token", valid_579052
  var valid_579053 = query.getOrDefault("useDomainAdminAccess")
  valid_579053 = validateParameter(valid_579053, JBool, required = false,
                                 default = newJBool(false))
  if valid_579053 != nil:
    section.add "useDomainAdminAccess", valid_579053
  var valid_579054 = query.getOrDefault("q")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "q", valid_579054
  var valid_579055 = query.getOrDefault("alt")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = newJString("json"))
  if valid_579055 != nil:
    section.add "alt", valid_579055
  var valid_579056 = query.getOrDefault("userIp")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "userIp", valid_579056
  var valid_579057 = query.getOrDefault("quotaUser")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "quotaUser", valid_579057
  var valid_579058 = query.getOrDefault("pageToken")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "pageToken", valid_579058
  var valid_579059 = query.getOrDefault("fields")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "fields", valid_579059
  var valid_579060 = query.getOrDefault("maxResults")
  valid_579060 = validateParameter(valid_579060, JInt, required = false,
                                 default = newJInt(10))
  if valid_579060 != nil:
    section.add "maxResults", valid_579060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579061: Call_DriveDrivesList_579047; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's shared drives.
  ## 
  let valid = call_579061.validator(path, query, header, formData, body)
  let scheme = call_579061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579061.url(scheme.get, call_579061.host, call_579061.base,
                         call_579061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579061, url, valid)

proc call*(call_579062: Call_DriveDrivesList_579047; key: string = "";
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
  var query_579063 = newJObject()
  add(query_579063, "key", newJString(key))
  add(query_579063, "prettyPrint", newJBool(prettyPrint))
  add(query_579063, "oauth_token", newJString(oauthToken))
  add(query_579063, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579063, "q", newJString(q))
  add(query_579063, "alt", newJString(alt))
  add(query_579063, "userIp", newJString(userIp))
  add(query_579063, "quotaUser", newJString(quotaUser))
  add(query_579063, "pageToken", newJString(pageToken))
  add(query_579063, "fields", newJString(fields))
  add(query_579063, "maxResults", newJInt(maxResults))
  result = call_579062.call(nil, query_579063, nil, nil, nil)

var driveDrivesList* = Call_DriveDrivesList_579047(name: "driveDrivesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/drives",
    validator: validate_DriveDrivesList_579048, base: "/drive/v2",
    url: url_DriveDrivesList_579049, schemes: {Scheme.Https})
type
  Call_DriveDrivesUpdate_579096 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesUpdate_579098(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesUpdate_579097(path: JsonNode; query: JsonNode;
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
  var valid_579099 = path.getOrDefault("driveId")
  valid_579099 = validateParameter(valid_579099, JString, required = true,
                                 default = nil)
  if valid_579099 != nil:
    section.add "driveId", valid_579099
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
  var valid_579100 = query.getOrDefault("key")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "key", valid_579100
  var valid_579101 = query.getOrDefault("prettyPrint")
  valid_579101 = validateParameter(valid_579101, JBool, required = false,
                                 default = newJBool(true))
  if valid_579101 != nil:
    section.add "prettyPrint", valid_579101
  var valid_579102 = query.getOrDefault("oauth_token")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "oauth_token", valid_579102
  var valid_579103 = query.getOrDefault("useDomainAdminAccess")
  valid_579103 = validateParameter(valid_579103, JBool, required = false,
                                 default = newJBool(false))
  if valid_579103 != nil:
    section.add "useDomainAdminAccess", valid_579103
  var valid_579104 = query.getOrDefault("alt")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = newJString("json"))
  if valid_579104 != nil:
    section.add "alt", valid_579104
  var valid_579105 = query.getOrDefault("userIp")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "userIp", valid_579105
  var valid_579106 = query.getOrDefault("quotaUser")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "quotaUser", valid_579106
  var valid_579107 = query.getOrDefault("fields")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "fields", valid_579107
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

proc call*(call_579109: Call_DriveDrivesUpdate_579096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadata for a shared drive.
  ## 
  let valid = call_579109.validator(path, query, header, formData, body)
  let scheme = call_579109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579109.url(scheme.get, call_579109.host, call_579109.base,
                         call_579109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579109, url, valid)

proc call*(call_579110: Call_DriveDrivesUpdate_579096; driveId: string;
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
  var path_579111 = newJObject()
  var query_579112 = newJObject()
  var body_579113 = newJObject()
  add(query_579112, "key", newJString(key))
  add(query_579112, "prettyPrint", newJBool(prettyPrint))
  add(query_579112, "oauth_token", newJString(oauthToken))
  add(query_579112, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579112, "alt", newJString(alt))
  add(query_579112, "userIp", newJString(userIp))
  add(query_579112, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579113 = body
  add(path_579111, "driveId", newJString(driveId))
  add(query_579112, "fields", newJString(fields))
  result = call_579110.call(path_579111, query_579112, nil, nil, body_579113)

var driveDrivesUpdate* = Call_DriveDrivesUpdate_579096(name: "driveDrivesUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesUpdate_579097,
    base: "/drive/v2", url: url_DriveDrivesUpdate_579098, schemes: {Scheme.Https})
type
  Call_DriveDrivesGet_579080 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesGet_579082(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesGet_579081(path: JsonNode; query: JsonNode;
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
  var valid_579083 = path.getOrDefault("driveId")
  valid_579083 = validateParameter(valid_579083, JString, required = true,
                                 default = nil)
  if valid_579083 != nil:
    section.add "driveId", valid_579083
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
  var valid_579084 = query.getOrDefault("key")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "key", valid_579084
  var valid_579085 = query.getOrDefault("prettyPrint")
  valid_579085 = validateParameter(valid_579085, JBool, required = false,
                                 default = newJBool(true))
  if valid_579085 != nil:
    section.add "prettyPrint", valid_579085
  var valid_579086 = query.getOrDefault("oauth_token")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "oauth_token", valid_579086
  var valid_579087 = query.getOrDefault("useDomainAdminAccess")
  valid_579087 = validateParameter(valid_579087, JBool, required = false,
                                 default = newJBool(false))
  if valid_579087 != nil:
    section.add "useDomainAdminAccess", valid_579087
  var valid_579088 = query.getOrDefault("alt")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = newJString("json"))
  if valid_579088 != nil:
    section.add "alt", valid_579088
  var valid_579089 = query.getOrDefault("userIp")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "userIp", valid_579089
  var valid_579090 = query.getOrDefault("quotaUser")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "quotaUser", valid_579090
  var valid_579091 = query.getOrDefault("fields")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "fields", valid_579091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579092: Call_DriveDrivesGet_579080; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a shared drive's metadata by ID.
  ## 
  let valid = call_579092.validator(path, query, header, formData, body)
  let scheme = call_579092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579092.url(scheme.get, call_579092.host, call_579092.base,
                         call_579092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579092, url, valid)

proc call*(call_579093: Call_DriveDrivesGet_579080; driveId: string;
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
  var path_579094 = newJObject()
  var query_579095 = newJObject()
  add(query_579095, "key", newJString(key))
  add(query_579095, "prettyPrint", newJBool(prettyPrint))
  add(query_579095, "oauth_token", newJString(oauthToken))
  add(query_579095, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579095, "alt", newJString(alt))
  add(query_579095, "userIp", newJString(userIp))
  add(query_579095, "quotaUser", newJString(quotaUser))
  add(path_579094, "driveId", newJString(driveId))
  add(query_579095, "fields", newJString(fields))
  result = call_579093.call(path_579094, query_579095, nil, nil, nil)

var driveDrivesGet* = Call_DriveDrivesGet_579080(name: "driveDrivesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesGet_579081,
    base: "/drive/v2", url: url_DriveDrivesGet_579082, schemes: {Scheme.Https})
type
  Call_DriveDrivesDelete_579114 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesDelete_579116(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesDelete_579115(path: JsonNode; query: JsonNode;
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
  var valid_579117 = path.getOrDefault("driveId")
  valid_579117 = validateParameter(valid_579117, JString, required = true,
                                 default = nil)
  if valid_579117 != nil:
    section.add "driveId", valid_579117
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
  var valid_579118 = query.getOrDefault("key")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "key", valid_579118
  var valid_579119 = query.getOrDefault("prettyPrint")
  valid_579119 = validateParameter(valid_579119, JBool, required = false,
                                 default = newJBool(true))
  if valid_579119 != nil:
    section.add "prettyPrint", valid_579119
  var valid_579120 = query.getOrDefault("oauth_token")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "oauth_token", valid_579120
  var valid_579121 = query.getOrDefault("alt")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = newJString("json"))
  if valid_579121 != nil:
    section.add "alt", valid_579121
  var valid_579122 = query.getOrDefault("userIp")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "userIp", valid_579122
  var valid_579123 = query.getOrDefault("quotaUser")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "quotaUser", valid_579123
  var valid_579124 = query.getOrDefault("fields")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "fields", valid_579124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579125: Call_DriveDrivesDelete_579114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
  ## 
  let valid = call_579125.validator(path, query, header, formData, body)
  let scheme = call_579125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579125.url(scheme.get, call_579125.host, call_579125.base,
                         call_579125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579125, url, valid)

proc call*(call_579126: Call_DriveDrivesDelete_579114; driveId: string;
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
  var path_579127 = newJObject()
  var query_579128 = newJObject()
  add(query_579128, "key", newJString(key))
  add(query_579128, "prettyPrint", newJBool(prettyPrint))
  add(query_579128, "oauth_token", newJString(oauthToken))
  add(query_579128, "alt", newJString(alt))
  add(query_579128, "userIp", newJString(userIp))
  add(query_579128, "quotaUser", newJString(quotaUser))
  add(path_579127, "driveId", newJString(driveId))
  add(query_579128, "fields", newJString(fields))
  result = call_579126.call(path_579127, query_579128, nil, nil, nil)

var driveDrivesDelete* = Call_DriveDrivesDelete_579114(name: "driveDrivesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/drives/{driveId}", validator: validate_DriveDrivesDelete_579115,
    base: "/drive/v2", url: url_DriveDrivesDelete_579116, schemes: {Scheme.Https})
type
  Call_DriveDrivesHide_579129 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesHide_579131(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesHide_579130(path: JsonNode; query: JsonNode;
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
  var valid_579132 = path.getOrDefault("driveId")
  valid_579132 = validateParameter(valid_579132, JString, required = true,
                                 default = nil)
  if valid_579132 != nil:
    section.add "driveId", valid_579132
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
  var valid_579133 = query.getOrDefault("key")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "key", valid_579133
  var valid_579134 = query.getOrDefault("prettyPrint")
  valid_579134 = validateParameter(valid_579134, JBool, required = false,
                                 default = newJBool(true))
  if valid_579134 != nil:
    section.add "prettyPrint", valid_579134
  var valid_579135 = query.getOrDefault("oauth_token")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "oauth_token", valid_579135
  var valid_579136 = query.getOrDefault("alt")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = newJString("json"))
  if valid_579136 != nil:
    section.add "alt", valid_579136
  var valid_579137 = query.getOrDefault("userIp")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "userIp", valid_579137
  var valid_579138 = query.getOrDefault("quotaUser")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "quotaUser", valid_579138
  var valid_579139 = query.getOrDefault("fields")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "fields", valid_579139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579140: Call_DriveDrivesHide_579129; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hides a shared drive from the default view.
  ## 
  let valid = call_579140.validator(path, query, header, formData, body)
  let scheme = call_579140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579140.url(scheme.get, call_579140.host, call_579140.base,
                         call_579140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579140, url, valid)

proc call*(call_579141: Call_DriveDrivesHide_579129; driveId: string;
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
  var path_579142 = newJObject()
  var query_579143 = newJObject()
  add(query_579143, "key", newJString(key))
  add(query_579143, "prettyPrint", newJBool(prettyPrint))
  add(query_579143, "oauth_token", newJString(oauthToken))
  add(query_579143, "alt", newJString(alt))
  add(query_579143, "userIp", newJString(userIp))
  add(query_579143, "quotaUser", newJString(quotaUser))
  add(path_579142, "driveId", newJString(driveId))
  add(query_579143, "fields", newJString(fields))
  result = call_579141.call(path_579142, query_579143, nil, nil, nil)

var driveDrivesHide* = Call_DriveDrivesHide_579129(name: "driveDrivesHide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/hide", validator: validate_DriveDrivesHide_579130,
    base: "/drive/v2", url: url_DriveDrivesHide_579131, schemes: {Scheme.Https})
type
  Call_DriveDrivesUnhide_579144 = ref object of OpenApiRestCall_578355
proc url_DriveDrivesUnhide_579146(protocol: Scheme; host: string; base: string;
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

proc validate_DriveDrivesUnhide_579145(path: JsonNode; query: JsonNode;
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
  var valid_579147 = path.getOrDefault("driveId")
  valid_579147 = validateParameter(valid_579147, JString, required = true,
                                 default = nil)
  if valid_579147 != nil:
    section.add "driveId", valid_579147
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

proc call*(call_579155: Call_DriveDrivesUnhide_579144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a shared drive to the default view.
  ## 
  let valid = call_579155.validator(path, query, header, formData, body)
  let scheme = call_579155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579155.url(scheme.get, call_579155.host, call_579155.base,
                         call_579155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579155, url, valid)

proc call*(call_579156: Call_DriveDrivesUnhide_579144; driveId: string;
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
  var path_579157 = newJObject()
  var query_579158 = newJObject()
  add(query_579158, "key", newJString(key))
  add(query_579158, "prettyPrint", newJBool(prettyPrint))
  add(query_579158, "oauth_token", newJString(oauthToken))
  add(query_579158, "alt", newJString(alt))
  add(query_579158, "userIp", newJString(userIp))
  add(query_579158, "quotaUser", newJString(quotaUser))
  add(path_579157, "driveId", newJString(driveId))
  add(query_579158, "fields", newJString(fields))
  result = call_579156.call(path_579157, query_579158, nil, nil, nil)

var driveDrivesUnhide* = Call_DriveDrivesUnhide_579144(name: "driveDrivesUnhide",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/drives/{driveId}/unhide", validator: validate_DriveDrivesUnhide_579145,
    base: "/drive/v2", url: url_DriveDrivesUnhide_579146, schemes: {Scheme.Https})
type
  Call_DriveFilesInsert_579186 = ref object of OpenApiRestCall_578355
proc url_DriveFilesInsert_579188(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesInsert_579187(path: JsonNode; query: JsonNode;
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
  var valid_579189 = query.getOrDefault("key")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "key", valid_579189
  var valid_579190 = query.getOrDefault("useContentAsIndexableText")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(false))
  if valid_579190 != nil:
    section.add "useContentAsIndexableText", valid_579190
  var valid_579191 = query.getOrDefault("prettyPrint")
  valid_579191 = validateParameter(valid_579191, JBool, required = false,
                                 default = newJBool(true))
  if valid_579191 != nil:
    section.add "prettyPrint", valid_579191
  var valid_579192 = query.getOrDefault("oauth_token")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "oauth_token", valid_579192
  var valid_579193 = query.getOrDefault("ocr")
  valid_579193 = validateParameter(valid_579193, JBool, required = false,
                                 default = newJBool(false))
  if valid_579193 != nil:
    section.add "ocr", valid_579193
  var valid_579194 = query.getOrDefault("ocrLanguage")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "ocrLanguage", valid_579194
  var valid_579195 = query.getOrDefault("timedTextLanguage")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "timedTextLanguage", valid_579195
  var valid_579196 = query.getOrDefault("convert")
  valid_579196 = validateParameter(valid_579196, JBool, required = false,
                                 default = newJBool(false))
  if valid_579196 != nil:
    section.add "convert", valid_579196
  var valid_579197 = query.getOrDefault("alt")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = newJString("json"))
  if valid_579197 != nil:
    section.add "alt", valid_579197
  var valid_579198 = query.getOrDefault("userIp")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "userIp", valid_579198
  var valid_579199 = query.getOrDefault("quotaUser")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "quotaUser", valid_579199
  var valid_579200 = query.getOrDefault("supportsTeamDrives")
  valid_579200 = validateParameter(valid_579200, JBool, required = false,
                                 default = newJBool(false))
  if valid_579200 != nil:
    section.add "supportsTeamDrives", valid_579200
  var valid_579201 = query.getOrDefault("timedTextTrackName")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "timedTextTrackName", valid_579201
  var valid_579202 = query.getOrDefault("visibility")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_579202 != nil:
    section.add "visibility", valid_579202
  var valid_579203 = query.getOrDefault("supportsAllDrives")
  valid_579203 = validateParameter(valid_579203, JBool, required = false,
                                 default = newJBool(false))
  if valid_579203 != nil:
    section.add "supportsAllDrives", valid_579203
  var valid_579204 = query.getOrDefault("fields")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "fields", valid_579204
  var valid_579205 = query.getOrDefault("pinned")
  valid_579205 = validateParameter(valid_579205, JBool, required = false,
                                 default = newJBool(false))
  if valid_579205 != nil:
    section.add "pinned", valid_579205
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

proc call*(call_579207: Call_DriveFilesInsert_579186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Insert a new file.
  ## 
  let valid = call_579207.validator(path, query, header, formData, body)
  let scheme = call_579207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579207.url(scheme.get, call_579207.host, call_579207.base,
                         call_579207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579207, url, valid)

proc call*(call_579208: Call_DriveFilesInsert_579186; key: string = "";
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
  var query_579209 = newJObject()
  var body_579210 = newJObject()
  add(query_579209, "key", newJString(key))
  add(query_579209, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_579209, "prettyPrint", newJBool(prettyPrint))
  add(query_579209, "oauth_token", newJString(oauthToken))
  add(query_579209, "ocr", newJBool(ocr))
  add(query_579209, "ocrLanguage", newJString(ocrLanguage))
  add(query_579209, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_579209, "convert", newJBool(convert))
  add(query_579209, "alt", newJString(alt))
  add(query_579209, "userIp", newJString(userIp))
  add(query_579209, "quotaUser", newJString(quotaUser))
  add(query_579209, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579209, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_579209, "visibility", newJString(visibility))
  add(query_579209, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_579210 = body
  add(query_579209, "fields", newJString(fields))
  add(query_579209, "pinned", newJBool(pinned))
  result = call_579208.call(nil, query_579209, nil, nil, body_579210)

var driveFilesInsert* = Call_DriveFilesInsert_579186(name: "driveFilesInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesInsert_579187, base: "/drive/v2",
    url: url_DriveFilesInsert_579188, schemes: {Scheme.Https})
type
  Call_DriveFilesList_579159 = ref object of OpenApiRestCall_578355
proc url_DriveFilesList_579161(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesList_579160(path: JsonNode; query: JsonNode;
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
  var valid_579162 = query.getOrDefault("key")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "key", valid_579162
  var valid_579163 = query.getOrDefault("prettyPrint")
  valid_579163 = validateParameter(valid_579163, JBool, required = false,
                                 default = newJBool(true))
  if valid_579163 != nil:
    section.add "prettyPrint", valid_579163
  var valid_579164 = query.getOrDefault("oauth_token")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "oauth_token", valid_579164
  var valid_579165 = query.getOrDefault("driveId")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "driveId", valid_579165
  var valid_579166 = query.getOrDefault("includeItemsFromAllDrives")
  valid_579166 = validateParameter(valid_579166, JBool, required = false,
                                 default = newJBool(false))
  if valid_579166 != nil:
    section.add "includeItemsFromAllDrives", valid_579166
  var valid_579167 = query.getOrDefault("q")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "q", valid_579167
  var valid_579168 = query.getOrDefault("spaces")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "spaces", valid_579168
  var valid_579169 = query.getOrDefault("alt")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = newJString("json"))
  if valid_579169 != nil:
    section.add "alt", valid_579169
  var valid_579170 = query.getOrDefault("userIp")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "userIp", valid_579170
  var valid_579171 = query.getOrDefault("quotaUser")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "quotaUser", valid_579171
  var valid_579172 = query.getOrDefault("orderBy")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "orderBy", valid_579172
  var valid_579173 = query.getOrDefault("pageToken")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "pageToken", valid_579173
  var valid_579174 = query.getOrDefault("supportsTeamDrives")
  valid_579174 = validateParameter(valid_579174, JBool, required = false,
                                 default = newJBool(false))
  if valid_579174 != nil:
    section.add "supportsTeamDrives", valid_579174
  var valid_579175 = query.getOrDefault("supportsAllDrives")
  valid_579175 = validateParameter(valid_579175, JBool, required = false,
                                 default = newJBool(false))
  if valid_579175 != nil:
    section.add "supportsAllDrives", valid_579175
  var valid_579176 = query.getOrDefault("corpus")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_579176 != nil:
    section.add "corpus", valid_579176
  var valid_579177 = query.getOrDefault("includeTeamDriveItems")
  valid_579177 = validateParameter(valid_579177, JBool, required = false,
                                 default = newJBool(false))
  if valid_579177 != nil:
    section.add "includeTeamDriveItems", valid_579177
  var valid_579178 = query.getOrDefault("corpora")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "corpora", valid_579178
  var valid_579179 = query.getOrDefault("projection")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579179 != nil:
    section.add "projection", valid_579179
  var valid_579180 = query.getOrDefault("fields")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "fields", valid_579180
  var valid_579181 = query.getOrDefault("maxResults")
  valid_579181 = validateParameter(valid_579181, JInt, required = false,
                                 default = newJInt(100))
  if valid_579181 != nil:
    section.add "maxResults", valid_579181
  var valid_579182 = query.getOrDefault("teamDriveId")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "teamDriveId", valid_579182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579183: Call_DriveFilesList_579159; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the user's files.
  ## 
  let valid = call_579183.validator(path, query, header, formData, body)
  let scheme = call_579183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579183.url(scheme.get, call_579183.host, call_579183.base,
                         call_579183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579183, url, valid)

proc call*(call_579184: Call_DriveFilesList_579159; key: string = "";
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
  var query_579185 = newJObject()
  add(query_579185, "key", newJString(key))
  add(query_579185, "prettyPrint", newJBool(prettyPrint))
  add(query_579185, "oauth_token", newJString(oauthToken))
  add(query_579185, "driveId", newJString(driveId))
  add(query_579185, "includeItemsFromAllDrives",
      newJBool(includeItemsFromAllDrives))
  add(query_579185, "q", newJString(q))
  add(query_579185, "spaces", newJString(spaces))
  add(query_579185, "alt", newJString(alt))
  add(query_579185, "userIp", newJString(userIp))
  add(query_579185, "quotaUser", newJString(quotaUser))
  add(query_579185, "orderBy", newJString(orderBy))
  add(query_579185, "pageToken", newJString(pageToken))
  add(query_579185, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579185, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579185, "corpus", newJString(corpus))
  add(query_579185, "includeTeamDriveItems", newJBool(includeTeamDriveItems))
  add(query_579185, "corpora", newJString(corpora))
  add(query_579185, "projection", newJString(projection))
  add(query_579185, "fields", newJString(fields))
  add(query_579185, "maxResults", newJInt(maxResults))
  add(query_579185, "teamDriveId", newJString(teamDriveId))
  result = call_579184.call(nil, query_579185, nil, nil, nil)

var driveFilesList* = Call_DriveFilesList_579159(name: "driveFilesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files",
    validator: validate_DriveFilesList_579160, base: "/drive/v2",
    url: url_DriveFilesList_579161, schemes: {Scheme.Https})
type
  Call_DriveFilesGenerateIds_579211 = ref object of OpenApiRestCall_578355
proc url_DriveFilesGenerateIds_579213(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesGenerateIds_579212(path: JsonNode; query: JsonNode;
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
  var valid_579217 = query.getOrDefault("alt")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = newJString("json"))
  if valid_579217 != nil:
    section.add "alt", valid_579217
  var valid_579218 = query.getOrDefault("userIp")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "userIp", valid_579218
  var valid_579219 = query.getOrDefault("quotaUser")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "quotaUser", valid_579219
  var valid_579220 = query.getOrDefault("space")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = newJString("drive"))
  if valid_579220 != nil:
    section.add "space", valid_579220
  var valid_579221 = query.getOrDefault("fields")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "fields", valid_579221
  var valid_579222 = query.getOrDefault("maxResults")
  valid_579222 = validateParameter(valid_579222, JInt, required = false,
                                 default = newJInt(10))
  if valid_579222 != nil:
    section.add "maxResults", valid_579222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579223: Call_DriveFilesGenerateIds_579211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a set of file IDs which can be provided in insert or copy requests.
  ## 
  let valid = call_579223.validator(path, query, header, formData, body)
  let scheme = call_579223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579223.url(scheme.get, call_579223.host, call_579223.base,
                         call_579223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579223, url, valid)

proc call*(call_579224: Call_DriveFilesGenerateIds_579211; key: string = "";
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
  var query_579225 = newJObject()
  add(query_579225, "key", newJString(key))
  add(query_579225, "prettyPrint", newJBool(prettyPrint))
  add(query_579225, "oauth_token", newJString(oauthToken))
  add(query_579225, "alt", newJString(alt))
  add(query_579225, "userIp", newJString(userIp))
  add(query_579225, "quotaUser", newJString(quotaUser))
  add(query_579225, "space", newJString(space))
  add(query_579225, "fields", newJString(fields))
  add(query_579225, "maxResults", newJInt(maxResults))
  result = call_579224.call(nil, query_579225, nil, nil, nil)

var driveFilesGenerateIds* = Call_DriveFilesGenerateIds_579211(
    name: "driveFilesGenerateIds", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/generateIds",
    validator: validate_DriveFilesGenerateIds_579212, base: "/drive/v2",
    url: url_DriveFilesGenerateIds_579213, schemes: {Scheme.Https})
type
  Call_DriveFilesEmptyTrash_579226 = ref object of OpenApiRestCall_578355
proc url_DriveFilesEmptyTrash_579228(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveFilesEmptyTrash_579227(path: JsonNode; query: JsonNode;
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
  var valid_579229 = query.getOrDefault("key")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "key", valid_579229
  var valid_579230 = query.getOrDefault("prettyPrint")
  valid_579230 = validateParameter(valid_579230, JBool, required = false,
                                 default = newJBool(true))
  if valid_579230 != nil:
    section.add "prettyPrint", valid_579230
  var valid_579231 = query.getOrDefault("oauth_token")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "oauth_token", valid_579231
  var valid_579232 = query.getOrDefault("alt")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = newJString("json"))
  if valid_579232 != nil:
    section.add "alt", valid_579232
  var valid_579233 = query.getOrDefault("userIp")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "userIp", valid_579233
  var valid_579234 = query.getOrDefault("quotaUser")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "quotaUser", valid_579234
  var valid_579235 = query.getOrDefault("fields")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "fields", valid_579235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579236: Call_DriveFilesEmptyTrash_579226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes all of the user's trashed files.
  ## 
  let valid = call_579236.validator(path, query, header, formData, body)
  let scheme = call_579236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579236.url(scheme.get, call_579236.host, call_579236.base,
                         call_579236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579236, url, valid)

proc call*(call_579237: Call_DriveFilesEmptyTrash_579226; key: string = "";
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
  var query_579238 = newJObject()
  add(query_579238, "key", newJString(key))
  add(query_579238, "prettyPrint", newJBool(prettyPrint))
  add(query_579238, "oauth_token", newJString(oauthToken))
  add(query_579238, "alt", newJString(alt))
  add(query_579238, "userIp", newJString(userIp))
  add(query_579238, "quotaUser", newJString(quotaUser))
  add(query_579238, "fields", newJString(fields))
  result = call_579237.call(nil, query_579238, nil, nil, nil)

var driveFilesEmptyTrash* = Call_DriveFilesEmptyTrash_579226(
    name: "driveFilesEmptyTrash", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/trash",
    validator: validate_DriveFilesEmptyTrash_579227, base: "/drive/v2",
    url: url_DriveFilesEmptyTrash_579228, schemes: {Scheme.Https})
type
  Call_DriveFilesUpdate_579260 = ref object of OpenApiRestCall_578355
proc url_DriveFilesUpdate_579262(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesUpdate_579261(path: JsonNode; query: JsonNode;
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
  var valid_579263 = path.getOrDefault("fileId")
  valid_579263 = validateParameter(valid_579263, JString, required = true,
                                 default = nil)
  if valid_579263 != nil:
    section.add "fileId", valid_579263
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
  var valid_579264 = query.getOrDefault("key")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "key", valid_579264
  var valid_579265 = query.getOrDefault("useContentAsIndexableText")
  valid_579265 = validateParameter(valid_579265, JBool, required = false,
                                 default = newJBool(false))
  if valid_579265 != nil:
    section.add "useContentAsIndexableText", valid_579265
  var valid_579266 = query.getOrDefault("prettyPrint")
  valid_579266 = validateParameter(valid_579266, JBool, required = false,
                                 default = newJBool(true))
  if valid_579266 != nil:
    section.add "prettyPrint", valid_579266
  var valid_579267 = query.getOrDefault("oauth_token")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "oauth_token", valid_579267
  var valid_579268 = query.getOrDefault("addParents")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "addParents", valid_579268
  var valid_579269 = query.getOrDefault("ocr")
  valid_579269 = validateParameter(valid_579269, JBool, required = false,
                                 default = newJBool(false))
  if valid_579269 != nil:
    section.add "ocr", valid_579269
  var valid_579270 = query.getOrDefault("modifiedDateBehavior")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = newJString("fromBody"))
  if valid_579270 != nil:
    section.add "modifiedDateBehavior", valid_579270
  var valid_579271 = query.getOrDefault("ocrLanguage")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "ocrLanguage", valid_579271
  var valid_579272 = query.getOrDefault("timedTextLanguage")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "timedTextLanguage", valid_579272
  var valid_579273 = query.getOrDefault("setModifiedDate")
  valid_579273 = validateParameter(valid_579273, JBool, required = false,
                                 default = newJBool(false))
  if valid_579273 != nil:
    section.add "setModifiedDate", valid_579273
  var valid_579274 = query.getOrDefault("newRevision")
  valid_579274 = validateParameter(valid_579274, JBool, required = false,
                                 default = newJBool(true))
  if valid_579274 != nil:
    section.add "newRevision", valid_579274
  var valid_579275 = query.getOrDefault("convert")
  valid_579275 = validateParameter(valid_579275, JBool, required = false,
                                 default = newJBool(false))
  if valid_579275 != nil:
    section.add "convert", valid_579275
  var valid_579276 = query.getOrDefault("alt")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = newJString("json"))
  if valid_579276 != nil:
    section.add "alt", valid_579276
  var valid_579277 = query.getOrDefault("userIp")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "userIp", valid_579277
  var valid_579278 = query.getOrDefault("quotaUser")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "quotaUser", valid_579278
  var valid_579279 = query.getOrDefault("supportsTeamDrives")
  valid_579279 = validateParameter(valid_579279, JBool, required = false,
                                 default = newJBool(false))
  if valid_579279 != nil:
    section.add "supportsTeamDrives", valid_579279
  var valid_579280 = query.getOrDefault("timedTextTrackName")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "timedTextTrackName", valid_579280
  var valid_579281 = query.getOrDefault("supportsAllDrives")
  valid_579281 = validateParameter(valid_579281, JBool, required = false,
                                 default = newJBool(false))
  if valid_579281 != nil:
    section.add "supportsAllDrives", valid_579281
  var valid_579282 = query.getOrDefault("removeParents")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "removeParents", valid_579282
  var valid_579283 = query.getOrDefault("fields")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "fields", valid_579283
  var valid_579284 = query.getOrDefault("updateViewedDate")
  valid_579284 = validateParameter(valid_579284, JBool, required = false,
                                 default = newJBool(true))
  if valid_579284 != nil:
    section.add "updateViewedDate", valid_579284
  var valid_579285 = query.getOrDefault("pinned")
  valid_579285 = validateParameter(valid_579285, JBool, required = false,
                                 default = newJBool(false))
  if valid_579285 != nil:
    section.add "pinned", valid_579285
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

proc call*(call_579287: Call_DriveFilesUpdate_579260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates file metadata and/or content.
  ## 
  let valid = call_579287.validator(path, query, header, formData, body)
  let scheme = call_579287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579287.url(scheme.get, call_579287.host, call_579287.base,
                         call_579287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579287, url, valid)

proc call*(call_579288: Call_DriveFilesUpdate_579260; fileId: string;
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
  var path_579289 = newJObject()
  var query_579290 = newJObject()
  var body_579291 = newJObject()
  add(query_579290, "key", newJString(key))
  add(query_579290, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_579290, "prettyPrint", newJBool(prettyPrint))
  add(query_579290, "oauth_token", newJString(oauthToken))
  add(query_579290, "addParents", newJString(addParents))
  add(query_579290, "ocr", newJBool(ocr))
  add(query_579290, "modifiedDateBehavior", newJString(modifiedDateBehavior))
  add(query_579290, "ocrLanguage", newJString(ocrLanguage))
  add(query_579290, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_579290, "setModifiedDate", newJBool(setModifiedDate))
  add(query_579290, "newRevision", newJBool(newRevision))
  add(query_579290, "convert", newJBool(convert))
  add(query_579290, "alt", newJString(alt))
  add(query_579290, "userIp", newJString(userIp))
  add(query_579290, "quotaUser", newJString(quotaUser))
  add(path_579289, "fileId", newJString(fileId))
  add(query_579290, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579290, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_579290, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_579291 = body
  add(query_579290, "removeParents", newJString(removeParents))
  add(query_579290, "fields", newJString(fields))
  add(query_579290, "updateViewedDate", newJBool(updateViewedDate))
  add(query_579290, "pinned", newJBool(pinned))
  result = call_579288.call(path_579289, query_579290, nil, nil, body_579291)

var driveFilesUpdate* = Call_DriveFilesUpdate_579260(name: "driveFilesUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesUpdate_579261, base: "/drive/v2",
    url: url_DriveFilesUpdate_579262, schemes: {Scheme.Https})
type
  Call_DriveFilesGet_579239 = ref object of OpenApiRestCall_578355
proc url_DriveFilesGet_579241(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesGet_579240(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579242 = path.getOrDefault("fileId")
  valid_579242 = validateParameter(valid_579242, JString, required = true,
                                 default = nil)
  if valid_579242 != nil:
    section.add "fileId", valid_579242
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
  var valid_579243 = query.getOrDefault("key")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "key", valid_579243
  var valid_579244 = query.getOrDefault("prettyPrint")
  valid_579244 = validateParameter(valid_579244, JBool, required = false,
                                 default = newJBool(true))
  if valid_579244 != nil:
    section.add "prettyPrint", valid_579244
  var valid_579245 = query.getOrDefault("oauth_token")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "oauth_token", valid_579245
  var valid_579246 = query.getOrDefault("alt")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = newJString("json"))
  if valid_579246 != nil:
    section.add "alt", valid_579246
  var valid_579247 = query.getOrDefault("userIp")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "userIp", valid_579247
  var valid_579248 = query.getOrDefault("quotaUser")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "quotaUser", valid_579248
  var valid_579249 = query.getOrDefault("supportsTeamDrives")
  valid_579249 = validateParameter(valid_579249, JBool, required = false,
                                 default = newJBool(false))
  if valid_579249 != nil:
    section.add "supportsTeamDrives", valid_579249
  var valid_579250 = query.getOrDefault("acknowledgeAbuse")
  valid_579250 = validateParameter(valid_579250, JBool, required = false,
                                 default = newJBool(false))
  if valid_579250 != nil:
    section.add "acknowledgeAbuse", valid_579250
  var valid_579251 = query.getOrDefault("supportsAllDrives")
  valid_579251 = validateParameter(valid_579251, JBool, required = false,
                                 default = newJBool(false))
  if valid_579251 != nil:
    section.add "supportsAllDrives", valid_579251
  var valid_579252 = query.getOrDefault("revisionId")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "revisionId", valid_579252
  var valid_579253 = query.getOrDefault("projection")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579253 != nil:
    section.add "projection", valid_579253
  var valid_579254 = query.getOrDefault("fields")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "fields", valid_579254
  var valid_579255 = query.getOrDefault("updateViewedDate")
  valid_579255 = validateParameter(valid_579255, JBool, required = false,
                                 default = newJBool(false))
  if valid_579255 != nil:
    section.add "updateViewedDate", valid_579255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579256: Call_DriveFilesGet_579239; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a file's metadata by ID.
  ## 
  let valid = call_579256.validator(path, query, header, formData, body)
  let scheme = call_579256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579256.url(scheme.get, call_579256.host, call_579256.base,
                         call_579256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579256, url, valid)

proc call*(call_579257: Call_DriveFilesGet_579239; fileId: string; key: string = "";
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
  var path_579258 = newJObject()
  var query_579259 = newJObject()
  add(query_579259, "key", newJString(key))
  add(query_579259, "prettyPrint", newJBool(prettyPrint))
  add(query_579259, "oauth_token", newJString(oauthToken))
  add(query_579259, "alt", newJString(alt))
  add(query_579259, "userIp", newJString(userIp))
  add(query_579259, "quotaUser", newJString(quotaUser))
  add(path_579258, "fileId", newJString(fileId))
  add(query_579259, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579259, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_579259, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579259, "revisionId", newJString(revisionId))
  add(query_579259, "projection", newJString(projection))
  add(query_579259, "fields", newJString(fields))
  add(query_579259, "updateViewedDate", newJBool(updateViewedDate))
  result = call_579257.call(path_579258, query_579259, nil, nil, nil)

var driveFilesGet* = Call_DriveFilesGet_579239(name: "driveFilesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/files/{fileId}",
    validator: validate_DriveFilesGet_579240, base: "/drive/v2",
    url: url_DriveFilesGet_579241, schemes: {Scheme.Https})
type
  Call_DriveFilesPatch_579309 = ref object of OpenApiRestCall_578355
proc url_DriveFilesPatch_579311(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesPatch_579310(path: JsonNode; query: JsonNode;
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
  var valid_579312 = path.getOrDefault("fileId")
  valid_579312 = validateParameter(valid_579312, JString, required = true,
                                 default = nil)
  if valid_579312 != nil:
    section.add "fileId", valid_579312
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
  var valid_579313 = query.getOrDefault("key")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "key", valid_579313
  var valid_579314 = query.getOrDefault("useContentAsIndexableText")
  valid_579314 = validateParameter(valid_579314, JBool, required = false,
                                 default = newJBool(false))
  if valid_579314 != nil:
    section.add "useContentAsIndexableText", valid_579314
  var valid_579315 = query.getOrDefault("prettyPrint")
  valid_579315 = validateParameter(valid_579315, JBool, required = false,
                                 default = newJBool(true))
  if valid_579315 != nil:
    section.add "prettyPrint", valid_579315
  var valid_579316 = query.getOrDefault("oauth_token")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "oauth_token", valid_579316
  var valid_579317 = query.getOrDefault("addParents")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "addParents", valid_579317
  var valid_579318 = query.getOrDefault("ocr")
  valid_579318 = validateParameter(valid_579318, JBool, required = false,
                                 default = newJBool(false))
  if valid_579318 != nil:
    section.add "ocr", valid_579318
  var valid_579319 = query.getOrDefault("modifiedDateBehavior")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = newJString("fromBody"))
  if valid_579319 != nil:
    section.add "modifiedDateBehavior", valid_579319
  var valid_579320 = query.getOrDefault("ocrLanguage")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "ocrLanguage", valid_579320
  var valid_579321 = query.getOrDefault("timedTextLanguage")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "timedTextLanguage", valid_579321
  var valid_579322 = query.getOrDefault("setModifiedDate")
  valid_579322 = validateParameter(valid_579322, JBool, required = false,
                                 default = newJBool(false))
  if valid_579322 != nil:
    section.add "setModifiedDate", valid_579322
  var valid_579323 = query.getOrDefault("newRevision")
  valid_579323 = validateParameter(valid_579323, JBool, required = false,
                                 default = newJBool(true))
  if valid_579323 != nil:
    section.add "newRevision", valid_579323
  var valid_579324 = query.getOrDefault("convert")
  valid_579324 = validateParameter(valid_579324, JBool, required = false,
                                 default = newJBool(false))
  if valid_579324 != nil:
    section.add "convert", valid_579324
  var valid_579325 = query.getOrDefault("alt")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = newJString("json"))
  if valid_579325 != nil:
    section.add "alt", valid_579325
  var valid_579326 = query.getOrDefault("userIp")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "userIp", valid_579326
  var valid_579327 = query.getOrDefault("quotaUser")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "quotaUser", valid_579327
  var valid_579328 = query.getOrDefault("supportsTeamDrives")
  valid_579328 = validateParameter(valid_579328, JBool, required = false,
                                 default = newJBool(false))
  if valid_579328 != nil:
    section.add "supportsTeamDrives", valid_579328
  var valid_579329 = query.getOrDefault("timedTextTrackName")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = nil)
  if valid_579329 != nil:
    section.add "timedTextTrackName", valid_579329
  var valid_579330 = query.getOrDefault("supportsAllDrives")
  valid_579330 = validateParameter(valid_579330, JBool, required = false,
                                 default = newJBool(false))
  if valid_579330 != nil:
    section.add "supportsAllDrives", valid_579330
  var valid_579331 = query.getOrDefault("removeParents")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "removeParents", valid_579331
  var valid_579332 = query.getOrDefault("fields")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "fields", valid_579332
  var valid_579333 = query.getOrDefault("updateViewedDate")
  valid_579333 = validateParameter(valid_579333, JBool, required = false,
                                 default = newJBool(true))
  if valid_579333 != nil:
    section.add "updateViewedDate", valid_579333
  var valid_579334 = query.getOrDefault("pinned")
  valid_579334 = validateParameter(valid_579334, JBool, required = false,
                                 default = newJBool(false))
  if valid_579334 != nil:
    section.add "pinned", valid_579334
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

proc call*(call_579336: Call_DriveFilesPatch_579309; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates file metadata and/or content. This method supports patch semantics.
  ## 
  let valid = call_579336.validator(path, query, header, formData, body)
  let scheme = call_579336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579336.url(scheme.get, call_579336.host, call_579336.base,
                         call_579336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579336, url, valid)

proc call*(call_579337: Call_DriveFilesPatch_579309; fileId: string;
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
  var path_579338 = newJObject()
  var query_579339 = newJObject()
  var body_579340 = newJObject()
  add(query_579339, "key", newJString(key))
  add(query_579339, "useContentAsIndexableText",
      newJBool(useContentAsIndexableText))
  add(query_579339, "prettyPrint", newJBool(prettyPrint))
  add(query_579339, "oauth_token", newJString(oauthToken))
  add(query_579339, "addParents", newJString(addParents))
  add(query_579339, "ocr", newJBool(ocr))
  add(query_579339, "modifiedDateBehavior", newJString(modifiedDateBehavior))
  add(query_579339, "ocrLanguage", newJString(ocrLanguage))
  add(query_579339, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_579339, "setModifiedDate", newJBool(setModifiedDate))
  add(query_579339, "newRevision", newJBool(newRevision))
  add(query_579339, "convert", newJBool(convert))
  add(query_579339, "alt", newJString(alt))
  add(query_579339, "userIp", newJString(userIp))
  add(query_579339, "quotaUser", newJString(quotaUser))
  add(path_579338, "fileId", newJString(fileId))
  add(query_579339, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579339, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_579339, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_579340 = body
  add(query_579339, "removeParents", newJString(removeParents))
  add(query_579339, "fields", newJString(fields))
  add(query_579339, "updateViewedDate", newJBool(updateViewedDate))
  add(query_579339, "pinned", newJBool(pinned))
  result = call_579337.call(path_579338, query_579339, nil, nil, body_579340)

var driveFilesPatch* = Call_DriveFilesPatch_579309(name: "driveFilesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesPatch_579310,
    base: "/drive/v2", url: url_DriveFilesPatch_579311, schemes: {Scheme.Https})
type
  Call_DriveFilesDelete_579292 = ref object of OpenApiRestCall_578355
proc url_DriveFilesDelete_579294(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesDelete_579293(path: JsonNode; query: JsonNode;
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
  var valid_579295 = path.getOrDefault("fileId")
  valid_579295 = validateParameter(valid_579295, JString, required = true,
                                 default = nil)
  if valid_579295 != nil:
    section.add "fileId", valid_579295
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
  var valid_579296 = query.getOrDefault("key")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "key", valid_579296
  var valid_579297 = query.getOrDefault("prettyPrint")
  valid_579297 = validateParameter(valid_579297, JBool, required = false,
                                 default = newJBool(true))
  if valid_579297 != nil:
    section.add "prettyPrint", valid_579297
  var valid_579298 = query.getOrDefault("oauth_token")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "oauth_token", valid_579298
  var valid_579299 = query.getOrDefault("alt")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = newJString("json"))
  if valid_579299 != nil:
    section.add "alt", valid_579299
  var valid_579300 = query.getOrDefault("userIp")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "userIp", valid_579300
  var valid_579301 = query.getOrDefault("quotaUser")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "quotaUser", valid_579301
  var valid_579302 = query.getOrDefault("supportsTeamDrives")
  valid_579302 = validateParameter(valid_579302, JBool, required = false,
                                 default = newJBool(false))
  if valid_579302 != nil:
    section.add "supportsTeamDrives", valid_579302
  var valid_579303 = query.getOrDefault("supportsAllDrives")
  valid_579303 = validateParameter(valid_579303, JBool, required = false,
                                 default = newJBool(false))
  if valid_579303 != nil:
    section.add "supportsAllDrives", valid_579303
  var valid_579304 = query.getOrDefault("fields")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "fields", valid_579304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579305: Call_DriveFilesDelete_579292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file by ID. Skips the trash. The currently authenticated user must own the file or be an organizer on the parent for shared drive files.
  ## 
  let valid = call_579305.validator(path, query, header, formData, body)
  let scheme = call_579305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579305.url(scheme.get, call_579305.host, call_579305.base,
                         call_579305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579305, url, valid)

proc call*(call_579306: Call_DriveFilesDelete_579292; fileId: string;
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
  var path_579307 = newJObject()
  var query_579308 = newJObject()
  add(query_579308, "key", newJString(key))
  add(query_579308, "prettyPrint", newJBool(prettyPrint))
  add(query_579308, "oauth_token", newJString(oauthToken))
  add(query_579308, "alt", newJString(alt))
  add(query_579308, "userIp", newJString(userIp))
  add(query_579308, "quotaUser", newJString(quotaUser))
  add(path_579307, "fileId", newJString(fileId))
  add(query_579308, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579308, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579308, "fields", newJString(fields))
  result = call_579306.call(path_579307, query_579308, nil, nil, nil)

var driveFilesDelete* = Call_DriveFilesDelete_579292(name: "driveFilesDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/files/{fileId}", validator: validate_DriveFilesDelete_579293,
    base: "/drive/v2", url: url_DriveFilesDelete_579294, schemes: {Scheme.Https})
type
  Call_DriveCommentsInsert_579360 = ref object of OpenApiRestCall_578355
proc url_DriveCommentsInsert_579362(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsInsert_579361(path: JsonNode; query: JsonNode;
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
  var valid_579363 = path.getOrDefault("fileId")
  valid_579363 = validateParameter(valid_579363, JString, required = true,
                                 default = nil)
  if valid_579363 != nil:
    section.add "fileId", valid_579363
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
  var valid_579364 = query.getOrDefault("key")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "key", valid_579364
  var valid_579365 = query.getOrDefault("prettyPrint")
  valid_579365 = validateParameter(valid_579365, JBool, required = false,
                                 default = newJBool(true))
  if valid_579365 != nil:
    section.add "prettyPrint", valid_579365
  var valid_579366 = query.getOrDefault("oauth_token")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "oauth_token", valid_579366
  var valid_579367 = query.getOrDefault("alt")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = newJString("json"))
  if valid_579367 != nil:
    section.add "alt", valid_579367
  var valid_579368 = query.getOrDefault("userIp")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "userIp", valid_579368
  var valid_579369 = query.getOrDefault("quotaUser")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "quotaUser", valid_579369
  var valid_579370 = query.getOrDefault("fields")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "fields", valid_579370
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

proc call*(call_579372: Call_DriveCommentsInsert_579360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new comment on the given file.
  ## 
  let valid = call_579372.validator(path, query, header, formData, body)
  let scheme = call_579372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579372.url(scheme.get, call_579372.host, call_579372.base,
                         call_579372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579372, url, valid)

proc call*(call_579373: Call_DriveCommentsInsert_579360; fileId: string;
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
  var path_579374 = newJObject()
  var query_579375 = newJObject()
  var body_579376 = newJObject()
  add(query_579375, "key", newJString(key))
  add(query_579375, "prettyPrint", newJBool(prettyPrint))
  add(query_579375, "oauth_token", newJString(oauthToken))
  add(query_579375, "alt", newJString(alt))
  add(query_579375, "userIp", newJString(userIp))
  add(query_579375, "quotaUser", newJString(quotaUser))
  add(path_579374, "fileId", newJString(fileId))
  if body != nil:
    body_579376 = body
  add(query_579375, "fields", newJString(fields))
  result = call_579373.call(path_579374, query_579375, nil, nil, body_579376)

var driveCommentsInsert* = Call_DriveCommentsInsert_579360(
    name: "driveCommentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/comments",
    validator: validate_DriveCommentsInsert_579361, base: "/drive/v2",
    url: url_DriveCommentsInsert_579362, schemes: {Scheme.Https})
type
  Call_DriveCommentsList_579341 = ref object of OpenApiRestCall_578355
proc url_DriveCommentsList_579343(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsList_579342(path: JsonNode; query: JsonNode;
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
  var valid_579344 = path.getOrDefault("fileId")
  valid_579344 = validateParameter(valid_579344, JString, required = true,
                                 default = nil)
  if valid_579344 != nil:
    section.add "fileId", valid_579344
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
  var valid_579345 = query.getOrDefault("key")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "key", valid_579345
  var valid_579346 = query.getOrDefault("prettyPrint")
  valid_579346 = validateParameter(valid_579346, JBool, required = false,
                                 default = newJBool(true))
  if valid_579346 != nil:
    section.add "prettyPrint", valid_579346
  var valid_579347 = query.getOrDefault("oauth_token")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "oauth_token", valid_579347
  var valid_579348 = query.getOrDefault("alt")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = newJString("json"))
  if valid_579348 != nil:
    section.add "alt", valid_579348
  var valid_579349 = query.getOrDefault("userIp")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "userIp", valid_579349
  var valid_579350 = query.getOrDefault("quotaUser")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "quotaUser", valid_579350
  var valid_579351 = query.getOrDefault("pageToken")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "pageToken", valid_579351
  var valid_579352 = query.getOrDefault("includeDeleted")
  valid_579352 = validateParameter(valid_579352, JBool, required = false,
                                 default = newJBool(false))
  if valid_579352 != nil:
    section.add "includeDeleted", valid_579352
  var valid_579353 = query.getOrDefault("updatedMin")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "updatedMin", valid_579353
  var valid_579354 = query.getOrDefault("fields")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "fields", valid_579354
  var valid_579355 = query.getOrDefault("maxResults")
  valid_579355 = validateParameter(valid_579355, JInt, required = false,
                                 default = newJInt(20))
  if valid_579355 != nil:
    section.add "maxResults", valid_579355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579356: Call_DriveCommentsList_579341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's comments.
  ## 
  let valid = call_579356.validator(path, query, header, formData, body)
  let scheme = call_579356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579356.url(scheme.get, call_579356.host, call_579356.base,
                         call_579356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579356, url, valid)

proc call*(call_579357: Call_DriveCommentsList_579341; fileId: string;
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
  var path_579358 = newJObject()
  var query_579359 = newJObject()
  add(query_579359, "key", newJString(key))
  add(query_579359, "prettyPrint", newJBool(prettyPrint))
  add(query_579359, "oauth_token", newJString(oauthToken))
  add(query_579359, "alt", newJString(alt))
  add(query_579359, "userIp", newJString(userIp))
  add(query_579359, "quotaUser", newJString(quotaUser))
  add(path_579358, "fileId", newJString(fileId))
  add(query_579359, "pageToken", newJString(pageToken))
  add(query_579359, "includeDeleted", newJBool(includeDeleted))
  add(query_579359, "updatedMin", newJString(updatedMin))
  add(query_579359, "fields", newJString(fields))
  add(query_579359, "maxResults", newJInt(maxResults))
  result = call_579357.call(path_579358, query_579359, nil, nil, nil)

var driveCommentsList* = Call_DriveCommentsList_579341(name: "driveCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments", validator: validate_DriveCommentsList_579342,
    base: "/drive/v2", url: url_DriveCommentsList_579343, schemes: {Scheme.Https})
type
  Call_DriveCommentsUpdate_579394 = ref object of OpenApiRestCall_578355
proc url_DriveCommentsUpdate_579396(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsUpdate_579395(path: JsonNode; query: JsonNode;
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
  var valid_579397 = path.getOrDefault("fileId")
  valid_579397 = validateParameter(valid_579397, JString, required = true,
                                 default = nil)
  if valid_579397 != nil:
    section.add "fileId", valid_579397
  var valid_579398 = path.getOrDefault("commentId")
  valid_579398 = validateParameter(valid_579398, JString, required = true,
                                 default = nil)
  if valid_579398 != nil:
    section.add "commentId", valid_579398
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
  var valid_579399 = query.getOrDefault("key")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "key", valid_579399
  var valid_579400 = query.getOrDefault("prettyPrint")
  valid_579400 = validateParameter(valid_579400, JBool, required = false,
                                 default = newJBool(true))
  if valid_579400 != nil:
    section.add "prettyPrint", valid_579400
  var valid_579401 = query.getOrDefault("oauth_token")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "oauth_token", valid_579401
  var valid_579402 = query.getOrDefault("alt")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = newJString("json"))
  if valid_579402 != nil:
    section.add "alt", valid_579402
  var valid_579403 = query.getOrDefault("userIp")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "userIp", valid_579403
  var valid_579404 = query.getOrDefault("quotaUser")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "quotaUser", valid_579404
  var valid_579405 = query.getOrDefault("fields")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "fields", valid_579405
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

proc call*(call_579407: Call_DriveCommentsUpdate_579394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing comment.
  ## 
  let valid = call_579407.validator(path, query, header, formData, body)
  let scheme = call_579407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579407.url(scheme.get, call_579407.host, call_579407.base,
                         call_579407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579407, url, valid)

proc call*(call_579408: Call_DriveCommentsUpdate_579394; fileId: string;
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
  var path_579409 = newJObject()
  var query_579410 = newJObject()
  var body_579411 = newJObject()
  add(query_579410, "key", newJString(key))
  add(query_579410, "prettyPrint", newJBool(prettyPrint))
  add(query_579410, "oauth_token", newJString(oauthToken))
  add(query_579410, "alt", newJString(alt))
  add(query_579410, "userIp", newJString(userIp))
  add(query_579410, "quotaUser", newJString(quotaUser))
  add(path_579409, "fileId", newJString(fileId))
  add(path_579409, "commentId", newJString(commentId))
  if body != nil:
    body_579411 = body
  add(query_579410, "fields", newJString(fields))
  result = call_579408.call(path_579409, query_579410, nil, nil, body_579411)

var driveCommentsUpdate* = Call_DriveCommentsUpdate_579394(
    name: "driveCommentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsUpdate_579395, base: "/drive/v2",
    url: url_DriveCommentsUpdate_579396, schemes: {Scheme.Https})
type
  Call_DriveCommentsGet_579377 = ref object of OpenApiRestCall_578355
proc url_DriveCommentsGet_579379(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsGet_579378(path: JsonNode; query: JsonNode;
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
  var valid_579380 = path.getOrDefault("fileId")
  valid_579380 = validateParameter(valid_579380, JString, required = true,
                                 default = nil)
  if valid_579380 != nil:
    section.add "fileId", valid_579380
  var valid_579381 = path.getOrDefault("commentId")
  valid_579381 = validateParameter(valid_579381, JString, required = true,
                                 default = nil)
  if valid_579381 != nil:
    section.add "commentId", valid_579381
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
  var valid_579382 = query.getOrDefault("key")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "key", valid_579382
  var valid_579383 = query.getOrDefault("prettyPrint")
  valid_579383 = validateParameter(valid_579383, JBool, required = false,
                                 default = newJBool(true))
  if valid_579383 != nil:
    section.add "prettyPrint", valid_579383
  var valid_579384 = query.getOrDefault("oauth_token")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "oauth_token", valid_579384
  var valid_579385 = query.getOrDefault("alt")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = newJString("json"))
  if valid_579385 != nil:
    section.add "alt", valid_579385
  var valid_579386 = query.getOrDefault("userIp")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "userIp", valid_579386
  var valid_579387 = query.getOrDefault("quotaUser")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "quotaUser", valid_579387
  var valid_579388 = query.getOrDefault("includeDeleted")
  valid_579388 = validateParameter(valid_579388, JBool, required = false,
                                 default = newJBool(false))
  if valid_579388 != nil:
    section.add "includeDeleted", valid_579388
  var valid_579389 = query.getOrDefault("fields")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "fields", valid_579389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579390: Call_DriveCommentsGet_579377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a comment by ID.
  ## 
  let valid = call_579390.validator(path, query, header, formData, body)
  let scheme = call_579390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579390.url(scheme.get, call_579390.host, call_579390.base,
                         call_579390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579390, url, valid)

proc call*(call_579391: Call_DriveCommentsGet_579377; fileId: string;
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
  var path_579392 = newJObject()
  var query_579393 = newJObject()
  add(query_579393, "key", newJString(key))
  add(query_579393, "prettyPrint", newJBool(prettyPrint))
  add(query_579393, "oauth_token", newJString(oauthToken))
  add(query_579393, "alt", newJString(alt))
  add(query_579393, "userIp", newJString(userIp))
  add(query_579393, "quotaUser", newJString(quotaUser))
  add(path_579392, "fileId", newJString(fileId))
  add(path_579392, "commentId", newJString(commentId))
  add(query_579393, "includeDeleted", newJBool(includeDeleted))
  add(query_579393, "fields", newJString(fields))
  result = call_579391.call(path_579392, query_579393, nil, nil, nil)

var driveCommentsGet* = Call_DriveCommentsGet_579377(name: "driveCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsGet_579378, base: "/drive/v2",
    url: url_DriveCommentsGet_579379, schemes: {Scheme.Https})
type
  Call_DriveCommentsPatch_579428 = ref object of OpenApiRestCall_578355
proc url_DriveCommentsPatch_579430(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsPatch_579429(path: JsonNode; query: JsonNode;
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
  var valid_579431 = path.getOrDefault("fileId")
  valid_579431 = validateParameter(valid_579431, JString, required = true,
                                 default = nil)
  if valid_579431 != nil:
    section.add "fileId", valid_579431
  var valid_579432 = path.getOrDefault("commentId")
  valid_579432 = validateParameter(valid_579432, JString, required = true,
                                 default = nil)
  if valid_579432 != nil:
    section.add "commentId", valid_579432
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
  var valid_579433 = query.getOrDefault("key")
  valid_579433 = validateParameter(valid_579433, JString, required = false,
                                 default = nil)
  if valid_579433 != nil:
    section.add "key", valid_579433
  var valid_579434 = query.getOrDefault("prettyPrint")
  valid_579434 = validateParameter(valid_579434, JBool, required = false,
                                 default = newJBool(true))
  if valid_579434 != nil:
    section.add "prettyPrint", valid_579434
  var valid_579435 = query.getOrDefault("oauth_token")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "oauth_token", valid_579435
  var valid_579436 = query.getOrDefault("alt")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = newJString("json"))
  if valid_579436 != nil:
    section.add "alt", valid_579436
  var valid_579437 = query.getOrDefault("userIp")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "userIp", valid_579437
  var valid_579438 = query.getOrDefault("quotaUser")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "quotaUser", valid_579438
  var valid_579439 = query.getOrDefault("fields")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "fields", valid_579439
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

proc call*(call_579441: Call_DriveCommentsPatch_579428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing comment. This method supports patch semantics.
  ## 
  let valid = call_579441.validator(path, query, header, formData, body)
  let scheme = call_579441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579441.url(scheme.get, call_579441.host, call_579441.base,
                         call_579441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579441, url, valid)

proc call*(call_579442: Call_DriveCommentsPatch_579428; fileId: string;
          commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveCommentsPatch
  ## Updates an existing comment. This method supports patch semantics.
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
  var path_579443 = newJObject()
  var query_579444 = newJObject()
  var body_579445 = newJObject()
  add(query_579444, "key", newJString(key))
  add(query_579444, "prettyPrint", newJBool(prettyPrint))
  add(query_579444, "oauth_token", newJString(oauthToken))
  add(query_579444, "alt", newJString(alt))
  add(query_579444, "userIp", newJString(userIp))
  add(query_579444, "quotaUser", newJString(quotaUser))
  add(path_579443, "fileId", newJString(fileId))
  add(path_579443, "commentId", newJString(commentId))
  if body != nil:
    body_579445 = body
  add(query_579444, "fields", newJString(fields))
  result = call_579442.call(path_579443, query_579444, nil, nil, body_579445)

var driveCommentsPatch* = Call_DriveCommentsPatch_579428(
    name: "driveCommentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsPatch_579429, base: "/drive/v2",
    url: url_DriveCommentsPatch_579430, schemes: {Scheme.Https})
type
  Call_DriveCommentsDelete_579412 = ref object of OpenApiRestCall_578355
proc url_DriveCommentsDelete_579414(protocol: Scheme; host: string; base: string;
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

proc validate_DriveCommentsDelete_579413(path: JsonNode; query: JsonNode;
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
  var valid_579415 = path.getOrDefault("fileId")
  valid_579415 = validateParameter(valid_579415, JString, required = true,
                                 default = nil)
  if valid_579415 != nil:
    section.add "fileId", valid_579415
  var valid_579416 = path.getOrDefault("commentId")
  valid_579416 = validateParameter(valid_579416, JString, required = true,
                                 default = nil)
  if valid_579416 != nil:
    section.add "commentId", valid_579416
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
  var valid_579417 = query.getOrDefault("key")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "key", valid_579417
  var valid_579418 = query.getOrDefault("prettyPrint")
  valid_579418 = validateParameter(valid_579418, JBool, required = false,
                                 default = newJBool(true))
  if valid_579418 != nil:
    section.add "prettyPrint", valid_579418
  var valid_579419 = query.getOrDefault("oauth_token")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "oauth_token", valid_579419
  var valid_579420 = query.getOrDefault("alt")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = newJString("json"))
  if valid_579420 != nil:
    section.add "alt", valid_579420
  var valid_579421 = query.getOrDefault("userIp")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "userIp", valid_579421
  var valid_579422 = query.getOrDefault("quotaUser")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "quotaUser", valid_579422
  var valid_579423 = query.getOrDefault("fields")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "fields", valid_579423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579424: Call_DriveCommentsDelete_579412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_579424.validator(path, query, header, formData, body)
  let scheme = call_579424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579424.url(scheme.get, call_579424.host, call_579424.base,
                         call_579424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579424, url, valid)

proc call*(call_579425: Call_DriveCommentsDelete_579412; fileId: string;
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
  var path_579426 = newJObject()
  var query_579427 = newJObject()
  add(query_579427, "key", newJString(key))
  add(query_579427, "prettyPrint", newJBool(prettyPrint))
  add(query_579427, "oauth_token", newJString(oauthToken))
  add(query_579427, "alt", newJString(alt))
  add(query_579427, "userIp", newJString(userIp))
  add(query_579427, "quotaUser", newJString(quotaUser))
  add(path_579426, "fileId", newJString(fileId))
  add(path_579426, "commentId", newJString(commentId))
  add(query_579427, "fields", newJString(fields))
  result = call_579425.call(path_579426, query_579427, nil, nil, nil)

var driveCommentsDelete* = Call_DriveCommentsDelete_579412(
    name: "driveCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/comments/{commentId}",
    validator: validate_DriveCommentsDelete_579413, base: "/drive/v2",
    url: url_DriveCommentsDelete_579414, schemes: {Scheme.Https})
type
  Call_DriveRepliesInsert_579465 = ref object of OpenApiRestCall_578355
proc url_DriveRepliesInsert_579467(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesInsert_579466(path: JsonNode; query: JsonNode;
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
  var valid_579468 = path.getOrDefault("fileId")
  valid_579468 = validateParameter(valid_579468, JString, required = true,
                                 default = nil)
  if valid_579468 != nil:
    section.add "fileId", valid_579468
  var valid_579469 = path.getOrDefault("commentId")
  valid_579469 = validateParameter(valid_579469, JString, required = true,
                                 default = nil)
  if valid_579469 != nil:
    section.add "commentId", valid_579469
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
  var valid_579470 = query.getOrDefault("key")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "key", valid_579470
  var valid_579471 = query.getOrDefault("prettyPrint")
  valid_579471 = validateParameter(valid_579471, JBool, required = false,
                                 default = newJBool(true))
  if valid_579471 != nil:
    section.add "prettyPrint", valid_579471
  var valid_579472 = query.getOrDefault("oauth_token")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "oauth_token", valid_579472
  var valid_579473 = query.getOrDefault("alt")
  valid_579473 = validateParameter(valid_579473, JString, required = false,
                                 default = newJString("json"))
  if valid_579473 != nil:
    section.add "alt", valid_579473
  var valid_579474 = query.getOrDefault("userIp")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "userIp", valid_579474
  var valid_579475 = query.getOrDefault("quotaUser")
  valid_579475 = validateParameter(valid_579475, JString, required = false,
                                 default = nil)
  if valid_579475 != nil:
    section.add "quotaUser", valid_579475
  var valid_579476 = query.getOrDefault("fields")
  valid_579476 = validateParameter(valid_579476, JString, required = false,
                                 default = nil)
  if valid_579476 != nil:
    section.add "fields", valid_579476
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

proc call*(call_579478: Call_DriveRepliesInsert_579465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new reply to the given comment.
  ## 
  let valid = call_579478.validator(path, query, header, formData, body)
  let scheme = call_579478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579478.url(scheme.get, call_579478.host, call_579478.base,
                         call_579478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579478, url, valid)

proc call*(call_579479: Call_DriveRepliesInsert_579465; fileId: string;
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
  var path_579480 = newJObject()
  var query_579481 = newJObject()
  var body_579482 = newJObject()
  add(query_579481, "key", newJString(key))
  add(query_579481, "prettyPrint", newJBool(prettyPrint))
  add(query_579481, "oauth_token", newJString(oauthToken))
  add(query_579481, "alt", newJString(alt))
  add(query_579481, "userIp", newJString(userIp))
  add(query_579481, "quotaUser", newJString(quotaUser))
  add(path_579480, "fileId", newJString(fileId))
  add(path_579480, "commentId", newJString(commentId))
  if body != nil:
    body_579482 = body
  add(query_579481, "fields", newJString(fields))
  result = call_579479.call(path_579480, query_579481, nil, nil, body_579482)

var driveRepliesInsert* = Call_DriveRepliesInsert_579465(
    name: "driveRepliesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesInsert_579466, base: "/drive/v2",
    url: url_DriveRepliesInsert_579467, schemes: {Scheme.Https})
type
  Call_DriveRepliesList_579446 = ref object of OpenApiRestCall_578355
proc url_DriveRepliesList_579448(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesList_579447(path: JsonNode; query: JsonNode;
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
  var valid_579449 = path.getOrDefault("fileId")
  valid_579449 = validateParameter(valid_579449, JString, required = true,
                                 default = nil)
  if valid_579449 != nil:
    section.add "fileId", valid_579449
  var valid_579450 = path.getOrDefault("commentId")
  valid_579450 = validateParameter(valid_579450, JString, required = true,
                                 default = nil)
  if valid_579450 != nil:
    section.add "commentId", valid_579450
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
  var valid_579451 = query.getOrDefault("key")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = nil)
  if valid_579451 != nil:
    section.add "key", valid_579451
  var valid_579452 = query.getOrDefault("prettyPrint")
  valid_579452 = validateParameter(valid_579452, JBool, required = false,
                                 default = newJBool(true))
  if valid_579452 != nil:
    section.add "prettyPrint", valid_579452
  var valid_579453 = query.getOrDefault("oauth_token")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "oauth_token", valid_579453
  var valid_579454 = query.getOrDefault("alt")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = newJString("json"))
  if valid_579454 != nil:
    section.add "alt", valid_579454
  var valid_579455 = query.getOrDefault("userIp")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = nil)
  if valid_579455 != nil:
    section.add "userIp", valid_579455
  var valid_579456 = query.getOrDefault("quotaUser")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = nil)
  if valid_579456 != nil:
    section.add "quotaUser", valid_579456
  var valid_579457 = query.getOrDefault("pageToken")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "pageToken", valid_579457
  var valid_579458 = query.getOrDefault("includeDeleted")
  valid_579458 = validateParameter(valid_579458, JBool, required = false,
                                 default = newJBool(false))
  if valid_579458 != nil:
    section.add "includeDeleted", valid_579458
  var valid_579459 = query.getOrDefault("fields")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = nil)
  if valid_579459 != nil:
    section.add "fields", valid_579459
  var valid_579460 = query.getOrDefault("maxResults")
  valid_579460 = validateParameter(valid_579460, JInt, required = false,
                                 default = newJInt(20))
  if valid_579460 != nil:
    section.add "maxResults", valid_579460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579461: Call_DriveRepliesList_579446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the replies to a comment.
  ## 
  let valid = call_579461.validator(path, query, header, formData, body)
  let scheme = call_579461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579461.url(scheme.get, call_579461.host, call_579461.base,
                         call_579461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579461, url, valid)

proc call*(call_579462: Call_DriveRepliesList_579446; fileId: string;
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
  var path_579463 = newJObject()
  var query_579464 = newJObject()
  add(query_579464, "key", newJString(key))
  add(query_579464, "prettyPrint", newJBool(prettyPrint))
  add(query_579464, "oauth_token", newJString(oauthToken))
  add(query_579464, "alt", newJString(alt))
  add(query_579464, "userIp", newJString(userIp))
  add(query_579464, "quotaUser", newJString(quotaUser))
  add(path_579463, "fileId", newJString(fileId))
  add(query_579464, "pageToken", newJString(pageToken))
  add(path_579463, "commentId", newJString(commentId))
  add(query_579464, "includeDeleted", newJBool(includeDeleted))
  add(query_579464, "fields", newJString(fields))
  add(query_579464, "maxResults", newJInt(maxResults))
  result = call_579462.call(path_579463, query_579464, nil, nil, nil)

var driveRepliesList* = Call_DriveRepliesList_579446(name: "driveRepliesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies",
    validator: validate_DriveRepliesList_579447, base: "/drive/v2",
    url: url_DriveRepliesList_579448, schemes: {Scheme.Https})
type
  Call_DriveRepliesUpdate_579501 = ref object of OpenApiRestCall_578355
proc url_DriveRepliesUpdate_579503(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesUpdate_579502(path: JsonNode; query: JsonNode;
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
  var valid_579504 = path.getOrDefault("replyId")
  valid_579504 = validateParameter(valid_579504, JString, required = true,
                                 default = nil)
  if valid_579504 != nil:
    section.add "replyId", valid_579504
  var valid_579505 = path.getOrDefault("fileId")
  valid_579505 = validateParameter(valid_579505, JString, required = true,
                                 default = nil)
  if valid_579505 != nil:
    section.add "fileId", valid_579505
  var valid_579506 = path.getOrDefault("commentId")
  valid_579506 = validateParameter(valid_579506, JString, required = true,
                                 default = nil)
  if valid_579506 != nil:
    section.add "commentId", valid_579506
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
  var valid_579507 = query.getOrDefault("key")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "key", valid_579507
  var valid_579508 = query.getOrDefault("prettyPrint")
  valid_579508 = validateParameter(valid_579508, JBool, required = false,
                                 default = newJBool(true))
  if valid_579508 != nil:
    section.add "prettyPrint", valid_579508
  var valid_579509 = query.getOrDefault("oauth_token")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "oauth_token", valid_579509
  var valid_579510 = query.getOrDefault("alt")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = newJString("json"))
  if valid_579510 != nil:
    section.add "alt", valid_579510
  var valid_579511 = query.getOrDefault("userIp")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "userIp", valid_579511
  var valid_579512 = query.getOrDefault("quotaUser")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "quotaUser", valid_579512
  var valid_579513 = query.getOrDefault("fields")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "fields", valid_579513
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

proc call*(call_579515: Call_DriveRepliesUpdate_579501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing reply.
  ## 
  let valid = call_579515.validator(path, query, header, formData, body)
  let scheme = call_579515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579515.url(scheme.get, call_579515.host, call_579515.base,
                         call_579515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579515, url, valid)

proc call*(call_579516: Call_DriveRepliesUpdate_579501; replyId: string;
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
  var path_579517 = newJObject()
  var query_579518 = newJObject()
  var body_579519 = newJObject()
  add(query_579518, "key", newJString(key))
  add(query_579518, "prettyPrint", newJBool(prettyPrint))
  add(query_579518, "oauth_token", newJString(oauthToken))
  add(query_579518, "alt", newJString(alt))
  add(query_579518, "userIp", newJString(userIp))
  add(path_579517, "replyId", newJString(replyId))
  add(query_579518, "quotaUser", newJString(quotaUser))
  add(path_579517, "fileId", newJString(fileId))
  add(path_579517, "commentId", newJString(commentId))
  if body != nil:
    body_579519 = body
  add(query_579518, "fields", newJString(fields))
  result = call_579516.call(path_579517, query_579518, nil, nil, body_579519)

var driveRepliesUpdate* = Call_DriveRepliesUpdate_579501(
    name: "driveRepliesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesUpdate_579502, base: "/drive/v2",
    url: url_DriveRepliesUpdate_579503, schemes: {Scheme.Https})
type
  Call_DriveRepliesGet_579483 = ref object of OpenApiRestCall_578355
proc url_DriveRepliesGet_579485(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesGet_579484(path: JsonNode; query: JsonNode;
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
  var valid_579486 = path.getOrDefault("replyId")
  valid_579486 = validateParameter(valid_579486, JString, required = true,
                                 default = nil)
  if valid_579486 != nil:
    section.add "replyId", valid_579486
  var valid_579487 = path.getOrDefault("fileId")
  valid_579487 = validateParameter(valid_579487, JString, required = true,
                                 default = nil)
  if valid_579487 != nil:
    section.add "fileId", valid_579487
  var valid_579488 = path.getOrDefault("commentId")
  valid_579488 = validateParameter(valid_579488, JString, required = true,
                                 default = nil)
  if valid_579488 != nil:
    section.add "commentId", valid_579488
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
  var valid_579489 = query.getOrDefault("key")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = nil)
  if valid_579489 != nil:
    section.add "key", valid_579489
  var valid_579490 = query.getOrDefault("prettyPrint")
  valid_579490 = validateParameter(valid_579490, JBool, required = false,
                                 default = newJBool(true))
  if valid_579490 != nil:
    section.add "prettyPrint", valid_579490
  var valid_579491 = query.getOrDefault("oauth_token")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = nil)
  if valid_579491 != nil:
    section.add "oauth_token", valid_579491
  var valid_579492 = query.getOrDefault("alt")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = newJString("json"))
  if valid_579492 != nil:
    section.add "alt", valid_579492
  var valid_579493 = query.getOrDefault("userIp")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "userIp", valid_579493
  var valid_579494 = query.getOrDefault("quotaUser")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "quotaUser", valid_579494
  var valid_579495 = query.getOrDefault("includeDeleted")
  valid_579495 = validateParameter(valid_579495, JBool, required = false,
                                 default = newJBool(false))
  if valid_579495 != nil:
    section.add "includeDeleted", valid_579495
  var valid_579496 = query.getOrDefault("fields")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "fields", valid_579496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579497: Call_DriveRepliesGet_579483; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a reply.
  ## 
  let valid = call_579497.validator(path, query, header, formData, body)
  let scheme = call_579497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579497.url(scheme.get, call_579497.host, call_579497.base,
                         call_579497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579497, url, valid)

proc call*(call_579498: Call_DriveRepliesGet_579483; replyId: string; fileId: string;
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
  var path_579499 = newJObject()
  var query_579500 = newJObject()
  add(query_579500, "key", newJString(key))
  add(query_579500, "prettyPrint", newJBool(prettyPrint))
  add(query_579500, "oauth_token", newJString(oauthToken))
  add(query_579500, "alt", newJString(alt))
  add(query_579500, "userIp", newJString(userIp))
  add(path_579499, "replyId", newJString(replyId))
  add(query_579500, "quotaUser", newJString(quotaUser))
  add(path_579499, "fileId", newJString(fileId))
  add(path_579499, "commentId", newJString(commentId))
  add(query_579500, "includeDeleted", newJBool(includeDeleted))
  add(query_579500, "fields", newJString(fields))
  result = call_579498.call(path_579499, query_579500, nil, nil, nil)

var driveRepliesGet* = Call_DriveRepliesGet_579483(name: "driveRepliesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesGet_579484, base: "/drive/v2",
    url: url_DriveRepliesGet_579485, schemes: {Scheme.Https})
type
  Call_DriveRepliesPatch_579537 = ref object of OpenApiRestCall_578355
proc url_DriveRepliesPatch_579539(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesPatch_579538(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates an existing reply. This method supports patch semantics.
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
  var valid_579540 = path.getOrDefault("replyId")
  valid_579540 = validateParameter(valid_579540, JString, required = true,
                                 default = nil)
  if valid_579540 != nil:
    section.add "replyId", valid_579540
  var valid_579541 = path.getOrDefault("fileId")
  valid_579541 = validateParameter(valid_579541, JString, required = true,
                                 default = nil)
  if valid_579541 != nil:
    section.add "fileId", valid_579541
  var valid_579542 = path.getOrDefault("commentId")
  valid_579542 = validateParameter(valid_579542, JString, required = true,
                                 default = nil)
  if valid_579542 != nil:
    section.add "commentId", valid_579542
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
  var valid_579543 = query.getOrDefault("key")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "key", valid_579543
  var valid_579544 = query.getOrDefault("prettyPrint")
  valid_579544 = validateParameter(valid_579544, JBool, required = false,
                                 default = newJBool(true))
  if valid_579544 != nil:
    section.add "prettyPrint", valid_579544
  var valid_579545 = query.getOrDefault("oauth_token")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "oauth_token", valid_579545
  var valid_579546 = query.getOrDefault("alt")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = newJString("json"))
  if valid_579546 != nil:
    section.add "alt", valid_579546
  var valid_579547 = query.getOrDefault("userIp")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "userIp", valid_579547
  var valid_579548 = query.getOrDefault("quotaUser")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = nil)
  if valid_579548 != nil:
    section.add "quotaUser", valid_579548
  var valid_579549 = query.getOrDefault("fields")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = nil)
  if valid_579549 != nil:
    section.add "fields", valid_579549
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

proc call*(call_579551: Call_DriveRepliesPatch_579537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing reply. This method supports patch semantics.
  ## 
  let valid = call_579551.validator(path, query, header, formData, body)
  let scheme = call_579551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579551.url(scheme.get, call_579551.host, call_579551.base,
                         call_579551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579551, url, valid)

proc call*(call_579552: Call_DriveRepliesPatch_579537; replyId: string;
          fileId: string; commentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveRepliesPatch
  ## Updates an existing reply. This method supports patch semantics.
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
  var path_579553 = newJObject()
  var query_579554 = newJObject()
  var body_579555 = newJObject()
  add(query_579554, "key", newJString(key))
  add(query_579554, "prettyPrint", newJBool(prettyPrint))
  add(query_579554, "oauth_token", newJString(oauthToken))
  add(query_579554, "alt", newJString(alt))
  add(query_579554, "userIp", newJString(userIp))
  add(path_579553, "replyId", newJString(replyId))
  add(query_579554, "quotaUser", newJString(quotaUser))
  add(path_579553, "fileId", newJString(fileId))
  add(path_579553, "commentId", newJString(commentId))
  if body != nil:
    body_579555 = body
  add(query_579554, "fields", newJString(fields))
  result = call_579552.call(path_579553, query_579554, nil, nil, body_579555)

var driveRepliesPatch* = Call_DriveRepliesPatch_579537(name: "driveRepliesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesPatch_579538, base: "/drive/v2",
    url: url_DriveRepliesPatch_579539, schemes: {Scheme.Https})
type
  Call_DriveRepliesDelete_579520 = ref object of OpenApiRestCall_578355
proc url_DriveRepliesDelete_579522(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRepliesDelete_579521(path: JsonNode; query: JsonNode;
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
  var valid_579523 = path.getOrDefault("replyId")
  valid_579523 = validateParameter(valid_579523, JString, required = true,
                                 default = nil)
  if valid_579523 != nil:
    section.add "replyId", valid_579523
  var valid_579524 = path.getOrDefault("fileId")
  valid_579524 = validateParameter(valid_579524, JString, required = true,
                                 default = nil)
  if valid_579524 != nil:
    section.add "fileId", valid_579524
  var valid_579525 = path.getOrDefault("commentId")
  valid_579525 = validateParameter(valid_579525, JString, required = true,
                                 default = nil)
  if valid_579525 != nil:
    section.add "commentId", valid_579525
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
  var valid_579526 = query.getOrDefault("key")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = nil)
  if valid_579526 != nil:
    section.add "key", valid_579526
  var valid_579527 = query.getOrDefault("prettyPrint")
  valid_579527 = validateParameter(valid_579527, JBool, required = false,
                                 default = newJBool(true))
  if valid_579527 != nil:
    section.add "prettyPrint", valid_579527
  var valid_579528 = query.getOrDefault("oauth_token")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "oauth_token", valid_579528
  var valid_579529 = query.getOrDefault("alt")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = newJString("json"))
  if valid_579529 != nil:
    section.add "alt", valid_579529
  var valid_579530 = query.getOrDefault("userIp")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "userIp", valid_579530
  var valid_579531 = query.getOrDefault("quotaUser")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "quotaUser", valid_579531
  var valid_579532 = query.getOrDefault("fields")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "fields", valid_579532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579533: Call_DriveRepliesDelete_579520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a reply.
  ## 
  let valid = call_579533.validator(path, query, header, formData, body)
  let scheme = call_579533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579533.url(scheme.get, call_579533.host, call_579533.base,
                         call_579533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579533, url, valid)

proc call*(call_579534: Call_DriveRepliesDelete_579520; replyId: string;
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
  var path_579535 = newJObject()
  var query_579536 = newJObject()
  add(query_579536, "key", newJString(key))
  add(query_579536, "prettyPrint", newJBool(prettyPrint))
  add(query_579536, "oauth_token", newJString(oauthToken))
  add(query_579536, "alt", newJString(alt))
  add(query_579536, "userIp", newJString(userIp))
  add(path_579535, "replyId", newJString(replyId))
  add(query_579536, "quotaUser", newJString(quotaUser))
  add(path_579535, "fileId", newJString(fileId))
  add(path_579535, "commentId", newJString(commentId))
  add(query_579536, "fields", newJString(fields))
  result = call_579534.call(path_579535, query_579536, nil, nil, nil)

var driveRepliesDelete* = Call_DriveRepliesDelete_579520(
    name: "driveRepliesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/comments/{commentId}/replies/{replyId}",
    validator: validate_DriveRepliesDelete_579521, base: "/drive/v2",
    url: url_DriveRepliesDelete_579522, schemes: {Scheme.Https})
type
  Call_DriveFilesCopy_579556 = ref object of OpenApiRestCall_578355
proc url_DriveFilesCopy_579558(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesCopy_579557(path: JsonNode; query: JsonNode;
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
  var valid_579559 = path.getOrDefault("fileId")
  valid_579559 = validateParameter(valid_579559, JString, required = true,
                                 default = nil)
  if valid_579559 != nil:
    section.add "fileId", valid_579559
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
  var valid_579560 = query.getOrDefault("key")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = nil)
  if valid_579560 != nil:
    section.add "key", valid_579560
  var valid_579561 = query.getOrDefault("prettyPrint")
  valid_579561 = validateParameter(valid_579561, JBool, required = false,
                                 default = newJBool(true))
  if valid_579561 != nil:
    section.add "prettyPrint", valid_579561
  var valid_579562 = query.getOrDefault("oauth_token")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = nil)
  if valid_579562 != nil:
    section.add "oauth_token", valid_579562
  var valid_579563 = query.getOrDefault("ocr")
  valid_579563 = validateParameter(valid_579563, JBool, required = false,
                                 default = newJBool(false))
  if valid_579563 != nil:
    section.add "ocr", valid_579563
  var valid_579564 = query.getOrDefault("ocrLanguage")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = nil)
  if valid_579564 != nil:
    section.add "ocrLanguage", valid_579564
  var valid_579565 = query.getOrDefault("timedTextLanguage")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = nil)
  if valid_579565 != nil:
    section.add "timedTextLanguage", valid_579565
  var valid_579566 = query.getOrDefault("convert")
  valid_579566 = validateParameter(valid_579566, JBool, required = false,
                                 default = newJBool(false))
  if valid_579566 != nil:
    section.add "convert", valid_579566
  var valid_579567 = query.getOrDefault("alt")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = newJString("json"))
  if valid_579567 != nil:
    section.add "alt", valid_579567
  var valid_579568 = query.getOrDefault("userIp")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = nil)
  if valid_579568 != nil:
    section.add "userIp", valid_579568
  var valid_579569 = query.getOrDefault("quotaUser")
  valid_579569 = validateParameter(valid_579569, JString, required = false,
                                 default = nil)
  if valid_579569 != nil:
    section.add "quotaUser", valid_579569
  var valid_579570 = query.getOrDefault("supportsTeamDrives")
  valid_579570 = validateParameter(valid_579570, JBool, required = false,
                                 default = newJBool(false))
  if valid_579570 != nil:
    section.add "supportsTeamDrives", valid_579570
  var valid_579571 = query.getOrDefault("timedTextTrackName")
  valid_579571 = validateParameter(valid_579571, JString, required = false,
                                 default = nil)
  if valid_579571 != nil:
    section.add "timedTextTrackName", valid_579571
  var valid_579572 = query.getOrDefault("visibility")
  valid_579572 = validateParameter(valid_579572, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_579572 != nil:
    section.add "visibility", valid_579572
  var valid_579573 = query.getOrDefault("supportsAllDrives")
  valid_579573 = validateParameter(valid_579573, JBool, required = false,
                                 default = newJBool(false))
  if valid_579573 != nil:
    section.add "supportsAllDrives", valid_579573
  var valid_579574 = query.getOrDefault("fields")
  valid_579574 = validateParameter(valid_579574, JString, required = false,
                                 default = nil)
  if valid_579574 != nil:
    section.add "fields", valid_579574
  var valid_579575 = query.getOrDefault("pinned")
  valid_579575 = validateParameter(valid_579575, JBool, required = false,
                                 default = newJBool(false))
  if valid_579575 != nil:
    section.add "pinned", valid_579575
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

proc call*(call_579577: Call_DriveFilesCopy_579556; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a copy of the specified file.
  ## 
  let valid = call_579577.validator(path, query, header, formData, body)
  let scheme = call_579577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579577.url(scheme.get, call_579577.host, call_579577.base,
                         call_579577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579577, url, valid)

proc call*(call_579578: Call_DriveFilesCopy_579556; fileId: string; key: string = "";
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
  var path_579579 = newJObject()
  var query_579580 = newJObject()
  var body_579581 = newJObject()
  add(query_579580, "key", newJString(key))
  add(query_579580, "prettyPrint", newJBool(prettyPrint))
  add(query_579580, "oauth_token", newJString(oauthToken))
  add(query_579580, "ocr", newJBool(ocr))
  add(query_579580, "ocrLanguage", newJString(ocrLanguage))
  add(query_579580, "timedTextLanguage", newJString(timedTextLanguage))
  add(query_579580, "convert", newJBool(convert))
  add(query_579580, "alt", newJString(alt))
  add(query_579580, "userIp", newJString(userIp))
  add(query_579580, "quotaUser", newJString(quotaUser))
  add(path_579579, "fileId", newJString(fileId))
  add(query_579580, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579580, "timedTextTrackName", newJString(timedTextTrackName))
  add(query_579580, "visibility", newJString(visibility))
  add(query_579580, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_579581 = body
  add(query_579580, "fields", newJString(fields))
  add(query_579580, "pinned", newJBool(pinned))
  result = call_579578.call(path_579579, query_579580, nil, nil, body_579581)

var driveFilesCopy* = Call_DriveFilesCopy_579556(name: "driveFilesCopy",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/copy", validator: validate_DriveFilesCopy_579557,
    base: "/drive/v2", url: url_DriveFilesCopy_579558, schemes: {Scheme.Https})
type
  Call_DriveFilesExport_579582 = ref object of OpenApiRestCall_578355
proc url_DriveFilesExport_579584(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesExport_579583(path: JsonNode; query: JsonNode;
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
  var valid_579585 = path.getOrDefault("fileId")
  valid_579585 = validateParameter(valid_579585, JString, required = true,
                                 default = nil)
  if valid_579585 != nil:
    section.add "fileId", valid_579585
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
  var valid_579586 = query.getOrDefault("key")
  valid_579586 = validateParameter(valid_579586, JString, required = false,
                                 default = nil)
  if valid_579586 != nil:
    section.add "key", valid_579586
  var valid_579587 = query.getOrDefault("prettyPrint")
  valid_579587 = validateParameter(valid_579587, JBool, required = false,
                                 default = newJBool(true))
  if valid_579587 != nil:
    section.add "prettyPrint", valid_579587
  var valid_579588 = query.getOrDefault("oauth_token")
  valid_579588 = validateParameter(valid_579588, JString, required = false,
                                 default = nil)
  if valid_579588 != nil:
    section.add "oauth_token", valid_579588
  var valid_579589 = query.getOrDefault("alt")
  valid_579589 = validateParameter(valid_579589, JString, required = false,
                                 default = newJString("json"))
  if valid_579589 != nil:
    section.add "alt", valid_579589
  var valid_579590 = query.getOrDefault("userIp")
  valid_579590 = validateParameter(valid_579590, JString, required = false,
                                 default = nil)
  if valid_579590 != nil:
    section.add "userIp", valid_579590
  var valid_579591 = query.getOrDefault("quotaUser")
  valid_579591 = validateParameter(valid_579591, JString, required = false,
                                 default = nil)
  if valid_579591 != nil:
    section.add "quotaUser", valid_579591
  assert query != nil,
        "query argument is necessary due to required `mimeType` field"
  var valid_579592 = query.getOrDefault("mimeType")
  valid_579592 = validateParameter(valid_579592, JString, required = true,
                                 default = nil)
  if valid_579592 != nil:
    section.add "mimeType", valid_579592
  var valid_579593 = query.getOrDefault("fields")
  valid_579593 = validateParameter(valid_579593, JString, required = false,
                                 default = nil)
  if valid_579593 != nil:
    section.add "fields", valid_579593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579594: Call_DriveFilesExport_579582; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  ## 
  let valid = call_579594.validator(path, query, header, formData, body)
  let scheme = call_579594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579594.url(scheme.get, call_579594.host, call_579594.base,
                         call_579594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579594, url, valid)

proc call*(call_579595: Call_DriveFilesExport_579582; fileId: string;
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
  var path_579596 = newJObject()
  var query_579597 = newJObject()
  add(query_579597, "key", newJString(key))
  add(query_579597, "prettyPrint", newJBool(prettyPrint))
  add(query_579597, "oauth_token", newJString(oauthToken))
  add(query_579597, "alt", newJString(alt))
  add(query_579597, "userIp", newJString(userIp))
  add(query_579597, "quotaUser", newJString(quotaUser))
  add(path_579596, "fileId", newJString(fileId))
  add(query_579597, "mimeType", newJString(mimeType))
  add(query_579597, "fields", newJString(fields))
  result = call_579595.call(path_579596, query_579597, nil, nil, nil)

var driveFilesExport* = Call_DriveFilesExport_579582(name: "driveFilesExport",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/export", validator: validate_DriveFilesExport_579583,
    base: "/drive/v2", url: url_DriveFilesExport_579584, schemes: {Scheme.Https})
type
  Call_DriveParentsInsert_579613 = ref object of OpenApiRestCall_578355
proc url_DriveParentsInsert_579615(protocol: Scheme; host: string; base: string;
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

proc validate_DriveParentsInsert_579614(path: JsonNode; query: JsonNode;
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
  var valid_579616 = path.getOrDefault("fileId")
  valid_579616 = validateParameter(valid_579616, JString, required = true,
                                 default = nil)
  if valid_579616 != nil:
    section.add "fileId", valid_579616
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
  var valid_579617 = query.getOrDefault("key")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = nil)
  if valid_579617 != nil:
    section.add "key", valid_579617
  var valid_579618 = query.getOrDefault("prettyPrint")
  valid_579618 = validateParameter(valid_579618, JBool, required = false,
                                 default = newJBool(true))
  if valid_579618 != nil:
    section.add "prettyPrint", valid_579618
  var valid_579619 = query.getOrDefault("oauth_token")
  valid_579619 = validateParameter(valid_579619, JString, required = false,
                                 default = nil)
  if valid_579619 != nil:
    section.add "oauth_token", valid_579619
  var valid_579620 = query.getOrDefault("alt")
  valid_579620 = validateParameter(valid_579620, JString, required = false,
                                 default = newJString("json"))
  if valid_579620 != nil:
    section.add "alt", valid_579620
  var valid_579621 = query.getOrDefault("userIp")
  valid_579621 = validateParameter(valid_579621, JString, required = false,
                                 default = nil)
  if valid_579621 != nil:
    section.add "userIp", valid_579621
  var valid_579622 = query.getOrDefault("quotaUser")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "quotaUser", valid_579622
  var valid_579623 = query.getOrDefault("supportsTeamDrives")
  valid_579623 = validateParameter(valid_579623, JBool, required = false,
                                 default = newJBool(false))
  if valid_579623 != nil:
    section.add "supportsTeamDrives", valid_579623
  var valid_579624 = query.getOrDefault("supportsAllDrives")
  valid_579624 = validateParameter(valid_579624, JBool, required = false,
                                 default = newJBool(false))
  if valid_579624 != nil:
    section.add "supportsAllDrives", valid_579624
  var valid_579625 = query.getOrDefault("fields")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = nil)
  if valid_579625 != nil:
    section.add "fields", valid_579625
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

proc call*(call_579627: Call_DriveParentsInsert_579613; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a parent folder for a file.
  ## 
  let valid = call_579627.validator(path, query, header, formData, body)
  let scheme = call_579627.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579627.url(scheme.get, call_579627.host, call_579627.base,
                         call_579627.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579627, url, valid)

proc call*(call_579628: Call_DriveParentsInsert_579613; fileId: string;
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
  var path_579629 = newJObject()
  var query_579630 = newJObject()
  var body_579631 = newJObject()
  add(query_579630, "key", newJString(key))
  add(query_579630, "prettyPrint", newJBool(prettyPrint))
  add(query_579630, "oauth_token", newJString(oauthToken))
  add(query_579630, "alt", newJString(alt))
  add(query_579630, "userIp", newJString(userIp))
  add(query_579630, "quotaUser", newJString(quotaUser))
  add(path_579629, "fileId", newJString(fileId))
  add(query_579630, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579630, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_579631 = body
  add(query_579630, "fields", newJString(fields))
  result = call_579628.call(path_579629, query_579630, nil, nil, body_579631)

var driveParentsInsert* = Call_DriveParentsInsert_579613(
    name: "driveParentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/parents",
    validator: validate_DriveParentsInsert_579614, base: "/drive/v2",
    url: url_DriveParentsInsert_579615, schemes: {Scheme.Https})
type
  Call_DriveParentsList_579598 = ref object of OpenApiRestCall_578355
proc url_DriveParentsList_579600(protocol: Scheme; host: string; base: string;
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

proc validate_DriveParentsList_579599(path: JsonNode; query: JsonNode;
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
  var valid_579601 = path.getOrDefault("fileId")
  valid_579601 = validateParameter(valid_579601, JString, required = true,
                                 default = nil)
  if valid_579601 != nil:
    section.add "fileId", valid_579601
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
  var valid_579602 = query.getOrDefault("key")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = nil)
  if valid_579602 != nil:
    section.add "key", valid_579602
  var valid_579603 = query.getOrDefault("prettyPrint")
  valid_579603 = validateParameter(valid_579603, JBool, required = false,
                                 default = newJBool(true))
  if valid_579603 != nil:
    section.add "prettyPrint", valid_579603
  var valid_579604 = query.getOrDefault("oauth_token")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = nil)
  if valid_579604 != nil:
    section.add "oauth_token", valid_579604
  var valid_579605 = query.getOrDefault("alt")
  valid_579605 = validateParameter(valid_579605, JString, required = false,
                                 default = newJString("json"))
  if valid_579605 != nil:
    section.add "alt", valid_579605
  var valid_579606 = query.getOrDefault("userIp")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "userIp", valid_579606
  var valid_579607 = query.getOrDefault("quotaUser")
  valid_579607 = validateParameter(valid_579607, JString, required = false,
                                 default = nil)
  if valid_579607 != nil:
    section.add "quotaUser", valid_579607
  var valid_579608 = query.getOrDefault("fields")
  valid_579608 = validateParameter(valid_579608, JString, required = false,
                                 default = nil)
  if valid_579608 != nil:
    section.add "fields", valid_579608
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579609: Call_DriveParentsList_579598; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's parents.
  ## 
  let valid = call_579609.validator(path, query, header, formData, body)
  let scheme = call_579609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579609.url(scheme.get, call_579609.host, call_579609.base,
                         call_579609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579609, url, valid)

proc call*(call_579610: Call_DriveParentsList_579598; fileId: string;
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
  var path_579611 = newJObject()
  var query_579612 = newJObject()
  add(query_579612, "key", newJString(key))
  add(query_579612, "prettyPrint", newJBool(prettyPrint))
  add(query_579612, "oauth_token", newJString(oauthToken))
  add(query_579612, "alt", newJString(alt))
  add(query_579612, "userIp", newJString(userIp))
  add(query_579612, "quotaUser", newJString(quotaUser))
  add(path_579611, "fileId", newJString(fileId))
  add(query_579612, "fields", newJString(fields))
  result = call_579610.call(path_579611, query_579612, nil, nil, nil)

var driveParentsList* = Call_DriveParentsList_579598(name: "driveParentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/parents", validator: validate_DriveParentsList_579599,
    base: "/drive/v2", url: url_DriveParentsList_579600, schemes: {Scheme.Https})
type
  Call_DriveParentsGet_579632 = ref object of OpenApiRestCall_578355
proc url_DriveParentsGet_579634(protocol: Scheme; host: string; base: string;
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

proc validate_DriveParentsGet_579633(path: JsonNode; query: JsonNode;
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
  var valid_579635 = path.getOrDefault("fileId")
  valid_579635 = validateParameter(valid_579635, JString, required = true,
                                 default = nil)
  if valid_579635 != nil:
    section.add "fileId", valid_579635
  var valid_579636 = path.getOrDefault("parentId")
  valid_579636 = validateParameter(valid_579636, JString, required = true,
                                 default = nil)
  if valid_579636 != nil:
    section.add "parentId", valid_579636
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
  var valid_579637 = query.getOrDefault("key")
  valid_579637 = validateParameter(valid_579637, JString, required = false,
                                 default = nil)
  if valid_579637 != nil:
    section.add "key", valid_579637
  var valid_579638 = query.getOrDefault("prettyPrint")
  valid_579638 = validateParameter(valid_579638, JBool, required = false,
                                 default = newJBool(true))
  if valid_579638 != nil:
    section.add "prettyPrint", valid_579638
  var valid_579639 = query.getOrDefault("oauth_token")
  valid_579639 = validateParameter(valid_579639, JString, required = false,
                                 default = nil)
  if valid_579639 != nil:
    section.add "oauth_token", valid_579639
  var valid_579640 = query.getOrDefault("alt")
  valid_579640 = validateParameter(valid_579640, JString, required = false,
                                 default = newJString("json"))
  if valid_579640 != nil:
    section.add "alt", valid_579640
  var valid_579641 = query.getOrDefault("userIp")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = nil)
  if valid_579641 != nil:
    section.add "userIp", valid_579641
  var valid_579642 = query.getOrDefault("quotaUser")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "quotaUser", valid_579642
  var valid_579643 = query.getOrDefault("fields")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "fields", valid_579643
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579644: Call_DriveParentsGet_579632; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific parent reference.
  ## 
  let valid = call_579644.validator(path, query, header, formData, body)
  let scheme = call_579644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579644.url(scheme.get, call_579644.host, call_579644.base,
                         call_579644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579644, url, valid)

proc call*(call_579645: Call_DriveParentsGet_579632; fileId: string;
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
  var path_579646 = newJObject()
  var query_579647 = newJObject()
  add(query_579647, "key", newJString(key))
  add(query_579647, "prettyPrint", newJBool(prettyPrint))
  add(query_579647, "oauth_token", newJString(oauthToken))
  add(query_579647, "alt", newJString(alt))
  add(query_579647, "userIp", newJString(userIp))
  add(query_579647, "quotaUser", newJString(quotaUser))
  add(path_579646, "fileId", newJString(fileId))
  add(path_579646, "parentId", newJString(parentId))
  add(query_579647, "fields", newJString(fields))
  result = call_579645.call(path_579646, query_579647, nil, nil, nil)

var driveParentsGet* = Call_DriveParentsGet_579632(name: "driveParentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/parents/{parentId}",
    validator: validate_DriveParentsGet_579633, base: "/drive/v2",
    url: url_DriveParentsGet_579634, schemes: {Scheme.Https})
type
  Call_DriveParentsDelete_579648 = ref object of OpenApiRestCall_578355
proc url_DriveParentsDelete_579650(protocol: Scheme; host: string; base: string;
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

proc validate_DriveParentsDelete_579649(path: JsonNode; query: JsonNode;
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
  var valid_579651 = path.getOrDefault("fileId")
  valid_579651 = validateParameter(valid_579651, JString, required = true,
                                 default = nil)
  if valid_579651 != nil:
    section.add "fileId", valid_579651
  var valid_579652 = path.getOrDefault("parentId")
  valid_579652 = validateParameter(valid_579652, JString, required = true,
                                 default = nil)
  if valid_579652 != nil:
    section.add "parentId", valid_579652
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
  var valid_579653 = query.getOrDefault("key")
  valid_579653 = validateParameter(valid_579653, JString, required = false,
                                 default = nil)
  if valid_579653 != nil:
    section.add "key", valid_579653
  var valid_579654 = query.getOrDefault("prettyPrint")
  valid_579654 = validateParameter(valid_579654, JBool, required = false,
                                 default = newJBool(true))
  if valid_579654 != nil:
    section.add "prettyPrint", valid_579654
  var valid_579655 = query.getOrDefault("oauth_token")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "oauth_token", valid_579655
  var valid_579656 = query.getOrDefault("alt")
  valid_579656 = validateParameter(valid_579656, JString, required = false,
                                 default = newJString("json"))
  if valid_579656 != nil:
    section.add "alt", valid_579656
  var valid_579657 = query.getOrDefault("userIp")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "userIp", valid_579657
  var valid_579658 = query.getOrDefault("quotaUser")
  valid_579658 = validateParameter(valid_579658, JString, required = false,
                                 default = nil)
  if valid_579658 != nil:
    section.add "quotaUser", valid_579658
  var valid_579659 = query.getOrDefault("fields")
  valid_579659 = validateParameter(valid_579659, JString, required = false,
                                 default = nil)
  if valid_579659 != nil:
    section.add "fields", valid_579659
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579660: Call_DriveParentsDelete_579648; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a parent from a file.
  ## 
  let valid = call_579660.validator(path, query, header, formData, body)
  let scheme = call_579660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579660.url(scheme.get, call_579660.host, call_579660.base,
                         call_579660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579660, url, valid)

proc call*(call_579661: Call_DriveParentsDelete_579648; fileId: string;
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
  var path_579662 = newJObject()
  var query_579663 = newJObject()
  add(query_579663, "key", newJString(key))
  add(query_579663, "prettyPrint", newJBool(prettyPrint))
  add(query_579663, "oauth_token", newJString(oauthToken))
  add(query_579663, "alt", newJString(alt))
  add(query_579663, "userIp", newJString(userIp))
  add(query_579663, "quotaUser", newJString(quotaUser))
  add(path_579662, "fileId", newJString(fileId))
  add(path_579662, "parentId", newJString(parentId))
  add(query_579663, "fields", newJString(fields))
  result = call_579661.call(path_579662, query_579663, nil, nil, nil)

var driveParentsDelete* = Call_DriveParentsDelete_579648(
    name: "driveParentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/parents/{parentId}",
    validator: validate_DriveParentsDelete_579649, base: "/drive/v2",
    url: url_DriveParentsDelete_579650, schemes: {Scheme.Https})
type
  Call_DrivePermissionsInsert_579684 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsInsert_579686(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsInsert_579685(path: JsonNode; query: JsonNode;
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
  var valid_579687 = path.getOrDefault("fileId")
  valid_579687 = validateParameter(valid_579687, JString, required = true,
                                 default = nil)
  if valid_579687 != nil:
    section.add "fileId", valid_579687
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
  var valid_579688 = query.getOrDefault("key")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = nil)
  if valid_579688 != nil:
    section.add "key", valid_579688
  var valid_579689 = query.getOrDefault("prettyPrint")
  valid_579689 = validateParameter(valid_579689, JBool, required = false,
                                 default = newJBool(true))
  if valid_579689 != nil:
    section.add "prettyPrint", valid_579689
  var valid_579690 = query.getOrDefault("oauth_token")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "oauth_token", valid_579690
  var valid_579691 = query.getOrDefault("useDomainAdminAccess")
  valid_579691 = validateParameter(valid_579691, JBool, required = false,
                                 default = newJBool(false))
  if valid_579691 != nil:
    section.add "useDomainAdminAccess", valid_579691
  var valid_579692 = query.getOrDefault("alt")
  valid_579692 = validateParameter(valid_579692, JString, required = false,
                                 default = newJString("json"))
  if valid_579692 != nil:
    section.add "alt", valid_579692
  var valid_579693 = query.getOrDefault("userIp")
  valid_579693 = validateParameter(valid_579693, JString, required = false,
                                 default = nil)
  if valid_579693 != nil:
    section.add "userIp", valid_579693
  var valid_579694 = query.getOrDefault("quotaUser")
  valid_579694 = validateParameter(valid_579694, JString, required = false,
                                 default = nil)
  if valid_579694 != nil:
    section.add "quotaUser", valid_579694
  var valid_579695 = query.getOrDefault("sendNotificationEmails")
  valid_579695 = validateParameter(valid_579695, JBool, required = false,
                                 default = newJBool(true))
  if valid_579695 != nil:
    section.add "sendNotificationEmails", valid_579695
  var valid_579696 = query.getOrDefault("supportsTeamDrives")
  valid_579696 = validateParameter(valid_579696, JBool, required = false,
                                 default = newJBool(false))
  if valid_579696 != nil:
    section.add "supportsTeamDrives", valid_579696
  var valid_579697 = query.getOrDefault("emailMessage")
  valid_579697 = validateParameter(valid_579697, JString, required = false,
                                 default = nil)
  if valid_579697 != nil:
    section.add "emailMessage", valid_579697
  var valid_579698 = query.getOrDefault("supportsAllDrives")
  valid_579698 = validateParameter(valid_579698, JBool, required = false,
                                 default = newJBool(false))
  if valid_579698 != nil:
    section.add "supportsAllDrives", valid_579698
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

proc call*(call_579701: Call_DrivePermissionsInsert_579684; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a permission for a file or shared drive.
  ## 
  let valid = call_579701.validator(path, query, header, formData, body)
  let scheme = call_579701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579701.url(scheme.get, call_579701.host, call_579701.base,
                         call_579701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579701, url, valid)

proc call*(call_579702: Call_DrivePermissionsInsert_579684; fileId: string;
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
  var path_579703 = newJObject()
  var query_579704 = newJObject()
  var body_579705 = newJObject()
  add(query_579704, "key", newJString(key))
  add(query_579704, "prettyPrint", newJBool(prettyPrint))
  add(query_579704, "oauth_token", newJString(oauthToken))
  add(query_579704, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579704, "alt", newJString(alt))
  add(query_579704, "userIp", newJString(userIp))
  add(query_579704, "quotaUser", newJString(quotaUser))
  add(path_579703, "fileId", newJString(fileId))
  add(query_579704, "sendNotificationEmails", newJBool(sendNotificationEmails))
  add(query_579704, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579704, "emailMessage", newJString(emailMessage))
  add(query_579704, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_579705 = body
  add(query_579704, "fields", newJString(fields))
  result = call_579702.call(path_579703, query_579704, nil, nil, body_579705)

var drivePermissionsInsert* = Call_DrivePermissionsInsert_579684(
    name: "drivePermissionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsInsert_579685, base: "/drive/v2",
    url: url_DrivePermissionsInsert_579686, schemes: {Scheme.Https})
type
  Call_DrivePermissionsList_579664 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsList_579666(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsList_579665(path: JsonNode; query: JsonNode;
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
  var valid_579667 = path.getOrDefault("fileId")
  valid_579667 = validateParameter(valid_579667, JString, required = true,
                                 default = nil)
  if valid_579667 != nil:
    section.add "fileId", valid_579667
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
  var valid_579668 = query.getOrDefault("key")
  valid_579668 = validateParameter(valid_579668, JString, required = false,
                                 default = nil)
  if valid_579668 != nil:
    section.add "key", valid_579668
  var valid_579669 = query.getOrDefault("prettyPrint")
  valid_579669 = validateParameter(valid_579669, JBool, required = false,
                                 default = newJBool(true))
  if valid_579669 != nil:
    section.add "prettyPrint", valid_579669
  var valid_579670 = query.getOrDefault("oauth_token")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = nil)
  if valid_579670 != nil:
    section.add "oauth_token", valid_579670
  var valid_579671 = query.getOrDefault("useDomainAdminAccess")
  valid_579671 = validateParameter(valid_579671, JBool, required = false,
                                 default = newJBool(false))
  if valid_579671 != nil:
    section.add "useDomainAdminAccess", valid_579671
  var valid_579672 = query.getOrDefault("alt")
  valid_579672 = validateParameter(valid_579672, JString, required = false,
                                 default = newJString("json"))
  if valid_579672 != nil:
    section.add "alt", valid_579672
  var valid_579673 = query.getOrDefault("userIp")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = nil)
  if valid_579673 != nil:
    section.add "userIp", valid_579673
  var valid_579674 = query.getOrDefault("quotaUser")
  valid_579674 = validateParameter(valid_579674, JString, required = false,
                                 default = nil)
  if valid_579674 != nil:
    section.add "quotaUser", valid_579674
  var valid_579675 = query.getOrDefault("pageToken")
  valid_579675 = validateParameter(valid_579675, JString, required = false,
                                 default = nil)
  if valid_579675 != nil:
    section.add "pageToken", valid_579675
  var valid_579676 = query.getOrDefault("supportsTeamDrives")
  valid_579676 = validateParameter(valid_579676, JBool, required = false,
                                 default = newJBool(false))
  if valid_579676 != nil:
    section.add "supportsTeamDrives", valid_579676
  var valid_579677 = query.getOrDefault("supportsAllDrives")
  valid_579677 = validateParameter(valid_579677, JBool, required = false,
                                 default = newJBool(false))
  if valid_579677 != nil:
    section.add "supportsAllDrives", valid_579677
  var valid_579678 = query.getOrDefault("fields")
  valid_579678 = validateParameter(valid_579678, JString, required = false,
                                 default = nil)
  if valid_579678 != nil:
    section.add "fields", valid_579678
  var valid_579679 = query.getOrDefault("maxResults")
  valid_579679 = validateParameter(valid_579679, JInt, required = false, default = nil)
  if valid_579679 != nil:
    section.add "maxResults", valid_579679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579680: Call_DrivePermissionsList_579664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's or shared drive's permissions.
  ## 
  let valid = call_579680.validator(path, query, header, formData, body)
  let scheme = call_579680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579680.url(scheme.get, call_579680.host, call_579680.base,
                         call_579680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579680, url, valid)

proc call*(call_579681: Call_DrivePermissionsList_579664; fileId: string;
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
  var path_579682 = newJObject()
  var query_579683 = newJObject()
  add(query_579683, "key", newJString(key))
  add(query_579683, "prettyPrint", newJBool(prettyPrint))
  add(query_579683, "oauth_token", newJString(oauthToken))
  add(query_579683, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579683, "alt", newJString(alt))
  add(query_579683, "userIp", newJString(userIp))
  add(query_579683, "quotaUser", newJString(quotaUser))
  add(path_579682, "fileId", newJString(fileId))
  add(query_579683, "pageToken", newJString(pageToken))
  add(query_579683, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579683, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579683, "fields", newJString(fields))
  add(query_579683, "maxResults", newJInt(maxResults))
  result = call_579681.call(path_579682, query_579683, nil, nil, nil)

var drivePermissionsList* = Call_DrivePermissionsList_579664(
    name: "drivePermissionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/permissions",
    validator: validate_DrivePermissionsList_579665, base: "/drive/v2",
    url: url_DrivePermissionsList_579666, schemes: {Scheme.Https})
type
  Call_DrivePermissionsUpdate_579725 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsUpdate_579727(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsUpdate_579726(path: JsonNode; query: JsonNode;
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
  var valid_579728 = path.getOrDefault("fileId")
  valid_579728 = validateParameter(valid_579728, JString, required = true,
                                 default = nil)
  if valid_579728 != nil:
    section.add "fileId", valid_579728
  var valid_579729 = path.getOrDefault("permissionId")
  valid_579729 = validateParameter(valid_579729, JString, required = true,
                                 default = nil)
  if valid_579729 != nil:
    section.add "permissionId", valid_579729
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
  var valid_579730 = query.getOrDefault("key")
  valid_579730 = validateParameter(valid_579730, JString, required = false,
                                 default = nil)
  if valid_579730 != nil:
    section.add "key", valid_579730
  var valid_579731 = query.getOrDefault("prettyPrint")
  valid_579731 = validateParameter(valid_579731, JBool, required = false,
                                 default = newJBool(true))
  if valid_579731 != nil:
    section.add "prettyPrint", valid_579731
  var valid_579732 = query.getOrDefault("oauth_token")
  valid_579732 = validateParameter(valid_579732, JString, required = false,
                                 default = nil)
  if valid_579732 != nil:
    section.add "oauth_token", valid_579732
  var valid_579733 = query.getOrDefault("useDomainAdminAccess")
  valid_579733 = validateParameter(valid_579733, JBool, required = false,
                                 default = newJBool(false))
  if valid_579733 != nil:
    section.add "useDomainAdminAccess", valid_579733
  var valid_579734 = query.getOrDefault("removeExpiration")
  valid_579734 = validateParameter(valid_579734, JBool, required = false,
                                 default = newJBool(false))
  if valid_579734 != nil:
    section.add "removeExpiration", valid_579734
  var valid_579735 = query.getOrDefault("alt")
  valid_579735 = validateParameter(valid_579735, JString, required = false,
                                 default = newJString("json"))
  if valid_579735 != nil:
    section.add "alt", valid_579735
  var valid_579736 = query.getOrDefault("userIp")
  valid_579736 = validateParameter(valid_579736, JString, required = false,
                                 default = nil)
  if valid_579736 != nil:
    section.add "userIp", valid_579736
  var valid_579737 = query.getOrDefault("quotaUser")
  valid_579737 = validateParameter(valid_579737, JString, required = false,
                                 default = nil)
  if valid_579737 != nil:
    section.add "quotaUser", valid_579737
  var valid_579738 = query.getOrDefault("supportsTeamDrives")
  valid_579738 = validateParameter(valid_579738, JBool, required = false,
                                 default = newJBool(false))
  if valid_579738 != nil:
    section.add "supportsTeamDrives", valid_579738
  var valid_579739 = query.getOrDefault("transferOwnership")
  valid_579739 = validateParameter(valid_579739, JBool, required = false,
                                 default = newJBool(false))
  if valid_579739 != nil:
    section.add "transferOwnership", valid_579739
  var valid_579740 = query.getOrDefault("supportsAllDrives")
  valid_579740 = validateParameter(valid_579740, JBool, required = false,
                                 default = newJBool(false))
  if valid_579740 != nil:
    section.add "supportsAllDrives", valid_579740
  var valid_579741 = query.getOrDefault("fields")
  valid_579741 = validateParameter(valid_579741, JString, required = false,
                                 default = nil)
  if valid_579741 != nil:
    section.add "fields", valid_579741
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

proc call*(call_579743: Call_DrivePermissionsUpdate_579725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission.
  ## 
  let valid = call_579743.validator(path, query, header, formData, body)
  let scheme = call_579743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579743.url(scheme.get, call_579743.host, call_579743.base,
                         call_579743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579743, url, valid)

proc call*(call_579744: Call_DrivePermissionsUpdate_579725; fileId: string;
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
  var path_579745 = newJObject()
  var query_579746 = newJObject()
  var body_579747 = newJObject()
  add(query_579746, "key", newJString(key))
  add(query_579746, "prettyPrint", newJBool(prettyPrint))
  add(query_579746, "oauth_token", newJString(oauthToken))
  add(query_579746, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579746, "removeExpiration", newJBool(removeExpiration))
  add(query_579746, "alt", newJString(alt))
  add(query_579746, "userIp", newJString(userIp))
  add(query_579746, "quotaUser", newJString(quotaUser))
  add(path_579745, "fileId", newJString(fileId))
  add(query_579746, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579746, "transferOwnership", newJBool(transferOwnership))
  add(query_579746, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_579747 = body
  add(query_579746, "fields", newJString(fields))
  add(path_579745, "permissionId", newJString(permissionId))
  result = call_579744.call(path_579745, query_579746, nil, nil, body_579747)

var drivePermissionsUpdate* = Call_DrivePermissionsUpdate_579725(
    name: "drivePermissionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsUpdate_579726, base: "/drive/v2",
    url: url_DrivePermissionsUpdate_579727, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGet_579706 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsGet_579708(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsGet_579707(path: JsonNode; query: JsonNode;
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
  var valid_579709 = path.getOrDefault("fileId")
  valid_579709 = validateParameter(valid_579709, JString, required = true,
                                 default = nil)
  if valid_579709 != nil:
    section.add "fileId", valid_579709
  var valid_579710 = path.getOrDefault("permissionId")
  valid_579710 = validateParameter(valid_579710, JString, required = true,
                                 default = nil)
  if valid_579710 != nil:
    section.add "permissionId", valid_579710
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
  var valid_579714 = query.getOrDefault("useDomainAdminAccess")
  valid_579714 = validateParameter(valid_579714, JBool, required = false,
                                 default = newJBool(false))
  if valid_579714 != nil:
    section.add "useDomainAdminAccess", valid_579714
  var valid_579715 = query.getOrDefault("alt")
  valid_579715 = validateParameter(valid_579715, JString, required = false,
                                 default = newJString("json"))
  if valid_579715 != nil:
    section.add "alt", valid_579715
  var valid_579716 = query.getOrDefault("userIp")
  valid_579716 = validateParameter(valid_579716, JString, required = false,
                                 default = nil)
  if valid_579716 != nil:
    section.add "userIp", valid_579716
  var valid_579717 = query.getOrDefault("quotaUser")
  valid_579717 = validateParameter(valid_579717, JString, required = false,
                                 default = nil)
  if valid_579717 != nil:
    section.add "quotaUser", valid_579717
  var valid_579718 = query.getOrDefault("supportsTeamDrives")
  valid_579718 = validateParameter(valid_579718, JBool, required = false,
                                 default = newJBool(false))
  if valid_579718 != nil:
    section.add "supportsTeamDrives", valid_579718
  var valid_579719 = query.getOrDefault("supportsAllDrives")
  valid_579719 = validateParameter(valid_579719, JBool, required = false,
                                 default = newJBool(false))
  if valid_579719 != nil:
    section.add "supportsAllDrives", valid_579719
  var valid_579720 = query.getOrDefault("fields")
  valid_579720 = validateParameter(valid_579720, JString, required = false,
                                 default = nil)
  if valid_579720 != nil:
    section.add "fields", valid_579720
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579721: Call_DrivePermissionsGet_579706; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a permission by ID.
  ## 
  let valid = call_579721.validator(path, query, header, formData, body)
  let scheme = call_579721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579721.url(scheme.get, call_579721.host, call_579721.base,
                         call_579721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579721, url, valid)

proc call*(call_579722: Call_DrivePermissionsGet_579706; fileId: string;
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
  var path_579723 = newJObject()
  var query_579724 = newJObject()
  add(query_579724, "key", newJString(key))
  add(query_579724, "prettyPrint", newJBool(prettyPrint))
  add(query_579724, "oauth_token", newJString(oauthToken))
  add(query_579724, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579724, "alt", newJString(alt))
  add(query_579724, "userIp", newJString(userIp))
  add(query_579724, "quotaUser", newJString(quotaUser))
  add(path_579723, "fileId", newJString(fileId))
  add(query_579724, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579724, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579724, "fields", newJString(fields))
  add(path_579723, "permissionId", newJString(permissionId))
  result = call_579722.call(path_579723, query_579724, nil, nil, nil)

var drivePermissionsGet* = Call_DrivePermissionsGet_579706(
    name: "drivePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsGet_579707, base: "/drive/v2",
    url: url_DrivePermissionsGet_579708, schemes: {Scheme.Https})
type
  Call_DrivePermissionsPatch_579767 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsPatch_579769(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsPatch_579768(path: JsonNode; query: JsonNode;
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
  var valid_579770 = path.getOrDefault("fileId")
  valid_579770 = validateParameter(valid_579770, JString, required = true,
                                 default = nil)
  if valid_579770 != nil:
    section.add "fileId", valid_579770
  var valid_579771 = path.getOrDefault("permissionId")
  valid_579771 = validateParameter(valid_579771, JString, required = true,
                                 default = nil)
  if valid_579771 != nil:
    section.add "permissionId", valid_579771
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
  var valid_579772 = query.getOrDefault("key")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "key", valid_579772
  var valid_579773 = query.getOrDefault("prettyPrint")
  valid_579773 = validateParameter(valid_579773, JBool, required = false,
                                 default = newJBool(true))
  if valid_579773 != nil:
    section.add "prettyPrint", valid_579773
  var valid_579774 = query.getOrDefault("oauth_token")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "oauth_token", valid_579774
  var valid_579775 = query.getOrDefault("useDomainAdminAccess")
  valid_579775 = validateParameter(valid_579775, JBool, required = false,
                                 default = newJBool(false))
  if valid_579775 != nil:
    section.add "useDomainAdminAccess", valid_579775
  var valid_579776 = query.getOrDefault("removeExpiration")
  valid_579776 = validateParameter(valid_579776, JBool, required = false,
                                 default = newJBool(false))
  if valid_579776 != nil:
    section.add "removeExpiration", valid_579776
  var valid_579777 = query.getOrDefault("alt")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = newJString("json"))
  if valid_579777 != nil:
    section.add "alt", valid_579777
  var valid_579778 = query.getOrDefault("userIp")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "userIp", valid_579778
  var valid_579779 = query.getOrDefault("quotaUser")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "quotaUser", valid_579779
  var valid_579780 = query.getOrDefault("supportsTeamDrives")
  valid_579780 = validateParameter(valid_579780, JBool, required = false,
                                 default = newJBool(false))
  if valid_579780 != nil:
    section.add "supportsTeamDrives", valid_579780
  var valid_579781 = query.getOrDefault("transferOwnership")
  valid_579781 = validateParameter(valid_579781, JBool, required = false,
                                 default = newJBool(false))
  if valid_579781 != nil:
    section.add "transferOwnership", valid_579781
  var valid_579782 = query.getOrDefault("supportsAllDrives")
  valid_579782 = validateParameter(valid_579782, JBool, required = false,
                                 default = newJBool(false))
  if valid_579782 != nil:
    section.add "supportsAllDrives", valid_579782
  var valid_579783 = query.getOrDefault("fields")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "fields", valid_579783
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

proc call*(call_579785: Call_DrivePermissionsPatch_579767; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a permission using patch semantics.
  ## 
  let valid = call_579785.validator(path, query, header, formData, body)
  let scheme = call_579785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579785.url(scheme.get, call_579785.host, call_579785.base,
                         call_579785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579785, url, valid)

proc call*(call_579786: Call_DrivePermissionsPatch_579767; fileId: string;
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
  var path_579787 = newJObject()
  var query_579788 = newJObject()
  var body_579789 = newJObject()
  add(query_579788, "key", newJString(key))
  add(query_579788, "prettyPrint", newJBool(prettyPrint))
  add(query_579788, "oauth_token", newJString(oauthToken))
  add(query_579788, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579788, "removeExpiration", newJBool(removeExpiration))
  add(query_579788, "alt", newJString(alt))
  add(query_579788, "userIp", newJString(userIp))
  add(query_579788, "quotaUser", newJString(quotaUser))
  add(path_579787, "fileId", newJString(fileId))
  add(query_579788, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579788, "transferOwnership", newJBool(transferOwnership))
  add(query_579788, "supportsAllDrives", newJBool(supportsAllDrives))
  if body != nil:
    body_579789 = body
  add(query_579788, "fields", newJString(fields))
  add(path_579787, "permissionId", newJString(permissionId))
  result = call_579786.call(path_579787, query_579788, nil, nil, body_579789)

var drivePermissionsPatch* = Call_DrivePermissionsPatch_579767(
    name: "drivePermissionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsPatch_579768, base: "/drive/v2",
    url: url_DrivePermissionsPatch_579769, schemes: {Scheme.Https})
type
  Call_DrivePermissionsDelete_579748 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsDelete_579750(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePermissionsDelete_579749(path: JsonNode; query: JsonNode;
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
  var valid_579751 = path.getOrDefault("fileId")
  valid_579751 = validateParameter(valid_579751, JString, required = true,
                                 default = nil)
  if valid_579751 != nil:
    section.add "fileId", valid_579751
  var valid_579752 = path.getOrDefault("permissionId")
  valid_579752 = validateParameter(valid_579752, JString, required = true,
                                 default = nil)
  if valid_579752 != nil:
    section.add "permissionId", valid_579752
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
  var valid_579753 = query.getOrDefault("key")
  valid_579753 = validateParameter(valid_579753, JString, required = false,
                                 default = nil)
  if valid_579753 != nil:
    section.add "key", valid_579753
  var valid_579754 = query.getOrDefault("prettyPrint")
  valid_579754 = validateParameter(valid_579754, JBool, required = false,
                                 default = newJBool(true))
  if valid_579754 != nil:
    section.add "prettyPrint", valid_579754
  var valid_579755 = query.getOrDefault("oauth_token")
  valid_579755 = validateParameter(valid_579755, JString, required = false,
                                 default = nil)
  if valid_579755 != nil:
    section.add "oauth_token", valid_579755
  var valid_579756 = query.getOrDefault("useDomainAdminAccess")
  valid_579756 = validateParameter(valid_579756, JBool, required = false,
                                 default = newJBool(false))
  if valid_579756 != nil:
    section.add "useDomainAdminAccess", valid_579756
  var valid_579757 = query.getOrDefault("alt")
  valid_579757 = validateParameter(valid_579757, JString, required = false,
                                 default = newJString("json"))
  if valid_579757 != nil:
    section.add "alt", valid_579757
  var valid_579758 = query.getOrDefault("userIp")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "userIp", valid_579758
  var valid_579759 = query.getOrDefault("quotaUser")
  valid_579759 = validateParameter(valid_579759, JString, required = false,
                                 default = nil)
  if valid_579759 != nil:
    section.add "quotaUser", valid_579759
  var valid_579760 = query.getOrDefault("supportsTeamDrives")
  valid_579760 = validateParameter(valid_579760, JBool, required = false,
                                 default = newJBool(false))
  if valid_579760 != nil:
    section.add "supportsTeamDrives", valid_579760
  var valid_579761 = query.getOrDefault("supportsAllDrives")
  valid_579761 = validateParameter(valid_579761, JBool, required = false,
                                 default = newJBool(false))
  if valid_579761 != nil:
    section.add "supportsAllDrives", valid_579761
  var valid_579762 = query.getOrDefault("fields")
  valid_579762 = validateParameter(valid_579762, JString, required = false,
                                 default = nil)
  if valid_579762 != nil:
    section.add "fields", valid_579762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579763: Call_DrivePermissionsDelete_579748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a permission from a file or shared drive.
  ## 
  let valid = call_579763.validator(path, query, header, formData, body)
  let scheme = call_579763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579763.url(scheme.get, call_579763.host, call_579763.base,
                         call_579763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579763, url, valid)

proc call*(call_579764: Call_DrivePermissionsDelete_579748; fileId: string;
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
  var path_579765 = newJObject()
  var query_579766 = newJObject()
  add(query_579766, "key", newJString(key))
  add(query_579766, "prettyPrint", newJBool(prettyPrint))
  add(query_579766, "oauth_token", newJString(oauthToken))
  add(query_579766, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_579766, "alt", newJString(alt))
  add(query_579766, "userIp", newJString(userIp))
  add(query_579766, "quotaUser", newJString(quotaUser))
  add(path_579765, "fileId", newJString(fileId))
  add(query_579766, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_579766, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_579766, "fields", newJString(fields))
  add(path_579765, "permissionId", newJString(permissionId))
  result = call_579764.call(path_579765, query_579766, nil, nil, nil)

var drivePermissionsDelete* = Call_DrivePermissionsDelete_579748(
    name: "drivePermissionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/files/{fileId}/permissions/{permissionId}",
    validator: validate_DrivePermissionsDelete_579749, base: "/drive/v2",
    url: url_DrivePermissionsDelete_579750, schemes: {Scheme.Https})
type
  Call_DrivePropertiesInsert_579805 = ref object of OpenApiRestCall_578355
proc url_DrivePropertiesInsert_579807(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesInsert_579806(path: JsonNode; query: JsonNode;
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
  var valid_579808 = path.getOrDefault("fileId")
  valid_579808 = validateParameter(valid_579808, JString, required = true,
                                 default = nil)
  if valid_579808 != nil:
    section.add "fileId", valid_579808
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
  var valid_579809 = query.getOrDefault("key")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "key", valid_579809
  var valid_579810 = query.getOrDefault("prettyPrint")
  valid_579810 = validateParameter(valid_579810, JBool, required = false,
                                 default = newJBool(true))
  if valid_579810 != nil:
    section.add "prettyPrint", valid_579810
  var valid_579811 = query.getOrDefault("oauth_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "oauth_token", valid_579811
  var valid_579812 = query.getOrDefault("alt")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = newJString("json"))
  if valid_579812 != nil:
    section.add "alt", valid_579812
  var valid_579813 = query.getOrDefault("userIp")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "userIp", valid_579813
  var valid_579814 = query.getOrDefault("quotaUser")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "quotaUser", valid_579814
  var valid_579815 = query.getOrDefault("fields")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = nil)
  if valid_579815 != nil:
    section.add "fields", valid_579815
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

proc call*(call_579817: Call_DrivePropertiesInsert_579805; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a property to a file, or updates it if it already exists.
  ## 
  let valid = call_579817.validator(path, query, header, formData, body)
  let scheme = call_579817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579817.url(scheme.get, call_579817.host, call_579817.base,
                         call_579817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579817, url, valid)

proc call*(call_579818: Call_DrivePropertiesInsert_579805; fileId: string;
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
  var path_579819 = newJObject()
  var query_579820 = newJObject()
  var body_579821 = newJObject()
  add(query_579820, "key", newJString(key))
  add(query_579820, "prettyPrint", newJBool(prettyPrint))
  add(query_579820, "oauth_token", newJString(oauthToken))
  add(query_579820, "alt", newJString(alt))
  add(query_579820, "userIp", newJString(userIp))
  add(query_579820, "quotaUser", newJString(quotaUser))
  add(path_579819, "fileId", newJString(fileId))
  if body != nil:
    body_579821 = body
  add(query_579820, "fields", newJString(fields))
  result = call_579818.call(path_579819, query_579820, nil, nil, body_579821)

var drivePropertiesInsert* = Call_DrivePropertiesInsert_579805(
    name: "drivePropertiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{fileId}/properties",
    validator: validate_DrivePropertiesInsert_579806, base: "/drive/v2",
    url: url_DrivePropertiesInsert_579807, schemes: {Scheme.Https})
type
  Call_DrivePropertiesList_579790 = ref object of OpenApiRestCall_578355
proc url_DrivePropertiesList_579792(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesList_579791(path: JsonNode; query: JsonNode;
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
  var valid_579793 = path.getOrDefault("fileId")
  valid_579793 = validateParameter(valid_579793, JString, required = true,
                                 default = nil)
  if valid_579793 != nil:
    section.add "fileId", valid_579793
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
  var valid_579794 = query.getOrDefault("key")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "key", valid_579794
  var valid_579795 = query.getOrDefault("prettyPrint")
  valid_579795 = validateParameter(valid_579795, JBool, required = false,
                                 default = newJBool(true))
  if valid_579795 != nil:
    section.add "prettyPrint", valid_579795
  var valid_579796 = query.getOrDefault("oauth_token")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "oauth_token", valid_579796
  var valid_579797 = query.getOrDefault("alt")
  valid_579797 = validateParameter(valid_579797, JString, required = false,
                                 default = newJString("json"))
  if valid_579797 != nil:
    section.add "alt", valid_579797
  var valid_579798 = query.getOrDefault("userIp")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "userIp", valid_579798
  var valid_579799 = query.getOrDefault("quotaUser")
  valid_579799 = validateParameter(valid_579799, JString, required = false,
                                 default = nil)
  if valid_579799 != nil:
    section.add "quotaUser", valid_579799
  var valid_579800 = query.getOrDefault("fields")
  valid_579800 = validateParameter(valid_579800, JString, required = false,
                                 default = nil)
  if valid_579800 != nil:
    section.add "fields", valid_579800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579801: Call_DrivePropertiesList_579790; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's properties.
  ## 
  let valid = call_579801.validator(path, query, header, formData, body)
  let scheme = call_579801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579801.url(scheme.get, call_579801.host, call_579801.base,
                         call_579801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579801, url, valid)

proc call*(call_579802: Call_DrivePropertiesList_579790; fileId: string;
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
  var path_579803 = newJObject()
  var query_579804 = newJObject()
  add(query_579804, "key", newJString(key))
  add(query_579804, "prettyPrint", newJBool(prettyPrint))
  add(query_579804, "oauth_token", newJString(oauthToken))
  add(query_579804, "alt", newJString(alt))
  add(query_579804, "userIp", newJString(userIp))
  add(query_579804, "quotaUser", newJString(quotaUser))
  add(path_579803, "fileId", newJString(fileId))
  add(query_579804, "fields", newJString(fields))
  result = call_579802.call(path_579803, query_579804, nil, nil, nil)

var drivePropertiesList* = Call_DrivePropertiesList_579790(
    name: "drivePropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/properties",
    validator: validate_DrivePropertiesList_579791, base: "/drive/v2",
    url: url_DrivePropertiesList_579792, schemes: {Scheme.Https})
type
  Call_DrivePropertiesUpdate_579839 = ref object of OpenApiRestCall_578355
proc url_DrivePropertiesUpdate_579841(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesUpdate_579840(path: JsonNode; query: JsonNode;
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
  var valid_579842 = path.getOrDefault("fileId")
  valid_579842 = validateParameter(valid_579842, JString, required = true,
                                 default = nil)
  if valid_579842 != nil:
    section.add "fileId", valid_579842
  var valid_579843 = path.getOrDefault("propertyKey")
  valid_579843 = validateParameter(valid_579843, JString, required = true,
                                 default = nil)
  if valid_579843 != nil:
    section.add "propertyKey", valid_579843
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
  var valid_579844 = query.getOrDefault("key")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "key", valid_579844
  var valid_579845 = query.getOrDefault("prettyPrint")
  valid_579845 = validateParameter(valid_579845, JBool, required = false,
                                 default = newJBool(true))
  if valid_579845 != nil:
    section.add "prettyPrint", valid_579845
  var valid_579846 = query.getOrDefault("oauth_token")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "oauth_token", valid_579846
  var valid_579847 = query.getOrDefault("alt")
  valid_579847 = validateParameter(valid_579847, JString, required = false,
                                 default = newJString("json"))
  if valid_579847 != nil:
    section.add "alt", valid_579847
  var valid_579848 = query.getOrDefault("userIp")
  valid_579848 = validateParameter(valid_579848, JString, required = false,
                                 default = nil)
  if valid_579848 != nil:
    section.add "userIp", valid_579848
  var valid_579849 = query.getOrDefault("quotaUser")
  valid_579849 = validateParameter(valid_579849, JString, required = false,
                                 default = nil)
  if valid_579849 != nil:
    section.add "quotaUser", valid_579849
  var valid_579850 = query.getOrDefault("visibility")
  valid_579850 = validateParameter(valid_579850, JString, required = false,
                                 default = newJString("private"))
  if valid_579850 != nil:
    section.add "visibility", valid_579850
  var valid_579851 = query.getOrDefault("fields")
  valid_579851 = validateParameter(valid_579851, JString, required = false,
                                 default = nil)
  if valid_579851 != nil:
    section.add "fields", valid_579851
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

proc call*(call_579853: Call_DrivePropertiesUpdate_579839; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a property.
  ## 
  let valid = call_579853.validator(path, query, header, formData, body)
  let scheme = call_579853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579853.url(scheme.get, call_579853.host, call_579853.base,
                         call_579853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579853, url, valid)

proc call*(call_579854: Call_DrivePropertiesUpdate_579839; fileId: string;
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
  var path_579855 = newJObject()
  var query_579856 = newJObject()
  var body_579857 = newJObject()
  add(query_579856, "key", newJString(key))
  add(query_579856, "prettyPrint", newJBool(prettyPrint))
  add(query_579856, "oauth_token", newJString(oauthToken))
  add(query_579856, "alt", newJString(alt))
  add(query_579856, "userIp", newJString(userIp))
  add(query_579856, "quotaUser", newJString(quotaUser))
  add(path_579855, "fileId", newJString(fileId))
  add(query_579856, "visibility", newJString(visibility))
  add(path_579855, "propertyKey", newJString(propertyKey))
  if body != nil:
    body_579857 = body
  add(query_579856, "fields", newJString(fields))
  result = call_579854.call(path_579855, query_579856, nil, nil, body_579857)

var drivePropertiesUpdate* = Call_DrivePropertiesUpdate_579839(
    name: "drivePropertiesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesUpdate_579840, base: "/drive/v2",
    url: url_DrivePropertiesUpdate_579841, schemes: {Scheme.Https})
type
  Call_DrivePropertiesGet_579822 = ref object of OpenApiRestCall_578355
proc url_DrivePropertiesGet_579824(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesGet_579823(path: JsonNode; query: JsonNode;
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
  var valid_579825 = path.getOrDefault("fileId")
  valid_579825 = validateParameter(valid_579825, JString, required = true,
                                 default = nil)
  if valid_579825 != nil:
    section.add "fileId", valid_579825
  var valid_579826 = path.getOrDefault("propertyKey")
  valid_579826 = validateParameter(valid_579826, JString, required = true,
                                 default = nil)
  if valid_579826 != nil:
    section.add "propertyKey", valid_579826
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
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("prettyPrint")
  valid_579828 = validateParameter(valid_579828, JBool, required = false,
                                 default = newJBool(true))
  if valid_579828 != nil:
    section.add "prettyPrint", valid_579828
  var valid_579829 = query.getOrDefault("oauth_token")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "oauth_token", valid_579829
  var valid_579830 = query.getOrDefault("alt")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = newJString("json"))
  if valid_579830 != nil:
    section.add "alt", valid_579830
  var valid_579831 = query.getOrDefault("userIp")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "userIp", valid_579831
  var valid_579832 = query.getOrDefault("quotaUser")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "quotaUser", valid_579832
  var valid_579833 = query.getOrDefault("visibility")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = newJString("private"))
  if valid_579833 != nil:
    section.add "visibility", valid_579833
  var valid_579834 = query.getOrDefault("fields")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "fields", valid_579834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579835: Call_DrivePropertiesGet_579822; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a property by its key.
  ## 
  let valid = call_579835.validator(path, query, header, formData, body)
  let scheme = call_579835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579835.url(scheme.get, call_579835.host, call_579835.base,
                         call_579835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579835, url, valid)

proc call*(call_579836: Call_DrivePropertiesGet_579822; fileId: string;
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
  var path_579837 = newJObject()
  var query_579838 = newJObject()
  add(query_579838, "key", newJString(key))
  add(query_579838, "prettyPrint", newJBool(prettyPrint))
  add(query_579838, "oauth_token", newJString(oauthToken))
  add(query_579838, "alt", newJString(alt))
  add(query_579838, "userIp", newJString(userIp))
  add(query_579838, "quotaUser", newJString(quotaUser))
  add(path_579837, "fileId", newJString(fileId))
  add(query_579838, "visibility", newJString(visibility))
  add(path_579837, "propertyKey", newJString(propertyKey))
  add(query_579838, "fields", newJString(fields))
  result = call_579836.call(path_579837, query_579838, nil, nil, nil)

var drivePropertiesGet* = Call_DrivePropertiesGet_579822(
    name: "drivePropertiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesGet_579823, base: "/drive/v2",
    url: url_DrivePropertiesGet_579824, schemes: {Scheme.Https})
type
  Call_DrivePropertiesPatch_579875 = ref object of OpenApiRestCall_578355
proc url_DrivePropertiesPatch_579877(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesPatch_579876(path: JsonNode; query: JsonNode;
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
  var valid_579878 = path.getOrDefault("fileId")
  valid_579878 = validateParameter(valid_579878, JString, required = true,
                                 default = nil)
  if valid_579878 != nil:
    section.add "fileId", valid_579878
  var valid_579879 = path.getOrDefault("propertyKey")
  valid_579879 = validateParameter(valid_579879, JString, required = true,
                                 default = nil)
  if valid_579879 != nil:
    section.add "propertyKey", valid_579879
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
  var valid_579880 = query.getOrDefault("key")
  valid_579880 = validateParameter(valid_579880, JString, required = false,
                                 default = nil)
  if valid_579880 != nil:
    section.add "key", valid_579880
  var valid_579881 = query.getOrDefault("prettyPrint")
  valid_579881 = validateParameter(valid_579881, JBool, required = false,
                                 default = newJBool(true))
  if valid_579881 != nil:
    section.add "prettyPrint", valid_579881
  var valid_579882 = query.getOrDefault("oauth_token")
  valid_579882 = validateParameter(valid_579882, JString, required = false,
                                 default = nil)
  if valid_579882 != nil:
    section.add "oauth_token", valid_579882
  var valid_579883 = query.getOrDefault("alt")
  valid_579883 = validateParameter(valid_579883, JString, required = false,
                                 default = newJString("json"))
  if valid_579883 != nil:
    section.add "alt", valid_579883
  var valid_579884 = query.getOrDefault("userIp")
  valid_579884 = validateParameter(valid_579884, JString, required = false,
                                 default = nil)
  if valid_579884 != nil:
    section.add "userIp", valid_579884
  var valid_579885 = query.getOrDefault("quotaUser")
  valid_579885 = validateParameter(valid_579885, JString, required = false,
                                 default = nil)
  if valid_579885 != nil:
    section.add "quotaUser", valid_579885
  var valid_579886 = query.getOrDefault("visibility")
  valid_579886 = validateParameter(valid_579886, JString, required = false,
                                 default = newJString("private"))
  if valid_579886 != nil:
    section.add "visibility", valid_579886
  var valid_579887 = query.getOrDefault("fields")
  valid_579887 = validateParameter(valid_579887, JString, required = false,
                                 default = nil)
  if valid_579887 != nil:
    section.add "fields", valid_579887
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

proc call*(call_579889: Call_DrivePropertiesPatch_579875; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a property.
  ## 
  let valid = call_579889.validator(path, query, header, formData, body)
  let scheme = call_579889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579889.url(scheme.get, call_579889.host, call_579889.base,
                         call_579889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579889, url, valid)

proc call*(call_579890: Call_DrivePropertiesPatch_579875; fileId: string;
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
  var path_579891 = newJObject()
  var query_579892 = newJObject()
  var body_579893 = newJObject()
  add(query_579892, "key", newJString(key))
  add(query_579892, "prettyPrint", newJBool(prettyPrint))
  add(query_579892, "oauth_token", newJString(oauthToken))
  add(query_579892, "alt", newJString(alt))
  add(query_579892, "userIp", newJString(userIp))
  add(query_579892, "quotaUser", newJString(quotaUser))
  add(path_579891, "fileId", newJString(fileId))
  add(query_579892, "visibility", newJString(visibility))
  add(path_579891, "propertyKey", newJString(propertyKey))
  if body != nil:
    body_579893 = body
  add(query_579892, "fields", newJString(fields))
  result = call_579890.call(path_579891, query_579892, nil, nil, body_579893)

var drivePropertiesPatch* = Call_DrivePropertiesPatch_579875(
    name: "drivePropertiesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesPatch_579876, base: "/drive/v2",
    url: url_DrivePropertiesPatch_579877, schemes: {Scheme.Https})
type
  Call_DrivePropertiesDelete_579858 = ref object of OpenApiRestCall_578355
proc url_DrivePropertiesDelete_579860(protocol: Scheme; host: string; base: string;
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

proc validate_DrivePropertiesDelete_579859(path: JsonNode; query: JsonNode;
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
  var valid_579861 = path.getOrDefault("fileId")
  valid_579861 = validateParameter(valid_579861, JString, required = true,
                                 default = nil)
  if valid_579861 != nil:
    section.add "fileId", valid_579861
  var valid_579862 = path.getOrDefault("propertyKey")
  valid_579862 = validateParameter(valid_579862, JString, required = true,
                                 default = nil)
  if valid_579862 != nil:
    section.add "propertyKey", valid_579862
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
  var valid_579863 = query.getOrDefault("key")
  valid_579863 = validateParameter(valid_579863, JString, required = false,
                                 default = nil)
  if valid_579863 != nil:
    section.add "key", valid_579863
  var valid_579864 = query.getOrDefault("prettyPrint")
  valid_579864 = validateParameter(valid_579864, JBool, required = false,
                                 default = newJBool(true))
  if valid_579864 != nil:
    section.add "prettyPrint", valid_579864
  var valid_579865 = query.getOrDefault("oauth_token")
  valid_579865 = validateParameter(valid_579865, JString, required = false,
                                 default = nil)
  if valid_579865 != nil:
    section.add "oauth_token", valid_579865
  var valid_579866 = query.getOrDefault("alt")
  valid_579866 = validateParameter(valid_579866, JString, required = false,
                                 default = newJString("json"))
  if valid_579866 != nil:
    section.add "alt", valid_579866
  var valid_579867 = query.getOrDefault("userIp")
  valid_579867 = validateParameter(valid_579867, JString, required = false,
                                 default = nil)
  if valid_579867 != nil:
    section.add "userIp", valid_579867
  var valid_579868 = query.getOrDefault("quotaUser")
  valid_579868 = validateParameter(valid_579868, JString, required = false,
                                 default = nil)
  if valid_579868 != nil:
    section.add "quotaUser", valid_579868
  var valid_579869 = query.getOrDefault("visibility")
  valid_579869 = validateParameter(valid_579869, JString, required = false,
                                 default = newJString("private"))
  if valid_579869 != nil:
    section.add "visibility", valid_579869
  var valid_579870 = query.getOrDefault("fields")
  valid_579870 = validateParameter(valid_579870, JString, required = false,
                                 default = nil)
  if valid_579870 != nil:
    section.add "fields", valid_579870
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579871: Call_DrivePropertiesDelete_579858; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a property.
  ## 
  let valid = call_579871.validator(path, query, header, formData, body)
  let scheme = call_579871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579871.url(scheme.get, call_579871.host, call_579871.base,
                         call_579871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579871, url, valid)

proc call*(call_579872: Call_DrivePropertiesDelete_579858; fileId: string;
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
  var path_579873 = newJObject()
  var query_579874 = newJObject()
  add(query_579874, "key", newJString(key))
  add(query_579874, "prettyPrint", newJBool(prettyPrint))
  add(query_579874, "oauth_token", newJString(oauthToken))
  add(query_579874, "alt", newJString(alt))
  add(query_579874, "userIp", newJString(userIp))
  add(query_579874, "quotaUser", newJString(quotaUser))
  add(path_579873, "fileId", newJString(fileId))
  add(query_579874, "visibility", newJString(visibility))
  add(path_579873, "propertyKey", newJString(propertyKey))
  add(query_579874, "fields", newJString(fields))
  result = call_579872.call(path_579873, query_579874, nil, nil, nil)

var drivePropertiesDelete* = Call_DrivePropertiesDelete_579858(
    name: "drivePropertiesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/properties/{propertyKey}",
    validator: validate_DrivePropertiesDelete_579859, base: "/drive/v2",
    url: url_DrivePropertiesDelete_579860, schemes: {Scheme.Https})
type
  Call_DriveRealtimeUpdate_579910 = ref object of OpenApiRestCall_578355
proc url_DriveRealtimeUpdate_579912(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRealtimeUpdate_579911(path: JsonNode; query: JsonNode;
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
  var valid_579913 = path.getOrDefault("fileId")
  valid_579913 = validateParameter(valid_579913, JString, required = true,
                                 default = nil)
  if valid_579913 != nil:
    section.add "fileId", valid_579913
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
  var valid_579917 = query.getOrDefault("baseRevision")
  valid_579917 = validateParameter(valid_579917, JString, required = false,
                                 default = nil)
  if valid_579917 != nil:
    section.add "baseRevision", valid_579917
  var valid_579918 = query.getOrDefault("alt")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = newJString("json"))
  if valid_579918 != nil:
    section.add "alt", valid_579918
  var valid_579919 = query.getOrDefault("userIp")
  valid_579919 = validateParameter(valid_579919, JString, required = false,
                                 default = nil)
  if valid_579919 != nil:
    section.add "userIp", valid_579919
  var valid_579920 = query.getOrDefault("quotaUser")
  valid_579920 = validateParameter(valid_579920, JString, required = false,
                                 default = nil)
  if valid_579920 != nil:
    section.add "quotaUser", valid_579920
  var valid_579921 = query.getOrDefault("fields")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "fields", valid_579921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579922: Call_DriveRealtimeUpdate_579910; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Overwrites the Realtime API data model associated with this file with the provided JSON data model.
  ## 
  let valid = call_579922.validator(path, query, header, formData, body)
  let scheme = call_579922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579922.url(scheme.get, call_579922.host, call_579922.base,
                         call_579922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579922, url, valid)

proc call*(call_579923: Call_DriveRealtimeUpdate_579910; fileId: string;
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
  var path_579924 = newJObject()
  var query_579925 = newJObject()
  add(query_579925, "key", newJString(key))
  add(query_579925, "prettyPrint", newJBool(prettyPrint))
  add(query_579925, "oauth_token", newJString(oauthToken))
  add(query_579925, "baseRevision", newJString(baseRevision))
  add(query_579925, "alt", newJString(alt))
  add(query_579925, "userIp", newJString(userIp))
  add(query_579925, "quotaUser", newJString(quotaUser))
  add(path_579924, "fileId", newJString(fileId))
  add(query_579925, "fields", newJString(fields))
  result = call_579923.call(path_579924, query_579925, nil, nil, nil)

var driveRealtimeUpdate* = Call_DriveRealtimeUpdate_579910(
    name: "driveRealtimeUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/realtime",
    validator: validate_DriveRealtimeUpdate_579911, base: "/drive/v2",
    url: url_DriveRealtimeUpdate_579912, schemes: {Scheme.Https})
type
  Call_DriveRealtimeGet_579894 = ref object of OpenApiRestCall_578355
proc url_DriveRealtimeGet_579896(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRealtimeGet_579895(path: JsonNode; query: JsonNode;
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
  var valid_579897 = path.getOrDefault("fileId")
  valid_579897 = validateParameter(valid_579897, JString, required = true,
                                 default = nil)
  if valid_579897 != nil:
    section.add "fileId", valid_579897
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
  var valid_579904 = query.getOrDefault("revision")
  valid_579904 = validateParameter(valid_579904, JInt, required = false, default = nil)
  if valid_579904 != nil:
    section.add "revision", valid_579904
  var valid_579905 = query.getOrDefault("fields")
  valid_579905 = validateParameter(valid_579905, JString, required = false,
                                 default = nil)
  if valid_579905 != nil:
    section.add "fields", valid_579905
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579906: Call_DriveRealtimeGet_579894; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the contents of the Realtime API data model associated with this file as JSON.
  ## 
  let valid = call_579906.validator(path, query, header, formData, body)
  let scheme = call_579906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579906.url(scheme.get, call_579906.host, call_579906.base,
                         call_579906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579906, url, valid)

proc call*(call_579907: Call_DriveRealtimeGet_579894; fileId: string;
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
  var path_579908 = newJObject()
  var query_579909 = newJObject()
  add(query_579909, "key", newJString(key))
  add(query_579909, "prettyPrint", newJBool(prettyPrint))
  add(query_579909, "oauth_token", newJString(oauthToken))
  add(query_579909, "alt", newJString(alt))
  add(query_579909, "userIp", newJString(userIp))
  add(query_579909, "quotaUser", newJString(quotaUser))
  add(path_579908, "fileId", newJString(fileId))
  add(query_579909, "revision", newJInt(revision))
  add(query_579909, "fields", newJString(fields))
  result = call_579907.call(path_579908, query_579909, nil, nil, nil)

var driveRealtimeGet* = Call_DriveRealtimeGet_579894(name: "driveRealtimeGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/realtime", validator: validate_DriveRealtimeGet_579895,
    base: "/drive/v2", url: url_DriveRealtimeGet_579896, schemes: {Scheme.Https})
type
  Call_DriveRevisionsList_579926 = ref object of OpenApiRestCall_578355
proc url_DriveRevisionsList_579928(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsList_579927(path: JsonNode; query: JsonNode;
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
  var valid_579929 = path.getOrDefault("fileId")
  valid_579929 = validateParameter(valid_579929, JString, required = true,
                                 default = nil)
  if valid_579929 != nil:
    section.add "fileId", valid_579929
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
  var valid_579930 = query.getOrDefault("key")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "key", valid_579930
  var valid_579931 = query.getOrDefault("prettyPrint")
  valid_579931 = validateParameter(valid_579931, JBool, required = false,
                                 default = newJBool(true))
  if valid_579931 != nil:
    section.add "prettyPrint", valid_579931
  var valid_579932 = query.getOrDefault("oauth_token")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "oauth_token", valid_579932
  var valid_579933 = query.getOrDefault("alt")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = newJString("json"))
  if valid_579933 != nil:
    section.add "alt", valid_579933
  var valid_579934 = query.getOrDefault("userIp")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "userIp", valid_579934
  var valid_579935 = query.getOrDefault("quotaUser")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "quotaUser", valid_579935
  var valid_579936 = query.getOrDefault("pageToken")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "pageToken", valid_579936
  var valid_579937 = query.getOrDefault("fields")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "fields", valid_579937
  var valid_579938 = query.getOrDefault("maxResults")
  valid_579938 = validateParameter(valid_579938, JInt, required = false,
                                 default = newJInt(200))
  if valid_579938 != nil:
    section.add "maxResults", valid_579938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579939: Call_DriveRevisionsList_579926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a file's revisions.
  ## 
  let valid = call_579939.validator(path, query, header, formData, body)
  let scheme = call_579939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579939.url(scheme.get, call_579939.host, call_579939.base,
                         call_579939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579939, url, valid)

proc call*(call_579940: Call_DriveRevisionsList_579926; fileId: string;
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
  var path_579941 = newJObject()
  var query_579942 = newJObject()
  add(query_579942, "key", newJString(key))
  add(query_579942, "prettyPrint", newJBool(prettyPrint))
  add(query_579942, "oauth_token", newJString(oauthToken))
  add(query_579942, "alt", newJString(alt))
  add(query_579942, "userIp", newJString(userIp))
  add(query_579942, "quotaUser", newJString(quotaUser))
  add(path_579941, "fileId", newJString(fileId))
  add(query_579942, "pageToken", newJString(pageToken))
  add(query_579942, "fields", newJString(fields))
  add(query_579942, "maxResults", newJInt(maxResults))
  result = call_579940.call(path_579941, query_579942, nil, nil, nil)

var driveRevisionsList* = Call_DriveRevisionsList_579926(
    name: "driveRevisionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions",
    validator: validate_DriveRevisionsList_579927, base: "/drive/v2",
    url: url_DriveRevisionsList_579928, schemes: {Scheme.Https})
type
  Call_DriveRevisionsUpdate_579959 = ref object of OpenApiRestCall_578355
proc url_DriveRevisionsUpdate_579961(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsUpdate_579960(path: JsonNode; query: JsonNode;
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
  var valid_579962 = path.getOrDefault("fileId")
  valid_579962 = validateParameter(valid_579962, JString, required = true,
                                 default = nil)
  if valid_579962 != nil:
    section.add "fileId", valid_579962
  var valid_579963 = path.getOrDefault("revisionId")
  valid_579963 = validateParameter(valid_579963, JString, required = true,
                                 default = nil)
  if valid_579963 != nil:
    section.add "revisionId", valid_579963
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
  var valid_579964 = query.getOrDefault("key")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "key", valid_579964
  var valid_579965 = query.getOrDefault("prettyPrint")
  valid_579965 = validateParameter(valid_579965, JBool, required = false,
                                 default = newJBool(true))
  if valid_579965 != nil:
    section.add "prettyPrint", valid_579965
  var valid_579966 = query.getOrDefault("oauth_token")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "oauth_token", valid_579966
  var valid_579967 = query.getOrDefault("alt")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = newJString("json"))
  if valid_579967 != nil:
    section.add "alt", valid_579967
  var valid_579968 = query.getOrDefault("userIp")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "userIp", valid_579968
  var valid_579969 = query.getOrDefault("quotaUser")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "quotaUser", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
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

proc call*(call_579972: Call_DriveRevisionsUpdate_579959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision.
  ## 
  let valid = call_579972.validator(path, query, header, formData, body)
  let scheme = call_579972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579972.url(scheme.get, call_579972.host, call_579972.base,
                         call_579972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579972, url, valid)

proc call*(call_579973: Call_DriveRevisionsUpdate_579959; fileId: string;
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
  var path_579974 = newJObject()
  var query_579975 = newJObject()
  var body_579976 = newJObject()
  add(query_579975, "key", newJString(key))
  add(query_579975, "prettyPrint", newJBool(prettyPrint))
  add(query_579975, "oauth_token", newJString(oauthToken))
  add(query_579975, "alt", newJString(alt))
  add(query_579975, "userIp", newJString(userIp))
  add(query_579975, "quotaUser", newJString(quotaUser))
  add(path_579974, "fileId", newJString(fileId))
  if body != nil:
    body_579976 = body
  add(path_579974, "revisionId", newJString(revisionId))
  add(query_579975, "fields", newJString(fields))
  result = call_579973.call(path_579974, query_579975, nil, nil, body_579976)

var driveRevisionsUpdate* = Call_DriveRevisionsUpdate_579959(
    name: "driveRevisionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsUpdate_579960, base: "/drive/v2",
    url: url_DriveRevisionsUpdate_579961, schemes: {Scheme.Https})
type
  Call_DriveRevisionsGet_579943 = ref object of OpenApiRestCall_578355
proc url_DriveRevisionsGet_579945(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsGet_579944(path: JsonNode; query: JsonNode;
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
  var valid_579946 = path.getOrDefault("fileId")
  valid_579946 = validateParameter(valid_579946, JString, required = true,
                                 default = nil)
  if valid_579946 != nil:
    section.add "fileId", valid_579946
  var valid_579947 = path.getOrDefault("revisionId")
  valid_579947 = validateParameter(valid_579947, JString, required = true,
                                 default = nil)
  if valid_579947 != nil:
    section.add "revisionId", valid_579947
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
  var valid_579948 = query.getOrDefault("key")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "key", valid_579948
  var valid_579949 = query.getOrDefault("prettyPrint")
  valid_579949 = validateParameter(valid_579949, JBool, required = false,
                                 default = newJBool(true))
  if valid_579949 != nil:
    section.add "prettyPrint", valid_579949
  var valid_579950 = query.getOrDefault("oauth_token")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "oauth_token", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("userIp")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "userIp", valid_579952
  var valid_579953 = query.getOrDefault("quotaUser")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "quotaUser", valid_579953
  var valid_579954 = query.getOrDefault("fields")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "fields", valid_579954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579955: Call_DriveRevisionsGet_579943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific revision.
  ## 
  let valid = call_579955.validator(path, query, header, formData, body)
  let scheme = call_579955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579955.url(scheme.get, call_579955.host, call_579955.base,
                         call_579955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579955, url, valid)

proc call*(call_579956: Call_DriveRevisionsGet_579943; fileId: string;
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
  var path_579957 = newJObject()
  var query_579958 = newJObject()
  add(query_579958, "key", newJString(key))
  add(query_579958, "prettyPrint", newJBool(prettyPrint))
  add(query_579958, "oauth_token", newJString(oauthToken))
  add(query_579958, "alt", newJString(alt))
  add(query_579958, "userIp", newJString(userIp))
  add(query_579958, "quotaUser", newJString(quotaUser))
  add(path_579957, "fileId", newJString(fileId))
  add(path_579957, "revisionId", newJString(revisionId))
  add(query_579958, "fields", newJString(fields))
  result = call_579956.call(path_579957, query_579958, nil, nil, nil)

var driveRevisionsGet* = Call_DriveRevisionsGet_579943(name: "driveRevisionsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsGet_579944, base: "/drive/v2",
    url: url_DriveRevisionsGet_579945, schemes: {Scheme.Https})
type
  Call_DriveRevisionsPatch_579993 = ref object of OpenApiRestCall_578355
proc url_DriveRevisionsPatch_579995(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsPatch_579994(path: JsonNode; query: JsonNode;
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
  var valid_579996 = path.getOrDefault("fileId")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "fileId", valid_579996
  var valid_579997 = path.getOrDefault("revisionId")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "revisionId", valid_579997
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
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("prettyPrint")
  valid_579999 = validateParameter(valid_579999, JBool, required = false,
                                 default = newJBool(true))
  if valid_579999 != nil:
    section.add "prettyPrint", valid_579999
  var valid_580000 = query.getOrDefault("oauth_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "oauth_token", valid_580000
  var valid_580001 = query.getOrDefault("alt")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("json"))
  if valid_580001 != nil:
    section.add "alt", valid_580001
  var valid_580002 = query.getOrDefault("userIp")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "userIp", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("fields")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "fields", valid_580004
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

proc call*(call_580006: Call_DriveRevisionsPatch_579993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a revision. This method supports patch semantics.
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_DriveRevisionsPatch_579993; fileId: string;
          revisionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## driveRevisionsPatch
  ## Updates a revision. This method supports patch semantics.
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
  var path_580008 = newJObject()
  var query_580009 = newJObject()
  var body_580010 = newJObject()
  add(query_580009, "key", newJString(key))
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "userIp", newJString(userIp))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(path_580008, "fileId", newJString(fileId))
  if body != nil:
    body_580010 = body
  add(path_580008, "revisionId", newJString(revisionId))
  add(query_580009, "fields", newJString(fields))
  result = call_580007.call(path_580008, query_580009, nil, nil, body_580010)

var driveRevisionsPatch* = Call_DriveRevisionsPatch_579993(
    name: "driveRevisionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsPatch_579994, base: "/drive/v2",
    url: url_DriveRevisionsPatch_579995, schemes: {Scheme.Https})
type
  Call_DriveRevisionsDelete_579977 = ref object of OpenApiRestCall_578355
proc url_DriveRevisionsDelete_579979(protocol: Scheme; host: string; base: string;
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

proc validate_DriveRevisionsDelete_579978(path: JsonNode; query: JsonNode;
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
  var valid_579980 = path.getOrDefault("fileId")
  valid_579980 = validateParameter(valid_579980, JString, required = true,
                                 default = nil)
  if valid_579980 != nil:
    section.add "fileId", valid_579980
  var valid_579981 = path.getOrDefault("revisionId")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "revisionId", valid_579981
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
  var valid_579984 = query.getOrDefault("oauth_token")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "oauth_token", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("userIp")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "userIp", valid_579986
  var valid_579987 = query.getOrDefault("quotaUser")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "quotaUser", valid_579987
  var valid_579988 = query.getOrDefault("fields")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "fields", valid_579988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579989: Call_DriveRevisionsDelete_579977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a file version. You can only delete revisions for files with binary content, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
  ## 
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_DriveRevisionsDelete_579977; fileId: string;
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
  var path_579991 = newJObject()
  var query_579992 = newJObject()
  add(query_579992, "key", newJString(key))
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "userIp", newJString(userIp))
  add(query_579992, "quotaUser", newJString(quotaUser))
  add(path_579991, "fileId", newJString(fileId))
  add(path_579991, "revisionId", newJString(revisionId))
  add(query_579992, "fields", newJString(fields))
  result = call_579990.call(path_579991, query_579992, nil, nil, nil)

var driveRevisionsDelete* = Call_DriveRevisionsDelete_579977(
    name: "driveRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{fileId}/revisions/{revisionId}",
    validator: validate_DriveRevisionsDelete_579978, base: "/drive/v2",
    url: url_DriveRevisionsDelete_579979, schemes: {Scheme.Https})
type
  Call_DriveFilesTouch_580011 = ref object of OpenApiRestCall_578355
proc url_DriveFilesTouch_580013(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesTouch_580012(path: JsonNode; query: JsonNode;
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
  var valid_580014 = path.getOrDefault("fileId")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "fileId", valid_580014
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
  var valid_580015 = query.getOrDefault("key")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "key", valid_580015
  var valid_580016 = query.getOrDefault("prettyPrint")
  valid_580016 = validateParameter(valid_580016, JBool, required = false,
                                 default = newJBool(true))
  if valid_580016 != nil:
    section.add "prettyPrint", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("alt")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("json"))
  if valid_580018 != nil:
    section.add "alt", valid_580018
  var valid_580019 = query.getOrDefault("userIp")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "userIp", valid_580019
  var valid_580020 = query.getOrDefault("quotaUser")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "quotaUser", valid_580020
  var valid_580021 = query.getOrDefault("supportsTeamDrives")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(false))
  if valid_580021 != nil:
    section.add "supportsTeamDrives", valid_580021
  var valid_580022 = query.getOrDefault("supportsAllDrives")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(false))
  if valid_580022 != nil:
    section.add "supportsAllDrives", valid_580022
  var valid_580023 = query.getOrDefault("fields")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "fields", valid_580023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580024: Call_DriveFilesTouch_580011; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set the file's updated time to the current server time.
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_DriveFilesTouch_580011; fileId: string;
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
  var path_580026 = newJObject()
  var query_580027 = newJObject()
  add(query_580027, "key", newJString(key))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "userIp", newJString(userIp))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(path_580026, "fileId", newJString(fileId))
  add(query_580027, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580027, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580027, "fields", newJString(fields))
  result = call_580025.call(path_580026, query_580027, nil, nil, nil)

var driveFilesTouch* = Call_DriveFilesTouch_580011(name: "driveFilesTouch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/touch", validator: validate_DriveFilesTouch_580012,
    base: "/drive/v2", url: url_DriveFilesTouch_580013, schemes: {Scheme.Https})
type
  Call_DriveFilesTrash_580028 = ref object of OpenApiRestCall_578355
proc url_DriveFilesTrash_580030(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesTrash_580029(path: JsonNode; query: JsonNode;
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
  var valid_580031 = path.getOrDefault("fileId")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "fileId", valid_580031
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
  var valid_580032 = query.getOrDefault("key")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "key", valid_580032
  var valid_580033 = query.getOrDefault("prettyPrint")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "prettyPrint", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("userIp")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "userIp", valid_580036
  var valid_580037 = query.getOrDefault("quotaUser")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "quotaUser", valid_580037
  var valid_580038 = query.getOrDefault("supportsTeamDrives")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(false))
  if valid_580038 != nil:
    section.add "supportsTeamDrives", valid_580038
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580041: Call_DriveFilesTrash_580028; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves a file to the trash. The currently authenticated user must own the file or be at least a fileOrganizer on the parent for shared drive files.
  ## 
  let valid = call_580041.validator(path, query, header, formData, body)
  let scheme = call_580041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580041.url(scheme.get, call_580041.host, call_580041.base,
                         call_580041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580041, url, valid)

proc call*(call_580042: Call_DriveFilesTrash_580028; fileId: string;
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
  var path_580043 = newJObject()
  var query_580044 = newJObject()
  add(query_580044, "key", newJString(key))
  add(query_580044, "prettyPrint", newJBool(prettyPrint))
  add(query_580044, "oauth_token", newJString(oauthToken))
  add(query_580044, "alt", newJString(alt))
  add(query_580044, "userIp", newJString(userIp))
  add(query_580044, "quotaUser", newJString(quotaUser))
  add(path_580043, "fileId", newJString(fileId))
  add(query_580044, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580044, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580044, "fields", newJString(fields))
  result = call_580042.call(path_580043, query_580044, nil, nil, nil)

var driveFilesTrash* = Call_DriveFilesTrash_580028(name: "driveFilesTrash",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/trash", validator: validate_DriveFilesTrash_580029,
    base: "/drive/v2", url: url_DriveFilesTrash_580030, schemes: {Scheme.Https})
type
  Call_DriveFilesUntrash_580045 = ref object of OpenApiRestCall_578355
proc url_DriveFilesUntrash_580047(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesUntrash_580046(path: JsonNode; query: JsonNode;
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
  var valid_580048 = path.getOrDefault("fileId")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fileId", valid_580048
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
  var valid_580049 = query.getOrDefault("key")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "key", valid_580049
  var valid_580050 = query.getOrDefault("prettyPrint")
  valid_580050 = validateParameter(valid_580050, JBool, required = false,
                                 default = newJBool(true))
  if valid_580050 != nil:
    section.add "prettyPrint", valid_580050
  var valid_580051 = query.getOrDefault("oauth_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "oauth_token", valid_580051
  var valid_580052 = query.getOrDefault("alt")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("json"))
  if valid_580052 != nil:
    section.add "alt", valid_580052
  var valid_580053 = query.getOrDefault("userIp")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "userIp", valid_580053
  var valid_580054 = query.getOrDefault("quotaUser")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "quotaUser", valid_580054
  var valid_580055 = query.getOrDefault("supportsTeamDrives")
  valid_580055 = validateParameter(valid_580055, JBool, required = false,
                                 default = newJBool(false))
  if valid_580055 != nil:
    section.add "supportsTeamDrives", valid_580055
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580058: Call_DriveFilesUntrash_580045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a file from the trash.
  ## 
  let valid = call_580058.validator(path, query, header, formData, body)
  let scheme = call_580058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580058.url(scheme.get, call_580058.host, call_580058.base,
                         call_580058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580058, url, valid)

proc call*(call_580059: Call_DriveFilesUntrash_580045; fileId: string;
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
  var path_580060 = newJObject()
  var query_580061 = newJObject()
  add(query_580061, "key", newJString(key))
  add(query_580061, "prettyPrint", newJBool(prettyPrint))
  add(query_580061, "oauth_token", newJString(oauthToken))
  add(query_580061, "alt", newJString(alt))
  add(query_580061, "userIp", newJString(userIp))
  add(query_580061, "quotaUser", newJString(quotaUser))
  add(path_580060, "fileId", newJString(fileId))
  add(query_580061, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580061, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580061, "fields", newJString(fields))
  result = call_580059.call(path_580060, query_580061, nil, nil, nil)

var driveFilesUntrash* = Call_DriveFilesUntrash_580045(name: "driveFilesUntrash",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/untrash", validator: validate_DriveFilesUntrash_580046,
    base: "/drive/v2", url: url_DriveFilesUntrash_580047, schemes: {Scheme.Https})
type
  Call_DriveFilesWatch_580062 = ref object of OpenApiRestCall_578355
proc url_DriveFilesWatch_580064(protocol: Scheme; host: string; base: string;
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

proc validate_DriveFilesWatch_580063(path: JsonNode; query: JsonNode;
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
  var valid_580065 = path.getOrDefault("fileId")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "fileId", valid_580065
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
  var valid_580066 = query.getOrDefault("key")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "key", valid_580066
  var valid_580067 = query.getOrDefault("prettyPrint")
  valid_580067 = validateParameter(valid_580067, JBool, required = false,
                                 default = newJBool(true))
  if valid_580067 != nil:
    section.add "prettyPrint", valid_580067
  var valid_580068 = query.getOrDefault("oauth_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "oauth_token", valid_580068
  var valid_580069 = query.getOrDefault("alt")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = newJString("json"))
  if valid_580069 != nil:
    section.add "alt", valid_580069
  var valid_580070 = query.getOrDefault("userIp")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "userIp", valid_580070
  var valid_580071 = query.getOrDefault("quotaUser")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "quotaUser", valid_580071
  var valid_580072 = query.getOrDefault("supportsTeamDrives")
  valid_580072 = validateParameter(valid_580072, JBool, required = false,
                                 default = newJBool(false))
  if valid_580072 != nil:
    section.add "supportsTeamDrives", valid_580072
  var valid_580073 = query.getOrDefault("acknowledgeAbuse")
  valid_580073 = validateParameter(valid_580073, JBool, required = false,
                                 default = newJBool(false))
  if valid_580073 != nil:
    section.add "acknowledgeAbuse", valid_580073
  var valid_580074 = query.getOrDefault("supportsAllDrives")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(false))
  if valid_580074 != nil:
    section.add "supportsAllDrives", valid_580074
  var valid_580075 = query.getOrDefault("revisionId")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "revisionId", valid_580075
  var valid_580076 = query.getOrDefault("projection")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580076 != nil:
    section.add "projection", valid_580076
  var valid_580077 = query.getOrDefault("fields")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "fields", valid_580077
  var valid_580078 = query.getOrDefault("updateViewedDate")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(false))
  if valid_580078 != nil:
    section.add "updateViewedDate", valid_580078
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

proc call*(call_580080: Call_DriveFilesWatch_580062; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe to changes on a file
  ## 
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_DriveFilesWatch_580062; fileId: string;
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
  var path_580082 = newJObject()
  var query_580083 = newJObject()
  var body_580084 = newJObject()
  add(query_580083, "key", newJString(key))
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(query_580083, "alt", newJString(alt))
  add(query_580083, "userIp", newJString(userIp))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(path_580082, "fileId", newJString(fileId))
  add(query_580083, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580083, "acknowledgeAbuse", newJBool(acknowledgeAbuse))
  add(query_580083, "supportsAllDrives", newJBool(supportsAllDrives))
  add(query_580083, "revisionId", newJString(revisionId))
  if resource != nil:
    body_580084 = resource
  add(query_580083, "projection", newJString(projection))
  add(query_580083, "fields", newJString(fields))
  add(query_580083, "updateViewedDate", newJBool(updateViewedDate))
  result = call_580081.call(path_580082, query_580083, nil, nil, body_580084)

var driveFilesWatch* = Call_DriveFilesWatch_580062(name: "driveFilesWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/files/{fileId}/watch", validator: validate_DriveFilesWatch_580063,
    base: "/drive/v2", url: url_DriveFilesWatch_580064, schemes: {Scheme.Https})
type
  Call_DriveChildrenInsert_580104 = ref object of OpenApiRestCall_578355
proc url_DriveChildrenInsert_580106(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChildrenInsert_580105(path: JsonNode; query: JsonNode;
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
  var valid_580107 = path.getOrDefault("folderId")
  valid_580107 = validateParameter(valid_580107, JString, required = true,
                                 default = nil)
  if valid_580107 != nil:
    section.add "folderId", valid_580107
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
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("prettyPrint")
  valid_580109 = validateParameter(valid_580109, JBool, required = false,
                                 default = newJBool(true))
  if valid_580109 != nil:
    section.add "prettyPrint", valid_580109
  var valid_580110 = query.getOrDefault("oauth_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "oauth_token", valid_580110
  var valid_580111 = query.getOrDefault("alt")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = newJString("json"))
  if valid_580111 != nil:
    section.add "alt", valid_580111
  var valid_580112 = query.getOrDefault("userIp")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "userIp", valid_580112
  var valid_580113 = query.getOrDefault("quotaUser")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "quotaUser", valid_580113
  var valid_580114 = query.getOrDefault("supportsTeamDrives")
  valid_580114 = validateParameter(valid_580114, JBool, required = false,
                                 default = newJBool(false))
  if valid_580114 != nil:
    section.add "supportsTeamDrives", valid_580114
  var valid_580115 = query.getOrDefault("supportsAllDrives")
  valid_580115 = validateParameter(valid_580115, JBool, required = false,
                                 default = newJBool(false))
  if valid_580115 != nil:
    section.add "supportsAllDrives", valid_580115
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580118: Call_DriveChildrenInsert_580104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a file into a folder.
  ## 
  let valid = call_580118.validator(path, query, header, formData, body)
  let scheme = call_580118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580118.url(scheme.get, call_580118.host, call_580118.base,
                         call_580118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580118, url, valid)

proc call*(call_580119: Call_DriveChildrenInsert_580104; folderId: string;
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
  var path_580120 = newJObject()
  var query_580121 = newJObject()
  var body_580122 = newJObject()
  add(query_580121, "key", newJString(key))
  add(query_580121, "prettyPrint", newJBool(prettyPrint))
  add(query_580121, "oauth_token", newJString(oauthToken))
  add(query_580121, "alt", newJString(alt))
  add(query_580121, "userIp", newJString(userIp))
  add(query_580121, "quotaUser", newJString(quotaUser))
  add(query_580121, "supportsTeamDrives", newJBool(supportsTeamDrives))
  add(query_580121, "supportsAllDrives", newJBool(supportsAllDrives))
  add(path_580120, "folderId", newJString(folderId))
  if body != nil:
    body_580122 = body
  add(query_580121, "fields", newJString(fields))
  result = call_580119.call(path_580120, query_580121, nil, nil, body_580122)

var driveChildrenInsert* = Call_DriveChildrenInsert_580104(
    name: "driveChildrenInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/files/{folderId}/children",
    validator: validate_DriveChildrenInsert_580105, base: "/drive/v2",
    url: url_DriveChildrenInsert_580106, schemes: {Scheme.Https})
type
  Call_DriveChildrenList_580085 = ref object of OpenApiRestCall_578355
proc url_DriveChildrenList_580087(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChildrenList_580086(path: JsonNode; query: JsonNode;
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
  var valid_580088 = path.getOrDefault("folderId")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "folderId", valid_580088
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
  var valid_580089 = query.getOrDefault("key")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "key", valid_580089
  var valid_580090 = query.getOrDefault("prettyPrint")
  valid_580090 = validateParameter(valid_580090, JBool, required = false,
                                 default = newJBool(true))
  if valid_580090 != nil:
    section.add "prettyPrint", valid_580090
  var valid_580091 = query.getOrDefault("oauth_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "oauth_token", valid_580091
  var valid_580092 = query.getOrDefault("q")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "q", valid_580092
  var valid_580093 = query.getOrDefault("alt")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("json"))
  if valid_580093 != nil:
    section.add "alt", valid_580093
  var valid_580094 = query.getOrDefault("userIp")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "userIp", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("orderBy")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "orderBy", valid_580096
  var valid_580097 = query.getOrDefault("pageToken")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "pageToken", valid_580097
  var valid_580098 = query.getOrDefault("fields")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "fields", valid_580098
  var valid_580099 = query.getOrDefault("maxResults")
  valid_580099 = validateParameter(valid_580099, JInt, required = false,
                                 default = newJInt(100))
  if valid_580099 != nil:
    section.add "maxResults", valid_580099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580100: Call_DriveChildrenList_580085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a folder's children.
  ## 
  let valid = call_580100.validator(path, query, header, formData, body)
  let scheme = call_580100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580100.url(scheme.get, call_580100.host, call_580100.base,
                         call_580100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580100, url, valid)

proc call*(call_580101: Call_DriveChildrenList_580085; folderId: string;
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
  var path_580102 = newJObject()
  var query_580103 = newJObject()
  add(query_580103, "key", newJString(key))
  add(query_580103, "prettyPrint", newJBool(prettyPrint))
  add(query_580103, "oauth_token", newJString(oauthToken))
  add(query_580103, "q", newJString(q))
  add(query_580103, "alt", newJString(alt))
  add(query_580103, "userIp", newJString(userIp))
  add(query_580103, "quotaUser", newJString(quotaUser))
  add(query_580103, "orderBy", newJString(orderBy))
  add(query_580103, "pageToken", newJString(pageToken))
  add(path_580102, "folderId", newJString(folderId))
  add(query_580103, "fields", newJString(fields))
  add(query_580103, "maxResults", newJInt(maxResults))
  result = call_580101.call(path_580102, query_580103, nil, nil, nil)

var driveChildrenList* = Call_DriveChildrenList_580085(name: "driveChildrenList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{folderId}/children", validator: validate_DriveChildrenList_580086,
    base: "/drive/v2", url: url_DriveChildrenList_580087, schemes: {Scheme.Https})
type
  Call_DriveChildrenGet_580123 = ref object of OpenApiRestCall_578355
proc url_DriveChildrenGet_580125(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChildrenGet_580124(path: JsonNode; query: JsonNode;
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
  var valid_580126 = path.getOrDefault("childId")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "childId", valid_580126
  var valid_580127 = path.getOrDefault("folderId")
  valid_580127 = validateParameter(valid_580127, JString, required = true,
                                 default = nil)
  if valid_580127 != nil:
    section.add "folderId", valid_580127
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
  var valid_580128 = query.getOrDefault("key")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "key", valid_580128
  var valid_580129 = query.getOrDefault("prettyPrint")
  valid_580129 = validateParameter(valid_580129, JBool, required = false,
                                 default = newJBool(true))
  if valid_580129 != nil:
    section.add "prettyPrint", valid_580129
  var valid_580130 = query.getOrDefault("oauth_token")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "oauth_token", valid_580130
  var valid_580131 = query.getOrDefault("alt")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = newJString("json"))
  if valid_580131 != nil:
    section.add "alt", valid_580131
  var valid_580132 = query.getOrDefault("userIp")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "userIp", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("fields")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "fields", valid_580134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580135: Call_DriveChildrenGet_580123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific child reference.
  ## 
  let valid = call_580135.validator(path, query, header, formData, body)
  let scheme = call_580135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580135.url(scheme.get, call_580135.host, call_580135.base,
                         call_580135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580135, url, valid)

proc call*(call_580136: Call_DriveChildrenGet_580123; childId: string;
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
  var path_580137 = newJObject()
  var query_580138 = newJObject()
  add(query_580138, "key", newJString(key))
  add(query_580138, "prettyPrint", newJBool(prettyPrint))
  add(query_580138, "oauth_token", newJString(oauthToken))
  add(query_580138, "alt", newJString(alt))
  add(query_580138, "userIp", newJString(userIp))
  add(query_580138, "quotaUser", newJString(quotaUser))
  add(path_580137, "childId", newJString(childId))
  add(path_580137, "folderId", newJString(folderId))
  add(query_580138, "fields", newJString(fields))
  result = call_580136.call(path_580137, query_580138, nil, nil, nil)

var driveChildrenGet* = Call_DriveChildrenGet_580123(name: "driveChildrenGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/files/{folderId}/children/{childId}",
    validator: validate_DriveChildrenGet_580124, base: "/drive/v2",
    url: url_DriveChildrenGet_580125, schemes: {Scheme.Https})
type
  Call_DriveChildrenDelete_580139 = ref object of OpenApiRestCall_578355
proc url_DriveChildrenDelete_580141(protocol: Scheme; host: string; base: string;
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

proc validate_DriveChildrenDelete_580140(path: JsonNode; query: JsonNode;
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
  var valid_580142 = path.getOrDefault("childId")
  valid_580142 = validateParameter(valid_580142, JString, required = true,
                                 default = nil)
  if valid_580142 != nil:
    section.add "childId", valid_580142
  var valid_580143 = path.getOrDefault("folderId")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "folderId", valid_580143
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
  var valid_580144 = query.getOrDefault("key")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "key", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
  var valid_580146 = query.getOrDefault("oauth_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "oauth_token", valid_580146
  var valid_580147 = query.getOrDefault("alt")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = newJString("json"))
  if valid_580147 != nil:
    section.add "alt", valid_580147
  var valid_580148 = query.getOrDefault("userIp")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "userIp", valid_580148
  var valid_580149 = query.getOrDefault("quotaUser")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "quotaUser", valid_580149
  var valid_580150 = query.getOrDefault("fields")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "fields", valid_580150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580151: Call_DriveChildrenDelete_580139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a child from a folder.
  ## 
  let valid = call_580151.validator(path, query, header, formData, body)
  let scheme = call_580151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580151.url(scheme.get, call_580151.host, call_580151.base,
                         call_580151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580151, url, valid)

proc call*(call_580152: Call_DriveChildrenDelete_580139; childId: string;
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
  var path_580153 = newJObject()
  var query_580154 = newJObject()
  add(query_580154, "key", newJString(key))
  add(query_580154, "prettyPrint", newJBool(prettyPrint))
  add(query_580154, "oauth_token", newJString(oauthToken))
  add(query_580154, "alt", newJString(alt))
  add(query_580154, "userIp", newJString(userIp))
  add(query_580154, "quotaUser", newJString(quotaUser))
  add(path_580153, "childId", newJString(childId))
  add(path_580153, "folderId", newJString(folderId))
  add(query_580154, "fields", newJString(fields))
  result = call_580152.call(path_580153, query_580154, nil, nil, nil)

var driveChildrenDelete* = Call_DriveChildrenDelete_580139(
    name: "driveChildrenDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/files/{folderId}/children/{childId}",
    validator: validate_DriveChildrenDelete_580140, base: "/drive/v2",
    url: url_DriveChildrenDelete_580141, schemes: {Scheme.Https})
type
  Call_DrivePermissionsGetIdForEmail_580155 = ref object of OpenApiRestCall_578355
proc url_DrivePermissionsGetIdForEmail_580157(protocol: Scheme; host: string;
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

proc validate_DrivePermissionsGetIdForEmail_580156(path: JsonNode; query: JsonNode;
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
  var valid_580158 = path.getOrDefault("email")
  valid_580158 = validateParameter(valid_580158, JString, required = true,
                                 default = nil)
  if valid_580158 != nil:
    section.add "email", valid_580158
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
  var valid_580159 = query.getOrDefault("key")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "key", valid_580159
  var valid_580160 = query.getOrDefault("prettyPrint")
  valid_580160 = validateParameter(valid_580160, JBool, required = false,
                                 default = newJBool(true))
  if valid_580160 != nil:
    section.add "prettyPrint", valid_580160
  var valid_580161 = query.getOrDefault("oauth_token")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "oauth_token", valid_580161
  var valid_580162 = query.getOrDefault("alt")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = newJString("json"))
  if valid_580162 != nil:
    section.add "alt", valid_580162
  var valid_580163 = query.getOrDefault("userIp")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "userIp", valid_580163
  var valid_580164 = query.getOrDefault("quotaUser")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "quotaUser", valid_580164
  var valid_580165 = query.getOrDefault("fields")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "fields", valid_580165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580166: Call_DrivePermissionsGetIdForEmail_580155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the permission ID for an email address.
  ## 
  let valid = call_580166.validator(path, query, header, formData, body)
  let scheme = call_580166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580166.url(scheme.get, call_580166.host, call_580166.base,
                         call_580166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580166, url, valid)

proc call*(call_580167: Call_DrivePermissionsGetIdForEmail_580155; email: string;
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
  var path_580168 = newJObject()
  var query_580169 = newJObject()
  add(query_580169, "key", newJString(key))
  add(query_580169, "prettyPrint", newJBool(prettyPrint))
  add(query_580169, "oauth_token", newJString(oauthToken))
  add(path_580168, "email", newJString(email))
  add(query_580169, "alt", newJString(alt))
  add(query_580169, "userIp", newJString(userIp))
  add(query_580169, "quotaUser", newJString(quotaUser))
  add(query_580169, "fields", newJString(fields))
  result = call_580167.call(path_580168, query_580169, nil, nil, nil)

var drivePermissionsGetIdForEmail* = Call_DrivePermissionsGetIdForEmail_580155(
    name: "drivePermissionsGetIdForEmail", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/permissionIds/{email}",
    validator: validate_DrivePermissionsGetIdForEmail_580156, base: "/drive/v2",
    url: url_DrivePermissionsGetIdForEmail_580157, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesInsert_580187 = ref object of OpenApiRestCall_578355
proc url_DriveTeamdrivesInsert_580189(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesInsert_580188(path: JsonNode; query: JsonNode;
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
  var valid_580192 = query.getOrDefault("oauth_token")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "oauth_token", valid_580192
  var valid_580193 = query.getOrDefault("alt")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("json"))
  if valid_580193 != nil:
    section.add "alt", valid_580193
  var valid_580194 = query.getOrDefault("userIp")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "userIp", valid_580194
  var valid_580195 = query.getOrDefault("quotaUser")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "quotaUser", valid_580195
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_580196 = query.getOrDefault("requestId")
  valid_580196 = validateParameter(valid_580196, JString, required = true,
                                 default = nil)
  if valid_580196 != nil:
    section.add "requestId", valid_580196
  var valid_580197 = query.getOrDefault("fields")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "fields", valid_580197
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

proc call*(call_580199: Call_DriveTeamdrivesInsert_580187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.insert instead.
  ## 
  let valid = call_580199.validator(path, query, header, formData, body)
  let scheme = call_580199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580199.url(scheme.get, call_580199.host, call_580199.base,
                         call_580199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580199, url, valid)

proc call*(call_580200: Call_DriveTeamdrivesInsert_580187; requestId: string;
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
  var query_580201 = newJObject()
  var body_580202 = newJObject()
  add(query_580201, "key", newJString(key))
  add(query_580201, "prettyPrint", newJBool(prettyPrint))
  add(query_580201, "oauth_token", newJString(oauthToken))
  add(query_580201, "alt", newJString(alt))
  add(query_580201, "userIp", newJString(userIp))
  add(query_580201, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580202 = body
  add(query_580201, "requestId", newJString(requestId))
  add(query_580201, "fields", newJString(fields))
  result = call_580200.call(nil, query_580201, nil, nil, body_580202)

var driveTeamdrivesInsert* = Call_DriveTeamdrivesInsert_580187(
    name: "driveTeamdrivesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesInsert_580188, base: "/drive/v2",
    url: url_DriveTeamdrivesInsert_580189, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesList_580170 = ref object of OpenApiRestCall_578355
proc url_DriveTeamdrivesList_580172(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DriveTeamdrivesList_580171(path: JsonNode; query: JsonNode;
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
  var valid_580176 = query.getOrDefault("useDomainAdminAccess")
  valid_580176 = validateParameter(valid_580176, JBool, required = false,
                                 default = newJBool(false))
  if valid_580176 != nil:
    section.add "useDomainAdminAccess", valid_580176
  var valid_580177 = query.getOrDefault("q")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "q", valid_580177
  var valid_580178 = query.getOrDefault("alt")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = newJString("json"))
  if valid_580178 != nil:
    section.add "alt", valid_580178
  var valid_580179 = query.getOrDefault("userIp")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "userIp", valid_580179
  var valid_580180 = query.getOrDefault("quotaUser")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "quotaUser", valid_580180
  var valid_580181 = query.getOrDefault("pageToken")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "pageToken", valid_580181
  var valid_580182 = query.getOrDefault("fields")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "fields", valid_580182
  var valid_580183 = query.getOrDefault("maxResults")
  valid_580183 = validateParameter(valid_580183, JInt, required = false,
                                 default = newJInt(10))
  if valid_580183 != nil:
    section.add "maxResults", valid_580183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580184: Call_DriveTeamdrivesList_580170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.list instead.
  ## 
  let valid = call_580184.validator(path, query, header, formData, body)
  let scheme = call_580184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580184.url(scheme.get, call_580184.host, call_580184.base,
                         call_580184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580184, url, valid)

proc call*(call_580185: Call_DriveTeamdrivesList_580170; key: string = "";
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
  var query_580186 = newJObject()
  add(query_580186, "key", newJString(key))
  add(query_580186, "prettyPrint", newJBool(prettyPrint))
  add(query_580186, "oauth_token", newJString(oauthToken))
  add(query_580186, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580186, "q", newJString(q))
  add(query_580186, "alt", newJString(alt))
  add(query_580186, "userIp", newJString(userIp))
  add(query_580186, "quotaUser", newJString(quotaUser))
  add(query_580186, "pageToken", newJString(pageToken))
  add(query_580186, "fields", newJString(fields))
  add(query_580186, "maxResults", newJInt(maxResults))
  result = call_580185.call(nil, query_580186, nil, nil, nil)

var driveTeamdrivesList* = Call_DriveTeamdrivesList_580170(
    name: "driveTeamdrivesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives",
    validator: validate_DriveTeamdrivesList_580171, base: "/drive/v2",
    url: url_DriveTeamdrivesList_580172, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesUpdate_580219 = ref object of OpenApiRestCall_578355
proc url_DriveTeamdrivesUpdate_580221(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesUpdate_580220(path: JsonNode; query: JsonNode;
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
  var valid_580222 = path.getOrDefault("teamDriveId")
  valid_580222 = validateParameter(valid_580222, JString, required = true,
                                 default = nil)
  if valid_580222 != nil:
    section.add "teamDriveId", valid_580222
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
  var valid_580223 = query.getOrDefault("key")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "key", valid_580223
  var valid_580224 = query.getOrDefault("prettyPrint")
  valid_580224 = validateParameter(valid_580224, JBool, required = false,
                                 default = newJBool(true))
  if valid_580224 != nil:
    section.add "prettyPrint", valid_580224
  var valid_580225 = query.getOrDefault("oauth_token")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "oauth_token", valid_580225
  var valid_580226 = query.getOrDefault("useDomainAdminAccess")
  valid_580226 = validateParameter(valid_580226, JBool, required = false,
                                 default = newJBool(false))
  if valid_580226 != nil:
    section.add "useDomainAdminAccess", valid_580226
  var valid_580227 = query.getOrDefault("alt")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("json"))
  if valid_580227 != nil:
    section.add "alt", valid_580227
  var valid_580228 = query.getOrDefault("userIp")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "userIp", valid_580228
  var valid_580229 = query.getOrDefault("quotaUser")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "quotaUser", valid_580229
  var valid_580230 = query.getOrDefault("fields")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "fields", valid_580230
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

proc call*(call_580232: Call_DriveTeamdrivesUpdate_580219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.update instead.
  ## 
  let valid = call_580232.validator(path, query, header, formData, body)
  let scheme = call_580232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580232.url(scheme.get, call_580232.host, call_580232.base,
                         call_580232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580232, url, valid)

proc call*(call_580233: Call_DriveTeamdrivesUpdate_580219; teamDriveId: string;
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
  var path_580234 = newJObject()
  var query_580235 = newJObject()
  var body_580236 = newJObject()
  add(query_580235, "key", newJString(key))
  add(path_580234, "teamDriveId", newJString(teamDriveId))
  add(query_580235, "prettyPrint", newJBool(prettyPrint))
  add(query_580235, "oauth_token", newJString(oauthToken))
  add(query_580235, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580235, "alt", newJString(alt))
  add(query_580235, "userIp", newJString(userIp))
  add(query_580235, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580236 = body
  add(query_580235, "fields", newJString(fields))
  result = call_580233.call(path_580234, query_580235, nil, nil, body_580236)

var driveTeamdrivesUpdate* = Call_DriveTeamdrivesUpdate_580219(
    name: "driveTeamdrivesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesUpdate_580220, base: "/drive/v2",
    url: url_DriveTeamdrivesUpdate_580221, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesGet_580203 = ref object of OpenApiRestCall_578355
proc url_DriveTeamdrivesGet_580205(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesGet_580204(path: JsonNode; query: JsonNode;
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
  var valid_580206 = path.getOrDefault("teamDriveId")
  valid_580206 = validateParameter(valid_580206, JString, required = true,
                                 default = nil)
  if valid_580206 != nil:
    section.add "teamDriveId", valid_580206
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
  var valid_580207 = query.getOrDefault("key")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "key", valid_580207
  var valid_580208 = query.getOrDefault("prettyPrint")
  valid_580208 = validateParameter(valid_580208, JBool, required = false,
                                 default = newJBool(true))
  if valid_580208 != nil:
    section.add "prettyPrint", valid_580208
  var valid_580209 = query.getOrDefault("oauth_token")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "oauth_token", valid_580209
  var valid_580210 = query.getOrDefault("useDomainAdminAccess")
  valid_580210 = validateParameter(valid_580210, JBool, required = false,
                                 default = newJBool(false))
  if valid_580210 != nil:
    section.add "useDomainAdminAccess", valid_580210
  var valid_580211 = query.getOrDefault("alt")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("json"))
  if valid_580211 != nil:
    section.add "alt", valid_580211
  var valid_580212 = query.getOrDefault("userIp")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "userIp", valid_580212
  var valid_580213 = query.getOrDefault("quotaUser")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "quotaUser", valid_580213
  var valid_580214 = query.getOrDefault("fields")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "fields", valid_580214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580215: Call_DriveTeamdrivesGet_580203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.get instead.
  ## 
  let valid = call_580215.validator(path, query, header, formData, body)
  let scheme = call_580215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580215.url(scheme.get, call_580215.host, call_580215.base,
                         call_580215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580215, url, valid)

proc call*(call_580216: Call_DriveTeamdrivesGet_580203; teamDriveId: string;
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
  var path_580217 = newJObject()
  var query_580218 = newJObject()
  add(query_580218, "key", newJString(key))
  add(path_580217, "teamDriveId", newJString(teamDriveId))
  add(query_580218, "prettyPrint", newJBool(prettyPrint))
  add(query_580218, "oauth_token", newJString(oauthToken))
  add(query_580218, "useDomainAdminAccess", newJBool(useDomainAdminAccess))
  add(query_580218, "alt", newJString(alt))
  add(query_580218, "userIp", newJString(userIp))
  add(query_580218, "quotaUser", newJString(quotaUser))
  add(query_580218, "fields", newJString(fields))
  result = call_580216.call(path_580217, query_580218, nil, nil, nil)

var driveTeamdrivesGet* = Call_DriveTeamdrivesGet_580203(
    name: "driveTeamdrivesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesGet_580204, base: "/drive/v2",
    url: url_DriveTeamdrivesGet_580205, schemes: {Scheme.Https})
type
  Call_DriveTeamdrivesDelete_580237 = ref object of OpenApiRestCall_578355
proc url_DriveTeamdrivesDelete_580239(protocol: Scheme; host: string; base: string;
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

proc validate_DriveTeamdrivesDelete_580238(path: JsonNode; query: JsonNode;
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
  var valid_580240 = path.getOrDefault("teamDriveId")
  valid_580240 = validateParameter(valid_580240, JString, required = true,
                                 default = nil)
  if valid_580240 != nil:
    section.add "teamDriveId", valid_580240
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
  var valid_580241 = query.getOrDefault("key")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "key", valid_580241
  var valid_580242 = query.getOrDefault("prettyPrint")
  valid_580242 = validateParameter(valid_580242, JBool, required = false,
                                 default = newJBool(true))
  if valid_580242 != nil:
    section.add "prettyPrint", valid_580242
  var valid_580243 = query.getOrDefault("oauth_token")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "oauth_token", valid_580243
  var valid_580244 = query.getOrDefault("alt")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("json"))
  if valid_580244 != nil:
    section.add "alt", valid_580244
  var valid_580245 = query.getOrDefault("userIp")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "userIp", valid_580245
  var valid_580246 = query.getOrDefault("quotaUser")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "quotaUser", valid_580246
  var valid_580247 = query.getOrDefault("fields")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "fields", valid_580247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580248: Call_DriveTeamdrivesDelete_580237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated use drives.delete instead.
  ## 
  let valid = call_580248.validator(path, query, header, formData, body)
  let scheme = call_580248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580248.url(scheme.get, call_580248.host, call_580248.base,
                         call_580248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580248, url, valid)

proc call*(call_580249: Call_DriveTeamdrivesDelete_580237; teamDriveId: string;
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
  var path_580250 = newJObject()
  var query_580251 = newJObject()
  add(query_580251, "key", newJString(key))
  add(path_580250, "teamDriveId", newJString(teamDriveId))
  add(query_580251, "prettyPrint", newJBool(prettyPrint))
  add(query_580251, "oauth_token", newJString(oauthToken))
  add(query_580251, "alt", newJString(alt))
  add(query_580251, "userIp", newJString(userIp))
  add(query_580251, "quotaUser", newJString(quotaUser))
  add(query_580251, "fields", newJString(fields))
  result = call_580249.call(path_580250, query_580251, nil, nil, nil)

var driveTeamdrivesDelete* = Call_DriveTeamdrivesDelete_580237(
    name: "driveTeamdrivesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/teamdrives/{teamDriveId}",
    validator: validate_DriveTeamdrivesDelete_580238, base: "/drive/v2",
    url: url_DriveTeamdrivesDelete_580239, schemes: {Scheme.Https})
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
