
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play Developer
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses Android application developers' Google Play accounts.
## 
## https://developers.google.com/android-publisher
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
  gcpServiceName = "androidpublisher"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidpublisherInternalappsharingartifactsUploadapk_578618 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInternalappsharingartifactsUploadapk_578620(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/internalappsharing/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/artifacts/apk")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInternalappsharingartifactsUploadapk_578619(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Uploads an APK to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app; for example, "com.spiffygame".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_578746 = path.getOrDefault("packageName")
  valid_578746 = validateParameter(valid_578746, JString, required = true,
                                 default = nil)
  if valid_578746 != nil:
    section.add "packageName", valid_578746
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
  var valid_578747 = query.getOrDefault("key")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "key", valid_578747
  var valid_578761 = query.getOrDefault("prettyPrint")
  valid_578761 = validateParameter(valid_578761, JBool, required = false,
                                 default = newJBool(true))
  if valid_578761 != nil:
    section.add "prettyPrint", valid_578761
  var valid_578762 = query.getOrDefault("oauth_token")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "oauth_token", valid_578762
  var valid_578763 = query.getOrDefault("alt")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = newJString("json"))
  if valid_578763 != nil:
    section.add "alt", valid_578763
  var valid_578764 = query.getOrDefault("userIp")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "userIp", valid_578764
  var valid_578765 = query.getOrDefault("quotaUser")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "quotaUser", valid_578765
  var valid_578766 = query.getOrDefault("fields")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "fields", valid_578766
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578789: Call_AndroidpublisherInternalappsharingartifactsUploadapk_578618;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads an APK to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_578789.validator(path, query, header, formData, body)
  let scheme = call_578789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578789.url(scheme.get, call_578789.host, call_578789.base,
                         call_578789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578789, url, valid)

proc call*(call_578860: Call_AndroidpublisherInternalappsharingartifactsUploadapk_578618;
          packageName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherInternalappsharingartifactsUploadapk
  ## Uploads an APK to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app; for example, "com.spiffygame".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578861 = newJObject()
  var query_578863 = newJObject()
  add(query_578863, "key", newJString(key))
  add(query_578863, "prettyPrint", newJBool(prettyPrint))
  add(query_578863, "oauth_token", newJString(oauthToken))
  add(path_578861, "packageName", newJString(packageName))
  add(query_578863, "alt", newJString(alt))
  add(query_578863, "userIp", newJString(userIp))
  add(query_578863, "quotaUser", newJString(quotaUser))
  add(query_578863, "fields", newJString(fields))
  result = call_578860.call(path_578861, query_578863, nil, nil, nil)

var androidpublisherInternalappsharingartifactsUploadapk* = Call_AndroidpublisherInternalappsharingartifactsUploadapk_578618(
    name: "androidpublisherInternalappsharingartifactsUploadapk",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/internalappsharing/{packageName}/artifacts/apk",
    validator: validate_AndroidpublisherInternalappsharingartifactsUploadapk_578619,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInternalappsharingartifactsUploadapk_578620,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherInternalappsharingartifactsUploadbundle_578902 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInternalappsharingartifactsUploadbundle_578904(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/internalappsharing/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/artifacts/bundle")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInternalappsharingartifactsUploadbundle_578903(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Uploads an app bundle to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app; for example, "com.spiffygame".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_578905 = path.getOrDefault("packageName")
  valid_578905 = validateParameter(valid_578905, JString, required = true,
                                 default = nil)
  if valid_578905 != nil:
    section.add "packageName", valid_578905
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
  var valid_578906 = query.getOrDefault("key")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "key", valid_578906
  var valid_578907 = query.getOrDefault("prettyPrint")
  valid_578907 = validateParameter(valid_578907, JBool, required = false,
                                 default = newJBool(true))
  if valid_578907 != nil:
    section.add "prettyPrint", valid_578907
  var valid_578908 = query.getOrDefault("oauth_token")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "oauth_token", valid_578908
  var valid_578909 = query.getOrDefault("alt")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("json"))
  if valid_578909 != nil:
    section.add "alt", valid_578909
  var valid_578910 = query.getOrDefault("userIp")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "userIp", valid_578910
  var valid_578911 = query.getOrDefault("quotaUser")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "quotaUser", valid_578911
  var valid_578912 = query.getOrDefault("fields")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "fields", valid_578912
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578913: Call_AndroidpublisherInternalappsharingartifactsUploadbundle_578902;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads an app bundle to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_578913.validator(path, query, header, formData, body)
  let scheme = call_578913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578913.url(scheme.get, call_578913.host, call_578913.base,
                         call_578913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578913, url, valid)

proc call*(call_578914: Call_AndroidpublisherInternalappsharingartifactsUploadbundle_578902;
          packageName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherInternalappsharingartifactsUploadbundle
  ## Uploads an app bundle to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app; for example, "com.spiffygame".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578915 = newJObject()
  var query_578916 = newJObject()
  add(query_578916, "key", newJString(key))
  add(query_578916, "prettyPrint", newJBool(prettyPrint))
  add(query_578916, "oauth_token", newJString(oauthToken))
  add(path_578915, "packageName", newJString(packageName))
  add(query_578916, "alt", newJString(alt))
  add(query_578916, "userIp", newJString(userIp))
  add(query_578916, "quotaUser", newJString(quotaUser))
  add(query_578916, "fields", newJString(fields))
  result = call_578914.call(path_578915, query_578916, nil, nil, nil)

var androidpublisherInternalappsharingartifactsUploadbundle* = Call_AndroidpublisherInternalappsharingartifactsUploadbundle_578902(
    name: "androidpublisherInternalappsharingartifactsUploadbundle",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/internalappsharing/{packageName}/artifacts/bundle", validator: validate_AndroidpublisherInternalappsharingartifactsUploadbundle_578903,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInternalappsharingartifactsUploadbundle_578904,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsInsert_578917 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsInsert_578919(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsInsert_578918(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new edit for an app, populated with the app's current state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_578920 = path.getOrDefault("packageName")
  valid_578920 = validateParameter(valid_578920, JString, required = true,
                                 default = nil)
  if valid_578920 != nil:
    section.add "packageName", valid_578920
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
  var valid_578921 = query.getOrDefault("key")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "key", valid_578921
  var valid_578922 = query.getOrDefault("prettyPrint")
  valid_578922 = validateParameter(valid_578922, JBool, required = false,
                                 default = newJBool(true))
  if valid_578922 != nil:
    section.add "prettyPrint", valid_578922
  var valid_578923 = query.getOrDefault("oauth_token")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "oauth_token", valid_578923
  var valid_578924 = query.getOrDefault("alt")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = newJString("json"))
  if valid_578924 != nil:
    section.add "alt", valid_578924
  var valid_578925 = query.getOrDefault("userIp")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "userIp", valid_578925
  var valid_578926 = query.getOrDefault("quotaUser")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "quotaUser", valid_578926
  var valid_578927 = query.getOrDefault("fields")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "fields", valid_578927
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

proc call*(call_578929: Call_AndroidpublisherEditsInsert_578917; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new edit for an app, populated with the app's current state.
  ## 
  let valid = call_578929.validator(path, query, header, formData, body)
  let scheme = call_578929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578929.url(scheme.get, call_578929.host, call_578929.base,
                         call_578929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578929, url, valid)

proc call*(call_578930: Call_AndroidpublisherEditsInsert_578917;
          packageName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidpublisherEditsInsert
  ## Creates a new edit for an app, populated with the app's current state.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578931 = newJObject()
  var query_578932 = newJObject()
  var body_578933 = newJObject()
  add(query_578932, "key", newJString(key))
  add(query_578932, "prettyPrint", newJBool(prettyPrint))
  add(query_578932, "oauth_token", newJString(oauthToken))
  add(path_578931, "packageName", newJString(packageName))
  add(query_578932, "alt", newJString(alt))
  add(query_578932, "userIp", newJString(userIp))
  add(query_578932, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578933 = body
  add(query_578932, "fields", newJString(fields))
  result = call_578930.call(path_578931, query_578932, nil, nil, body_578933)

var androidpublisherEditsInsert* = Call_AndroidpublisherEditsInsert_578917(
    name: "androidpublisherEditsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits",
    validator: validate_AndroidpublisherEditsInsert_578918,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsInsert_578919, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsGet_578934 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsGet_578936(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsGet_578935(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_578937 = path.getOrDefault("packageName")
  valid_578937 = validateParameter(valid_578937, JString, required = true,
                                 default = nil)
  if valid_578937 != nil:
    section.add "packageName", valid_578937
  var valid_578938 = path.getOrDefault("editId")
  valid_578938 = validateParameter(valid_578938, JString, required = true,
                                 default = nil)
  if valid_578938 != nil:
    section.add "editId", valid_578938
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
  var valid_578939 = query.getOrDefault("key")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "key", valid_578939
  var valid_578940 = query.getOrDefault("prettyPrint")
  valid_578940 = validateParameter(valid_578940, JBool, required = false,
                                 default = newJBool(true))
  if valid_578940 != nil:
    section.add "prettyPrint", valid_578940
  var valid_578941 = query.getOrDefault("oauth_token")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "oauth_token", valid_578941
  var valid_578942 = query.getOrDefault("alt")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = newJString("json"))
  if valid_578942 != nil:
    section.add "alt", valid_578942
  var valid_578943 = query.getOrDefault("userIp")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "userIp", valid_578943
  var valid_578944 = query.getOrDefault("quotaUser")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "quotaUser", valid_578944
  var valid_578945 = query.getOrDefault("fields")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "fields", valid_578945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578946: Call_AndroidpublisherEditsGet_578934; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_AndroidpublisherEditsGet_578934; packageName: string;
          editId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsGet
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578948 = newJObject()
  var query_578949 = newJObject()
  add(query_578949, "key", newJString(key))
  add(query_578949, "prettyPrint", newJBool(prettyPrint))
  add(query_578949, "oauth_token", newJString(oauthToken))
  add(path_578948, "packageName", newJString(packageName))
  add(path_578948, "editId", newJString(editId))
  add(query_578949, "alt", newJString(alt))
  add(query_578949, "userIp", newJString(userIp))
  add(query_578949, "quotaUser", newJString(quotaUser))
  add(query_578949, "fields", newJString(fields))
  result = call_578947.call(path_578948, query_578949, nil, nil, nil)

var androidpublisherEditsGet* = Call_AndroidpublisherEditsGet_578934(
    name: "androidpublisherEditsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsGet_578935,
    base: "/androidpublisher/v3/applications", url: url_AndroidpublisherEditsGet_578936,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDelete_578950 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsDelete_578952(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsDelete_578951(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_578953 = path.getOrDefault("packageName")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "packageName", valid_578953
  var valid_578954 = path.getOrDefault("editId")
  valid_578954 = validateParameter(valid_578954, JString, required = true,
                                 default = nil)
  if valid_578954 != nil:
    section.add "editId", valid_578954
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
  var valid_578955 = query.getOrDefault("key")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "key", valid_578955
  var valid_578956 = query.getOrDefault("prettyPrint")
  valid_578956 = validateParameter(valid_578956, JBool, required = false,
                                 default = newJBool(true))
  if valid_578956 != nil:
    section.add "prettyPrint", valid_578956
  var valid_578957 = query.getOrDefault("oauth_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "oauth_token", valid_578957
  var valid_578958 = query.getOrDefault("alt")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("json"))
  if valid_578958 != nil:
    section.add "alt", valid_578958
  var valid_578959 = query.getOrDefault("userIp")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "userIp", valid_578959
  var valid_578960 = query.getOrDefault("quotaUser")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "quotaUser", valid_578960
  var valid_578961 = query.getOrDefault("fields")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "fields", valid_578961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578962: Call_AndroidpublisherEditsDelete_578950; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ## 
  let valid = call_578962.validator(path, query, header, formData, body)
  let scheme = call_578962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578962.url(scheme.get, call_578962.host, call_578962.base,
                         call_578962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578962, url, valid)

proc call*(call_578963: Call_AndroidpublisherEditsDelete_578950;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsDelete
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578964 = newJObject()
  var query_578965 = newJObject()
  add(query_578965, "key", newJString(key))
  add(query_578965, "prettyPrint", newJBool(prettyPrint))
  add(query_578965, "oauth_token", newJString(oauthToken))
  add(path_578964, "packageName", newJString(packageName))
  add(path_578964, "editId", newJString(editId))
  add(query_578965, "alt", newJString(alt))
  add(query_578965, "userIp", newJString(userIp))
  add(query_578965, "quotaUser", newJString(quotaUser))
  add(query_578965, "fields", newJString(fields))
  result = call_578963.call(path_578964, query_578965, nil, nil, nil)

var androidpublisherEditsDelete* = Call_AndroidpublisherEditsDelete_578950(
    name: "androidpublisherEditsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsDelete_578951,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDelete_578952, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksUpload_578982 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApksUpload_578984(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApksUpload_578983(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_578985 = path.getOrDefault("packageName")
  valid_578985 = validateParameter(valid_578985, JString, required = true,
                                 default = nil)
  if valid_578985 != nil:
    section.add "packageName", valid_578985
  var valid_578986 = path.getOrDefault("editId")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "editId", valid_578986
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
  var valid_578987 = query.getOrDefault("key")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "key", valid_578987
  var valid_578988 = query.getOrDefault("prettyPrint")
  valid_578988 = validateParameter(valid_578988, JBool, required = false,
                                 default = newJBool(true))
  if valid_578988 != nil:
    section.add "prettyPrint", valid_578988
  var valid_578989 = query.getOrDefault("oauth_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "oauth_token", valid_578989
  var valid_578990 = query.getOrDefault("alt")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("json"))
  if valid_578990 != nil:
    section.add "alt", valid_578990
  var valid_578991 = query.getOrDefault("userIp")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "userIp", valid_578991
  var valid_578992 = query.getOrDefault("quotaUser")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "quotaUser", valid_578992
  var valid_578993 = query.getOrDefault("fields")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "fields", valid_578993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578994: Call_AndroidpublisherEditsApksUpload_578982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_578994.validator(path, query, header, formData, body)
  let scheme = call_578994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578994.url(scheme.get, call_578994.host, call_578994.base,
                         call_578994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578994, url, valid)

proc call*(call_578995: Call_AndroidpublisherEditsApksUpload_578982;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsApksUpload
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578996 = newJObject()
  var query_578997 = newJObject()
  add(query_578997, "key", newJString(key))
  add(query_578997, "prettyPrint", newJBool(prettyPrint))
  add(query_578997, "oauth_token", newJString(oauthToken))
  add(path_578996, "packageName", newJString(packageName))
  add(path_578996, "editId", newJString(editId))
  add(query_578997, "alt", newJString(alt))
  add(query_578997, "userIp", newJString(userIp))
  add(query_578997, "quotaUser", newJString(quotaUser))
  add(query_578997, "fields", newJString(fields))
  result = call_578995.call(path_578996, query_578997, nil, nil, nil)

var androidpublisherEditsApksUpload* = Call_AndroidpublisherEditsApksUpload_578982(
    name: "androidpublisherEditsApksUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksUpload_578983,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksUpload_578984, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksList_578966 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApksList_578968(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApksList_578967(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_578969 = path.getOrDefault("packageName")
  valid_578969 = validateParameter(valid_578969, JString, required = true,
                                 default = nil)
  if valid_578969 != nil:
    section.add "packageName", valid_578969
  var valid_578970 = path.getOrDefault("editId")
  valid_578970 = validateParameter(valid_578970, JString, required = true,
                                 default = nil)
  if valid_578970 != nil:
    section.add "editId", valid_578970
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
  var valid_578974 = query.getOrDefault("alt")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = newJString("json"))
  if valid_578974 != nil:
    section.add "alt", valid_578974
  var valid_578975 = query.getOrDefault("userIp")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "userIp", valid_578975
  var valid_578976 = query.getOrDefault("quotaUser")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "quotaUser", valid_578976
  var valid_578977 = query.getOrDefault("fields")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "fields", valid_578977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578978: Call_AndroidpublisherEditsApksList_578966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_578978.validator(path, query, header, formData, body)
  let scheme = call_578978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578978.url(scheme.get, call_578978.host, call_578978.base,
                         call_578978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578978, url, valid)

proc call*(call_578979: Call_AndroidpublisherEditsApksList_578966;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsApksList
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578980 = newJObject()
  var query_578981 = newJObject()
  add(query_578981, "key", newJString(key))
  add(query_578981, "prettyPrint", newJBool(prettyPrint))
  add(query_578981, "oauth_token", newJString(oauthToken))
  add(path_578980, "packageName", newJString(packageName))
  add(path_578980, "editId", newJString(editId))
  add(query_578981, "alt", newJString(alt))
  add(query_578981, "userIp", newJString(userIp))
  add(query_578981, "quotaUser", newJString(quotaUser))
  add(query_578981, "fields", newJString(fields))
  result = call_578979.call(path_578980, query_578981, nil, nil, nil)

var androidpublisherEditsApksList* = Call_AndroidpublisherEditsApksList_578966(
    name: "androidpublisherEditsApksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksList_578967,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksList_578968, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksAddexternallyhosted_578998 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApksAddexternallyhosted_579000(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/externallyHosted")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApksAddexternallyhosted_578999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579001 = path.getOrDefault("packageName")
  valid_579001 = validateParameter(valid_579001, JString, required = true,
                                 default = nil)
  if valid_579001 != nil:
    section.add "packageName", valid_579001
  var valid_579002 = path.getOrDefault("editId")
  valid_579002 = validateParameter(valid_579002, JString, required = true,
                                 default = nil)
  if valid_579002 != nil:
    section.add "editId", valid_579002
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
  var valid_579003 = query.getOrDefault("key")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "key", valid_579003
  var valid_579004 = query.getOrDefault("prettyPrint")
  valid_579004 = validateParameter(valid_579004, JBool, required = false,
                                 default = newJBool(true))
  if valid_579004 != nil:
    section.add "prettyPrint", valid_579004
  var valid_579005 = query.getOrDefault("oauth_token")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "oauth_token", valid_579005
  var valid_579006 = query.getOrDefault("alt")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = newJString("json"))
  if valid_579006 != nil:
    section.add "alt", valid_579006
  var valid_579007 = query.getOrDefault("userIp")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "userIp", valid_579007
  var valid_579008 = query.getOrDefault("quotaUser")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "quotaUser", valid_579008
  var valid_579009 = query.getOrDefault("fields")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "fields", valid_579009
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

proc call*(call_579011: Call_AndroidpublisherEditsApksAddexternallyhosted_578998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ## 
  let valid = call_579011.validator(path, query, header, formData, body)
  let scheme = call_579011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579011.url(scheme.get, call_579011.host, call_579011.base,
                         call_579011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579011, url, valid)

proc call*(call_579012: Call_AndroidpublisherEditsApksAddexternallyhosted_578998;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidpublisherEditsApksAddexternallyhosted
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579013 = newJObject()
  var query_579014 = newJObject()
  var body_579015 = newJObject()
  add(query_579014, "key", newJString(key))
  add(query_579014, "prettyPrint", newJBool(prettyPrint))
  add(query_579014, "oauth_token", newJString(oauthToken))
  add(path_579013, "packageName", newJString(packageName))
  add(path_579013, "editId", newJString(editId))
  add(query_579014, "alt", newJString(alt))
  add(query_579014, "userIp", newJString(userIp))
  add(query_579014, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579015 = body
  add(query_579014, "fields", newJString(fields))
  result = call_579012.call(path_579013, query_579014, nil, nil, body_579015)

var androidpublisherEditsApksAddexternallyhosted* = Call_AndroidpublisherEditsApksAddexternallyhosted_578998(
    name: "androidpublisherEditsApksAddexternallyhosted",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/externallyHosted",
    validator: validate_AndroidpublisherEditsApksAddexternallyhosted_578999,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksAddexternallyhosted_579000,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDeobfuscationfilesUpload_579016 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsDeobfuscationfilesUpload_579018(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "deobfuscationFileType" in path,
        "`deobfuscationFileType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/deobfuscationFiles/"),
               (kind: VariableSegment, value: "deobfuscationFileType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsDeobfuscationfilesUpload_579017(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier of the Android app for which the deobfuscatiuon files are being uploaded; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   deobfuscationFileType: JString (required)
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose deobfuscation file is being uploaded.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579019 = path.getOrDefault("packageName")
  valid_579019 = validateParameter(valid_579019, JString, required = true,
                                 default = nil)
  if valid_579019 != nil:
    section.add "packageName", valid_579019
  var valid_579020 = path.getOrDefault("editId")
  valid_579020 = validateParameter(valid_579020, JString, required = true,
                                 default = nil)
  if valid_579020 != nil:
    section.add "editId", valid_579020
  var valid_579021 = path.getOrDefault("deobfuscationFileType")
  valid_579021 = validateParameter(valid_579021, JString, required = true,
                                 default = newJString("proguard"))
  if valid_579021 != nil:
    section.add "deobfuscationFileType", valid_579021
  var valid_579022 = path.getOrDefault("apkVersionCode")
  valid_579022 = validateParameter(valid_579022, JInt, required = true, default = nil)
  if valid_579022 != nil:
    section.add "apkVersionCode", valid_579022
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
  if body != nil:
    result.add "body", body

proc call*(call_579030: Call_AndroidpublisherEditsDeobfuscationfilesUpload_579016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ## 
  let valid = call_579030.validator(path, query, header, formData, body)
  let scheme = call_579030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579030.url(scheme.get, call_579030.host, call_579030.base,
                         call_579030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579030, url, valid)

proc call*(call_579031: Call_AndroidpublisherEditsDeobfuscationfilesUpload_579016;
          packageName: string; editId: string; apkVersionCode: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          deobfuscationFileType: string = "proguard"; fields: string = ""): Recallable =
  ## androidpublisherEditsDeobfuscationfilesUpload
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier of the Android app for which the deobfuscatiuon files are being uploaded; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   deobfuscationFileType: string (required)
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose deobfuscation file is being uploaded.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579032 = newJObject()
  var query_579033 = newJObject()
  add(query_579033, "key", newJString(key))
  add(query_579033, "prettyPrint", newJBool(prettyPrint))
  add(query_579033, "oauth_token", newJString(oauthToken))
  add(path_579032, "packageName", newJString(packageName))
  add(path_579032, "editId", newJString(editId))
  add(query_579033, "alt", newJString(alt))
  add(query_579033, "userIp", newJString(userIp))
  add(query_579033, "quotaUser", newJString(quotaUser))
  add(path_579032, "deobfuscationFileType", newJString(deobfuscationFileType))
  add(path_579032, "apkVersionCode", newJInt(apkVersionCode))
  add(query_579033, "fields", newJString(fields))
  result = call_579031.call(path_579032, query_579033, nil, nil, nil)

var androidpublisherEditsDeobfuscationfilesUpload* = Call_AndroidpublisherEditsDeobfuscationfilesUpload_579016(
    name: "androidpublisherEditsDeobfuscationfilesUpload",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType}",
    validator: validate_AndroidpublisherEditsDeobfuscationfilesUpload_579017,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDeobfuscationfilesUpload_579018,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpdate_579052 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsExpansionfilesUpdate_579054(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "expansionFileType" in path,
        "`expansionFileType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/expansionFiles/"),
               (kind: VariableSegment, value: "expansionFileType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsExpansionfilesUpdate_579053(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  ##   expansionFileType: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579055 = path.getOrDefault("packageName")
  valid_579055 = validateParameter(valid_579055, JString, required = true,
                                 default = nil)
  if valid_579055 != nil:
    section.add "packageName", valid_579055
  var valid_579056 = path.getOrDefault("editId")
  valid_579056 = validateParameter(valid_579056, JString, required = true,
                                 default = nil)
  if valid_579056 != nil:
    section.add "editId", valid_579056
  var valid_579057 = path.getOrDefault("apkVersionCode")
  valid_579057 = validateParameter(valid_579057, JInt, required = true, default = nil)
  if valid_579057 != nil:
    section.add "apkVersionCode", valid_579057
  var valid_579058 = path.getOrDefault("expansionFileType")
  valid_579058 = validateParameter(valid_579058, JString, required = true,
                                 default = newJString("main"))
  if valid_579058 != nil:
    section.add "expansionFileType", valid_579058
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
  var valid_579059 = query.getOrDefault("key")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "key", valid_579059
  var valid_579060 = query.getOrDefault("prettyPrint")
  valid_579060 = validateParameter(valid_579060, JBool, required = false,
                                 default = newJBool(true))
  if valid_579060 != nil:
    section.add "prettyPrint", valid_579060
  var valid_579061 = query.getOrDefault("oauth_token")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "oauth_token", valid_579061
  var valid_579062 = query.getOrDefault("alt")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = newJString("json"))
  if valid_579062 != nil:
    section.add "alt", valid_579062
  var valid_579063 = query.getOrDefault("userIp")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "userIp", valid_579063
  var valid_579064 = query.getOrDefault("quotaUser")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "quotaUser", valid_579064
  var valid_579065 = query.getOrDefault("fields")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "fields", valid_579065
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

proc call*(call_579067: Call_AndroidpublisherEditsExpansionfilesUpdate_579052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ## 
  let valid = call_579067.validator(path, query, header, formData, body)
  let scheme = call_579067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579067.url(scheme.get, call_579067.host, call_579067.base,
                         call_579067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579067, url, valid)

proc call*(call_579068: Call_AndroidpublisherEditsExpansionfilesUpdate_579052;
          packageName: string; editId: string; apkVersionCode: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          expansionFileType: string = "main"; fields: string = ""): Recallable =
  ## androidpublisherEditsExpansionfilesUpdate
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  ##   body: JObject
  ##   expansionFileType: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579069 = newJObject()
  var query_579070 = newJObject()
  var body_579071 = newJObject()
  add(query_579070, "key", newJString(key))
  add(query_579070, "prettyPrint", newJBool(prettyPrint))
  add(query_579070, "oauth_token", newJString(oauthToken))
  add(path_579069, "packageName", newJString(packageName))
  add(path_579069, "editId", newJString(editId))
  add(query_579070, "alt", newJString(alt))
  add(query_579070, "userIp", newJString(userIp))
  add(query_579070, "quotaUser", newJString(quotaUser))
  add(path_579069, "apkVersionCode", newJInt(apkVersionCode))
  if body != nil:
    body_579071 = body
  add(path_579069, "expansionFileType", newJString(expansionFileType))
  add(query_579070, "fields", newJString(fields))
  result = call_579068.call(path_579069, query_579070, nil, nil, body_579071)

var androidpublisherEditsExpansionfilesUpdate* = Call_AndroidpublisherEditsExpansionfilesUpdate_579052(
    name: "androidpublisherEditsExpansionfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpdate_579053,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpdate_579054,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpload_579072 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsExpansionfilesUpload_579074(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "expansionFileType" in path,
        "`expansionFileType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/expansionFiles/"),
               (kind: VariableSegment, value: "expansionFileType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsExpansionfilesUpload_579073(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads and attaches a new Expansion File to the APK specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  ##   expansionFileType: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579075 = path.getOrDefault("packageName")
  valid_579075 = validateParameter(valid_579075, JString, required = true,
                                 default = nil)
  if valid_579075 != nil:
    section.add "packageName", valid_579075
  var valid_579076 = path.getOrDefault("editId")
  valid_579076 = validateParameter(valid_579076, JString, required = true,
                                 default = nil)
  if valid_579076 != nil:
    section.add "editId", valid_579076
  var valid_579077 = path.getOrDefault("apkVersionCode")
  valid_579077 = validateParameter(valid_579077, JInt, required = true, default = nil)
  if valid_579077 != nil:
    section.add "apkVersionCode", valid_579077
  var valid_579078 = path.getOrDefault("expansionFileType")
  valid_579078 = validateParameter(valid_579078, JString, required = true,
                                 default = newJString("main"))
  if valid_579078 != nil:
    section.add "expansionFileType", valid_579078
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
  var valid_579079 = query.getOrDefault("key")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "key", valid_579079
  var valid_579080 = query.getOrDefault("prettyPrint")
  valid_579080 = validateParameter(valid_579080, JBool, required = false,
                                 default = newJBool(true))
  if valid_579080 != nil:
    section.add "prettyPrint", valid_579080
  var valid_579081 = query.getOrDefault("oauth_token")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "oauth_token", valid_579081
  var valid_579082 = query.getOrDefault("alt")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = newJString("json"))
  if valid_579082 != nil:
    section.add "alt", valid_579082
  var valid_579083 = query.getOrDefault("userIp")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "userIp", valid_579083
  var valid_579084 = query.getOrDefault("quotaUser")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "quotaUser", valid_579084
  var valid_579085 = query.getOrDefault("fields")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "fields", valid_579085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579086: Call_AndroidpublisherEditsExpansionfilesUpload_579072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads and attaches a new Expansion File to the APK specified.
  ## 
  let valid = call_579086.validator(path, query, header, formData, body)
  let scheme = call_579086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579086.url(scheme.get, call_579086.host, call_579086.base,
                         call_579086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579086, url, valid)

proc call*(call_579087: Call_AndroidpublisherEditsExpansionfilesUpload_579072;
          packageName: string; editId: string; apkVersionCode: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          expansionFileType: string = "main"; fields: string = ""): Recallable =
  ## androidpublisherEditsExpansionfilesUpload
  ## Uploads and attaches a new Expansion File to the APK specified.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  ##   expansionFileType: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579088 = newJObject()
  var query_579089 = newJObject()
  add(query_579089, "key", newJString(key))
  add(query_579089, "prettyPrint", newJBool(prettyPrint))
  add(query_579089, "oauth_token", newJString(oauthToken))
  add(path_579088, "packageName", newJString(packageName))
  add(path_579088, "editId", newJString(editId))
  add(query_579089, "alt", newJString(alt))
  add(query_579089, "userIp", newJString(userIp))
  add(query_579089, "quotaUser", newJString(quotaUser))
  add(path_579088, "apkVersionCode", newJInt(apkVersionCode))
  add(path_579088, "expansionFileType", newJString(expansionFileType))
  add(query_579089, "fields", newJString(fields))
  result = call_579087.call(path_579088, query_579089, nil, nil, nil)

var androidpublisherEditsExpansionfilesUpload* = Call_AndroidpublisherEditsExpansionfilesUpload_579072(
    name: "androidpublisherEditsExpansionfilesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpload_579073,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpload_579074,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesGet_579034 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsExpansionfilesGet_579036(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "expansionFileType" in path,
        "`expansionFileType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/expansionFiles/"),
               (kind: VariableSegment, value: "expansionFileType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsExpansionfilesGet_579035(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the Expansion File configuration for the APK specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  ##   expansionFileType: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579037 = path.getOrDefault("packageName")
  valid_579037 = validateParameter(valid_579037, JString, required = true,
                                 default = nil)
  if valid_579037 != nil:
    section.add "packageName", valid_579037
  var valid_579038 = path.getOrDefault("editId")
  valid_579038 = validateParameter(valid_579038, JString, required = true,
                                 default = nil)
  if valid_579038 != nil:
    section.add "editId", valid_579038
  var valid_579039 = path.getOrDefault("apkVersionCode")
  valid_579039 = validateParameter(valid_579039, JInt, required = true, default = nil)
  if valid_579039 != nil:
    section.add "apkVersionCode", valid_579039
  var valid_579040 = path.getOrDefault("expansionFileType")
  valid_579040 = validateParameter(valid_579040, JString, required = true,
                                 default = newJString("main"))
  if valid_579040 != nil:
    section.add "expansionFileType", valid_579040
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
  var valid_579041 = query.getOrDefault("key")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "key", valid_579041
  var valid_579042 = query.getOrDefault("prettyPrint")
  valid_579042 = validateParameter(valid_579042, JBool, required = false,
                                 default = newJBool(true))
  if valid_579042 != nil:
    section.add "prettyPrint", valid_579042
  var valid_579043 = query.getOrDefault("oauth_token")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "oauth_token", valid_579043
  var valid_579044 = query.getOrDefault("alt")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = newJString("json"))
  if valid_579044 != nil:
    section.add "alt", valid_579044
  var valid_579045 = query.getOrDefault("userIp")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "userIp", valid_579045
  var valid_579046 = query.getOrDefault("quotaUser")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "quotaUser", valid_579046
  var valid_579047 = query.getOrDefault("fields")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "fields", valid_579047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579048: Call_AndroidpublisherEditsExpansionfilesGet_579034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the Expansion File configuration for the APK specified.
  ## 
  let valid = call_579048.validator(path, query, header, formData, body)
  let scheme = call_579048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579048.url(scheme.get, call_579048.host, call_579048.base,
                         call_579048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579048, url, valid)

proc call*(call_579049: Call_AndroidpublisherEditsExpansionfilesGet_579034;
          packageName: string; editId: string; apkVersionCode: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          expansionFileType: string = "main"; fields: string = ""): Recallable =
  ## androidpublisherEditsExpansionfilesGet
  ## Fetches the Expansion File configuration for the APK specified.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  ##   expansionFileType: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579050 = newJObject()
  var query_579051 = newJObject()
  add(query_579051, "key", newJString(key))
  add(query_579051, "prettyPrint", newJBool(prettyPrint))
  add(query_579051, "oauth_token", newJString(oauthToken))
  add(path_579050, "packageName", newJString(packageName))
  add(path_579050, "editId", newJString(editId))
  add(query_579051, "alt", newJString(alt))
  add(query_579051, "userIp", newJString(userIp))
  add(query_579051, "quotaUser", newJString(quotaUser))
  add(path_579050, "apkVersionCode", newJInt(apkVersionCode))
  add(path_579050, "expansionFileType", newJString(expansionFileType))
  add(query_579051, "fields", newJString(fields))
  result = call_579049.call(path_579050, query_579051, nil, nil, nil)

var androidpublisherEditsExpansionfilesGet* = Call_AndroidpublisherEditsExpansionfilesGet_579034(
    name: "androidpublisherEditsExpansionfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesGet_579035,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesGet_579036,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesPatch_579090 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsExpansionfilesPatch_579092(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "expansionFileType" in path,
        "`expansionFileType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/expansionFiles/"),
               (kind: VariableSegment, value: "expansionFileType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsExpansionfilesPatch_579091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  ##   expansionFileType: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579093 = path.getOrDefault("packageName")
  valid_579093 = validateParameter(valid_579093, JString, required = true,
                                 default = nil)
  if valid_579093 != nil:
    section.add "packageName", valid_579093
  var valid_579094 = path.getOrDefault("editId")
  valid_579094 = validateParameter(valid_579094, JString, required = true,
                                 default = nil)
  if valid_579094 != nil:
    section.add "editId", valid_579094
  var valid_579095 = path.getOrDefault("apkVersionCode")
  valid_579095 = validateParameter(valid_579095, JInt, required = true, default = nil)
  if valid_579095 != nil:
    section.add "apkVersionCode", valid_579095
  var valid_579096 = path.getOrDefault("expansionFileType")
  valid_579096 = validateParameter(valid_579096, JString, required = true,
                                 default = newJString("main"))
  if valid_579096 != nil:
    section.add "expansionFileType", valid_579096
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
  var valid_579097 = query.getOrDefault("key")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "key", valid_579097
  var valid_579098 = query.getOrDefault("prettyPrint")
  valid_579098 = validateParameter(valid_579098, JBool, required = false,
                                 default = newJBool(true))
  if valid_579098 != nil:
    section.add "prettyPrint", valid_579098
  var valid_579099 = query.getOrDefault("oauth_token")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "oauth_token", valid_579099
  var valid_579100 = query.getOrDefault("alt")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = newJString("json"))
  if valid_579100 != nil:
    section.add "alt", valid_579100
  var valid_579101 = query.getOrDefault("userIp")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "userIp", valid_579101
  var valid_579102 = query.getOrDefault("quotaUser")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "quotaUser", valid_579102
  var valid_579103 = query.getOrDefault("fields")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "fields", valid_579103
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

proc call*(call_579105: Call_AndroidpublisherEditsExpansionfilesPatch_579090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ## 
  let valid = call_579105.validator(path, query, header, formData, body)
  let scheme = call_579105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579105.url(scheme.get, call_579105.host, call_579105.base,
                         call_579105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579105, url, valid)

proc call*(call_579106: Call_AndroidpublisherEditsExpansionfilesPatch_579090;
          packageName: string; editId: string; apkVersionCode: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          expansionFileType: string = "main"; fields: string = ""): Recallable =
  ## androidpublisherEditsExpansionfilesPatch
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  ##   body: JObject
  ##   expansionFileType: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579107 = newJObject()
  var query_579108 = newJObject()
  var body_579109 = newJObject()
  add(query_579108, "key", newJString(key))
  add(query_579108, "prettyPrint", newJBool(prettyPrint))
  add(query_579108, "oauth_token", newJString(oauthToken))
  add(path_579107, "packageName", newJString(packageName))
  add(path_579107, "editId", newJString(editId))
  add(query_579108, "alt", newJString(alt))
  add(query_579108, "userIp", newJString(userIp))
  add(query_579108, "quotaUser", newJString(quotaUser))
  add(path_579107, "apkVersionCode", newJInt(apkVersionCode))
  if body != nil:
    body_579109 = body
  add(path_579107, "expansionFileType", newJString(expansionFileType))
  add(query_579108, "fields", newJString(fields))
  result = call_579106.call(path_579107, query_579108, nil, nil, body_579109)

var androidpublisherEditsExpansionfilesPatch* = Call_AndroidpublisherEditsExpansionfilesPatch_579090(
    name: "androidpublisherEditsExpansionfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesPatch_579091,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesPatch_579092,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesUpload_579126 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsBundlesUpload_579128(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/bundles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsBundlesUpload_579127(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579129 = path.getOrDefault("packageName")
  valid_579129 = validateParameter(valid_579129, JString, required = true,
                                 default = nil)
  if valid_579129 != nil:
    section.add "packageName", valid_579129
  var valid_579130 = path.getOrDefault("editId")
  valid_579130 = validateParameter(valid_579130, JString, required = true,
                                 default = nil)
  if valid_579130 != nil:
    section.add "editId", valid_579130
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   ackBundleInstallationWarning: JBool
  ##                               : Must be set to true if the bundle installation may trigger a warning on user devices (for example, if installation size may be over a threshold, typically 100 MB).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579131 = query.getOrDefault("key")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "key", valid_579131
  var valid_579132 = query.getOrDefault("prettyPrint")
  valid_579132 = validateParameter(valid_579132, JBool, required = false,
                                 default = newJBool(true))
  if valid_579132 != nil:
    section.add "prettyPrint", valid_579132
  var valid_579133 = query.getOrDefault("oauth_token")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "oauth_token", valid_579133
  var valid_579134 = query.getOrDefault("ackBundleInstallationWarning")
  valid_579134 = validateParameter(valid_579134, JBool, required = false, default = nil)
  if valid_579134 != nil:
    section.add "ackBundleInstallationWarning", valid_579134
  var valid_579135 = query.getOrDefault("alt")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = newJString("json"))
  if valid_579135 != nil:
    section.add "alt", valid_579135
  var valid_579136 = query.getOrDefault("userIp")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "userIp", valid_579136
  var valid_579137 = query.getOrDefault("quotaUser")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "quotaUser", valid_579137
  var valid_579138 = query.getOrDefault("fields")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "fields", valid_579138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579139: Call_AndroidpublisherEditsBundlesUpload_579126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_579139.validator(path, query, header, formData, body)
  let scheme = call_579139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579139.url(scheme.get, call_579139.host, call_579139.base,
                         call_579139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579139, url, valid)

proc call*(call_579140: Call_AndroidpublisherEditsBundlesUpload_579126;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          ackBundleInstallationWarning: bool = false; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsBundlesUpload
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   ackBundleInstallationWarning: bool
  ##                               : Must be set to true if the bundle installation may trigger a warning on user devices (for example, if installation size may be over a threshold, typically 100 MB).
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579141 = newJObject()
  var query_579142 = newJObject()
  add(query_579142, "key", newJString(key))
  add(query_579142, "prettyPrint", newJBool(prettyPrint))
  add(query_579142, "oauth_token", newJString(oauthToken))
  add(path_579141, "packageName", newJString(packageName))
  add(query_579142, "ackBundleInstallationWarning",
      newJBool(ackBundleInstallationWarning))
  add(path_579141, "editId", newJString(editId))
  add(query_579142, "alt", newJString(alt))
  add(query_579142, "userIp", newJString(userIp))
  add(query_579142, "quotaUser", newJString(quotaUser))
  add(query_579142, "fields", newJString(fields))
  result = call_579140.call(path_579141, query_579142, nil, nil, nil)

var androidpublisherEditsBundlesUpload* = Call_AndroidpublisherEditsBundlesUpload_579126(
    name: "androidpublisherEditsBundlesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesUpload_579127,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsBundlesUpload_579128, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesList_579110 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsBundlesList_579112(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/bundles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsBundlesList_579111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579113 = path.getOrDefault("packageName")
  valid_579113 = validateParameter(valid_579113, JString, required = true,
                                 default = nil)
  if valid_579113 != nil:
    section.add "packageName", valid_579113
  var valid_579114 = path.getOrDefault("editId")
  valid_579114 = validateParameter(valid_579114, JString, required = true,
                                 default = nil)
  if valid_579114 != nil:
    section.add "editId", valid_579114
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
  var valid_579115 = query.getOrDefault("key")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "key", valid_579115
  var valid_579116 = query.getOrDefault("prettyPrint")
  valid_579116 = validateParameter(valid_579116, JBool, required = false,
                                 default = newJBool(true))
  if valid_579116 != nil:
    section.add "prettyPrint", valid_579116
  var valid_579117 = query.getOrDefault("oauth_token")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "oauth_token", valid_579117
  var valid_579118 = query.getOrDefault("alt")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = newJString("json"))
  if valid_579118 != nil:
    section.add "alt", valid_579118
  var valid_579119 = query.getOrDefault("userIp")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "userIp", valid_579119
  var valid_579120 = query.getOrDefault("quotaUser")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "quotaUser", valid_579120
  var valid_579121 = query.getOrDefault("fields")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "fields", valid_579121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579122: Call_AndroidpublisherEditsBundlesList_579110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_579122.validator(path, query, header, formData, body)
  let scheme = call_579122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579122.url(scheme.get, call_579122.host, call_579122.base,
                         call_579122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579122, url, valid)

proc call*(call_579123: Call_AndroidpublisherEditsBundlesList_579110;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsBundlesList
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579124 = newJObject()
  var query_579125 = newJObject()
  add(query_579125, "key", newJString(key))
  add(query_579125, "prettyPrint", newJBool(prettyPrint))
  add(query_579125, "oauth_token", newJString(oauthToken))
  add(path_579124, "packageName", newJString(packageName))
  add(path_579124, "editId", newJString(editId))
  add(query_579125, "alt", newJString(alt))
  add(query_579125, "userIp", newJString(userIp))
  add(query_579125, "quotaUser", newJString(quotaUser))
  add(query_579125, "fields", newJString(fields))
  result = call_579123.call(path_579124, query_579125, nil, nil, nil)

var androidpublisherEditsBundlesList* = Call_AndroidpublisherEditsBundlesList_579110(
    name: "androidpublisherEditsBundlesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesList_579111,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsBundlesList_579112, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsUpdate_579159 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsDetailsUpdate_579161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/details")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsDetailsUpdate_579160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates app details for this edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579162 = path.getOrDefault("packageName")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "packageName", valid_579162
  var valid_579163 = path.getOrDefault("editId")
  valid_579163 = validateParameter(valid_579163, JString, required = true,
                                 default = nil)
  if valid_579163 != nil:
    section.add "editId", valid_579163
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

proc call*(call_579172: Call_AndroidpublisherEditsDetailsUpdate_579159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit.
  ## 
  let valid = call_579172.validator(path, query, header, formData, body)
  let scheme = call_579172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579172.url(scheme.get, call_579172.host, call_579172.base,
                         call_579172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579172, url, valid)

proc call*(call_579173: Call_AndroidpublisherEditsDetailsUpdate_579159;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidpublisherEditsDetailsUpdate
  ## Updates app details for this edit.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579174 = newJObject()
  var query_579175 = newJObject()
  var body_579176 = newJObject()
  add(query_579175, "key", newJString(key))
  add(query_579175, "prettyPrint", newJBool(prettyPrint))
  add(query_579175, "oauth_token", newJString(oauthToken))
  add(path_579174, "packageName", newJString(packageName))
  add(path_579174, "editId", newJString(editId))
  add(query_579175, "alt", newJString(alt))
  add(query_579175, "userIp", newJString(userIp))
  add(query_579175, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579176 = body
  add(query_579175, "fields", newJString(fields))
  result = call_579173.call(path_579174, query_579175, nil, nil, body_579176)

var androidpublisherEditsDetailsUpdate* = Call_AndroidpublisherEditsDetailsUpdate_579159(
    name: "androidpublisherEditsDetailsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsUpdate_579160,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsUpdate_579161, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsGet_579143 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsDetailsGet_579145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/details")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsDetailsGet_579144(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579146 = path.getOrDefault("packageName")
  valid_579146 = validateParameter(valid_579146, JString, required = true,
                                 default = nil)
  if valid_579146 != nil:
    section.add "packageName", valid_579146
  var valid_579147 = path.getOrDefault("editId")
  valid_579147 = validateParameter(valid_579147, JString, required = true,
                                 default = nil)
  if valid_579147 != nil:
    section.add "editId", valid_579147
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

proc call*(call_579155: Call_AndroidpublisherEditsDetailsGet_579143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ## 
  let valid = call_579155.validator(path, query, header, formData, body)
  let scheme = call_579155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579155.url(scheme.get, call_579155.host, call_579155.base,
                         call_579155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579155, url, valid)

proc call*(call_579156: Call_AndroidpublisherEditsDetailsGet_579143;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsDetailsGet
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579157 = newJObject()
  var query_579158 = newJObject()
  add(query_579158, "key", newJString(key))
  add(query_579158, "prettyPrint", newJBool(prettyPrint))
  add(query_579158, "oauth_token", newJString(oauthToken))
  add(path_579157, "packageName", newJString(packageName))
  add(path_579157, "editId", newJString(editId))
  add(query_579158, "alt", newJString(alt))
  add(query_579158, "userIp", newJString(userIp))
  add(query_579158, "quotaUser", newJString(quotaUser))
  add(query_579158, "fields", newJString(fields))
  result = call_579156.call(path_579157, query_579158, nil, nil, nil)

var androidpublisherEditsDetailsGet* = Call_AndroidpublisherEditsDetailsGet_579143(
    name: "androidpublisherEditsDetailsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsGet_579144,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsGet_579145, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsPatch_579177 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsDetailsPatch_579179(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/details")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsDetailsPatch_579178(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates app details for this edit. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579180 = path.getOrDefault("packageName")
  valid_579180 = validateParameter(valid_579180, JString, required = true,
                                 default = nil)
  if valid_579180 != nil:
    section.add "packageName", valid_579180
  var valid_579181 = path.getOrDefault("editId")
  valid_579181 = validateParameter(valid_579181, JString, required = true,
                                 default = nil)
  if valid_579181 != nil:
    section.add "editId", valid_579181
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
  var valid_579188 = query.getOrDefault("fields")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "fields", valid_579188
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

proc call*(call_579190: Call_AndroidpublisherEditsDetailsPatch_579177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit. This method supports patch semantics.
  ## 
  let valid = call_579190.validator(path, query, header, formData, body)
  let scheme = call_579190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579190.url(scheme.get, call_579190.host, call_579190.base,
                         call_579190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579190, url, valid)

proc call*(call_579191: Call_AndroidpublisherEditsDetailsPatch_579177;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidpublisherEditsDetailsPatch
  ## Updates app details for this edit. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579192 = newJObject()
  var query_579193 = newJObject()
  var body_579194 = newJObject()
  add(query_579193, "key", newJString(key))
  add(query_579193, "prettyPrint", newJBool(prettyPrint))
  add(query_579193, "oauth_token", newJString(oauthToken))
  add(path_579192, "packageName", newJString(packageName))
  add(path_579192, "editId", newJString(editId))
  add(query_579193, "alt", newJString(alt))
  add(query_579193, "userIp", newJString(userIp))
  add(query_579193, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579194 = body
  add(query_579193, "fields", newJString(fields))
  result = call_579191.call(path_579192, query_579193, nil, nil, body_579194)

var androidpublisherEditsDetailsPatch* = Call_AndroidpublisherEditsDetailsPatch_579177(
    name: "androidpublisherEditsDetailsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsPatch_579178,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsPatch_579179, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsList_579195 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsList_579197(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsList_579196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all of the localized store listings attached to this edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579198 = path.getOrDefault("packageName")
  valid_579198 = validateParameter(valid_579198, JString, required = true,
                                 default = nil)
  if valid_579198 != nil:
    section.add "packageName", valid_579198
  var valid_579199 = path.getOrDefault("editId")
  valid_579199 = validateParameter(valid_579199, JString, required = true,
                                 default = nil)
  if valid_579199 != nil:
    section.add "editId", valid_579199
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
  var valid_579200 = query.getOrDefault("key")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "key", valid_579200
  var valid_579201 = query.getOrDefault("prettyPrint")
  valid_579201 = validateParameter(valid_579201, JBool, required = false,
                                 default = newJBool(true))
  if valid_579201 != nil:
    section.add "prettyPrint", valid_579201
  var valid_579202 = query.getOrDefault("oauth_token")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "oauth_token", valid_579202
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

proc call*(call_579207: Call_AndroidpublisherEditsListingsList_579195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the localized store listings attached to this edit.
  ## 
  let valid = call_579207.validator(path, query, header, formData, body)
  let scheme = call_579207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579207.url(scheme.get, call_579207.host, call_579207.base,
                         call_579207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579207, url, valid)

proc call*(call_579208: Call_AndroidpublisherEditsListingsList_579195;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsListingsList
  ## Returns all of the localized store listings attached to this edit.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579209 = newJObject()
  var query_579210 = newJObject()
  add(query_579210, "key", newJString(key))
  add(query_579210, "prettyPrint", newJBool(prettyPrint))
  add(query_579210, "oauth_token", newJString(oauthToken))
  add(path_579209, "packageName", newJString(packageName))
  add(path_579209, "editId", newJString(editId))
  add(query_579210, "alt", newJString(alt))
  add(query_579210, "userIp", newJString(userIp))
  add(query_579210, "quotaUser", newJString(quotaUser))
  add(query_579210, "fields", newJString(fields))
  result = call_579208.call(path_579209, query_579210, nil, nil, nil)

var androidpublisherEditsListingsList* = Call_AndroidpublisherEditsListingsList_579195(
    name: "androidpublisherEditsListingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsList_579196,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsList_579197, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDeleteall_579211 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsDeleteall_579213(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsDeleteall_579212(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all localized listings from an edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579214 = path.getOrDefault("packageName")
  valid_579214 = validateParameter(valid_579214, JString, required = true,
                                 default = nil)
  if valid_579214 != nil:
    section.add "packageName", valid_579214
  var valid_579215 = path.getOrDefault("editId")
  valid_579215 = validateParameter(valid_579215, JString, required = true,
                                 default = nil)
  if valid_579215 != nil:
    section.add "editId", valid_579215
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
  if body != nil:
    result.add "body", body

proc call*(call_579223: Call_AndroidpublisherEditsListingsDeleteall_579211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all localized listings from an edit.
  ## 
  let valid = call_579223.validator(path, query, header, formData, body)
  let scheme = call_579223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579223.url(scheme.get, call_579223.host, call_579223.base,
                         call_579223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579223, url, valid)

proc call*(call_579224: Call_AndroidpublisherEditsListingsDeleteall_579211;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsListingsDeleteall
  ## Deletes all localized listings from an edit.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579225 = newJObject()
  var query_579226 = newJObject()
  add(query_579226, "key", newJString(key))
  add(query_579226, "prettyPrint", newJBool(prettyPrint))
  add(query_579226, "oauth_token", newJString(oauthToken))
  add(path_579225, "packageName", newJString(packageName))
  add(path_579225, "editId", newJString(editId))
  add(query_579226, "alt", newJString(alt))
  add(query_579226, "userIp", newJString(userIp))
  add(query_579226, "quotaUser", newJString(quotaUser))
  add(query_579226, "fields", newJString(fields))
  result = call_579224.call(path_579225, query_579226, nil, nil, nil)

var androidpublisherEditsListingsDeleteall* = Call_AndroidpublisherEditsListingsDeleteall_579211(
    name: "androidpublisherEditsListingsDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsDeleteall_579212,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsDeleteall_579213,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsUpdate_579244 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsUpdate_579246(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsUpdate_579245(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a localized store listing.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579247 = path.getOrDefault("packageName")
  valid_579247 = validateParameter(valid_579247, JString, required = true,
                                 default = nil)
  if valid_579247 != nil:
    section.add "packageName", valid_579247
  var valid_579248 = path.getOrDefault("editId")
  valid_579248 = validateParameter(valid_579248, JString, required = true,
                                 default = nil)
  if valid_579248 != nil:
    section.add "editId", valid_579248
  var valid_579249 = path.getOrDefault("language")
  valid_579249 = validateParameter(valid_579249, JString, required = true,
                                 default = nil)
  if valid_579249 != nil:
    section.add "language", valid_579249
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
  var valid_579250 = query.getOrDefault("key")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "key", valid_579250
  var valid_579251 = query.getOrDefault("prettyPrint")
  valid_579251 = validateParameter(valid_579251, JBool, required = false,
                                 default = newJBool(true))
  if valid_579251 != nil:
    section.add "prettyPrint", valid_579251
  var valid_579252 = query.getOrDefault("oauth_token")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "oauth_token", valid_579252
  var valid_579253 = query.getOrDefault("alt")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = newJString("json"))
  if valid_579253 != nil:
    section.add "alt", valid_579253
  var valid_579254 = query.getOrDefault("userIp")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "userIp", valid_579254
  var valid_579255 = query.getOrDefault("quotaUser")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "quotaUser", valid_579255
  var valid_579256 = query.getOrDefault("fields")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "fields", valid_579256
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

proc call*(call_579258: Call_AndroidpublisherEditsListingsUpdate_579244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing.
  ## 
  let valid = call_579258.validator(path, query, header, formData, body)
  let scheme = call_579258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579258.url(scheme.get, call_579258.host, call_579258.base,
                         call_579258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579258, url, valid)

proc call*(call_579259: Call_AndroidpublisherEditsListingsUpdate_579244;
          packageName: string; editId: string; language: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidpublisherEditsListingsUpdate
  ## Creates or updates a localized store listing.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579260 = newJObject()
  var query_579261 = newJObject()
  var body_579262 = newJObject()
  add(query_579261, "key", newJString(key))
  add(query_579261, "prettyPrint", newJBool(prettyPrint))
  add(query_579261, "oauth_token", newJString(oauthToken))
  add(path_579260, "packageName", newJString(packageName))
  add(path_579260, "editId", newJString(editId))
  add(path_579260, "language", newJString(language))
  add(query_579261, "alt", newJString(alt))
  add(query_579261, "userIp", newJString(userIp))
  add(query_579261, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579262 = body
  add(query_579261, "fields", newJString(fields))
  result = call_579259.call(path_579260, query_579261, nil, nil, body_579262)

var androidpublisherEditsListingsUpdate* = Call_AndroidpublisherEditsListingsUpdate_579244(
    name: "androidpublisherEditsListingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsUpdate_579245,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsUpdate_579246, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsGet_579227 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsGet_579229(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsGet_579228(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches information about a localized store listing.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579230 = path.getOrDefault("packageName")
  valid_579230 = validateParameter(valid_579230, JString, required = true,
                                 default = nil)
  if valid_579230 != nil:
    section.add "packageName", valid_579230
  var valid_579231 = path.getOrDefault("editId")
  valid_579231 = validateParameter(valid_579231, JString, required = true,
                                 default = nil)
  if valid_579231 != nil:
    section.add "editId", valid_579231
  var valid_579232 = path.getOrDefault("language")
  valid_579232 = validateParameter(valid_579232, JString, required = true,
                                 default = nil)
  if valid_579232 != nil:
    section.add "language", valid_579232
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
  var valid_579239 = query.getOrDefault("fields")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "fields", valid_579239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579240: Call_AndroidpublisherEditsListingsGet_579227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches information about a localized store listing.
  ## 
  let valid = call_579240.validator(path, query, header, formData, body)
  let scheme = call_579240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579240.url(scheme.get, call_579240.host, call_579240.base,
                         call_579240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579240, url, valid)

proc call*(call_579241: Call_AndroidpublisherEditsListingsGet_579227;
          packageName: string; editId: string; language: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsListingsGet
  ## Fetches information about a localized store listing.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579242 = newJObject()
  var query_579243 = newJObject()
  add(query_579243, "key", newJString(key))
  add(query_579243, "prettyPrint", newJBool(prettyPrint))
  add(query_579243, "oauth_token", newJString(oauthToken))
  add(path_579242, "packageName", newJString(packageName))
  add(path_579242, "editId", newJString(editId))
  add(path_579242, "language", newJString(language))
  add(query_579243, "alt", newJString(alt))
  add(query_579243, "userIp", newJString(userIp))
  add(query_579243, "quotaUser", newJString(quotaUser))
  add(query_579243, "fields", newJString(fields))
  result = call_579241.call(path_579242, query_579243, nil, nil, nil)

var androidpublisherEditsListingsGet* = Call_AndroidpublisherEditsListingsGet_579227(
    name: "androidpublisherEditsListingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsGet_579228,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsGet_579229, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsPatch_579280 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsPatch_579282(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsPatch_579281(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579283 = path.getOrDefault("packageName")
  valid_579283 = validateParameter(valid_579283, JString, required = true,
                                 default = nil)
  if valid_579283 != nil:
    section.add "packageName", valid_579283
  var valid_579284 = path.getOrDefault("editId")
  valid_579284 = validateParameter(valid_579284, JString, required = true,
                                 default = nil)
  if valid_579284 != nil:
    section.add "editId", valid_579284
  var valid_579285 = path.getOrDefault("language")
  valid_579285 = validateParameter(valid_579285, JString, required = true,
                                 default = nil)
  if valid_579285 != nil:
    section.add "language", valid_579285
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579294: Call_AndroidpublisherEditsListingsPatch_579280;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ## 
  let valid = call_579294.validator(path, query, header, formData, body)
  let scheme = call_579294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579294.url(scheme.get, call_579294.host, call_579294.base,
                         call_579294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579294, url, valid)

proc call*(call_579295: Call_AndroidpublisherEditsListingsPatch_579280;
          packageName: string; editId: string; language: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidpublisherEditsListingsPatch
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579296 = newJObject()
  var query_579297 = newJObject()
  var body_579298 = newJObject()
  add(query_579297, "key", newJString(key))
  add(query_579297, "prettyPrint", newJBool(prettyPrint))
  add(query_579297, "oauth_token", newJString(oauthToken))
  add(path_579296, "packageName", newJString(packageName))
  add(path_579296, "editId", newJString(editId))
  add(path_579296, "language", newJString(language))
  add(query_579297, "alt", newJString(alt))
  add(query_579297, "userIp", newJString(userIp))
  add(query_579297, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579298 = body
  add(query_579297, "fields", newJString(fields))
  result = call_579295.call(path_579296, query_579297, nil, nil, body_579298)

var androidpublisherEditsListingsPatch* = Call_AndroidpublisherEditsListingsPatch_579280(
    name: "androidpublisherEditsListingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsPatch_579281,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsPatch_579282, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDelete_579263 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsDelete_579265(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsListingsDelete_579264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified localized store listing from an edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579266 = path.getOrDefault("packageName")
  valid_579266 = validateParameter(valid_579266, JString, required = true,
                                 default = nil)
  if valid_579266 != nil:
    section.add "packageName", valid_579266
  var valid_579267 = path.getOrDefault("editId")
  valid_579267 = validateParameter(valid_579267, JString, required = true,
                                 default = nil)
  if valid_579267 != nil:
    section.add "editId", valid_579267
  var valid_579268 = path.getOrDefault("language")
  valid_579268 = validateParameter(valid_579268, JString, required = true,
                                 default = nil)
  if valid_579268 != nil:
    section.add "language", valid_579268
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
  var valid_579269 = query.getOrDefault("key")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "key", valid_579269
  var valid_579270 = query.getOrDefault("prettyPrint")
  valid_579270 = validateParameter(valid_579270, JBool, required = false,
                                 default = newJBool(true))
  if valid_579270 != nil:
    section.add "prettyPrint", valid_579270
  var valid_579271 = query.getOrDefault("oauth_token")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "oauth_token", valid_579271
  var valid_579272 = query.getOrDefault("alt")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = newJString("json"))
  if valid_579272 != nil:
    section.add "alt", valid_579272
  var valid_579273 = query.getOrDefault("userIp")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "userIp", valid_579273
  var valid_579274 = query.getOrDefault("quotaUser")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "quotaUser", valid_579274
  var valid_579275 = query.getOrDefault("fields")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "fields", valid_579275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579276: Call_AndroidpublisherEditsListingsDelete_579263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified localized store listing from an edit.
  ## 
  let valid = call_579276.validator(path, query, header, formData, body)
  let scheme = call_579276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579276.url(scheme.get, call_579276.host, call_579276.base,
                         call_579276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579276, url, valid)

proc call*(call_579277: Call_AndroidpublisherEditsListingsDelete_579263;
          packageName: string; editId: string; language: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsListingsDelete
  ## Deletes the specified localized store listing from an edit.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579278 = newJObject()
  var query_579279 = newJObject()
  add(query_579279, "key", newJString(key))
  add(query_579279, "prettyPrint", newJBool(prettyPrint))
  add(query_579279, "oauth_token", newJString(oauthToken))
  add(path_579278, "packageName", newJString(packageName))
  add(path_579278, "editId", newJString(editId))
  add(path_579278, "language", newJString(language))
  add(query_579279, "alt", newJString(alt))
  add(query_579279, "userIp", newJString(userIp))
  add(query_579279, "quotaUser", newJString(quotaUser))
  add(query_579279, "fields", newJString(fields))
  result = call_579277.call(path_579278, query_579279, nil, nil, nil)

var androidpublisherEditsListingsDelete* = Call_AndroidpublisherEditsListingsDelete_579263(
    name: "androidpublisherEditsListingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsDelete_579264,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsDelete_579265, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesUpload_579317 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsImagesUpload_579319(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  assert "imageType" in path, "`imageType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "imageType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsImagesUpload_579318(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   imageType: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579320 = path.getOrDefault("packageName")
  valid_579320 = validateParameter(valid_579320, JString, required = true,
                                 default = nil)
  if valid_579320 != nil:
    section.add "packageName", valid_579320
  var valid_579321 = path.getOrDefault("editId")
  valid_579321 = validateParameter(valid_579321, JString, required = true,
                                 default = nil)
  if valid_579321 != nil:
    section.add "editId", valid_579321
  var valid_579322 = path.getOrDefault("language")
  valid_579322 = validateParameter(valid_579322, JString, required = true,
                                 default = nil)
  if valid_579322 != nil:
    section.add "language", valid_579322
  var valid_579323 = path.getOrDefault("imageType")
  valid_579323 = validateParameter(valid_579323, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_579323 != nil:
    section.add "imageType", valid_579323
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
  var valid_579324 = query.getOrDefault("key")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "key", valid_579324
  var valid_579325 = query.getOrDefault("prettyPrint")
  valid_579325 = validateParameter(valid_579325, JBool, required = false,
                                 default = newJBool(true))
  if valid_579325 != nil:
    section.add "prettyPrint", valid_579325
  var valid_579326 = query.getOrDefault("oauth_token")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "oauth_token", valid_579326
  var valid_579327 = query.getOrDefault("alt")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = newJString("json"))
  if valid_579327 != nil:
    section.add "alt", valid_579327
  var valid_579328 = query.getOrDefault("userIp")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "userIp", valid_579328
  var valid_579329 = query.getOrDefault("quotaUser")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = nil)
  if valid_579329 != nil:
    section.add "quotaUser", valid_579329
  var valid_579330 = query.getOrDefault("fields")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "fields", valid_579330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579331: Call_AndroidpublisherEditsImagesUpload_579317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ## 
  let valid = call_579331.validator(path, query, header, formData, body)
  let scheme = call_579331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579331.url(scheme.get, call_579331.host, call_579331.base,
                         call_579331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579331, url, valid)

proc call*(call_579332: Call_AndroidpublisherEditsImagesUpload_579317;
          packageName: string; editId: string; language: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          imageType: string = "featureGraphic"; fields: string = ""): Recallable =
  ## androidpublisherEditsImagesUpload
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   imageType: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579333 = newJObject()
  var query_579334 = newJObject()
  add(query_579334, "key", newJString(key))
  add(query_579334, "prettyPrint", newJBool(prettyPrint))
  add(query_579334, "oauth_token", newJString(oauthToken))
  add(path_579333, "packageName", newJString(packageName))
  add(path_579333, "editId", newJString(editId))
  add(path_579333, "language", newJString(language))
  add(query_579334, "alt", newJString(alt))
  add(query_579334, "userIp", newJString(userIp))
  add(query_579334, "quotaUser", newJString(quotaUser))
  add(path_579333, "imageType", newJString(imageType))
  add(query_579334, "fields", newJString(fields))
  result = call_579332.call(path_579333, query_579334, nil, nil, nil)

var androidpublisherEditsImagesUpload* = Call_AndroidpublisherEditsImagesUpload_579317(
    name: "androidpublisherEditsImagesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesUpload_579318,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesUpload_579319, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesList_579299 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsImagesList_579301(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  assert "imageType" in path, "`imageType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "imageType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsImagesList_579300(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all images for the specified language and image type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   imageType: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579302 = path.getOrDefault("packageName")
  valid_579302 = validateParameter(valid_579302, JString, required = true,
                                 default = nil)
  if valid_579302 != nil:
    section.add "packageName", valid_579302
  var valid_579303 = path.getOrDefault("editId")
  valid_579303 = validateParameter(valid_579303, JString, required = true,
                                 default = nil)
  if valid_579303 != nil:
    section.add "editId", valid_579303
  var valid_579304 = path.getOrDefault("language")
  valid_579304 = validateParameter(valid_579304, JString, required = true,
                                 default = nil)
  if valid_579304 != nil:
    section.add "language", valid_579304
  var valid_579305 = path.getOrDefault("imageType")
  valid_579305 = validateParameter(valid_579305, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_579305 != nil:
    section.add "imageType", valid_579305
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
  var valid_579306 = query.getOrDefault("key")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "key", valid_579306
  var valid_579307 = query.getOrDefault("prettyPrint")
  valid_579307 = validateParameter(valid_579307, JBool, required = false,
                                 default = newJBool(true))
  if valid_579307 != nil:
    section.add "prettyPrint", valid_579307
  var valid_579308 = query.getOrDefault("oauth_token")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "oauth_token", valid_579308
  var valid_579309 = query.getOrDefault("alt")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = newJString("json"))
  if valid_579309 != nil:
    section.add "alt", valid_579309
  var valid_579310 = query.getOrDefault("userIp")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "userIp", valid_579310
  var valid_579311 = query.getOrDefault("quotaUser")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "quotaUser", valid_579311
  var valid_579312 = query.getOrDefault("fields")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "fields", valid_579312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579313: Call_AndroidpublisherEditsImagesList_579299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all images for the specified language and image type.
  ## 
  let valid = call_579313.validator(path, query, header, formData, body)
  let scheme = call_579313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579313.url(scheme.get, call_579313.host, call_579313.base,
                         call_579313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579313, url, valid)

proc call*(call_579314: Call_AndroidpublisherEditsImagesList_579299;
          packageName: string; editId: string; language: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          imageType: string = "featureGraphic"; fields: string = ""): Recallable =
  ## androidpublisherEditsImagesList
  ## Lists all images for the specified language and image type.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   imageType: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579315 = newJObject()
  var query_579316 = newJObject()
  add(query_579316, "key", newJString(key))
  add(query_579316, "prettyPrint", newJBool(prettyPrint))
  add(query_579316, "oauth_token", newJString(oauthToken))
  add(path_579315, "packageName", newJString(packageName))
  add(path_579315, "editId", newJString(editId))
  add(path_579315, "language", newJString(language))
  add(query_579316, "alt", newJString(alt))
  add(query_579316, "userIp", newJString(userIp))
  add(query_579316, "quotaUser", newJString(quotaUser))
  add(path_579315, "imageType", newJString(imageType))
  add(query_579316, "fields", newJString(fields))
  result = call_579314.call(path_579315, query_579316, nil, nil, nil)

var androidpublisherEditsImagesList* = Call_AndroidpublisherEditsImagesList_579299(
    name: "androidpublisherEditsImagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesList_579300,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesList_579301, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDeleteall_579335 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsImagesDeleteall_579337(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  assert "imageType" in path, "`imageType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "imageType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsImagesDeleteall_579336(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all images for the specified language and image type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   imageType: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579338 = path.getOrDefault("packageName")
  valid_579338 = validateParameter(valid_579338, JString, required = true,
                                 default = nil)
  if valid_579338 != nil:
    section.add "packageName", valid_579338
  var valid_579339 = path.getOrDefault("editId")
  valid_579339 = validateParameter(valid_579339, JString, required = true,
                                 default = nil)
  if valid_579339 != nil:
    section.add "editId", valid_579339
  var valid_579340 = path.getOrDefault("language")
  valid_579340 = validateParameter(valid_579340, JString, required = true,
                                 default = nil)
  if valid_579340 != nil:
    section.add "language", valid_579340
  var valid_579341 = path.getOrDefault("imageType")
  valid_579341 = validateParameter(valid_579341, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_579341 != nil:
    section.add "imageType", valid_579341
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
  var valid_579342 = query.getOrDefault("key")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "key", valid_579342
  var valid_579343 = query.getOrDefault("prettyPrint")
  valid_579343 = validateParameter(valid_579343, JBool, required = false,
                                 default = newJBool(true))
  if valid_579343 != nil:
    section.add "prettyPrint", valid_579343
  var valid_579344 = query.getOrDefault("oauth_token")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "oauth_token", valid_579344
  var valid_579345 = query.getOrDefault("alt")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = newJString("json"))
  if valid_579345 != nil:
    section.add "alt", valid_579345
  var valid_579346 = query.getOrDefault("userIp")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "userIp", valid_579346
  var valid_579347 = query.getOrDefault("quotaUser")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "quotaUser", valid_579347
  var valid_579348 = query.getOrDefault("fields")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "fields", valid_579348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579349: Call_AndroidpublisherEditsImagesDeleteall_579335;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all images for the specified language and image type.
  ## 
  let valid = call_579349.validator(path, query, header, formData, body)
  let scheme = call_579349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579349.url(scheme.get, call_579349.host, call_579349.base,
                         call_579349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579349, url, valid)

proc call*(call_579350: Call_AndroidpublisherEditsImagesDeleteall_579335;
          packageName: string; editId: string; language: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          imageType: string = "featureGraphic"; fields: string = ""): Recallable =
  ## androidpublisherEditsImagesDeleteall
  ## Deletes all images for the specified language and image type.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   imageType: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579351 = newJObject()
  var query_579352 = newJObject()
  add(query_579352, "key", newJString(key))
  add(query_579352, "prettyPrint", newJBool(prettyPrint))
  add(query_579352, "oauth_token", newJString(oauthToken))
  add(path_579351, "packageName", newJString(packageName))
  add(path_579351, "editId", newJString(editId))
  add(path_579351, "language", newJString(language))
  add(query_579352, "alt", newJString(alt))
  add(query_579352, "userIp", newJString(userIp))
  add(query_579352, "quotaUser", newJString(quotaUser))
  add(path_579351, "imageType", newJString(imageType))
  add(query_579352, "fields", newJString(fields))
  result = call_579350.call(path_579351, query_579352, nil, nil, nil)

var androidpublisherEditsImagesDeleteall* = Call_AndroidpublisherEditsImagesDeleteall_579335(
    name: "androidpublisherEditsImagesDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesDeleteall_579336,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesDeleteall_579337, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDelete_579353 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsImagesDelete_579355(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  assert "imageType" in path, "`imageType` is a required path parameter"
  assert "imageId" in path, "`imageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "imageType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "imageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsImagesDelete_579354(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the image (specified by id) from the edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageId: JString (required)
  ##          : Unique identifier an image within the set of images attached to this edit.
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   imageType: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageId` field"
  var valid_579356 = path.getOrDefault("imageId")
  valid_579356 = validateParameter(valid_579356, JString, required = true,
                                 default = nil)
  if valid_579356 != nil:
    section.add "imageId", valid_579356
  var valid_579357 = path.getOrDefault("packageName")
  valid_579357 = validateParameter(valid_579357, JString, required = true,
                                 default = nil)
  if valid_579357 != nil:
    section.add "packageName", valid_579357
  var valid_579358 = path.getOrDefault("editId")
  valid_579358 = validateParameter(valid_579358, JString, required = true,
                                 default = nil)
  if valid_579358 != nil:
    section.add "editId", valid_579358
  var valid_579359 = path.getOrDefault("language")
  valid_579359 = validateParameter(valid_579359, JString, required = true,
                                 default = nil)
  if valid_579359 != nil:
    section.add "language", valid_579359
  var valid_579360 = path.getOrDefault("imageType")
  valid_579360 = validateParameter(valid_579360, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_579360 != nil:
    section.add "imageType", valid_579360
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
  var valid_579361 = query.getOrDefault("key")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "key", valid_579361
  var valid_579362 = query.getOrDefault("prettyPrint")
  valid_579362 = validateParameter(valid_579362, JBool, required = false,
                                 default = newJBool(true))
  if valid_579362 != nil:
    section.add "prettyPrint", valid_579362
  var valid_579363 = query.getOrDefault("oauth_token")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "oauth_token", valid_579363
  var valid_579364 = query.getOrDefault("alt")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = newJString("json"))
  if valid_579364 != nil:
    section.add "alt", valid_579364
  var valid_579365 = query.getOrDefault("userIp")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "userIp", valid_579365
  var valid_579366 = query.getOrDefault("quotaUser")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "quotaUser", valid_579366
  var valid_579367 = query.getOrDefault("fields")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "fields", valid_579367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579368: Call_AndroidpublisherEditsImagesDelete_579353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the image (specified by id) from the edit.
  ## 
  let valid = call_579368.validator(path, query, header, formData, body)
  let scheme = call_579368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579368.url(scheme.get, call_579368.host, call_579368.base,
                         call_579368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579368, url, valid)

proc call*(call_579369: Call_AndroidpublisherEditsImagesDelete_579353;
          imageId: string; packageName: string; editId: string; language: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          imageType: string = "featureGraphic"; fields: string = ""): Recallable =
  ## androidpublisherEditsImagesDelete
  ## Deletes the image (specified by id) from the edit.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   imageId: string (required)
  ##          : Unique identifier an image within the set of images attached to this edit.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   imageType: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579370 = newJObject()
  var query_579371 = newJObject()
  add(query_579371, "key", newJString(key))
  add(path_579370, "imageId", newJString(imageId))
  add(query_579371, "prettyPrint", newJBool(prettyPrint))
  add(query_579371, "oauth_token", newJString(oauthToken))
  add(path_579370, "packageName", newJString(packageName))
  add(path_579370, "editId", newJString(editId))
  add(path_579370, "language", newJString(language))
  add(query_579371, "alt", newJString(alt))
  add(query_579371, "userIp", newJString(userIp))
  add(query_579371, "quotaUser", newJString(quotaUser))
  add(path_579370, "imageType", newJString(imageType))
  add(query_579371, "fields", newJString(fields))
  result = call_579369.call(path_579370, query_579371, nil, nil, nil)

var androidpublisherEditsImagesDelete* = Call_AndroidpublisherEditsImagesDelete_579353(
    name: "androidpublisherEditsImagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}/{imageId}",
    validator: validate_AndroidpublisherEditsImagesDelete_579354,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesDelete_579355, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersUpdate_579389 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTestersUpdate_579391(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/testers/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTestersUpdate_579390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579392 = path.getOrDefault("packageName")
  valid_579392 = validateParameter(valid_579392, JString, required = true,
                                 default = nil)
  if valid_579392 != nil:
    section.add "packageName", valid_579392
  var valid_579393 = path.getOrDefault("editId")
  valid_579393 = validateParameter(valid_579393, JString, required = true,
                                 default = nil)
  if valid_579393 != nil:
    section.add "editId", valid_579393
  var valid_579394 = path.getOrDefault("track")
  valid_579394 = validateParameter(valid_579394, JString, required = true,
                                 default = nil)
  if valid_579394 != nil:
    section.add "track", valid_579394
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
  var valid_579395 = query.getOrDefault("key")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "key", valid_579395
  var valid_579396 = query.getOrDefault("prettyPrint")
  valid_579396 = validateParameter(valid_579396, JBool, required = false,
                                 default = newJBool(true))
  if valid_579396 != nil:
    section.add "prettyPrint", valid_579396
  var valid_579397 = query.getOrDefault("oauth_token")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "oauth_token", valid_579397
  var valid_579398 = query.getOrDefault("alt")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = newJString("json"))
  if valid_579398 != nil:
    section.add "alt", valid_579398
  var valid_579399 = query.getOrDefault("userIp")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "userIp", valid_579399
  var valid_579400 = query.getOrDefault("quotaUser")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "quotaUser", valid_579400
  var valid_579401 = query.getOrDefault("fields")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "fields", valid_579401
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

proc call*(call_579403: Call_AndroidpublisherEditsTestersUpdate_579389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_579403.validator(path, query, header, formData, body)
  let scheme = call_579403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579403.url(scheme.get, call_579403.host, call_579403.base,
                         call_579403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579403, url, valid)

proc call*(call_579404: Call_AndroidpublisherEditsTestersUpdate_579389;
          packageName: string; editId: string; track: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidpublisherEditsTestersUpdate
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   track: string (required)
  ##        : The track to read or modify.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579405 = newJObject()
  var query_579406 = newJObject()
  var body_579407 = newJObject()
  add(query_579406, "key", newJString(key))
  add(query_579406, "prettyPrint", newJBool(prettyPrint))
  add(query_579406, "oauth_token", newJString(oauthToken))
  add(path_579405, "packageName", newJString(packageName))
  add(path_579405, "editId", newJString(editId))
  add(path_579405, "track", newJString(track))
  add(query_579406, "alt", newJString(alt))
  add(query_579406, "userIp", newJString(userIp))
  add(query_579406, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579407 = body
  add(query_579406, "fields", newJString(fields))
  result = call_579404.call(path_579405, query_579406, nil, nil, body_579407)

var androidpublisherEditsTestersUpdate* = Call_AndroidpublisherEditsTestersUpdate_579389(
    name: "androidpublisherEditsTestersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersUpdate_579390,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersUpdate_579391, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersGet_579372 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTestersGet_579374(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/testers/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTestersGet_579373(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579375 = path.getOrDefault("packageName")
  valid_579375 = validateParameter(valid_579375, JString, required = true,
                                 default = nil)
  if valid_579375 != nil:
    section.add "packageName", valid_579375
  var valid_579376 = path.getOrDefault("editId")
  valid_579376 = validateParameter(valid_579376, JString, required = true,
                                 default = nil)
  if valid_579376 != nil:
    section.add "editId", valid_579376
  var valid_579377 = path.getOrDefault("track")
  valid_579377 = validateParameter(valid_579377, JString, required = true,
                                 default = nil)
  if valid_579377 != nil:
    section.add "track", valid_579377
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
  var valid_579378 = query.getOrDefault("key")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "key", valid_579378
  var valid_579379 = query.getOrDefault("prettyPrint")
  valid_579379 = validateParameter(valid_579379, JBool, required = false,
                                 default = newJBool(true))
  if valid_579379 != nil:
    section.add "prettyPrint", valid_579379
  var valid_579380 = query.getOrDefault("oauth_token")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "oauth_token", valid_579380
  var valid_579381 = query.getOrDefault("alt")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = newJString("json"))
  if valid_579381 != nil:
    section.add "alt", valid_579381
  var valid_579382 = query.getOrDefault("userIp")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "userIp", valid_579382
  var valid_579383 = query.getOrDefault("quotaUser")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "quotaUser", valid_579383
  var valid_579384 = query.getOrDefault("fields")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "fields", valid_579384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579385: Call_AndroidpublisherEditsTestersGet_579372;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_579385.validator(path, query, header, formData, body)
  let scheme = call_579385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579385.url(scheme.get, call_579385.host, call_579385.base,
                         call_579385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579385, url, valid)

proc call*(call_579386: Call_AndroidpublisherEditsTestersGet_579372;
          packageName: string; editId: string; track: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsTestersGet
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   track: string (required)
  ##        : The track to read or modify.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579387 = newJObject()
  var query_579388 = newJObject()
  add(query_579388, "key", newJString(key))
  add(query_579388, "prettyPrint", newJBool(prettyPrint))
  add(query_579388, "oauth_token", newJString(oauthToken))
  add(path_579387, "packageName", newJString(packageName))
  add(path_579387, "editId", newJString(editId))
  add(path_579387, "track", newJString(track))
  add(query_579388, "alt", newJString(alt))
  add(query_579388, "userIp", newJString(userIp))
  add(query_579388, "quotaUser", newJString(quotaUser))
  add(query_579388, "fields", newJString(fields))
  result = call_579386.call(path_579387, query_579388, nil, nil, nil)

var androidpublisherEditsTestersGet* = Call_AndroidpublisherEditsTestersGet_579372(
    name: "androidpublisherEditsTestersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersGet_579373,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersGet_579374, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersPatch_579408 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTestersPatch_579410(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/testers/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTestersPatch_579409(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579411 = path.getOrDefault("packageName")
  valid_579411 = validateParameter(valid_579411, JString, required = true,
                                 default = nil)
  if valid_579411 != nil:
    section.add "packageName", valid_579411
  var valid_579412 = path.getOrDefault("editId")
  valid_579412 = validateParameter(valid_579412, JString, required = true,
                                 default = nil)
  if valid_579412 != nil:
    section.add "editId", valid_579412
  var valid_579413 = path.getOrDefault("track")
  valid_579413 = validateParameter(valid_579413, JString, required = true,
                                 default = nil)
  if valid_579413 != nil:
    section.add "track", valid_579413
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
  var valid_579414 = query.getOrDefault("key")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = nil)
  if valid_579414 != nil:
    section.add "key", valid_579414
  var valid_579415 = query.getOrDefault("prettyPrint")
  valid_579415 = validateParameter(valid_579415, JBool, required = false,
                                 default = newJBool(true))
  if valid_579415 != nil:
    section.add "prettyPrint", valid_579415
  var valid_579416 = query.getOrDefault("oauth_token")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "oauth_token", valid_579416
  var valid_579417 = query.getOrDefault("alt")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = newJString("json"))
  if valid_579417 != nil:
    section.add "alt", valid_579417
  var valid_579418 = query.getOrDefault("userIp")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "userIp", valid_579418
  var valid_579419 = query.getOrDefault("quotaUser")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "quotaUser", valid_579419
  var valid_579420 = query.getOrDefault("fields")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "fields", valid_579420
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

proc call*(call_579422: Call_AndroidpublisherEditsTestersPatch_579408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_579422.validator(path, query, header, formData, body)
  let scheme = call_579422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579422.url(scheme.get, call_579422.host, call_579422.base,
                         call_579422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579422, url, valid)

proc call*(call_579423: Call_AndroidpublisherEditsTestersPatch_579408;
          packageName: string; editId: string; track: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidpublisherEditsTestersPatch
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   track: string (required)
  ##        : The track to read or modify.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579424 = newJObject()
  var query_579425 = newJObject()
  var body_579426 = newJObject()
  add(query_579425, "key", newJString(key))
  add(query_579425, "prettyPrint", newJBool(prettyPrint))
  add(query_579425, "oauth_token", newJString(oauthToken))
  add(path_579424, "packageName", newJString(packageName))
  add(path_579424, "editId", newJString(editId))
  add(path_579424, "track", newJString(track))
  add(query_579425, "alt", newJString(alt))
  add(query_579425, "userIp", newJString(userIp))
  add(query_579425, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579426 = body
  add(query_579425, "fields", newJString(fields))
  result = call_579423.call(path_579424, query_579425, nil, nil, body_579426)

var androidpublisherEditsTestersPatch* = Call_AndroidpublisherEditsTestersPatch_579408(
    name: "androidpublisherEditsTestersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersPatch_579409,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersPatch_579410, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksList_579427 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTracksList_579429(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/tracks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTracksList_579428(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the track configurations for this edit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579430 = path.getOrDefault("packageName")
  valid_579430 = validateParameter(valid_579430, JString, required = true,
                                 default = nil)
  if valid_579430 != nil:
    section.add "packageName", valid_579430
  var valid_579431 = path.getOrDefault("editId")
  valid_579431 = validateParameter(valid_579431, JString, required = true,
                                 default = nil)
  if valid_579431 != nil:
    section.add "editId", valid_579431
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
  var valid_579432 = query.getOrDefault("key")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = nil)
  if valid_579432 != nil:
    section.add "key", valid_579432
  var valid_579433 = query.getOrDefault("prettyPrint")
  valid_579433 = validateParameter(valid_579433, JBool, required = false,
                                 default = newJBool(true))
  if valid_579433 != nil:
    section.add "prettyPrint", valid_579433
  var valid_579434 = query.getOrDefault("oauth_token")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = nil)
  if valid_579434 != nil:
    section.add "oauth_token", valid_579434
  var valid_579435 = query.getOrDefault("alt")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = newJString("json"))
  if valid_579435 != nil:
    section.add "alt", valid_579435
  var valid_579436 = query.getOrDefault("userIp")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "userIp", valid_579436
  var valid_579437 = query.getOrDefault("quotaUser")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "quotaUser", valid_579437
  var valid_579438 = query.getOrDefault("fields")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "fields", valid_579438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579439: Call_AndroidpublisherEditsTracksList_579427;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the track configurations for this edit.
  ## 
  let valid = call_579439.validator(path, query, header, formData, body)
  let scheme = call_579439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579439.url(scheme.get, call_579439.host, call_579439.base,
                         call_579439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579439, url, valid)

proc call*(call_579440: Call_AndroidpublisherEditsTracksList_579427;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsTracksList
  ## Lists all the track configurations for this edit.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579441 = newJObject()
  var query_579442 = newJObject()
  add(query_579442, "key", newJString(key))
  add(query_579442, "prettyPrint", newJBool(prettyPrint))
  add(query_579442, "oauth_token", newJString(oauthToken))
  add(path_579441, "packageName", newJString(packageName))
  add(path_579441, "editId", newJString(editId))
  add(query_579442, "alt", newJString(alt))
  add(query_579442, "userIp", newJString(userIp))
  add(query_579442, "quotaUser", newJString(quotaUser))
  add(query_579442, "fields", newJString(fields))
  result = call_579440.call(path_579441, query_579442, nil, nil, nil)

var androidpublisherEditsTracksList* = Call_AndroidpublisherEditsTracksList_579427(
    name: "androidpublisherEditsTracksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/tracks",
    validator: validate_AndroidpublisherEditsTracksList_579428,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksList_579429, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksUpdate_579460 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTracksUpdate_579462(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/tracks/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTracksUpdate_579461(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the track configuration for the specified track type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579463 = path.getOrDefault("packageName")
  valid_579463 = validateParameter(valid_579463, JString, required = true,
                                 default = nil)
  if valid_579463 != nil:
    section.add "packageName", valid_579463
  var valid_579464 = path.getOrDefault("editId")
  valid_579464 = validateParameter(valid_579464, JString, required = true,
                                 default = nil)
  if valid_579464 != nil:
    section.add "editId", valid_579464
  var valid_579465 = path.getOrDefault("track")
  valid_579465 = validateParameter(valid_579465, JString, required = true,
                                 default = nil)
  if valid_579465 != nil:
    section.add "track", valid_579465
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
  var valid_579466 = query.getOrDefault("key")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "key", valid_579466
  var valid_579467 = query.getOrDefault("prettyPrint")
  valid_579467 = validateParameter(valid_579467, JBool, required = false,
                                 default = newJBool(true))
  if valid_579467 != nil:
    section.add "prettyPrint", valid_579467
  var valid_579468 = query.getOrDefault("oauth_token")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "oauth_token", valid_579468
  var valid_579469 = query.getOrDefault("alt")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = newJString("json"))
  if valid_579469 != nil:
    section.add "alt", valid_579469
  var valid_579470 = query.getOrDefault("userIp")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "userIp", valid_579470
  var valid_579471 = query.getOrDefault("quotaUser")
  valid_579471 = validateParameter(valid_579471, JString, required = false,
                                 default = nil)
  if valid_579471 != nil:
    section.add "quotaUser", valid_579471
  var valid_579472 = query.getOrDefault("fields")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "fields", valid_579472
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

proc call*(call_579474: Call_AndroidpublisherEditsTracksUpdate_579460;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type.
  ## 
  let valid = call_579474.validator(path, query, header, formData, body)
  let scheme = call_579474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579474.url(scheme.get, call_579474.host, call_579474.base,
                         call_579474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579474, url, valid)

proc call*(call_579475: Call_AndroidpublisherEditsTracksUpdate_579460;
          packageName: string; editId: string; track: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidpublisherEditsTracksUpdate
  ## Updates the track configuration for the specified track type.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   track: string (required)
  ##        : The track to read or modify.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579476 = newJObject()
  var query_579477 = newJObject()
  var body_579478 = newJObject()
  add(query_579477, "key", newJString(key))
  add(query_579477, "prettyPrint", newJBool(prettyPrint))
  add(query_579477, "oauth_token", newJString(oauthToken))
  add(path_579476, "packageName", newJString(packageName))
  add(path_579476, "editId", newJString(editId))
  add(path_579476, "track", newJString(track))
  add(query_579477, "alt", newJString(alt))
  add(query_579477, "userIp", newJString(userIp))
  add(query_579477, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579478 = body
  add(query_579477, "fields", newJString(fields))
  result = call_579475.call(path_579476, query_579477, nil, nil, body_579478)

var androidpublisherEditsTracksUpdate* = Call_AndroidpublisherEditsTracksUpdate_579460(
    name: "androidpublisherEditsTracksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksUpdate_579461,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksUpdate_579462, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksGet_579443 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTracksGet_579445(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/tracks/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTracksGet_579444(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579446 = path.getOrDefault("packageName")
  valid_579446 = validateParameter(valid_579446, JString, required = true,
                                 default = nil)
  if valid_579446 != nil:
    section.add "packageName", valid_579446
  var valid_579447 = path.getOrDefault("editId")
  valid_579447 = validateParameter(valid_579447, JString, required = true,
                                 default = nil)
  if valid_579447 != nil:
    section.add "editId", valid_579447
  var valid_579448 = path.getOrDefault("track")
  valid_579448 = validateParameter(valid_579448, JString, required = true,
                                 default = nil)
  if valid_579448 != nil:
    section.add "track", valid_579448
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
  var valid_579449 = query.getOrDefault("key")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "key", valid_579449
  var valid_579450 = query.getOrDefault("prettyPrint")
  valid_579450 = validateParameter(valid_579450, JBool, required = false,
                                 default = newJBool(true))
  if valid_579450 != nil:
    section.add "prettyPrint", valid_579450
  var valid_579451 = query.getOrDefault("oauth_token")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = nil)
  if valid_579451 != nil:
    section.add "oauth_token", valid_579451
  var valid_579452 = query.getOrDefault("alt")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = newJString("json"))
  if valid_579452 != nil:
    section.add "alt", valid_579452
  var valid_579453 = query.getOrDefault("userIp")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "userIp", valid_579453
  var valid_579454 = query.getOrDefault("quotaUser")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "quotaUser", valid_579454
  var valid_579455 = query.getOrDefault("fields")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = nil)
  if valid_579455 != nil:
    section.add "fields", valid_579455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579456: Call_AndroidpublisherEditsTracksGet_579443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ## 
  let valid = call_579456.validator(path, query, header, formData, body)
  let scheme = call_579456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579456.url(scheme.get, call_579456.host, call_579456.base,
                         call_579456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579456, url, valid)

proc call*(call_579457: Call_AndroidpublisherEditsTracksGet_579443;
          packageName: string; editId: string; track: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsTracksGet
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   track: string (required)
  ##        : The track to read or modify.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579458 = newJObject()
  var query_579459 = newJObject()
  add(query_579459, "key", newJString(key))
  add(query_579459, "prettyPrint", newJBool(prettyPrint))
  add(query_579459, "oauth_token", newJString(oauthToken))
  add(path_579458, "packageName", newJString(packageName))
  add(path_579458, "editId", newJString(editId))
  add(path_579458, "track", newJString(track))
  add(query_579459, "alt", newJString(alt))
  add(query_579459, "userIp", newJString(userIp))
  add(query_579459, "quotaUser", newJString(quotaUser))
  add(query_579459, "fields", newJString(fields))
  result = call_579457.call(path_579458, query_579459, nil, nil, nil)

var androidpublisherEditsTracksGet* = Call_AndroidpublisherEditsTracksGet_579443(
    name: "androidpublisherEditsTracksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksGet_579444,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksGet_579445, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksPatch_579479 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTracksPatch_579481(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "track" in path, "`track` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/tracks/"),
               (kind: VariableSegment, value: "track")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsTracksPatch_579480(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   track: JString (required)
  ##        : The track to read or modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579482 = path.getOrDefault("packageName")
  valid_579482 = validateParameter(valid_579482, JString, required = true,
                                 default = nil)
  if valid_579482 != nil:
    section.add "packageName", valid_579482
  var valid_579483 = path.getOrDefault("editId")
  valid_579483 = validateParameter(valid_579483, JString, required = true,
                                 default = nil)
  if valid_579483 != nil:
    section.add "editId", valid_579483
  var valid_579484 = path.getOrDefault("track")
  valid_579484 = validateParameter(valid_579484, JString, required = true,
                                 default = nil)
  if valid_579484 != nil:
    section.add "track", valid_579484
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
  var valid_579485 = query.getOrDefault("key")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "key", valid_579485
  var valid_579486 = query.getOrDefault("prettyPrint")
  valid_579486 = validateParameter(valid_579486, JBool, required = false,
                                 default = newJBool(true))
  if valid_579486 != nil:
    section.add "prettyPrint", valid_579486
  var valid_579487 = query.getOrDefault("oauth_token")
  valid_579487 = validateParameter(valid_579487, JString, required = false,
                                 default = nil)
  if valid_579487 != nil:
    section.add "oauth_token", valid_579487
  var valid_579488 = query.getOrDefault("alt")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = newJString("json"))
  if valid_579488 != nil:
    section.add "alt", valid_579488
  var valid_579489 = query.getOrDefault("userIp")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = nil)
  if valid_579489 != nil:
    section.add "userIp", valid_579489
  var valid_579490 = query.getOrDefault("quotaUser")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "quotaUser", valid_579490
  var valid_579491 = query.getOrDefault("fields")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = nil)
  if valid_579491 != nil:
    section.add "fields", valid_579491
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

proc call*(call_579493: Call_AndroidpublisherEditsTracksPatch_579479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ## 
  let valid = call_579493.validator(path, query, header, formData, body)
  let scheme = call_579493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579493.url(scheme.get, call_579493.host, call_579493.base,
                         call_579493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579493, url, valid)

proc call*(call_579494: Call_AndroidpublisherEditsTracksPatch_579479;
          packageName: string; editId: string; track: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidpublisherEditsTracksPatch
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   track: string (required)
  ##        : The track to read or modify.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579495 = newJObject()
  var query_579496 = newJObject()
  var body_579497 = newJObject()
  add(query_579496, "key", newJString(key))
  add(query_579496, "prettyPrint", newJBool(prettyPrint))
  add(query_579496, "oauth_token", newJString(oauthToken))
  add(path_579495, "packageName", newJString(packageName))
  add(path_579495, "editId", newJString(editId))
  add(path_579495, "track", newJString(track))
  add(query_579496, "alt", newJString(alt))
  add(query_579496, "userIp", newJString(userIp))
  add(query_579496, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579497 = body
  add(query_579496, "fields", newJString(fields))
  result = call_579494.call(path_579495, query_579496, nil, nil, body_579497)

var androidpublisherEditsTracksPatch* = Call_AndroidpublisherEditsTracksPatch_579479(
    name: "androidpublisherEditsTracksPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksPatch_579480,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksPatch_579481, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsCommit_579498 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsCommit_579500(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: ":commit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsCommit_579499(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Commits/applies the changes made in this edit back to the app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579501 = path.getOrDefault("packageName")
  valid_579501 = validateParameter(valid_579501, JString, required = true,
                                 default = nil)
  if valid_579501 != nil:
    section.add "packageName", valid_579501
  var valid_579502 = path.getOrDefault("editId")
  valid_579502 = validateParameter(valid_579502, JString, required = true,
                                 default = nil)
  if valid_579502 != nil:
    section.add "editId", valid_579502
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
  var valid_579503 = query.getOrDefault("key")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = nil)
  if valid_579503 != nil:
    section.add "key", valid_579503
  var valid_579504 = query.getOrDefault("prettyPrint")
  valid_579504 = validateParameter(valid_579504, JBool, required = false,
                                 default = newJBool(true))
  if valid_579504 != nil:
    section.add "prettyPrint", valid_579504
  var valid_579505 = query.getOrDefault("oauth_token")
  valid_579505 = validateParameter(valid_579505, JString, required = false,
                                 default = nil)
  if valid_579505 != nil:
    section.add "oauth_token", valid_579505
  var valid_579506 = query.getOrDefault("alt")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = newJString("json"))
  if valid_579506 != nil:
    section.add "alt", valid_579506
  var valid_579507 = query.getOrDefault("userIp")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "userIp", valid_579507
  var valid_579508 = query.getOrDefault("quotaUser")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "quotaUser", valid_579508
  var valid_579509 = query.getOrDefault("fields")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "fields", valid_579509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579510: Call_AndroidpublisherEditsCommit_579498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commits/applies the changes made in this edit back to the app.
  ## 
  let valid = call_579510.validator(path, query, header, formData, body)
  let scheme = call_579510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579510.url(scheme.get, call_579510.host, call_579510.base,
                         call_579510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579510, url, valid)

proc call*(call_579511: Call_AndroidpublisherEditsCommit_579498;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsCommit
  ## Commits/applies the changes made in this edit back to the app.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579512 = newJObject()
  var query_579513 = newJObject()
  add(query_579513, "key", newJString(key))
  add(query_579513, "prettyPrint", newJBool(prettyPrint))
  add(query_579513, "oauth_token", newJString(oauthToken))
  add(path_579512, "packageName", newJString(packageName))
  add(path_579512, "editId", newJString(editId))
  add(query_579513, "alt", newJString(alt))
  add(query_579513, "userIp", newJString(userIp))
  add(query_579513, "quotaUser", newJString(quotaUser))
  add(query_579513, "fields", newJString(fields))
  result = call_579511.call(path_579512, query_579513, nil, nil, nil)

var androidpublisherEditsCommit* = Call_AndroidpublisherEditsCommit_579498(
    name: "androidpublisherEditsCommit", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:commit",
    validator: validate_AndroidpublisherEditsCommit_579499,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsCommit_579500, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsValidate_579514 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsValidate_579516(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: ":validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsValidate_579515(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579517 = path.getOrDefault("packageName")
  valid_579517 = validateParameter(valid_579517, JString, required = true,
                                 default = nil)
  if valid_579517 != nil:
    section.add "packageName", valid_579517
  var valid_579518 = path.getOrDefault("editId")
  valid_579518 = validateParameter(valid_579518, JString, required = true,
                                 default = nil)
  if valid_579518 != nil:
    section.add "editId", valid_579518
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
  var valid_579519 = query.getOrDefault("key")
  valid_579519 = validateParameter(valid_579519, JString, required = false,
                                 default = nil)
  if valid_579519 != nil:
    section.add "key", valid_579519
  var valid_579520 = query.getOrDefault("prettyPrint")
  valid_579520 = validateParameter(valid_579520, JBool, required = false,
                                 default = newJBool(true))
  if valid_579520 != nil:
    section.add "prettyPrint", valid_579520
  var valid_579521 = query.getOrDefault("oauth_token")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "oauth_token", valid_579521
  var valid_579522 = query.getOrDefault("alt")
  valid_579522 = validateParameter(valid_579522, JString, required = false,
                                 default = newJString("json"))
  if valid_579522 != nil:
    section.add "alt", valid_579522
  var valid_579523 = query.getOrDefault("userIp")
  valid_579523 = validateParameter(valid_579523, JString, required = false,
                                 default = nil)
  if valid_579523 != nil:
    section.add "userIp", valid_579523
  var valid_579524 = query.getOrDefault("quotaUser")
  valid_579524 = validateParameter(valid_579524, JString, required = false,
                                 default = nil)
  if valid_579524 != nil:
    section.add "quotaUser", valid_579524
  var valid_579525 = query.getOrDefault("fields")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = nil)
  if valid_579525 != nil:
    section.add "fields", valid_579525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579526: Call_AndroidpublisherEditsValidate_579514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ## 
  let valid = call_579526.validator(path, query, header, formData, body)
  let scheme = call_579526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579526.url(scheme.get, call_579526.host, call_579526.base,
                         call_579526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579526, url, valid)

proc call*(call_579527: Call_AndroidpublisherEditsValidate_579514;
          packageName: string; editId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsValidate
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579528 = newJObject()
  var query_579529 = newJObject()
  add(query_579529, "key", newJString(key))
  add(query_579529, "prettyPrint", newJBool(prettyPrint))
  add(query_579529, "oauth_token", newJString(oauthToken))
  add(path_579528, "packageName", newJString(packageName))
  add(path_579528, "editId", newJString(editId))
  add(query_579529, "alt", newJString(alt))
  add(query_579529, "userIp", newJString(userIp))
  add(query_579529, "quotaUser", newJString(quotaUser))
  add(query_579529, "fields", newJString(fields))
  result = call_579527.call(path_579528, query_579529, nil, nil, nil)

var androidpublisherEditsValidate* = Call_AndroidpublisherEditsValidate_579514(
    name: "androidpublisherEditsValidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:validate",
    validator: validate_AndroidpublisherEditsValidate_579515,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsValidate_579516, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsInsert_579548 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsInsert_579550(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsInsert_579549(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new in-app product for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app; for example, "com.spiffygame".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579551 = path.getOrDefault("packageName")
  valid_579551 = validateParameter(valid_579551, JString, required = true,
                                 default = nil)
  if valid_579551 != nil:
    section.add "packageName", valid_579551
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
  ##   autoConvertMissingPrices: JBool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579552 = query.getOrDefault("key")
  valid_579552 = validateParameter(valid_579552, JString, required = false,
                                 default = nil)
  if valid_579552 != nil:
    section.add "key", valid_579552
  var valid_579553 = query.getOrDefault("prettyPrint")
  valid_579553 = validateParameter(valid_579553, JBool, required = false,
                                 default = newJBool(true))
  if valid_579553 != nil:
    section.add "prettyPrint", valid_579553
  var valid_579554 = query.getOrDefault("oauth_token")
  valid_579554 = validateParameter(valid_579554, JString, required = false,
                                 default = nil)
  if valid_579554 != nil:
    section.add "oauth_token", valid_579554
  var valid_579555 = query.getOrDefault("alt")
  valid_579555 = validateParameter(valid_579555, JString, required = false,
                                 default = newJString("json"))
  if valid_579555 != nil:
    section.add "alt", valid_579555
  var valid_579556 = query.getOrDefault("userIp")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = nil)
  if valid_579556 != nil:
    section.add "userIp", valid_579556
  var valid_579557 = query.getOrDefault("quotaUser")
  valid_579557 = validateParameter(valid_579557, JString, required = false,
                                 default = nil)
  if valid_579557 != nil:
    section.add "quotaUser", valid_579557
  var valid_579558 = query.getOrDefault("autoConvertMissingPrices")
  valid_579558 = validateParameter(valid_579558, JBool, required = false, default = nil)
  if valid_579558 != nil:
    section.add "autoConvertMissingPrices", valid_579558
  var valid_579559 = query.getOrDefault("fields")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "fields", valid_579559
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

proc call*(call_579561: Call_AndroidpublisherInappproductsInsert_579548;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new in-app product for an app.
  ## 
  let valid = call_579561.validator(path, query, header, formData, body)
  let scheme = call_579561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579561.url(scheme.get, call_579561.host, call_579561.base,
                         call_579561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579561, url, valid)

proc call*(call_579562: Call_AndroidpublisherInappproductsInsert_579548;
          packageName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; autoConvertMissingPrices: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidpublisherInappproductsInsert
  ## Creates a new in-app product for an app.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app; for example, "com.spiffygame".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   autoConvertMissingPrices: bool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579563 = newJObject()
  var query_579564 = newJObject()
  var body_579565 = newJObject()
  add(query_579564, "key", newJString(key))
  add(query_579564, "prettyPrint", newJBool(prettyPrint))
  add(query_579564, "oauth_token", newJString(oauthToken))
  add(path_579563, "packageName", newJString(packageName))
  add(query_579564, "alt", newJString(alt))
  add(query_579564, "userIp", newJString(userIp))
  add(query_579564, "quotaUser", newJString(quotaUser))
  add(query_579564, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_579565 = body
  add(query_579564, "fields", newJString(fields))
  result = call_579562.call(path_579563, query_579564, nil, nil, body_579565)

var androidpublisherInappproductsInsert* = Call_AndroidpublisherInappproductsInsert_579548(
    name: "androidpublisherInappproductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsInsert_579549,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsInsert_579550, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsList_579530 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsList_579532(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsList_579531(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app with in-app products; for example, "com.spiffygame".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579533 = path.getOrDefault("packageName")
  valid_579533 = validateParameter(valid_579533, JString, required = true,
                                 default = nil)
  if valid_579533 != nil:
    section.add "packageName", valid_579533
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
  ##   startIndex: JInt
  ##   token: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  section = newJObject()
  var valid_579534 = query.getOrDefault("key")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "key", valid_579534
  var valid_579535 = query.getOrDefault("prettyPrint")
  valid_579535 = validateParameter(valid_579535, JBool, required = false,
                                 default = newJBool(true))
  if valid_579535 != nil:
    section.add "prettyPrint", valid_579535
  var valid_579536 = query.getOrDefault("oauth_token")
  valid_579536 = validateParameter(valid_579536, JString, required = false,
                                 default = nil)
  if valid_579536 != nil:
    section.add "oauth_token", valid_579536
  var valid_579537 = query.getOrDefault("alt")
  valid_579537 = validateParameter(valid_579537, JString, required = false,
                                 default = newJString("json"))
  if valid_579537 != nil:
    section.add "alt", valid_579537
  var valid_579538 = query.getOrDefault("userIp")
  valid_579538 = validateParameter(valid_579538, JString, required = false,
                                 default = nil)
  if valid_579538 != nil:
    section.add "userIp", valid_579538
  var valid_579539 = query.getOrDefault("quotaUser")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "quotaUser", valid_579539
  var valid_579540 = query.getOrDefault("startIndex")
  valid_579540 = validateParameter(valid_579540, JInt, required = false, default = nil)
  if valid_579540 != nil:
    section.add "startIndex", valid_579540
  var valid_579541 = query.getOrDefault("token")
  valid_579541 = validateParameter(valid_579541, JString, required = false,
                                 default = nil)
  if valid_579541 != nil:
    section.add "token", valid_579541
  var valid_579542 = query.getOrDefault("fields")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = nil)
  if valid_579542 != nil:
    section.add "fields", valid_579542
  var valid_579543 = query.getOrDefault("maxResults")
  valid_579543 = validateParameter(valid_579543, JInt, required = false, default = nil)
  if valid_579543 != nil:
    section.add "maxResults", valid_579543
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579544: Call_AndroidpublisherInappproductsList_579530;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ## 
  let valid = call_579544.validator(path, query, header, formData, body)
  let scheme = call_579544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579544.url(scheme.get, call_579544.host, call_579544.base,
                         call_579544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579544, url, valid)

proc call*(call_579545: Call_AndroidpublisherInappproductsList_579530;
          packageName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; startIndex: int = 0; token: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## androidpublisherInappproductsList
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with in-app products; for example, "com.spiffygame".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  var path_579546 = newJObject()
  var query_579547 = newJObject()
  add(query_579547, "key", newJString(key))
  add(query_579547, "prettyPrint", newJBool(prettyPrint))
  add(query_579547, "oauth_token", newJString(oauthToken))
  add(path_579546, "packageName", newJString(packageName))
  add(query_579547, "alt", newJString(alt))
  add(query_579547, "userIp", newJString(userIp))
  add(query_579547, "quotaUser", newJString(quotaUser))
  add(query_579547, "startIndex", newJInt(startIndex))
  add(query_579547, "token", newJString(token))
  add(query_579547, "fields", newJString(fields))
  add(query_579547, "maxResults", newJInt(maxResults))
  result = call_579545.call(path_579546, query_579547, nil, nil, nil)

var androidpublisherInappproductsList* = Call_AndroidpublisherInappproductsList_579530(
    name: "androidpublisherInappproductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsList_579531,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsList_579532, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsUpdate_579582 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsUpdate_579584(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts/"),
               (kind: VariableSegment, value: "sku")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsUpdate_579583(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of an in-app product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   sku: JString (required)
  ##      : Unique identifier for the in-app product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579585 = path.getOrDefault("packageName")
  valid_579585 = validateParameter(valid_579585, JString, required = true,
                                 default = nil)
  if valid_579585 != nil:
    section.add "packageName", valid_579585
  var valid_579586 = path.getOrDefault("sku")
  valid_579586 = validateParameter(valid_579586, JString, required = true,
                                 default = nil)
  if valid_579586 != nil:
    section.add "sku", valid_579586
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
  ##   autoConvertMissingPrices: JBool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579587 = query.getOrDefault("key")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = nil)
  if valid_579587 != nil:
    section.add "key", valid_579587
  var valid_579588 = query.getOrDefault("prettyPrint")
  valid_579588 = validateParameter(valid_579588, JBool, required = false,
                                 default = newJBool(true))
  if valid_579588 != nil:
    section.add "prettyPrint", valid_579588
  var valid_579589 = query.getOrDefault("oauth_token")
  valid_579589 = validateParameter(valid_579589, JString, required = false,
                                 default = nil)
  if valid_579589 != nil:
    section.add "oauth_token", valid_579589
  var valid_579590 = query.getOrDefault("alt")
  valid_579590 = validateParameter(valid_579590, JString, required = false,
                                 default = newJString("json"))
  if valid_579590 != nil:
    section.add "alt", valid_579590
  var valid_579591 = query.getOrDefault("userIp")
  valid_579591 = validateParameter(valid_579591, JString, required = false,
                                 default = nil)
  if valid_579591 != nil:
    section.add "userIp", valid_579591
  var valid_579592 = query.getOrDefault("quotaUser")
  valid_579592 = validateParameter(valid_579592, JString, required = false,
                                 default = nil)
  if valid_579592 != nil:
    section.add "quotaUser", valid_579592
  var valid_579593 = query.getOrDefault("autoConvertMissingPrices")
  valid_579593 = validateParameter(valid_579593, JBool, required = false, default = nil)
  if valid_579593 != nil:
    section.add "autoConvertMissingPrices", valid_579593
  var valid_579594 = query.getOrDefault("fields")
  valid_579594 = validateParameter(valid_579594, JString, required = false,
                                 default = nil)
  if valid_579594 != nil:
    section.add "fields", valid_579594
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

proc call*(call_579596: Call_AndroidpublisherInappproductsUpdate_579582;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product.
  ## 
  let valid = call_579596.validator(path, query, header, formData, body)
  let scheme = call_579596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579596.url(scheme.get, call_579596.host, call_579596.base,
                         call_579596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579596, url, valid)

proc call*(call_579597: Call_AndroidpublisherInappproductsUpdate_579582;
          packageName: string; sku: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; autoConvertMissingPrices: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidpublisherInappproductsUpdate
  ## Updates the details of an in-app product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   autoConvertMissingPrices: bool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579598 = newJObject()
  var query_579599 = newJObject()
  var body_579600 = newJObject()
  add(query_579599, "key", newJString(key))
  add(query_579599, "prettyPrint", newJBool(prettyPrint))
  add(query_579599, "oauth_token", newJString(oauthToken))
  add(path_579598, "packageName", newJString(packageName))
  add(query_579599, "alt", newJString(alt))
  add(query_579599, "userIp", newJString(userIp))
  add(path_579598, "sku", newJString(sku))
  add(query_579599, "quotaUser", newJString(quotaUser))
  add(query_579599, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_579600 = body
  add(query_579599, "fields", newJString(fields))
  result = call_579597.call(path_579598, query_579599, nil, nil, body_579600)

var androidpublisherInappproductsUpdate* = Call_AndroidpublisherInappproductsUpdate_579582(
    name: "androidpublisherInappproductsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsUpdate_579583,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsUpdate_579584, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsGet_579566 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsGet_579568(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts/"),
               (kind: VariableSegment, value: "sku")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsGet_579567(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about the in-app product specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##   sku: JString (required)
  ##      : Unique identifier for the in-app product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579569 = path.getOrDefault("packageName")
  valid_579569 = validateParameter(valid_579569, JString, required = true,
                                 default = nil)
  if valid_579569 != nil:
    section.add "packageName", valid_579569
  var valid_579570 = path.getOrDefault("sku")
  valid_579570 = validateParameter(valid_579570, JString, required = true,
                                 default = nil)
  if valid_579570 != nil:
    section.add "sku", valid_579570
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
  var valid_579571 = query.getOrDefault("key")
  valid_579571 = validateParameter(valid_579571, JString, required = false,
                                 default = nil)
  if valid_579571 != nil:
    section.add "key", valid_579571
  var valid_579572 = query.getOrDefault("prettyPrint")
  valid_579572 = validateParameter(valid_579572, JBool, required = false,
                                 default = newJBool(true))
  if valid_579572 != nil:
    section.add "prettyPrint", valid_579572
  var valid_579573 = query.getOrDefault("oauth_token")
  valid_579573 = validateParameter(valid_579573, JString, required = false,
                                 default = nil)
  if valid_579573 != nil:
    section.add "oauth_token", valid_579573
  var valid_579574 = query.getOrDefault("alt")
  valid_579574 = validateParameter(valid_579574, JString, required = false,
                                 default = newJString("json"))
  if valid_579574 != nil:
    section.add "alt", valid_579574
  var valid_579575 = query.getOrDefault("userIp")
  valid_579575 = validateParameter(valid_579575, JString, required = false,
                                 default = nil)
  if valid_579575 != nil:
    section.add "userIp", valid_579575
  var valid_579576 = query.getOrDefault("quotaUser")
  valid_579576 = validateParameter(valid_579576, JString, required = false,
                                 default = nil)
  if valid_579576 != nil:
    section.add "quotaUser", valid_579576
  var valid_579577 = query.getOrDefault("fields")
  valid_579577 = validateParameter(valid_579577, JString, required = false,
                                 default = nil)
  if valid_579577 != nil:
    section.add "fields", valid_579577
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579578: Call_AndroidpublisherInappproductsGet_579566;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the in-app product specified.
  ## 
  let valid = call_579578.validator(path, query, header, formData, body)
  let scheme = call_579578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579578.url(scheme.get, call_579578.host, call_579578.base,
                         call_579578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579578, url, valid)

proc call*(call_579579: Call_AndroidpublisherInappproductsGet_579566;
          packageName: string; sku: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherInappproductsGet
  ## Returns information about the in-app product specified.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579580 = newJObject()
  var query_579581 = newJObject()
  add(query_579581, "key", newJString(key))
  add(query_579581, "prettyPrint", newJBool(prettyPrint))
  add(query_579581, "oauth_token", newJString(oauthToken))
  add(path_579580, "packageName", newJString(packageName))
  add(query_579581, "alt", newJString(alt))
  add(query_579581, "userIp", newJString(userIp))
  add(path_579580, "sku", newJString(sku))
  add(query_579581, "quotaUser", newJString(quotaUser))
  add(query_579581, "fields", newJString(fields))
  result = call_579579.call(path_579580, query_579581, nil, nil, nil)

var androidpublisherInappproductsGet* = Call_AndroidpublisherInappproductsGet_579566(
    name: "androidpublisherInappproductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsGet_579567,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsGet_579568, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsPatch_579617 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsPatch_579619(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts/"),
               (kind: VariableSegment, value: "sku")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsPatch_579618(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of an in-app product. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   sku: JString (required)
  ##      : Unique identifier for the in-app product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579620 = path.getOrDefault("packageName")
  valid_579620 = validateParameter(valid_579620, JString, required = true,
                                 default = nil)
  if valid_579620 != nil:
    section.add "packageName", valid_579620
  var valid_579621 = path.getOrDefault("sku")
  valid_579621 = validateParameter(valid_579621, JString, required = true,
                                 default = nil)
  if valid_579621 != nil:
    section.add "sku", valid_579621
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
  ##   autoConvertMissingPrices: JBool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579622 = query.getOrDefault("key")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "key", valid_579622
  var valid_579623 = query.getOrDefault("prettyPrint")
  valid_579623 = validateParameter(valid_579623, JBool, required = false,
                                 default = newJBool(true))
  if valid_579623 != nil:
    section.add "prettyPrint", valid_579623
  var valid_579624 = query.getOrDefault("oauth_token")
  valid_579624 = validateParameter(valid_579624, JString, required = false,
                                 default = nil)
  if valid_579624 != nil:
    section.add "oauth_token", valid_579624
  var valid_579625 = query.getOrDefault("alt")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = newJString("json"))
  if valid_579625 != nil:
    section.add "alt", valid_579625
  var valid_579626 = query.getOrDefault("userIp")
  valid_579626 = validateParameter(valid_579626, JString, required = false,
                                 default = nil)
  if valid_579626 != nil:
    section.add "userIp", valid_579626
  var valid_579627 = query.getOrDefault("quotaUser")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = nil)
  if valid_579627 != nil:
    section.add "quotaUser", valid_579627
  var valid_579628 = query.getOrDefault("autoConvertMissingPrices")
  valid_579628 = validateParameter(valid_579628, JBool, required = false, default = nil)
  if valid_579628 != nil:
    section.add "autoConvertMissingPrices", valid_579628
  var valid_579629 = query.getOrDefault("fields")
  valid_579629 = validateParameter(valid_579629, JString, required = false,
                                 default = nil)
  if valid_579629 != nil:
    section.add "fields", valid_579629
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

proc call*(call_579631: Call_AndroidpublisherInappproductsPatch_579617;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product. This method supports patch semantics.
  ## 
  let valid = call_579631.validator(path, query, header, formData, body)
  let scheme = call_579631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579631.url(scheme.get, call_579631.host, call_579631.base,
                         call_579631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579631, url, valid)

proc call*(call_579632: Call_AndroidpublisherInappproductsPatch_579617;
          packageName: string; sku: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; autoConvertMissingPrices: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidpublisherInappproductsPatch
  ## Updates the details of an in-app product. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   autoConvertMissingPrices: bool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579633 = newJObject()
  var query_579634 = newJObject()
  var body_579635 = newJObject()
  add(query_579634, "key", newJString(key))
  add(query_579634, "prettyPrint", newJBool(prettyPrint))
  add(query_579634, "oauth_token", newJString(oauthToken))
  add(path_579633, "packageName", newJString(packageName))
  add(query_579634, "alt", newJString(alt))
  add(query_579634, "userIp", newJString(userIp))
  add(path_579633, "sku", newJString(sku))
  add(query_579634, "quotaUser", newJString(quotaUser))
  add(query_579634, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_579635 = body
  add(query_579634, "fields", newJString(fields))
  result = call_579632.call(path_579633, query_579634, nil, nil, body_579635)

var androidpublisherInappproductsPatch* = Call_AndroidpublisherInappproductsPatch_579617(
    name: "androidpublisherInappproductsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsPatch_579618,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsPatch_579619, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsDelete_579601 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsDelete_579603(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/inappproducts/"),
               (kind: VariableSegment, value: "sku")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherInappproductsDelete_579602(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an in-app product for an app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   sku: JString (required)
  ##      : Unique identifier for the in-app product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579604 = path.getOrDefault("packageName")
  valid_579604 = validateParameter(valid_579604, JString, required = true,
                                 default = nil)
  if valid_579604 != nil:
    section.add "packageName", valid_579604
  var valid_579605 = path.getOrDefault("sku")
  valid_579605 = validateParameter(valid_579605, JString, required = true,
                                 default = nil)
  if valid_579605 != nil:
    section.add "sku", valid_579605
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
  var valid_579606 = query.getOrDefault("key")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "key", valid_579606
  var valid_579607 = query.getOrDefault("prettyPrint")
  valid_579607 = validateParameter(valid_579607, JBool, required = false,
                                 default = newJBool(true))
  if valid_579607 != nil:
    section.add "prettyPrint", valid_579607
  var valid_579608 = query.getOrDefault("oauth_token")
  valid_579608 = validateParameter(valid_579608, JString, required = false,
                                 default = nil)
  if valid_579608 != nil:
    section.add "oauth_token", valid_579608
  var valid_579609 = query.getOrDefault("alt")
  valid_579609 = validateParameter(valid_579609, JString, required = false,
                                 default = newJString("json"))
  if valid_579609 != nil:
    section.add "alt", valid_579609
  var valid_579610 = query.getOrDefault("userIp")
  valid_579610 = validateParameter(valid_579610, JString, required = false,
                                 default = nil)
  if valid_579610 != nil:
    section.add "userIp", valid_579610
  var valid_579611 = query.getOrDefault("quotaUser")
  valid_579611 = validateParameter(valid_579611, JString, required = false,
                                 default = nil)
  if valid_579611 != nil:
    section.add "quotaUser", valid_579611
  var valid_579612 = query.getOrDefault("fields")
  valid_579612 = validateParameter(valid_579612, JString, required = false,
                                 default = nil)
  if valid_579612 != nil:
    section.add "fields", valid_579612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579613: Call_AndroidpublisherInappproductsDelete_579601;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an in-app product for an app.
  ## 
  let valid = call_579613.validator(path, query, header, formData, body)
  let scheme = call_579613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579613.url(scheme.get, call_579613.host, call_579613.base,
                         call_579613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579613, url, valid)

proc call*(call_579614: Call_AndroidpublisherInappproductsDelete_579601;
          packageName: string; sku: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherInappproductsDelete
  ## Delete an in-app product for an app.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579615 = newJObject()
  var query_579616 = newJObject()
  add(query_579616, "key", newJString(key))
  add(query_579616, "prettyPrint", newJBool(prettyPrint))
  add(query_579616, "oauth_token", newJString(oauthToken))
  add(path_579615, "packageName", newJString(packageName))
  add(query_579616, "alt", newJString(alt))
  add(query_579616, "userIp", newJString(userIp))
  add(path_579615, "sku", newJString(sku))
  add(query_579616, "quotaUser", newJString(quotaUser))
  add(query_579616, "fields", newJString(fields))
  result = call_579614.call(path_579615, query_579616, nil, nil, nil)

var androidpublisherInappproductsDelete* = Call_AndroidpublisherInappproductsDelete_579601(
    name: "androidpublisherInappproductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsDelete_579602,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsDelete_579603, schemes: {Scheme.Https})
type
  Call_AndroidpublisherOrdersRefund_579636 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherOrdersRefund_579638(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId"),
               (kind: ConstantSegment, value: ":refund")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherOrdersRefund_579637(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refund a user's subscription or in-app purchase order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription or in-app item was purchased (for example, 'com.some.thing').
  ##   orderId: JString (required)
  ##          : The order ID provided to the user when the subscription or in-app order was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579639 = path.getOrDefault("packageName")
  valid_579639 = validateParameter(valid_579639, JString, required = true,
                                 default = nil)
  if valid_579639 != nil:
    section.add "packageName", valid_579639
  var valid_579640 = path.getOrDefault("orderId")
  valid_579640 = validateParameter(valid_579640, JString, required = true,
                                 default = nil)
  if valid_579640 != nil:
    section.add "orderId", valid_579640
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
  ##   revoke: JBool
  ##         : Whether to revoke the purchased item. If set to true, access to the subscription or in-app item will be terminated immediately. If the item is a recurring subscription, all future payments will also be terminated. Consumed in-app items need to be handled by developer's app. (optional)
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579641 = query.getOrDefault("key")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = nil)
  if valid_579641 != nil:
    section.add "key", valid_579641
  var valid_579642 = query.getOrDefault("prettyPrint")
  valid_579642 = validateParameter(valid_579642, JBool, required = false,
                                 default = newJBool(true))
  if valid_579642 != nil:
    section.add "prettyPrint", valid_579642
  var valid_579643 = query.getOrDefault("oauth_token")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "oauth_token", valid_579643
  var valid_579644 = query.getOrDefault("alt")
  valid_579644 = validateParameter(valid_579644, JString, required = false,
                                 default = newJString("json"))
  if valid_579644 != nil:
    section.add "alt", valid_579644
  var valid_579645 = query.getOrDefault("userIp")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = nil)
  if valid_579645 != nil:
    section.add "userIp", valid_579645
  var valid_579646 = query.getOrDefault("quotaUser")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = nil)
  if valid_579646 != nil:
    section.add "quotaUser", valid_579646
  var valid_579647 = query.getOrDefault("revoke")
  valid_579647 = validateParameter(valid_579647, JBool, required = false, default = nil)
  if valid_579647 != nil:
    section.add "revoke", valid_579647
  var valid_579648 = query.getOrDefault("fields")
  valid_579648 = validateParameter(valid_579648, JString, required = false,
                                 default = nil)
  if valid_579648 != nil:
    section.add "fields", valid_579648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579649: Call_AndroidpublisherOrdersRefund_579636; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refund a user's subscription or in-app purchase order.
  ## 
  let valid = call_579649.validator(path, query, header, formData, body)
  let scheme = call_579649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579649.url(scheme.get, call_579649.host, call_579649.base,
                         call_579649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579649, url, valid)

proc call*(call_579650: Call_AndroidpublisherOrdersRefund_579636;
          packageName: string; orderId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; revoke: bool = false;
          fields: string = ""): Recallable =
  ## androidpublisherOrdersRefund
  ## Refund a user's subscription or in-app purchase order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription or in-app item was purchased (for example, 'com.some.thing').
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   revoke: bool
  ##         : Whether to revoke the purchased item. If set to true, access to the subscription or in-app item will be terminated immediately. If the item is a recurring subscription, all future payments will also be terminated. Consumed in-app items need to be handled by developer's app. (optional)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orderId: string (required)
  ##          : The order ID provided to the user when the subscription or in-app order was purchased.
  var path_579651 = newJObject()
  var query_579652 = newJObject()
  add(query_579652, "key", newJString(key))
  add(query_579652, "prettyPrint", newJBool(prettyPrint))
  add(query_579652, "oauth_token", newJString(oauthToken))
  add(path_579651, "packageName", newJString(packageName))
  add(query_579652, "alt", newJString(alt))
  add(query_579652, "userIp", newJString(userIp))
  add(query_579652, "quotaUser", newJString(quotaUser))
  add(query_579652, "revoke", newJBool(revoke))
  add(query_579652, "fields", newJString(fields))
  add(path_579651, "orderId", newJString(orderId))
  result = call_579650.call(path_579651, query_579652, nil, nil, nil)

var androidpublisherOrdersRefund* = Call_AndroidpublisherOrdersRefund_579636(
    name: "androidpublisherOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/orders/{orderId}:refund",
    validator: validate_AndroidpublisherOrdersRefund_579637,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherOrdersRefund_579638, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsGet_579653 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesProductsGet_579655(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesProductsGet_579654(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application the inapp product was sold in (for example, 'com.some.thing').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the inapp product was purchased.
  ##   productId: JString (required)
  ##            : The inapp product SKU (for example, 'com.some.thing.inapp1').
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579656 = path.getOrDefault("packageName")
  valid_579656 = validateParameter(valid_579656, JString, required = true,
                                 default = nil)
  if valid_579656 != nil:
    section.add "packageName", valid_579656
  var valid_579657 = path.getOrDefault("token")
  valid_579657 = validateParameter(valid_579657, JString, required = true,
                                 default = nil)
  if valid_579657 != nil:
    section.add "token", valid_579657
  var valid_579658 = path.getOrDefault("productId")
  valid_579658 = validateParameter(valid_579658, JString, required = true,
                                 default = nil)
  if valid_579658 != nil:
    section.add "productId", valid_579658
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
  var valid_579659 = query.getOrDefault("key")
  valid_579659 = validateParameter(valid_579659, JString, required = false,
                                 default = nil)
  if valid_579659 != nil:
    section.add "key", valid_579659
  var valid_579660 = query.getOrDefault("prettyPrint")
  valid_579660 = validateParameter(valid_579660, JBool, required = false,
                                 default = newJBool(true))
  if valid_579660 != nil:
    section.add "prettyPrint", valid_579660
  var valid_579661 = query.getOrDefault("oauth_token")
  valid_579661 = validateParameter(valid_579661, JString, required = false,
                                 default = nil)
  if valid_579661 != nil:
    section.add "oauth_token", valid_579661
  var valid_579662 = query.getOrDefault("alt")
  valid_579662 = validateParameter(valid_579662, JString, required = false,
                                 default = newJString("json"))
  if valid_579662 != nil:
    section.add "alt", valid_579662
  var valid_579663 = query.getOrDefault("userIp")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "userIp", valid_579663
  var valid_579664 = query.getOrDefault("quotaUser")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = nil)
  if valid_579664 != nil:
    section.add "quotaUser", valid_579664
  var valid_579665 = query.getOrDefault("fields")
  valid_579665 = validateParameter(valid_579665, JString, required = false,
                                 default = nil)
  if valid_579665 != nil:
    section.add "fields", valid_579665
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579666: Call_AndroidpublisherPurchasesProductsGet_579653;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  let valid = call_579666.validator(path, query, header, formData, body)
  let scheme = call_579666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579666.url(scheme.get, call_579666.host, call_579666.base,
                         call_579666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579666, url, valid)

proc call*(call_579667: Call_AndroidpublisherPurchasesProductsGet_579653;
          packageName: string; token: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherPurchasesProductsGet
  ## Checks the purchase and consumption status of an inapp item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application the inapp product was sold in (for example, 'com.some.thing').
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   token: string (required)
  ##        : The token provided to the user's device when the inapp product was purchased.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The inapp product SKU (for example, 'com.some.thing.inapp1').
  var path_579668 = newJObject()
  var query_579669 = newJObject()
  add(query_579669, "key", newJString(key))
  add(query_579669, "prettyPrint", newJBool(prettyPrint))
  add(query_579669, "oauth_token", newJString(oauthToken))
  add(path_579668, "packageName", newJString(packageName))
  add(query_579669, "alt", newJString(alt))
  add(query_579669, "userIp", newJString(userIp))
  add(query_579669, "quotaUser", newJString(quotaUser))
  add(path_579668, "token", newJString(token))
  add(query_579669, "fields", newJString(fields))
  add(path_579668, "productId", newJString(productId))
  result = call_579667.call(path_579668, query_579669, nil, nil, nil)

var androidpublisherPurchasesProductsGet* = Call_AndroidpublisherPurchasesProductsGet_579653(
    name: "androidpublisherPurchasesProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/purchases/products/{productId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesProductsGet_579654,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesProductsGet_579655, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsAcknowledge_579670 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesProductsAcknowledge_579672(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: ":acknowledge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesProductsAcknowledge_579671(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Acknowledges a purchase of an inapp item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application the inapp product was sold in (for example, 'com.some.thing').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   productId: JString (required)
  ##            : The inapp product SKU (for example, 'com.some.thing.inapp1').
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579673 = path.getOrDefault("packageName")
  valid_579673 = validateParameter(valid_579673, JString, required = true,
                                 default = nil)
  if valid_579673 != nil:
    section.add "packageName", valid_579673
  var valid_579674 = path.getOrDefault("token")
  valid_579674 = validateParameter(valid_579674, JString, required = true,
                                 default = nil)
  if valid_579674 != nil:
    section.add "token", valid_579674
  var valid_579675 = path.getOrDefault("productId")
  valid_579675 = validateParameter(valid_579675, JString, required = true,
                                 default = nil)
  if valid_579675 != nil:
    section.add "productId", valid_579675
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
  var valid_579676 = query.getOrDefault("key")
  valid_579676 = validateParameter(valid_579676, JString, required = false,
                                 default = nil)
  if valid_579676 != nil:
    section.add "key", valid_579676
  var valid_579677 = query.getOrDefault("prettyPrint")
  valid_579677 = validateParameter(valid_579677, JBool, required = false,
                                 default = newJBool(true))
  if valid_579677 != nil:
    section.add "prettyPrint", valid_579677
  var valid_579678 = query.getOrDefault("oauth_token")
  valid_579678 = validateParameter(valid_579678, JString, required = false,
                                 default = nil)
  if valid_579678 != nil:
    section.add "oauth_token", valid_579678
  var valid_579679 = query.getOrDefault("alt")
  valid_579679 = validateParameter(valid_579679, JString, required = false,
                                 default = newJString("json"))
  if valid_579679 != nil:
    section.add "alt", valid_579679
  var valid_579680 = query.getOrDefault("userIp")
  valid_579680 = validateParameter(valid_579680, JString, required = false,
                                 default = nil)
  if valid_579680 != nil:
    section.add "userIp", valid_579680
  var valid_579681 = query.getOrDefault("quotaUser")
  valid_579681 = validateParameter(valid_579681, JString, required = false,
                                 default = nil)
  if valid_579681 != nil:
    section.add "quotaUser", valid_579681
  var valid_579682 = query.getOrDefault("fields")
  valid_579682 = validateParameter(valid_579682, JString, required = false,
                                 default = nil)
  if valid_579682 != nil:
    section.add "fields", valid_579682
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

proc call*(call_579684: Call_AndroidpublisherPurchasesProductsAcknowledge_579670;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges a purchase of an inapp item.
  ## 
  let valid = call_579684.validator(path, query, header, formData, body)
  let scheme = call_579684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579684.url(scheme.get, call_579684.host, call_579684.base,
                         call_579684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579684, url, valid)

proc call*(call_579685: Call_AndroidpublisherPurchasesProductsAcknowledge_579670;
          packageName: string; token: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidpublisherPurchasesProductsAcknowledge
  ## Acknowledges a purchase of an inapp item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application the inapp product was sold in (for example, 'com.some.thing').
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The inapp product SKU (for example, 'com.some.thing.inapp1').
  var path_579686 = newJObject()
  var query_579687 = newJObject()
  var body_579688 = newJObject()
  add(query_579687, "key", newJString(key))
  add(query_579687, "prettyPrint", newJBool(prettyPrint))
  add(query_579687, "oauth_token", newJString(oauthToken))
  add(path_579686, "packageName", newJString(packageName))
  add(query_579687, "alt", newJString(alt))
  add(query_579687, "userIp", newJString(userIp))
  add(query_579687, "quotaUser", newJString(quotaUser))
  add(path_579686, "token", newJString(token))
  if body != nil:
    body_579688 = body
  add(query_579687, "fields", newJString(fields))
  add(path_579686, "productId", newJString(productId))
  result = call_579685.call(path_579686, query_579687, nil, nil, body_579688)

var androidpublisherPurchasesProductsAcknowledge* = Call_AndroidpublisherPurchasesProductsAcknowledge_579670(
    name: "androidpublisherPurchasesProductsAcknowledge",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/products/{productId}/tokens/{token}:acknowledge",
    validator: validate_AndroidpublisherPurchasesProductsAcknowledge_579671,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesProductsAcknowledge_579672,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsGet_579689 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesSubscriptionsGet_579691(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesSubscriptionsGet_579690(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579692 = path.getOrDefault("packageName")
  valid_579692 = validateParameter(valid_579692, JString, required = true,
                                 default = nil)
  if valid_579692 != nil:
    section.add "packageName", valid_579692
  var valid_579693 = path.getOrDefault("subscriptionId")
  valid_579693 = validateParameter(valid_579693, JString, required = true,
                                 default = nil)
  if valid_579693 != nil:
    section.add "subscriptionId", valid_579693
  var valid_579694 = path.getOrDefault("token")
  valid_579694 = validateParameter(valid_579694, JString, required = true,
                                 default = nil)
  if valid_579694 != nil:
    section.add "token", valid_579694
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
  var valid_579695 = query.getOrDefault("key")
  valid_579695 = validateParameter(valid_579695, JString, required = false,
                                 default = nil)
  if valid_579695 != nil:
    section.add "key", valid_579695
  var valid_579696 = query.getOrDefault("prettyPrint")
  valid_579696 = validateParameter(valid_579696, JBool, required = false,
                                 default = newJBool(true))
  if valid_579696 != nil:
    section.add "prettyPrint", valid_579696
  var valid_579697 = query.getOrDefault("oauth_token")
  valid_579697 = validateParameter(valid_579697, JString, required = false,
                                 default = nil)
  if valid_579697 != nil:
    section.add "oauth_token", valid_579697
  var valid_579698 = query.getOrDefault("alt")
  valid_579698 = validateParameter(valid_579698, JString, required = false,
                                 default = newJString("json"))
  if valid_579698 != nil:
    section.add "alt", valid_579698
  var valid_579699 = query.getOrDefault("userIp")
  valid_579699 = validateParameter(valid_579699, JString, required = false,
                                 default = nil)
  if valid_579699 != nil:
    section.add "userIp", valid_579699
  var valid_579700 = query.getOrDefault("quotaUser")
  valid_579700 = validateParameter(valid_579700, JString, required = false,
                                 default = nil)
  if valid_579700 != nil:
    section.add "quotaUser", valid_579700
  var valid_579701 = query.getOrDefault("fields")
  valid_579701 = validateParameter(valid_579701, JString, required = false,
                                 default = nil)
  if valid_579701 != nil:
    section.add "fields", valid_579701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579702: Call_AndroidpublisherPurchasesSubscriptionsGet_579689;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_579702.validator(path, query, header, formData, body)
  let scheme = call_579702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579702.url(scheme.get, call_579702.host, call_579702.base,
                         call_579702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579702, url, valid)

proc call*(call_579703: Call_AndroidpublisherPurchasesSubscriptionsGet_579689;
          packageName: string; subscriptionId: string; token: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidpublisherPurchasesSubscriptionsGet
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579704 = newJObject()
  var query_579705 = newJObject()
  add(query_579705, "key", newJString(key))
  add(query_579705, "prettyPrint", newJBool(prettyPrint))
  add(query_579705, "oauth_token", newJString(oauthToken))
  add(path_579704, "packageName", newJString(packageName))
  add(query_579705, "alt", newJString(alt))
  add(query_579705, "userIp", newJString(userIp))
  add(query_579705, "quotaUser", newJString(quotaUser))
  add(path_579704, "subscriptionId", newJString(subscriptionId))
  add(path_579704, "token", newJString(token))
  add(query_579705, "fields", newJString(fields))
  result = call_579703.call(path_579704, query_579705, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsGet* = Call_AndroidpublisherPurchasesSubscriptionsGet_579689(
    name: "androidpublisherPurchasesSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesSubscriptionsGet_579690,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsGet_579691,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_579706 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesSubscriptionsAcknowledge_579708(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: ":acknowledge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesSubscriptionsAcknowledge_579707(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Acknowledges a subscription purchase.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579709 = path.getOrDefault("packageName")
  valid_579709 = validateParameter(valid_579709, JString, required = true,
                                 default = nil)
  if valid_579709 != nil:
    section.add "packageName", valid_579709
  var valid_579710 = path.getOrDefault("subscriptionId")
  valid_579710 = validateParameter(valid_579710, JString, required = true,
                                 default = nil)
  if valid_579710 != nil:
    section.add "subscriptionId", valid_579710
  var valid_579711 = path.getOrDefault("token")
  valid_579711 = validateParameter(valid_579711, JString, required = true,
                                 default = nil)
  if valid_579711 != nil:
    section.add "token", valid_579711
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
  var valid_579712 = query.getOrDefault("key")
  valid_579712 = validateParameter(valid_579712, JString, required = false,
                                 default = nil)
  if valid_579712 != nil:
    section.add "key", valid_579712
  var valid_579713 = query.getOrDefault("prettyPrint")
  valid_579713 = validateParameter(valid_579713, JBool, required = false,
                                 default = newJBool(true))
  if valid_579713 != nil:
    section.add "prettyPrint", valid_579713
  var valid_579714 = query.getOrDefault("oauth_token")
  valid_579714 = validateParameter(valid_579714, JString, required = false,
                                 default = nil)
  if valid_579714 != nil:
    section.add "oauth_token", valid_579714
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
  var valid_579718 = query.getOrDefault("fields")
  valid_579718 = validateParameter(valid_579718, JString, required = false,
                                 default = nil)
  if valid_579718 != nil:
    section.add "fields", valid_579718
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

proc call*(call_579720: Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_579706;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges a subscription purchase.
  ## 
  let valid = call_579720.validator(path, query, header, formData, body)
  let scheme = call_579720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579720.url(scheme.get, call_579720.host, call_579720.base,
                         call_579720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579720, url, valid)

proc call*(call_579721: Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_579706;
          packageName: string; subscriptionId: string; token: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidpublisherPurchasesSubscriptionsAcknowledge
  ## Acknowledges a subscription purchase.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579722 = newJObject()
  var query_579723 = newJObject()
  var body_579724 = newJObject()
  add(query_579723, "key", newJString(key))
  add(query_579723, "prettyPrint", newJBool(prettyPrint))
  add(query_579723, "oauth_token", newJString(oauthToken))
  add(path_579722, "packageName", newJString(packageName))
  add(query_579723, "alt", newJString(alt))
  add(query_579723, "userIp", newJString(userIp))
  add(query_579723, "quotaUser", newJString(quotaUser))
  add(path_579722, "subscriptionId", newJString(subscriptionId))
  add(path_579722, "token", newJString(token))
  if body != nil:
    body_579724 = body
  add(query_579723, "fields", newJString(fields))
  result = call_579721.call(path_579722, query_579723, nil, nil, body_579724)

var androidpublisherPurchasesSubscriptionsAcknowledge* = Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_579706(
    name: "androidpublisherPurchasesSubscriptionsAcknowledge",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:acknowledge",
    validator: validate_AndroidpublisherPurchasesSubscriptionsAcknowledge_579707,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsAcknowledge_579708,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsCancel_579725 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesSubscriptionsCancel_579727(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesSubscriptionsCancel_579726(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579728 = path.getOrDefault("packageName")
  valid_579728 = validateParameter(valid_579728, JString, required = true,
                                 default = nil)
  if valid_579728 != nil:
    section.add "packageName", valid_579728
  var valid_579729 = path.getOrDefault("subscriptionId")
  valid_579729 = validateParameter(valid_579729, JString, required = true,
                                 default = nil)
  if valid_579729 != nil:
    section.add "subscriptionId", valid_579729
  var valid_579730 = path.getOrDefault("token")
  valid_579730 = validateParameter(valid_579730, JString, required = true,
                                 default = nil)
  if valid_579730 != nil:
    section.add "token", valid_579730
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
  var valid_579731 = query.getOrDefault("key")
  valid_579731 = validateParameter(valid_579731, JString, required = false,
                                 default = nil)
  if valid_579731 != nil:
    section.add "key", valid_579731
  var valid_579732 = query.getOrDefault("prettyPrint")
  valid_579732 = validateParameter(valid_579732, JBool, required = false,
                                 default = newJBool(true))
  if valid_579732 != nil:
    section.add "prettyPrint", valid_579732
  var valid_579733 = query.getOrDefault("oauth_token")
  valid_579733 = validateParameter(valid_579733, JString, required = false,
                                 default = nil)
  if valid_579733 != nil:
    section.add "oauth_token", valid_579733
  var valid_579734 = query.getOrDefault("alt")
  valid_579734 = validateParameter(valid_579734, JString, required = false,
                                 default = newJString("json"))
  if valid_579734 != nil:
    section.add "alt", valid_579734
  var valid_579735 = query.getOrDefault("userIp")
  valid_579735 = validateParameter(valid_579735, JString, required = false,
                                 default = nil)
  if valid_579735 != nil:
    section.add "userIp", valid_579735
  var valid_579736 = query.getOrDefault("quotaUser")
  valid_579736 = validateParameter(valid_579736, JString, required = false,
                                 default = nil)
  if valid_579736 != nil:
    section.add "quotaUser", valid_579736
  var valid_579737 = query.getOrDefault("fields")
  valid_579737 = validateParameter(valid_579737, JString, required = false,
                                 default = nil)
  if valid_579737 != nil:
    section.add "fields", valid_579737
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579738: Call_AndroidpublisherPurchasesSubscriptionsCancel_579725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_579738.validator(path, query, header, formData, body)
  let scheme = call_579738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579738.url(scheme.get, call_579738.host, call_579738.base,
                         call_579738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579738, url, valid)

proc call*(call_579739: Call_AndroidpublisherPurchasesSubscriptionsCancel_579725;
          packageName: string; subscriptionId: string; token: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidpublisherPurchasesSubscriptionsCancel
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579740 = newJObject()
  var query_579741 = newJObject()
  add(query_579741, "key", newJString(key))
  add(query_579741, "prettyPrint", newJBool(prettyPrint))
  add(query_579741, "oauth_token", newJString(oauthToken))
  add(path_579740, "packageName", newJString(packageName))
  add(query_579741, "alt", newJString(alt))
  add(query_579741, "userIp", newJString(userIp))
  add(query_579741, "quotaUser", newJString(quotaUser))
  add(path_579740, "subscriptionId", newJString(subscriptionId))
  add(path_579740, "token", newJString(token))
  add(query_579741, "fields", newJString(fields))
  result = call_579739.call(path_579740, query_579741, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsCancel* = Call_AndroidpublisherPurchasesSubscriptionsCancel_579725(
    name: "androidpublisherPurchasesSubscriptionsCancel",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:cancel",
    validator: validate_AndroidpublisherPurchasesSubscriptionsCancel_579726,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsCancel_579727,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsDefer_579742 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesSubscriptionsDefer_579744(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: ":defer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesSubscriptionsDefer_579743(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Defers a user's subscription purchase until a specified future expiration time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579745 = path.getOrDefault("packageName")
  valid_579745 = validateParameter(valid_579745, JString, required = true,
                                 default = nil)
  if valid_579745 != nil:
    section.add "packageName", valid_579745
  var valid_579746 = path.getOrDefault("subscriptionId")
  valid_579746 = validateParameter(valid_579746, JString, required = true,
                                 default = nil)
  if valid_579746 != nil:
    section.add "subscriptionId", valid_579746
  var valid_579747 = path.getOrDefault("token")
  valid_579747 = validateParameter(valid_579747, JString, required = true,
                                 default = nil)
  if valid_579747 != nil:
    section.add "token", valid_579747
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
  var valid_579748 = query.getOrDefault("key")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = nil)
  if valid_579748 != nil:
    section.add "key", valid_579748
  var valid_579749 = query.getOrDefault("prettyPrint")
  valid_579749 = validateParameter(valid_579749, JBool, required = false,
                                 default = newJBool(true))
  if valid_579749 != nil:
    section.add "prettyPrint", valid_579749
  var valid_579750 = query.getOrDefault("oauth_token")
  valid_579750 = validateParameter(valid_579750, JString, required = false,
                                 default = nil)
  if valid_579750 != nil:
    section.add "oauth_token", valid_579750
  var valid_579751 = query.getOrDefault("alt")
  valid_579751 = validateParameter(valid_579751, JString, required = false,
                                 default = newJString("json"))
  if valid_579751 != nil:
    section.add "alt", valid_579751
  var valid_579752 = query.getOrDefault("userIp")
  valid_579752 = validateParameter(valid_579752, JString, required = false,
                                 default = nil)
  if valid_579752 != nil:
    section.add "userIp", valid_579752
  var valid_579753 = query.getOrDefault("quotaUser")
  valid_579753 = validateParameter(valid_579753, JString, required = false,
                                 default = nil)
  if valid_579753 != nil:
    section.add "quotaUser", valid_579753
  var valid_579754 = query.getOrDefault("fields")
  valid_579754 = validateParameter(valid_579754, JString, required = false,
                                 default = nil)
  if valid_579754 != nil:
    section.add "fields", valid_579754
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

proc call*(call_579756: Call_AndroidpublisherPurchasesSubscriptionsDefer_579742;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Defers a user's subscription purchase until a specified future expiration time.
  ## 
  let valid = call_579756.validator(path, query, header, formData, body)
  let scheme = call_579756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579756.url(scheme.get, call_579756.host, call_579756.base,
                         call_579756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579756, url, valid)

proc call*(call_579757: Call_AndroidpublisherPurchasesSubscriptionsDefer_579742;
          packageName: string; subscriptionId: string; token: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidpublisherPurchasesSubscriptionsDefer
  ## Defers a user's subscription purchase until a specified future expiration time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579758 = newJObject()
  var query_579759 = newJObject()
  var body_579760 = newJObject()
  add(query_579759, "key", newJString(key))
  add(query_579759, "prettyPrint", newJBool(prettyPrint))
  add(query_579759, "oauth_token", newJString(oauthToken))
  add(path_579758, "packageName", newJString(packageName))
  add(query_579759, "alt", newJString(alt))
  add(query_579759, "userIp", newJString(userIp))
  add(query_579759, "quotaUser", newJString(quotaUser))
  add(path_579758, "subscriptionId", newJString(subscriptionId))
  add(path_579758, "token", newJString(token))
  if body != nil:
    body_579760 = body
  add(query_579759, "fields", newJString(fields))
  result = call_579757.call(path_579758, query_579759, nil, nil, body_579760)

var androidpublisherPurchasesSubscriptionsDefer* = Call_AndroidpublisherPurchasesSubscriptionsDefer_579742(
    name: "androidpublisherPurchasesSubscriptionsDefer",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:defer",
    validator: validate_AndroidpublisherPurchasesSubscriptionsDefer_579743,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsDefer_579744,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRefund_579761 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesSubscriptionsRefund_579763(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: ":refund")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesSubscriptionsRefund_579762(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579764 = path.getOrDefault("packageName")
  valid_579764 = validateParameter(valid_579764, JString, required = true,
                                 default = nil)
  if valid_579764 != nil:
    section.add "packageName", valid_579764
  var valid_579765 = path.getOrDefault("subscriptionId")
  valid_579765 = validateParameter(valid_579765, JString, required = true,
                                 default = nil)
  if valid_579765 != nil:
    section.add "subscriptionId", valid_579765
  var valid_579766 = path.getOrDefault("token")
  valid_579766 = validateParameter(valid_579766, JString, required = true,
                                 default = nil)
  if valid_579766 != nil:
    section.add "token", valid_579766
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
  var valid_579767 = query.getOrDefault("key")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "key", valid_579767
  var valid_579768 = query.getOrDefault("prettyPrint")
  valid_579768 = validateParameter(valid_579768, JBool, required = false,
                                 default = newJBool(true))
  if valid_579768 != nil:
    section.add "prettyPrint", valid_579768
  var valid_579769 = query.getOrDefault("oauth_token")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "oauth_token", valid_579769
  var valid_579770 = query.getOrDefault("alt")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = newJString("json"))
  if valid_579770 != nil:
    section.add "alt", valid_579770
  var valid_579771 = query.getOrDefault("userIp")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "userIp", valid_579771
  var valid_579772 = query.getOrDefault("quotaUser")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "quotaUser", valid_579772
  var valid_579773 = query.getOrDefault("fields")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "fields", valid_579773
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579774: Call_AndroidpublisherPurchasesSubscriptionsRefund_579761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ## 
  let valid = call_579774.validator(path, query, header, formData, body)
  let scheme = call_579774.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579774.url(scheme.get, call_579774.host, call_579774.base,
                         call_579774.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579774, url, valid)

proc call*(call_579775: Call_AndroidpublisherPurchasesSubscriptionsRefund_579761;
          packageName: string; subscriptionId: string; token: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidpublisherPurchasesSubscriptionsRefund
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579776 = newJObject()
  var query_579777 = newJObject()
  add(query_579777, "key", newJString(key))
  add(query_579777, "prettyPrint", newJBool(prettyPrint))
  add(query_579777, "oauth_token", newJString(oauthToken))
  add(path_579776, "packageName", newJString(packageName))
  add(query_579777, "alt", newJString(alt))
  add(query_579777, "userIp", newJString(userIp))
  add(query_579777, "quotaUser", newJString(quotaUser))
  add(path_579776, "subscriptionId", newJString(subscriptionId))
  add(path_579776, "token", newJString(token))
  add(query_579777, "fields", newJString(fields))
  result = call_579775.call(path_579776, query_579777, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRefund* = Call_AndroidpublisherPurchasesSubscriptionsRefund_579761(
    name: "androidpublisherPurchasesSubscriptionsRefund",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:refund",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRefund_579762,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRefund_579763,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRevoke_579778 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesSubscriptionsRevoke_579780(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: ":revoke")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesSubscriptionsRevoke_579779(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579781 = path.getOrDefault("packageName")
  valid_579781 = validateParameter(valid_579781, JString, required = true,
                                 default = nil)
  if valid_579781 != nil:
    section.add "packageName", valid_579781
  var valid_579782 = path.getOrDefault("subscriptionId")
  valid_579782 = validateParameter(valid_579782, JString, required = true,
                                 default = nil)
  if valid_579782 != nil:
    section.add "subscriptionId", valid_579782
  var valid_579783 = path.getOrDefault("token")
  valid_579783 = validateParameter(valid_579783, JString, required = true,
                                 default = nil)
  if valid_579783 != nil:
    section.add "token", valid_579783
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
  var valid_579784 = query.getOrDefault("key")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "key", valid_579784
  var valid_579785 = query.getOrDefault("prettyPrint")
  valid_579785 = validateParameter(valid_579785, JBool, required = false,
                                 default = newJBool(true))
  if valid_579785 != nil:
    section.add "prettyPrint", valid_579785
  var valid_579786 = query.getOrDefault("oauth_token")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "oauth_token", valid_579786
  var valid_579787 = query.getOrDefault("alt")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = newJString("json"))
  if valid_579787 != nil:
    section.add "alt", valid_579787
  var valid_579788 = query.getOrDefault("userIp")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "userIp", valid_579788
  var valid_579789 = query.getOrDefault("quotaUser")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = nil)
  if valid_579789 != nil:
    section.add "quotaUser", valid_579789
  var valid_579790 = query.getOrDefault("fields")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "fields", valid_579790
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579791: Call_AndroidpublisherPurchasesSubscriptionsRevoke_579778;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ## 
  let valid = call_579791.validator(path, query, header, formData, body)
  let scheme = call_579791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579791.url(scheme.get, call_579791.host, call_579791.base,
                         call_579791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579791, url, valid)

proc call*(call_579792: Call_AndroidpublisherPurchasesSubscriptionsRevoke_579778;
          packageName: string; subscriptionId: string; token: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidpublisherPurchasesSubscriptionsRevoke
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579793 = newJObject()
  var query_579794 = newJObject()
  add(query_579794, "key", newJString(key))
  add(query_579794, "prettyPrint", newJBool(prettyPrint))
  add(query_579794, "oauth_token", newJString(oauthToken))
  add(path_579793, "packageName", newJString(packageName))
  add(query_579794, "alt", newJString(alt))
  add(query_579794, "userIp", newJString(userIp))
  add(query_579794, "quotaUser", newJString(quotaUser))
  add(path_579793, "subscriptionId", newJString(subscriptionId))
  add(path_579793, "token", newJString(token))
  add(query_579794, "fields", newJString(fields))
  result = call_579792.call(path_579793, query_579794, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRevoke* = Call_AndroidpublisherPurchasesSubscriptionsRevoke_579778(
    name: "androidpublisherPurchasesSubscriptionsRevoke",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:revoke",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRevoke_579779,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRevoke_579780,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesVoidedpurchasesList_579795 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesVoidedpurchasesList_579797(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/purchases/voidedpurchases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesVoidedpurchasesList_579796(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the purchases that were canceled, refunded or charged-back.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which voided purchases need to be returned (for example, 'com.some.thing').
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579798 = path.getOrDefault("packageName")
  valid_579798 = validateParameter(valid_579798, JString, required = true,
                                 default = nil)
  if valid_579798 != nil:
    section.add "packageName", valid_579798
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   startTime: JString
  ##            : The time, in milliseconds since the Epoch, of the oldest voided purchase that you want to see in the response. The value of this parameter cannot be older than 30 days and is ignored if a pagination token is set. Default value is current time minus 30 days. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##   type: JInt
  ##       : The type of voided purchases that you want to see in the response. Possible values are:  
  ## - 0: Only voided in-app product purchases will be returned in the response. This is the default value.
  ## - 1: Both voided in-app purchases and voided subscription purchases will be returned in the response.  Note: Before requesting to receive voided subscription purchases, you must switch to use orderId in the response which uniquely identifies one-time purchases and subscriptions. Otherwise, you will receive multiple subscription orders with the same PurchaseToken, because subscription renewal orders share the same PurchaseToken.
  ##   token: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##   endTime: JString
  ##          : The time, in milliseconds since the Epoch, of the newest voided purchase that you want to see in the response. The value of this parameter cannot be greater than the current time and is ignored if a pagination token is set. Default value is current time. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  section = newJObject()
  var valid_579799 = query.getOrDefault("key")
  valid_579799 = validateParameter(valid_579799, JString, required = false,
                                 default = nil)
  if valid_579799 != nil:
    section.add "key", valid_579799
  var valid_579800 = query.getOrDefault("prettyPrint")
  valid_579800 = validateParameter(valid_579800, JBool, required = false,
                                 default = newJBool(true))
  if valid_579800 != nil:
    section.add "prettyPrint", valid_579800
  var valid_579801 = query.getOrDefault("oauth_token")
  valid_579801 = validateParameter(valid_579801, JString, required = false,
                                 default = nil)
  if valid_579801 != nil:
    section.add "oauth_token", valid_579801
  var valid_579802 = query.getOrDefault("startTime")
  valid_579802 = validateParameter(valid_579802, JString, required = false,
                                 default = nil)
  if valid_579802 != nil:
    section.add "startTime", valid_579802
  var valid_579803 = query.getOrDefault("alt")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = newJString("json"))
  if valid_579803 != nil:
    section.add "alt", valid_579803
  var valid_579804 = query.getOrDefault("userIp")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "userIp", valid_579804
  var valid_579805 = query.getOrDefault("quotaUser")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "quotaUser", valid_579805
  var valid_579806 = query.getOrDefault("startIndex")
  valid_579806 = validateParameter(valid_579806, JInt, required = false, default = nil)
  if valid_579806 != nil:
    section.add "startIndex", valid_579806
  var valid_579807 = query.getOrDefault("type")
  valid_579807 = validateParameter(valid_579807, JInt, required = false, default = nil)
  if valid_579807 != nil:
    section.add "type", valid_579807
  var valid_579808 = query.getOrDefault("token")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "token", valid_579808
  var valid_579809 = query.getOrDefault("fields")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "fields", valid_579809
  var valid_579810 = query.getOrDefault("maxResults")
  valid_579810 = validateParameter(valid_579810, JInt, required = false, default = nil)
  if valid_579810 != nil:
    section.add "maxResults", valid_579810
  var valid_579811 = query.getOrDefault("endTime")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "endTime", valid_579811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579812: Call_AndroidpublisherPurchasesVoidedpurchasesList_579795;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the purchases that were canceled, refunded or charged-back.
  ## 
  let valid = call_579812.validator(path, query, header, formData, body)
  let scheme = call_579812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579812.url(scheme.get, call_579812.host, call_579812.base,
                         call_579812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579812, url, valid)

proc call*(call_579813: Call_AndroidpublisherPurchasesVoidedpurchasesList_579795;
          packageName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; startTime: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0; `type`: int = 0;
          token: string = ""; fields: string = ""; maxResults: int = 0; endTime: string = ""): Recallable =
  ## androidpublisherPurchasesVoidedpurchasesList
  ## Lists the purchases that were canceled, refunded or charged-back.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application for which voided purchases need to be returned (for example, 'com.some.thing').
  ##   startTime: string
  ##            : The time, in milliseconds since the Epoch, of the oldest voided purchase that you want to see in the response. The value of this parameter cannot be older than 30 days and is ignored if a pagination token is set. Default value is current time minus 30 days. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##   type: int
  ##       : The type of voided purchases that you want to see in the response. Possible values are:  
  ## - 0: Only voided in-app product purchases will be returned in the response. This is the default value.
  ## - 1: Both voided in-app purchases and voided subscription purchases will be returned in the response.  Note: Before requesting to receive voided subscription purchases, you must switch to use orderId in the response which uniquely identifies one-time purchases and subscriptions. Otherwise, you will receive multiple subscription orders with the same PurchaseToken, because subscription renewal orders share the same PurchaseToken.
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##   endTime: string
  ##          : The time, in milliseconds since the Epoch, of the newest voided purchase that you want to see in the response. The value of this parameter cannot be greater than the current time and is ignored if a pagination token is set. Default value is current time. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  var path_579814 = newJObject()
  var query_579815 = newJObject()
  add(query_579815, "key", newJString(key))
  add(query_579815, "prettyPrint", newJBool(prettyPrint))
  add(query_579815, "oauth_token", newJString(oauthToken))
  add(path_579814, "packageName", newJString(packageName))
  add(query_579815, "startTime", newJString(startTime))
  add(query_579815, "alt", newJString(alt))
  add(query_579815, "userIp", newJString(userIp))
  add(query_579815, "quotaUser", newJString(quotaUser))
  add(query_579815, "startIndex", newJInt(startIndex))
  add(query_579815, "type", newJInt(`type`))
  add(query_579815, "token", newJString(token))
  add(query_579815, "fields", newJString(fields))
  add(query_579815, "maxResults", newJInt(maxResults))
  add(query_579815, "endTime", newJString(endTime))
  result = call_579813.call(path_579814, query_579815, nil, nil, nil)

var androidpublisherPurchasesVoidedpurchasesList* = Call_AndroidpublisherPurchasesVoidedpurchasesList_579795(
    name: "androidpublisherPurchasesVoidedpurchasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{packageName}/purchases/voidedpurchases",
    validator: validate_AndroidpublisherPurchasesVoidedpurchasesList_579796,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesVoidedpurchasesList_579797,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsList_579816 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherReviewsList_579818(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/reviews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherReviewsList_579817(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579819 = path.getOrDefault("packageName")
  valid_579819 = validateParameter(valid_579819, JString, required = true,
                                 default = nil)
  if valid_579819 != nil:
    section.add "packageName", valid_579819
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
  ##   startIndex: JInt
  ##   translationLanguage: JString
  ##   token: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  section = newJObject()
  var valid_579820 = query.getOrDefault("key")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "key", valid_579820
  var valid_579821 = query.getOrDefault("prettyPrint")
  valid_579821 = validateParameter(valid_579821, JBool, required = false,
                                 default = newJBool(true))
  if valid_579821 != nil:
    section.add "prettyPrint", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("alt")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = newJString("json"))
  if valid_579823 != nil:
    section.add "alt", valid_579823
  var valid_579824 = query.getOrDefault("userIp")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "userIp", valid_579824
  var valid_579825 = query.getOrDefault("quotaUser")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "quotaUser", valid_579825
  var valid_579826 = query.getOrDefault("startIndex")
  valid_579826 = validateParameter(valid_579826, JInt, required = false, default = nil)
  if valid_579826 != nil:
    section.add "startIndex", valid_579826
  var valid_579827 = query.getOrDefault("translationLanguage")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "translationLanguage", valid_579827
  var valid_579828 = query.getOrDefault("token")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "token", valid_579828
  var valid_579829 = query.getOrDefault("fields")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "fields", valid_579829
  var valid_579830 = query.getOrDefault("maxResults")
  valid_579830 = validateParameter(valid_579830, JInt, required = false, default = nil)
  if valid_579830 != nil:
    section.add "maxResults", valid_579830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579831: Call_AndroidpublisherReviewsList_579816; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ## 
  let valid = call_579831.validator(path, query, header, formData, body)
  let scheme = call_579831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579831.url(scheme.get, call_579831.host, call_579831.base,
                         call_579831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579831, url, valid)

proc call*(call_579832: Call_AndroidpublisherReviewsList_579816;
          packageName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; startIndex: int = 0; translationLanguage: string = "";
          token: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## androidpublisherReviewsList
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##   translationLanguage: string
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  var path_579833 = newJObject()
  var query_579834 = newJObject()
  add(query_579834, "key", newJString(key))
  add(query_579834, "prettyPrint", newJBool(prettyPrint))
  add(query_579834, "oauth_token", newJString(oauthToken))
  add(path_579833, "packageName", newJString(packageName))
  add(query_579834, "alt", newJString(alt))
  add(query_579834, "userIp", newJString(userIp))
  add(query_579834, "quotaUser", newJString(quotaUser))
  add(query_579834, "startIndex", newJInt(startIndex))
  add(query_579834, "translationLanguage", newJString(translationLanguage))
  add(query_579834, "token", newJString(token))
  add(query_579834, "fields", newJString(fields))
  add(query_579834, "maxResults", newJInt(maxResults))
  result = call_579832.call(path_579833, query_579834, nil, nil, nil)

var androidpublisherReviewsList* = Call_AndroidpublisherReviewsList_579816(
    name: "androidpublisherReviewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews",
    validator: validate_AndroidpublisherReviewsList_579817,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsList_579818, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsGet_579835 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherReviewsGet_579837(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "reviewId" in path, "`reviewId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/reviews/"),
               (kind: VariableSegment, value: "reviewId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherReviewsGet_579836(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a single review.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   reviewId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579838 = path.getOrDefault("packageName")
  valid_579838 = validateParameter(valid_579838, JString, required = true,
                                 default = nil)
  if valid_579838 != nil:
    section.add "packageName", valid_579838
  var valid_579839 = path.getOrDefault("reviewId")
  valid_579839 = validateParameter(valid_579839, JString, required = true,
                                 default = nil)
  if valid_579839 != nil:
    section.add "reviewId", valid_579839
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
  ##   translationLanguage: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579840 = query.getOrDefault("key")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "key", valid_579840
  var valid_579841 = query.getOrDefault("prettyPrint")
  valid_579841 = validateParameter(valid_579841, JBool, required = false,
                                 default = newJBool(true))
  if valid_579841 != nil:
    section.add "prettyPrint", valid_579841
  var valid_579842 = query.getOrDefault("oauth_token")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "oauth_token", valid_579842
  var valid_579843 = query.getOrDefault("alt")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = newJString("json"))
  if valid_579843 != nil:
    section.add "alt", valid_579843
  var valid_579844 = query.getOrDefault("userIp")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "userIp", valid_579844
  var valid_579845 = query.getOrDefault("quotaUser")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = nil)
  if valid_579845 != nil:
    section.add "quotaUser", valid_579845
  var valid_579846 = query.getOrDefault("translationLanguage")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "translationLanguage", valid_579846
  var valid_579847 = query.getOrDefault("fields")
  valid_579847 = validateParameter(valid_579847, JString, required = false,
                                 default = nil)
  if valid_579847 != nil:
    section.add "fields", valid_579847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579848: Call_AndroidpublisherReviewsGet_579835; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single review.
  ## 
  let valid = call_579848.validator(path, query, header, formData, body)
  let scheme = call_579848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579848.url(scheme.get, call_579848.host, call_579848.base,
                         call_579848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579848, url, valid)

proc call*(call_579849: Call_AndroidpublisherReviewsGet_579835;
          packageName: string; reviewId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; translationLanguage: string = "";
          fields: string = ""): Recallable =
  ## androidpublisherReviewsGet
  ## Returns a single review.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   reviewId: string (required)
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   translationLanguage: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579850 = newJObject()
  var query_579851 = newJObject()
  add(query_579851, "key", newJString(key))
  add(query_579851, "prettyPrint", newJBool(prettyPrint))
  add(query_579851, "oauth_token", newJString(oauthToken))
  add(path_579850, "packageName", newJString(packageName))
  add(path_579850, "reviewId", newJString(reviewId))
  add(query_579851, "alt", newJString(alt))
  add(query_579851, "userIp", newJString(userIp))
  add(query_579851, "quotaUser", newJString(quotaUser))
  add(query_579851, "translationLanguage", newJString(translationLanguage))
  add(query_579851, "fields", newJString(fields))
  result = call_579849.call(path_579850, query_579851, nil, nil, nil)

var androidpublisherReviewsGet* = Call_AndroidpublisherReviewsGet_579835(
    name: "androidpublisherReviewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}",
    validator: validate_AndroidpublisherReviewsGet_579836,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsGet_579837, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsReply_579852 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherReviewsReply_579854(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "reviewId" in path, "`reviewId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/reviews/"),
               (kind: VariableSegment, value: "reviewId"),
               (kind: ConstantSegment, value: ":reply")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherReviewsReply_579853(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reply to a single review, or update an existing reply.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   reviewId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579855 = path.getOrDefault("packageName")
  valid_579855 = validateParameter(valid_579855, JString, required = true,
                                 default = nil)
  if valid_579855 != nil:
    section.add "packageName", valid_579855
  var valid_579856 = path.getOrDefault("reviewId")
  valid_579856 = validateParameter(valid_579856, JString, required = true,
                                 default = nil)
  if valid_579856 != nil:
    section.add "reviewId", valid_579856
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
  var valid_579857 = query.getOrDefault("key")
  valid_579857 = validateParameter(valid_579857, JString, required = false,
                                 default = nil)
  if valid_579857 != nil:
    section.add "key", valid_579857
  var valid_579858 = query.getOrDefault("prettyPrint")
  valid_579858 = validateParameter(valid_579858, JBool, required = false,
                                 default = newJBool(true))
  if valid_579858 != nil:
    section.add "prettyPrint", valid_579858
  var valid_579859 = query.getOrDefault("oauth_token")
  valid_579859 = validateParameter(valid_579859, JString, required = false,
                                 default = nil)
  if valid_579859 != nil:
    section.add "oauth_token", valid_579859
  var valid_579860 = query.getOrDefault("alt")
  valid_579860 = validateParameter(valid_579860, JString, required = false,
                                 default = newJString("json"))
  if valid_579860 != nil:
    section.add "alt", valid_579860
  var valid_579861 = query.getOrDefault("userIp")
  valid_579861 = validateParameter(valid_579861, JString, required = false,
                                 default = nil)
  if valid_579861 != nil:
    section.add "userIp", valid_579861
  var valid_579862 = query.getOrDefault("quotaUser")
  valid_579862 = validateParameter(valid_579862, JString, required = false,
                                 default = nil)
  if valid_579862 != nil:
    section.add "quotaUser", valid_579862
  var valid_579863 = query.getOrDefault("fields")
  valid_579863 = validateParameter(valid_579863, JString, required = false,
                                 default = nil)
  if valid_579863 != nil:
    section.add "fields", valid_579863
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

proc call*(call_579865: Call_AndroidpublisherReviewsReply_579852; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reply to a single review, or update an existing reply.
  ## 
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579866: Call_AndroidpublisherReviewsReply_579852;
          packageName: string; reviewId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidpublisherReviewsReply
  ## Reply to a single review, or update an existing reply.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   reviewId: string (required)
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579867 = newJObject()
  var query_579868 = newJObject()
  var body_579869 = newJObject()
  add(query_579868, "key", newJString(key))
  add(query_579868, "prettyPrint", newJBool(prettyPrint))
  add(query_579868, "oauth_token", newJString(oauthToken))
  add(path_579867, "packageName", newJString(packageName))
  add(path_579867, "reviewId", newJString(reviewId))
  add(query_579868, "alt", newJString(alt))
  add(query_579868, "userIp", newJString(userIp))
  add(query_579868, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579869 = body
  add(query_579868, "fields", newJString(fields))
  result = call_579866.call(path_579867, query_579868, nil, nil, body_579869)

var androidpublisherReviewsReply* = Call_AndroidpublisherReviewsReply_579852(
    name: "androidpublisherReviewsReply", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}:reply",
    validator: validate_AndroidpublisherReviewsReply_579853,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsReply_579854, schemes: {Scheme.Https})
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
