
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "androidpublisher"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidpublisherInternalappsharingartifactsUploadapk_579689 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInternalappsharingartifactsUploadapk_579691(
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

proc validate_AndroidpublisherInternalappsharingartifactsUploadapk_579690(
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
  var valid_579817 = path.getOrDefault("packageName")
  valid_579817 = validateParameter(valid_579817, JString, required = true,
                                 default = nil)
  if valid_579817 != nil:
    section.add "packageName", valid_579817
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
  var valid_579818 = query.getOrDefault("fields")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = nil)
  if valid_579818 != nil:
    section.add "fields", valid_579818
  var valid_579819 = query.getOrDefault("quotaUser")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "quotaUser", valid_579819
  var valid_579833 = query.getOrDefault("alt")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = newJString("json"))
  if valid_579833 != nil:
    section.add "alt", valid_579833
  var valid_579834 = query.getOrDefault("oauth_token")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "oauth_token", valid_579834
  var valid_579835 = query.getOrDefault("userIp")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "userIp", valid_579835
  var valid_579836 = query.getOrDefault("key")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "key", valid_579836
  var valid_579837 = query.getOrDefault("prettyPrint")
  valid_579837 = validateParameter(valid_579837, JBool, required = false,
                                 default = newJBool(true))
  if valid_579837 != nil:
    section.add "prettyPrint", valid_579837
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579860: Call_AndroidpublisherInternalappsharingartifactsUploadapk_579689;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads an APK to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_579860.validator(path, query, header, formData, body)
  let scheme = call_579860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579860.url(scheme.get, call_579860.host, call_579860.base,
                         call_579860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579860, url, valid)

proc call*(call_579931: Call_AndroidpublisherInternalappsharingartifactsUploadapk_579689;
          packageName: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherInternalappsharingartifactsUploadapk
  ## Uploads an APK to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app; for example, "com.spiffygame".
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
  var path_579932 = newJObject()
  var query_579934 = newJObject()
  add(query_579934, "fields", newJString(fields))
  add(path_579932, "packageName", newJString(packageName))
  add(query_579934, "quotaUser", newJString(quotaUser))
  add(query_579934, "alt", newJString(alt))
  add(query_579934, "oauth_token", newJString(oauthToken))
  add(query_579934, "userIp", newJString(userIp))
  add(query_579934, "key", newJString(key))
  add(query_579934, "prettyPrint", newJBool(prettyPrint))
  result = call_579931.call(path_579932, query_579934, nil, nil, nil)

var androidpublisherInternalappsharingartifactsUploadapk* = Call_AndroidpublisherInternalappsharingartifactsUploadapk_579689(
    name: "androidpublisherInternalappsharingartifactsUploadapk",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/internalappsharing/{packageName}/artifacts/apk",
    validator: validate_AndroidpublisherInternalappsharingartifactsUploadapk_579690,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInternalappsharingartifactsUploadapk_579691,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherInternalappsharingartifactsUploadbundle_579973 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInternalappsharingartifactsUploadbundle_579975(
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

proc validate_AndroidpublisherInternalappsharingartifactsUploadbundle_579974(
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
  var valid_579976 = path.getOrDefault("packageName")
  valid_579976 = validateParameter(valid_579976, JString, required = true,
                                 default = nil)
  if valid_579976 != nil:
    section.add "packageName", valid_579976
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

proc call*(call_579984: Call_AndroidpublisherInternalappsharingartifactsUploadbundle_579973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads an app bundle to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_AndroidpublisherInternalappsharingartifactsUploadbundle_579973;
          packageName: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherInternalappsharingartifactsUploadbundle
  ## Uploads an app bundle to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app; for example, "com.spiffygame".
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
  var path_579986 = newJObject()
  var query_579987 = newJObject()
  add(query_579987, "fields", newJString(fields))
  add(path_579986, "packageName", newJString(packageName))
  add(query_579987, "quotaUser", newJString(quotaUser))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(query_579987, "userIp", newJString(userIp))
  add(query_579987, "key", newJString(key))
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  result = call_579985.call(path_579986, query_579987, nil, nil, nil)

var androidpublisherInternalappsharingartifactsUploadbundle* = Call_AndroidpublisherInternalappsharingartifactsUploadbundle_579973(
    name: "androidpublisherInternalappsharingartifactsUploadbundle",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/internalappsharing/{packageName}/artifacts/bundle", validator: validate_AndroidpublisherInternalappsharingartifactsUploadbundle_579974,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInternalappsharingartifactsUploadbundle_579975,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsInsert_579988 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsInsert_579990(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsInsert_579989(path: JsonNode; query: JsonNode;
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
  var valid_579991 = path.getOrDefault("packageName")
  valid_579991 = validateParameter(valid_579991, JString, required = true,
                                 default = nil)
  if valid_579991 != nil:
    section.add "packageName", valid_579991
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580000: Call_AndroidpublisherEditsInsert_579988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new edit for an app, populated with the app's current state.
  ## 
  let valid = call_580000.validator(path, query, header, formData, body)
  let scheme = call_580000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580000.url(scheme.get, call_580000.host, call_580000.base,
                         call_580000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580000, url, valid)

proc call*(call_580001: Call_AndroidpublisherEditsInsert_579988;
          packageName: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsInsert
  ## Creates a new edit for an app, populated with the app's current state.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
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
  var path_580002 = newJObject()
  var query_580003 = newJObject()
  var body_580004 = newJObject()
  add(query_580003, "fields", newJString(fields))
  add(path_580002, "packageName", newJString(packageName))
  add(query_580003, "quotaUser", newJString(quotaUser))
  add(query_580003, "alt", newJString(alt))
  add(query_580003, "oauth_token", newJString(oauthToken))
  add(query_580003, "userIp", newJString(userIp))
  add(query_580003, "key", newJString(key))
  if body != nil:
    body_580004 = body
  add(query_580003, "prettyPrint", newJBool(prettyPrint))
  result = call_580001.call(path_580002, query_580003, nil, nil, body_580004)

var androidpublisherEditsInsert* = Call_AndroidpublisherEditsInsert_579988(
    name: "androidpublisherEditsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits",
    validator: validate_AndroidpublisherEditsInsert_579989,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsInsert_579990, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsGet_580005 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsGet_580007(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsGet_580006(path: JsonNode; query: JsonNode;
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
  var valid_580008 = path.getOrDefault("packageName")
  valid_580008 = validateParameter(valid_580008, JString, required = true,
                                 default = nil)
  if valid_580008 != nil:
    section.add "packageName", valid_580008
  var valid_580009 = path.getOrDefault("editId")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "editId", valid_580009
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
  var valid_580010 = query.getOrDefault("fields")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "fields", valid_580010
  var valid_580011 = query.getOrDefault("quotaUser")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "quotaUser", valid_580011
  var valid_580012 = query.getOrDefault("alt")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("json"))
  if valid_580012 != nil:
    section.add "alt", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
  var valid_580014 = query.getOrDefault("userIp")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "userIp", valid_580014
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580017: Call_AndroidpublisherEditsGet_580005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ## 
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_AndroidpublisherEditsGet_580005; packageName: string;
          editId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsGet
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580019 = newJObject()
  var query_580020 = newJObject()
  add(query_580020, "fields", newJString(fields))
  add(path_580019, "packageName", newJString(packageName))
  add(query_580020, "quotaUser", newJString(quotaUser))
  add(query_580020, "alt", newJString(alt))
  add(path_580019, "editId", newJString(editId))
  add(query_580020, "oauth_token", newJString(oauthToken))
  add(query_580020, "userIp", newJString(userIp))
  add(query_580020, "key", newJString(key))
  add(query_580020, "prettyPrint", newJBool(prettyPrint))
  result = call_580018.call(path_580019, query_580020, nil, nil, nil)

var androidpublisherEditsGet* = Call_AndroidpublisherEditsGet_580005(
    name: "androidpublisherEditsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsGet_580006,
    base: "/androidpublisher/v3/applications", url: url_AndroidpublisherEditsGet_580007,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDelete_580021 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsDelete_580023(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDelete_580022(path: JsonNode; query: JsonNode;
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
  var valid_580024 = path.getOrDefault("packageName")
  valid_580024 = validateParameter(valid_580024, JString, required = true,
                                 default = nil)
  if valid_580024 != nil:
    section.add "packageName", valid_580024
  var valid_580025 = path.getOrDefault("editId")
  valid_580025 = validateParameter(valid_580025, JString, required = true,
                                 default = nil)
  if valid_580025 != nil:
    section.add "editId", valid_580025
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
  var valid_580026 = query.getOrDefault("fields")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "fields", valid_580026
  var valid_580027 = query.getOrDefault("quotaUser")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "quotaUser", valid_580027
  var valid_580028 = query.getOrDefault("alt")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = newJString("json"))
  if valid_580028 != nil:
    section.add "alt", valid_580028
  var valid_580029 = query.getOrDefault("oauth_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "oauth_token", valid_580029
  var valid_580030 = query.getOrDefault("userIp")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "userIp", valid_580030
  var valid_580031 = query.getOrDefault("key")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "key", valid_580031
  var valid_580032 = query.getOrDefault("prettyPrint")
  valid_580032 = validateParameter(valid_580032, JBool, required = false,
                                 default = newJBool(true))
  if valid_580032 != nil:
    section.add "prettyPrint", valid_580032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580033: Call_AndroidpublisherEditsDelete_580021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ## 
  let valid = call_580033.validator(path, query, header, formData, body)
  let scheme = call_580033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580033.url(scheme.get, call_580033.host, call_580033.base,
                         call_580033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580033, url, valid)

proc call*(call_580034: Call_AndroidpublisherEditsDelete_580021;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsDelete
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580035 = newJObject()
  var query_580036 = newJObject()
  add(query_580036, "fields", newJString(fields))
  add(path_580035, "packageName", newJString(packageName))
  add(query_580036, "quotaUser", newJString(quotaUser))
  add(query_580036, "alt", newJString(alt))
  add(path_580035, "editId", newJString(editId))
  add(query_580036, "oauth_token", newJString(oauthToken))
  add(query_580036, "userIp", newJString(userIp))
  add(query_580036, "key", newJString(key))
  add(query_580036, "prettyPrint", newJBool(prettyPrint))
  result = call_580034.call(path_580035, query_580036, nil, nil, nil)

var androidpublisherEditsDelete* = Call_AndroidpublisherEditsDelete_580021(
    name: "androidpublisherEditsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsDelete_580022,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDelete_580023, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksUpload_580053 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApksUpload_580055(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsApksUpload_580054(path: JsonNode;
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
  var valid_580056 = path.getOrDefault("packageName")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "packageName", valid_580056
  var valid_580057 = path.getOrDefault("editId")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "editId", valid_580057
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
  var valid_580058 = query.getOrDefault("fields")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "fields", valid_580058
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
  var valid_580062 = query.getOrDefault("userIp")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "userIp", valid_580062
  var valid_580063 = query.getOrDefault("key")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "key", valid_580063
  var valid_580064 = query.getOrDefault("prettyPrint")
  valid_580064 = validateParameter(valid_580064, JBool, required = false,
                                 default = newJBool(true))
  if valid_580064 != nil:
    section.add "prettyPrint", valid_580064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580065: Call_AndroidpublisherEditsApksUpload_580053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_AndroidpublisherEditsApksUpload_580053;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApksUpload
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  add(query_580068, "fields", newJString(fields))
  add(path_580067, "packageName", newJString(packageName))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(query_580068, "alt", newJString(alt))
  add(path_580067, "editId", newJString(editId))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "userIp", newJString(userIp))
  add(query_580068, "key", newJString(key))
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  result = call_580066.call(path_580067, query_580068, nil, nil, nil)

var androidpublisherEditsApksUpload* = Call_AndroidpublisherEditsApksUpload_580053(
    name: "androidpublisherEditsApksUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksUpload_580054,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksUpload_580055, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksList_580037 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApksList_580039(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsApksList_580038(path: JsonNode; query: JsonNode;
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
  var valid_580040 = path.getOrDefault("packageName")
  valid_580040 = validateParameter(valid_580040, JString, required = true,
                                 default = nil)
  if valid_580040 != nil:
    section.add "packageName", valid_580040
  var valid_580041 = path.getOrDefault("editId")
  valid_580041 = validateParameter(valid_580041, JString, required = true,
                                 default = nil)
  if valid_580041 != nil:
    section.add "editId", valid_580041
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
  var valid_580042 = query.getOrDefault("fields")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "fields", valid_580042
  var valid_580043 = query.getOrDefault("quotaUser")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "quotaUser", valid_580043
  var valid_580044 = query.getOrDefault("alt")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = newJString("json"))
  if valid_580044 != nil:
    section.add "alt", valid_580044
  var valid_580045 = query.getOrDefault("oauth_token")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "oauth_token", valid_580045
  var valid_580046 = query.getOrDefault("userIp")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "userIp", valid_580046
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

proc call*(call_580049: Call_AndroidpublisherEditsApksList_580037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_580049.validator(path, query, header, formData, body)
  let scheme = call_580049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580049.url(scheme.get, call_580049.host, call_580049.base,
                         call_580049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580049, url, valid)

proc call*(call_580050: Call_AndroidpublisherEditsApksList_580037;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApksList
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580051 = newJObject()
  var query_580052 = newJObject()
  add(query_580052, "fields", newJString(fields))
  add(path_580051, "packageName", newJString(packageName))
  add(query_580052, "quotaUser", newJString(quotaUser))
  add(query_580052, "alt", newJString(alt))
  add(path_580051, "editId", newJString(editId))
  add(query_580052, "oauth_token", newJString(oauthToken))
  add(query_580052, "userIp", newJString(userIp))
  add(query_580052, "key", newJString(key))
  add(query_580052, "prettyPrint", newJBool(prettyPrint))
  result = call_580050.call(path_580051, query_580052, nil, nil, nil)

var androidpublisherEditsApksList* = Call_AndroidpublisherEditsApksList_580037(
    name: "androidpublisherEditsApksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksList_580038,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksList_580039, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksAddexternallyhosted_580069 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsApksAddexternallyhosted_580071(protocol: Scheme;
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

proc validate_AndroidpublisherEditsApksAddexternallyhosted_580070(path: JsonNode;
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
  var valid_580072 = path.getOrDefault("packageName")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "packageName", valid_580072
  var valid_580073 = path.getOrDefault("editId")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "editId", valid_580073
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
  var valid_580074 = query.getOrDefault("fields")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "fields", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("alt")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("json"))
  if valid_580076 != nil:
    section.add "alt", valid_580076
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("userIp")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "userIp", valid_580078
  var valid_580079 = query.getOrDefault("key")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "key", valid_580079
  var valid_580080 = query.getOrDefault("prettyPrint")
  valid_580080 = validateParameter(valid_580080, JBool, required = false,
                                 default = newJBool(true))
  if valid_580080 != nil:
    section.add "prettyPrint", valid_580080
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

proc call*(call_580082: Call_AndroidpublisherEditsApksAddexternallyhosted_580069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ## 
  let valid = call_580082.validator(path, query, header, formData, body)
  let scheme = call_580082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580082.url(scheme.get, call_580082.host, call_580082.base,
                         call_580082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580082, url, valid)

proc call*(call_580083: Call_AndroidpublisherEditsApksAddexternallyhosted_580069;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsApksAddexternallyhosted
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580084 = newJObject()
  var query_580085 = newJObject()
  var body_580086 = newJObject()
  add(query_580085, "fields", newJString(fields))
  add(path_580084, "packageName", newJString(packageName))
  add(query_580085, "quotaUser", newJString(quotaUser))
  add(query_580085, "alt", newJString(alt))
  add(path_580084, "editId", newJString(editId))
  add(query_580085, "oauth_token", newJString(oauthToken))
  add(query_580085, "userIp", newJString(userIp))
  add(query_580085, "key", newJString(key))
  if body != nil:
    body_580086 = body
  add(query_580085, "prettyPrint", newJBool(prettyPrint))
  result = call_580083.call(path_580084, query_580085, nil, nil, body_580086)

var androidpublisherEditsApksAddexternallyhosted* = Call_AndroidpublisherEditsApksAddexternallyhosted_580069(
    name: "androidpublisherEditsApksAddexternallyhosted",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/externallyHosted",
    validator: validate_AndroidpublisherEditsApksAddexternallyhosted_580070,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksAddexternallyhosted_580071,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDeobfuscationfilesUpload_580087 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsDeobfuscationfilesUpload_580089(protocol: Scheme;
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

proc validate_AndroidpublisherEditsDeobfuscationfilesUpload_580088(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier of the Android app for which the deobfuscatiuon files are being uploaded; for example, "com.spiffygame".
  ##   deobfuscationFileType: JString (required)
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose deobfuscation file is being uploaded.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_580090 = path.getOrDefault("packageName")
  valid_580090 = validateParameter(valid_580090, JString, required = true,
                                 default = nil)
  if valid_580090 != nil:
    section.add "packageName", valid_580090
  var valid_580091 = path.getOrDefault("deobfuscationFileType")
  valid_580091 = validateParameter(valid_580091, JString, required = true,
                                 default = newJString("proguard"))
  if valid_580091 != nil:
    section.add "deobfuscationFileType", valid_580091
  var valid_580092 = path.getOrDefault("editId")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "editId", valid_580092
  var valid_580093 = path.getOrDefault("apkVersionCode")
  valid_580093 = validateParameter(valid_580093, JInt, required = true, default = nil)
  if valid_580093 != nil:
    section.add "apkVersionCode", valid_580093
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
  var valid_580094 = query.getOrDefault("fields")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "fields", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("alt")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = newJString("json"))
  if valid_580096 != nil:
    section.add "alt", valid_580096
  var valid_580097 = query.getOrDefault("oauth_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "oauth_token", valid_580097
  var valid_580098 = query.getOrDefault("userIp")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "userIp", valid_580098
  var valid_580099 = query.getOrDefault("key")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "key", valid_580099
  var valid_580100 = query.getOrDefault("prettyPrint")
  valid_580100 = validateParameter(valid_580100, JBool, required = false,
                                 default = newJBool(true))
  if valid_580100 != nil:
    section.add "prettyPrint", valid_580100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580101: Call_AndroidpublisherEditsDeobfuscationfilesUpload_580087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ## 
  let valid = call_580101.validator(path, query, header, formData, body)
  let scheme = call_580101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580101.url(scheme.get, call_580101.host, call_580101.base,
                         call_580101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580101, url, valid)

proc call*(call_580102: Call_AndroidpublisherEditsDeobfuscationfilesUpload_580087;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = "";
          deobfuscationFileType: string = "proguard"; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsDeobfuscationfilesUpload
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier of the Android app for which the deobfuscatiuon files are being uploaded; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   deobfuscationFileType: string (required)
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose deobfuscation file is being uploaded.
  var path_580103 = newJObject()
  var query_580104 = newJObject()
  add(query_580104, "fields", newJString(fields))
  add(path_580103, "packageName", newJString(packageName))
  add(query_580104, "quotaUser", newJString(quotaUser))
  add(path_580103, "deobfuscationFileType", newJString(deobfuscationFileType))
  add(query_580104, "alt", newJString(alt))
  add(path_580103, "editId", newJString(editId))
  add(query_580104, "oauth_token", newJString(oauthToken))
  add(query_580104, "userIp", newJString(userIp))
  add(query_580104, "key", newJString(key))
  add(query_580104, "prettyPrint", newJBool(prettyPrint))
  add(path_580103, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580102.call(path_580103, query_580104, nil, nil, nil)

var androidpublisherEditsDeobfuscationfilesUpload* = Call_AndroidpublisherEditsDeobfuscationfilesUpload_580087(
    name: "androidpublisherEditsDeobfuscationfilesUpload",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType}",
    validator: validate_AndroidpublisherEditsDeobfuscationfilesUpload_580088,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDeobfuscationfilesUpload_580089,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpdate_580123 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsExpansionfilesUpdate_580125(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesUpdate_580124(path: JsonNode;
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
  ##   expansionFileType: JString (required)
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_580126 = path.getOrDefault("packageName")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "packageName", valid_580126
  var valid_580127 = path.getOrDefault("editId")
  valid_580127 = validateParameter(valid_580127, JString, required = true,
                                 default = nil)
  if valid_580127 != nil:
    section.add "editId", valid_580127
  var valid_580128 = path.getOrDefault("expansionFileType")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = newJString("main"))
  if valid_580128 != nil:
    section.add "expansionFileType", valid_580128
  var valid_580129 = path.getOrDefault("apkVersionCode")
  valid_580129 = validateParameter(valid_580129, JInt, required = true, default = nil)
  if valid_580129 != nil:
    section.add "apkVersionCode", valid_580129
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
  var valid_580130 = query.getOrDefault("fields")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "fields", valid_580130
  var valid_580131 = query.getOrDefault("quotaUser")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "quotaUser", valid_580131
  var valid_580132 = query.getOrDefault("alt")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = newJString("json"))
  if valid_580132 != nil:
    section.add "alt", valid_580132
  var valid_580133 = query.getOrDefault("oauth_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "oauth_token", valid_580133
  var valid_580134 = query.getOrDefault("userIp")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "userIp", valid_580134
  var valid_580135 = query.getOrDefault("key")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "key", valid_580135
  var valid_580136 = query.getOrDefault("prettyPrint")
  valid_580136 = validateParameter(valid_580136, JBool, required = false,
                                 default = newJBool(true))
  if valid_580136 != nil:
    section.add "prettyPrint", valid_580136
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

proc call*(call_580138: Call_AndroidpublisherEditsExpansionfilesUpdate_580123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ## 
  let valid = call_580138.validator(path, query, header, formData, body)
  let scheme = call_580138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580138.url(scheme.get, call_580138.host, call_580138.base,
                         call_580138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580138, url, valid)

proc call*(call_580139: Call_AndroidpublisherEditsExpansionfilesUpdate_580123;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          expansionFileType: string = "main"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsExpansionfilesUpdate
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   expansionFileType: string (required)
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  var path_580140 = newJObject()
  var query_580141 = newJObject()
  var body_580142 = newJObject()
  add(query_580141, "fields", newJString(fields))
  add(path_580140, "packageName", newJString(packageName))
  add(query_580141, "quotaUser", newJString(quotaUser))
  add(query_580141, "alt", newJString(alt))
  add(path_580140, "editId", newJString(editId))
  add(query_580141, "oauth_token", newJString(oauthToken))
  add(query_580141, "userIp", newJString(userIp))
  add(query_580141, "key", newJString(key))
  add(path_580140, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_580142 = body
  add(query_580141, "prettyPrint", newJBool(prettyPrint))
  add(path_580140, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580139.call(path_580140, query_580141, nil, nil, body_580142)

var androidpublisherEditsExpansionfilesUpdate* = Call_AndroidpublisherEditsExpansionfilesUpdate_580123(
    name: "androidpublisherEditsExpansionfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpdate_580124,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpdate_580125,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpload_580143 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsExpansionfilesUpload_580145(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesUpload_580144(path: JsonNode;
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
  ##   expansionFileType: JString (required)
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_580146 = path.getOrDefault("packageName")
  valid_580146 = validateParameter(valid_580146, JString, required = true,
                                 default = nil)
  if valid_580146 != nil:
    section.add "packageName", valid_580146
  var valid_580147 = path.getOrDefault("editId")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "editId", valid_580147
  var valid_580148 = path.getOrDefault("expansionFileType")
  valid_580148 = validateParameter(valid_580148, JString, required = true,
                                 default = newJString("main"))
  if valid_580148 != nil:
    section.add "expansionFileType", valid_580148
  var valid_580149 = path.getOrDefault("apkVersionCode")
  valid_580149 = validateParameter(valid_580149, JInt, required = true, default = nil)
  if valid_580149 != nil:
    section.add "apkVersionCode", valid_580149
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
  var valid_580150 = query.getOrDefault("fields")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "fields", valid_580150
  var valid_580151 = query.getOrDefault("quotaUser")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "quotaUser", valid_580151
  var valid_580152 = query.getOrDefault("alt")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = newJString("json"))
  if valid_580152 != nil:
    section.add "alt", valid_580152
  var valid_580153 = query.getOrDefault("oauth_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "oauth_token", valid_580153
  var valid_580154 = query.getOrDefault("userIp")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "userIp", valid_580154
  var valid_580155 = query.getOrDefault("key")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "key", valid_580155
  var valid_580156 = query.getOrDefault("prettyPrint")
  valid_580156 = validateParameter(valid_580156, JBool, required = false,
                                 default = newJBool(true))
  if valid_580156 != nil:
    section.add "prettyPrint", valid_580156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580157: Call_AndroidpublisherEditsExpansionfilesUpload_580143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads and attaches a new Expansion File to the APK specified.
  ## 
  let valid = call_580157.validator(path, query, header, formData, body)
  let scheme = call_580157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580157.url(scheme.get, call_580157.host, call_580157.base,
                         call_580157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580157, url, valid)

proc call*(call_580158: Call_AndroidpublisherEditsExpansionfilesUpload_580143;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          expansionFileType: string = "main"; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsExpansionfilesUpload
  ## Uploads and attaches a new Expansion File to the APK specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   expansionFileType: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  var path_580159 = newJObject()
  var query_580160 = newJObject()
  add(query_580160, "fields", newJString(fields))
  add(path_580159, "packageName", newJString(packageName))
  add(query_580160, "quotaUser", newJString(quotaUser))
  add(query_580160, "alt", newJString(alt))
  add(path_580159, "editId", newJString(editId))
  add(query_580160, "oauth_token", newJString(oauthToken))
  add(query_580160, "userIp", newJString(userIp))
  add(query_580160, "key", newJString(key))
  add(path_580159, "expansionFileType", newJString(expansionFileType))
  add(query_580160, "prettyPrint", newJBool(prettyPrint))
  add(path_580159, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580158.call(path_580159, query_580160, nil, nil, nil)

var androidpublisherEditsExpansionfilesUpload* = Call_AndroidpublisherEditsExpansionfilesUpload_580143(
    name: "androidpublisherEditsExpansionfilesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpload_580144,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpload_580145,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesGet_580105 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsExpansionfilesGet_580107(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesGet_580106(path: JsonNode;
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
  ##   expansionFileType: JString (required)
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_580108 = path.getOrDefault("packageName")
  valid_580108 = validateParameter(valid_580108, JString, required = true,
                                 default = nil)
  if valid_580108 != nil:
    section.add "packageName", valid_580108
  var valid_580109 = path.getOrDefault("editId")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "editId", valid_580109
  var valid_580110 = path.getOrDefault("expansionFileType")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = newJString("main"))
  if valid_580110 != nil:
    section.add "expansionFileType", valid_580110
  var valid_580111 = path.getOrDefault("apkVersionCode")
  valid_580111 = validateParameter(valid_580111, JInt, required = true, default = nil)
  if valid_580111 != nil:
    section.add "apkVersionCode", valid_580111
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
  var valid_580112 = query.getOrDefault("fields")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "fields", valid_580112
  var valid_580113 = query.getOrDefault("quotaUser")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "quotaUser", valid_580113
  var valid_580114 = query.getOrDefault("alt")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("json"))
  if valid_580114 != nil:
    section.add "alt", valid_580114
  var valid_580115 = query.getOrDefault("oauth_token")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "oauth_token", valid_580115
  var valid_580116 = query.getOrDefault("userIp")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "userIp", valid_580116
  var valid_580117 = query.getOrDefault("key")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "key", valid_580117
  var valid_580118 = query.getOrDefault("prettyPrint")
  valid_580118 = validateParameter(valid_580118, JBool, required = false,
                                 default = newJBool(true))
  if valid_580118 != nil:
    section.add "prettyPrint", valid_580118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580119: Call_AndroidpublisherEditsExpansionfilesGet_580105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the Expansion File configuration for the APK specified.
  ## 
  let valid = call_580119.validator(path, query, header, formData, body)
  let scheme = call_580119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580119.url(scheme.get, call_580119.host, call_580119.base,
                         call_580119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580119, url, valid)

proc call*(call_580120: Call_AndroidpublisherEditsExpansionfilesGet_580105;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          expansionFileType: string = "main"; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsExpansionfilesGet
  ## Fetches the Expansion File configuration for the APK specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   expansionFileType: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  var path_580121 = newJObject()
  var query_580122 = newJObject()
  add(query_580122, "fields", newJString(fields))
  add(path_580121, "packageName", newJString(packageName))
  add(query_580122, "quotaUser", newJString(quotaUser))
  add(query_580122, "alt", newJString(alt))
  add(path_580121, "editId", newJString(editId))
  add(query_580122, "oauth_token", newJString(oauthToken))
  add(query_580122, "userIp", newJString(userIp))
  add(query_580122, "key", newJString(key))
  add(path_580121, "expansionFileType", newJString(expansionFileType))
  add(query_580122, "prettyPrint", newJBool(prettyPrint))
  add(path_580121, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580120.call(path_580121, query_580122, nil, nil, nil)

var androidpublisherEditsExpansionfilesGet* = Call_AndroidpublisherEditsExpansionfilesGet_580105(
    name: "androidpublisherEditsExpansionfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesGet_580106,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesGet_580107,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesPatch_580161 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsExpansionfilesPatch_580163(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesPatch_580162(path: JsonNode;
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
  ##   expansionFileType: JString (required)
  ##   apkVersionCode: JInt (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_580164 = path.getOrDefault("packageName")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "packageName", valid_580164
  var valid_580165 = path.getOrDefault("editId")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "editId", valid_580165
  var valid_580166 = path.getOrDefault("expansionFileType")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = newJString("main"))
  if valid_580166 != nil:
    section.add "expansionFileType", valid_580166
  var valid_580167 = path.getOrDefault("apkVersionCode")
  valid_580167 = validateParameter(valid_580167, JInt, required = true, default = nil)
  if valid_580167 != nil:
    section.add "apkVersionCode", valid_580167
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
  var valid_580168 = query.getOrDefault("fields")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "fields", valid_580168
  var valid_580169 = query.getOrDefault("quotaUser")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "quotaUser", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("oauth_token")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "oauth_token", valid_580171
  var valid_580172 = query.getOrDefault("userIp")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "userIp", valid_580172
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

proc call*(call_580176: Call_AndroidpublisherEditsExpansionfilesPatch_580161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ## 
  let valid = call_580176.validator(path, query, header, formData, body)
  let scheme = call_580176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580176.url(scheme.get, call_580176.host, call_580176.base,
                         call_580176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580176, url, valid)

proc call*(call_580177: Call_AndroidpublisherEditsExpansionfilesPatch_580161;
          packageName: string; editId: string; apkVersionCode: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          expansionFileType: string = "main"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsExpansionfilesPatch
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   expansionFileType: string (required)
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   apkVersionCode: int (required)
  ##                 : The version code of the APK whose Expansion File configuration is being read or modified.
  var path_580178 = newJObject()
  var query_580179 = newJObject()
  var body_580180 = newJObject()
  add(query_580179, "fields", newJString(fields))
  add(path_580178, "packageName", newJString(packageName))
  add(query_580179, "quotaUser", newJString(quotaUser))
  add(query_580179, "alt", newJString(alt))
  add(path_580178, "editId", newJString(editId))
  add(query_580179, "oauth_token", newJString(oauthToken))
  add(query_580179, "userIp", newJString(userIp))
  add(query_580179, "key", newJString(key))
  add(path_580178, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_580180 = body
  add(query_580179, "prettyPrint", newJBool(prettyPrint))
  add(path_580178, "apkVersionCode", newJInt(apkVersionCode))
  result = call_580177.call(path_580178, query_580179, nil, nil, body_580180)

var androidpublisherEditsExpansionfilesPatch* = Call_AndroidpublisherEditsExpansionfilesPatch_580161(
    name: "androidpublisherEditsExpansionfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesPatch_580162,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesPatch_580163,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesUpload_580197 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsBundlesUpload_580199(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsBundlesUpload_580198(path: JsonNode;
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
  var valid_580200 = path.getOrDefault("packageName")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "packageName", valid_580200
  var valid_580201 = path.getOrDefault("editId")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "editId", valid_580201
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
  ##   ackBundleInstallationWarning: JBool
  ##                               : Must be set to true if the bundle installation may trigger a warning on user devices (for example, if installation size may be over a threshold, typically 100 MB).
  section = newJObject()
  var valid_580202 = query.getOrDefault("fields")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "fields", valid_580202
  var valid_580203 = query.getOrDefault("quotaUser")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "quotaUser", valid_580203
  var valid_580204 = query.getOrDefault("alt")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("json"))
  if valid_580204 != nil:
    section.add "alt", valid_580204
  var valid_580205 = query.getOrDefault("oauth_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "oauth_token", valid_580205
  var valid_580206 = query.getOrDefault("userIp")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "userIp", valid_580206
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
  var valid_580209 = query.getOrDefault("ackBundleInstallationWarning")
  valid_580209 = validateParameter(valid_580209, JBool, required = false, default = nil)
  if valid_580209 != nil:
    section.add "ackBundleInstallationWarning", valid_580209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580210: Call_AndroidpublisherEditsBundlesUpload_580197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_580210.validator(path, query, header, formData, body)
  let scheme = call_580210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580210.url(scheme.get, call_580210.host, call_580210.base,
                         call_580210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580210, url, valid)

proc call*(call_580211: Call_AndroidpublisherEditsBundlesUpload_580197;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          ackBundleInstallationWarning: bool = false): Recallable =
  ## androidpublisherEditsBundlesUpload
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ackBundleInstallationWarning: bool
  ##                               : Must be set to true if the bundle installation may trigger a warning on user devices (for example, if installation size may be over a threshold, typically 100 MB).
  var path_580212 = newJObject()
  var query_580213 = newJObject()
  add(query_580213, "fields", newJString(fields))
  add(path_580212, "packageName", newJString(packageName))
  add(query_580213, "quotaUser", newJString(quotaUser))
  add(query_580213, "alt", newJString(alt))
  add(path_580212, "editId", newJString(editId))
  add(query_580213, "oauth_token", newJString(oauthToken))
  add(query_580213, "userIp", newJString(userIp))
  add(query_580213, "key", newJString(key))
  add(query_580213, "prettyPrint", newJBool(prettyPrint))
  add(query_580213, "ackBundleInstallationWarning",
      newJBool(ackBundleInstallationWarning))
  result = call_580211.call(path_580212, query_580213, nil, nil, nil)

var androidpublisherEditsBundlesUpload* = Call_AndroidpublisherEditsBundlesUpload_580197(
    name: "androidpublisherEditsBundlesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesUpload_580198,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsBundlesUpload_580199, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesList_580181 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsBundlesList_580183(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsBundlesList_580182(path: JsonNode;
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
  var valid_580184 = path.getOrDefault("packageName")
  valid_580184 = validateParameter(valid_580184, JString, required = true,
                                 default = nil)
  if valid_580184 != nil:
    section.add "packageName", valid_580184
  var valid_580185 = path.getOrDefault("editId")
  valid_580185 = validateParameter(valid_580185, JString, required = true,
                                 default = nil)
  if valid_580185 != nil:
    section.add "editId", valid_580185
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
  var valid_580186 = query.getOrDefault("fields")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "fields", valid_580186
  var valid_580187 = query.getOrDefault("quotaUser")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "quotaUser", valid_580187
  var valid_580188 = query.getOrDefault("alt")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = newJString("json"))
  if valid_580188 != nil:
    section.add "alt", valid_580188
  var valid_580189 = query.getOrDefault("oauth_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "oauth_token", valid_580189
  var valid_580190 = query.getOrDefault("userIp")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "userIp", valid_580190
  var valid_580191 = query.getOrDefault("key")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "key", valid_580191
  var valid_580192 = query.getOrDefault("prettyPrint")
  valid_580192 = validateParameter(valid_580192, JBool, required = false,
                                 default = newJBool(true))
  if valid_580192 != nil:
    section.add "prettyPrint", valid_580192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580193: Call_AndroidpublisherEditsBundlesList_580181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_580193.validator(path, query, header, formData, body)
  let scheme = call_580193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580193.url(scheme.get, call_580193.host, call_580193.base,
                         call_580193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580193, url, valid)

proc call*(call_580194: Call_AndroidpublisherEditsBundlesList_580181;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsBundlesList
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580195 = newJObject()
  var query_580196 = newJObject()
  add(query_580196, "fields", newJString(fields))
  add(path_580195, "packageName", newJString(packageName))
  add(query_580196, "quotaUser", newJString(quotaUser))
  add(query_580196, "alt", newJString(alt))
  add(path_580195, "editId", newJString(editId))
  add(query_580196, "oauth_token", newJString(oauthToken))
  add(query_580196, "userIp", newJString(userIp))
  add(query_580196, "key", newJString(key))
  add(query_580196, "prettyPrint", newJBool(prettyPrint))
  result = call_580194.call(path_580195, query_580196, nil, nil, nil)

var androidpublisherEditsBundlesList* = Call_AndroidpublisherEditsBundlesList_580181(
    name: "androidpublisherEditsBundlesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesList_580182,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsBundlesList_580183, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsUpdate_580230 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsDetailsUpdate_580232(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsUpdate_580231(path: JsonNode;
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
  var valid_580233 = path.getOrDefault("packageName")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "packageName", valid_580233
  var valid_580234 = path.getOrDefault("editId")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "editId", valid_580234
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
  var valid_580235 = query.getOrDefault("fields")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "fields", valid_580235
  var valid_580236 = query.getOrDefault("quotaUser")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "quotaUser", valid_580236
  var valid_580237 = query.getOrDefault("alt")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = newJString("json"))
  if valid_580237 != nil:
    section.add "alt", valid_580237
  var valid_580238 = query.getOrDefault("oauth_token")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "oauth_token", valid_580238
  var valid_580239 = query.getOrDefault("userIp")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "userIp", valid_580239
  var valid_580240 = query.getOrDefault("key")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "key", valid_580240
  var valid_580241 = query.getOrDefault("prettyPrint")
  valid_580241 = validateParameter(valid_580241, JBool, required = false,
                                 default = newJBool(true))
  if valid_580241 != nil:
    section.add "prettyPrint", valid_580241
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

proc call*(call_580243: Call_AndroidpublisherEditsDetailsUpdate_580230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit.
  ## 
  let valid = call_580243.validator(path, query, header, formData, body)
  let scheme = call_580243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580243.url(scheme.get, call_580243.host, call_580243.base,
                         call_580243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580243, url, valid)

proc call*(call_580244: Call_AndroidpublisherEditsDetailsUpdate_580230;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsDetailsUpdate
  ## Updates app details for this edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580245 = newJObject()
  var query_580246 = newJObject()
  var body_580247 = newJObject()
  add(query_580246, "fields", newJString(fields))
  add(path_580245, "packageName", newJString(packageName))
  add(query_580246, "quotaUser", newJString(quotaUser))
  add(query_580246, "alt", newJString(alt))
  add(path_580245, "editId", newJString(editId))
  add(query_580246, "oauth_token", newJString(oauthToken))
  add(query_580246, "userIp", newJString(userIp))
  add(query_580246, "key", newJString(key))
  if body != nil:
    body_580247 = body
  add(query_580246, "prettyPrint", newJBool(prettyPrint))
  result = call_580244.call(path_580245, query_580246, nil, nil, body_580247)

var androidpublisherEditsDetailsUpdate* = Call_AndroidpublisherEditsDetailsUpdate_580230(
    name: "androidpublisherEditsDetailsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsUpdate_580231,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsUpdate_580232, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsGet_580214 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsDetailsGet_580216(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsGet_580215(path: JsonNode;
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
  var valid_580217 = path.getOrDefault("packageName")
  valid_580217 = validateParameter(valid_580217, JString, required = true,
                                 default = nil)
  if valid_580217 != nil:
    section.add "packageName", valid_580217
  var valid_580218 = path.getOrDefault("editId")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "editId", valid_580218
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
  var valid_580219 = query.getOrDefault("fields")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "fields", valid_580219
  var valid_580220 = query.getOrDefault("quotaUser")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "quotaUser", valid_580220
  var valid_580221 = query.getOrDefault("alt")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = newJString("json"))
  if valid_580221 != nil:
    section.add "alt", valid_580221
  var valid_580222 = query.getOrDefault("oauth_token")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "oauth_token", valid_580222
  var valid_580223 = query.getOrDefault("userIp")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "userIp", valid_580223
  var valid_580224 = query.getOrDefault("key")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "key", valid_580224
  var valid_580225 = query.getOrDefault("prettyPrint")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(true))
  if valid_580225 != nil:
    section.add "prettyPrint", valid_580225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580226: Call_AndroidpublisherEditsDetailsGet_580214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ## 
  let valid = call_580226.validator(path, query, header, formData, body)
  let scheme = call_580226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580226.url(scheme.get, call_580226.host, call_580226.base,
                         call_580226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580226, url, valid)

proc call*(call_580227: Call_AndroidpublisherEditsDetailsGet_580214;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsDetailsGet
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580228 = newJObject()
  var query_580229 = newJObject()
  add(query_580229, "fields", newJString(fields))
  add(path_580228, "packageName", newJString(packageName))
  add(query_580229, "quotaUser", newJString(quotaUser))
  add(query_580229, "alt", newJString(alt))
  add(path_580228, "editId", newJString(editId))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(query_580229, "userIp", newJString(userIp))
  add(query_580229, "key", newJString(key))
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  result = call_580227.call(path_580228, query_580229, nil, nil, nil)

var androidpublisherEditsDetailsGet* = Call_AndroidpublisherEditsDetailsGet_580214(
    name: "androidpublisherEditsDetailsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsGet_580215,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsGet_580216, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsPatch_580248 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsDetailsPatch_580250(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsPatch_580249(path: JsonNode;
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
  var valid_580251 = path.getOrDefault("packageName")
  valid_580251 = validateParameter(valid_580251, JString, required = true,
                                 default = nil)
  if valid_580251 != nil:
    section.add "packageName", valid_580251
  var valid_580252 = path.getOrDefault("editId")
  valid_580252 = validateParameter(valid_580252, JString, required = true,
                                 default = nil)
  if valid_580252 != nil:
    section.add "editId", valid_580252
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
  var valid_580253 = query.getOrDefault("fields")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "fields", valid_580253
  var valid_580254 = query.getOrDefault("quotaUser")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "quotaUser", valid_580254
  var valid_580255 = query.getOrDefault("alt")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = newJString("json"))
  if valid_580255 != nil:
    section.add "alt", valid_580255
  var valid_580256 = query.getOrDefault("oauth_token")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "oauth_token", valid_580256
  var valid_580257 = query.getOrDefault("userIp")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "userIp", valid_580257
  var valid_580258 = query.getOrDefault("key")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "key", valid_580258
  var valid_580259 = query.getOrDefault("prettyPrint")
  valid_580259 = validateParameter(valid_580259, JBool, required = false,
                                 default = newJBool(true))
  if valid_580259 != nil:
    section.add "prettyPrint", valid_580259
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

proc call*(call_580261: Call_AndroidpublisherEditsDetailsPatch_580248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit. This method supports patch semantics.
  ## 
  let valid = call_580261.validator(path, query, header, formData, body)
  let scheme = call_580261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580261.url(scheme.get, call_580261.host, call_580261.base,
                         call_580261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580261, url, valid)

proc call*(call_580262: Call_AndroidpublisherEditsDetailsPatch_580248;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsDetailsPatch
  ## Updates app details for this edit. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580263 = newJObject()
  var query_580264 = newJObject()
  var body_580265 = newJObject()
  add(query_580264, "fields", newJString(fields))
  add(path_580263, "packageName", newJString(packageName))
  add(query_580264, "quotaUser", newJString(quotaUser))
  add(query_580264, "alt", newJString(alt))
  add(path_580263, "editId", newJString(editId))
  add(query_580264, "oauth_token", newJString(oauthToken))
  add(query_580264, "userIp", newJString(userIp))
  add(query_580264, "key", newJString(key))
  if body != nil:
    body_580265 = body
  add(query_580264, "prettyPrint", newJBool(prettyPrint))
  result = call_580262.call(path_580263, query_580264, nil, nil, body_580265)

var androidpublisherEditsDetailsPatch* = Call_AndroidpublisherEditsDetailsPatch_580248(
    name: "androidpublisherEditsDetailsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsPatch_580249,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsPatch_580250, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsList_580266 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsList_580268(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsList_580267(path: JsonNode;
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
  var valid_580269 = path.getOrDefault("packageName")
  valid_580269 = validateParameter(valid_580269, JString, required = true,
                                 default = nil)
  if valid_580269 != nil:
    section.add "packageName", valid_580269
  var valid_580270 = path.getOrDefault("editId")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "editId", valid_580270
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
  var valid_580271 = query.getOrDefault("fields")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "fields", valid_580271
  var valid_580272 = query.getOrDefault("quotaUser")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "quotaUser", valid_580272
  var valid_580273 = query.getOrDefault("alt")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = newJString("json"))
  if valid_580273 != nil:
    section.add "alt", valid_580273
  var valid_580274 = query.getOrDefault("oauth_token")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "oauth_token", valid_580274
  var valid_580275 = query.getOrDefault("userIp")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "userIp", valid_580275
  var valid_580276 = query.getOrDefault("key")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "key", valid_580276
  var valid_580277 = query.getOrDefault("prettyPrint")
  valid_580277 = validateParameter(valid_580277, JBool, required = false,
                                 default = newJBool(true))
  if valid_580277 != nil:
    section.add "prettyPrint", valid_580277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580278: Call_AndroidpublisherEditsListingsList_580266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the localized store listings attached to this edit.
  ## 
  let valid = call_580278.validator(path, query, header, formData, body)
  let scheme = call_580278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580278.url(scheme.get, call_580278.host, call_580278.base,
                         call_580278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580278, url, valid)

proc call*(call_580279: Call_AndroidpublisherEditsListingsList_580266;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsList
  ## Returns all of the localized store listings attached to this edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580280 = newJObject()
  var query_580281 = newJObject()
  add(query_580281, "fields", newJString(fields))
  add(path_580280, "packageName", newJString(packageName))
  add(query_580281, "quotaUser", newJString(quotaUser))
  add(query_580281, "alt", newJString(alt))
  add(path_580280, "editId", newJString(editId))
  add(query_580281, "oauth_token", newJString(oauthToken))
  add(query_580281, "userIp", newJString(userIp))
  add(query_580281, "key", newJString(key))
  add(query_580281, "prettyPrint", newJBool(prettyPrint))
  result = call_580279.call(path_580280, query_580281, nil, nil, nil)

var androidpublisherEditsListingsList* = Call_AndroidpublisherEditsListingsList_580266(
    name: "androidpublisherEditsListingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsList_580267,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsList_580268, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDeleteall_580282 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsDeleteall_580284(protocol: Scheme;
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

proc validate_AndroidpublisherEditsListingsDeleteall_580283(path: JsonNode;
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
  var valid_580285 = path.getOrDefault("packageName")
  valid_580285 = validateParameter(valid_580285, JString, required = true,
                                 default = nil)
  if valid_580285 != nil:
    section.add "packageName", valid_580285
  var valid_580286 = path.getOrDefault("editId")
  valid_580286 = validateParameter(valid_580286, JString, required = true,
                                 default = nil)
  if valid_580286 != nil:
    section.add "editId", valid_580286
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
  var valid_580287 = query.getOrDefault("fields")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "fields", valid_580287
  var valid_580288 = query.getOrDefault("quotaUser")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "quotaUser", valid_580288
  var valid_580289 = query.getOrDefault("alt")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = newJString("json"))
  if valid_580289 != nil:
    section.add "alt", valid_580289
  var valid_580290 = query.getOrDefault("oauth_token")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "oauth_token", valid_580290
  var valid_580291 = query.getOrDefault("userIp")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "userIp", valid_580291
  var valid_580292 = query.getOrDefault("key")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "key", valid_580292
  var valid_580293 = query.getOrDefault("prettyPrint")
  valid_580293 = validateParameter(valid_580293, JBool, required = false,
                                 default = newJBool(true))
  if valid_580293 != nil:
    section.add "prettyPrint", valid_580293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580294: Call_AndroidpublisherEditsListingsDeleteall_580282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all localized listings from an edit.
  ## 
  let valid = call_580294.validator(path, query, header, formData, body)
  let scheme = call_580294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580294.url(scheme.get, call_580294.host, call_580294.base,
                         call_580294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580294, url, valid)

proc call*(call_580295: Call_AndroidpublisherEditsListingsDeleteall_580282;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsDeleteall
  ## Deletes all localized listings from an edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580296 = newJObject()
  var query_580297 = newJObject()
  add(query_580297, "fields", newJString(fields))
  add(path_580296, "packageName", newJString(packageName))
  add(query_580297, "quotaUser", newJString(quotaUser))
  add(query_580297, "alt", newJString(alt))
  add(path_580296, "editId", newJString(editId))
  add(query_580297, "oauth_token", newJString(oauthToken))
  add(query_580297, "userIp", newJString(userIp))
  add(query_580297, "key", newJString(key))
  add(query_580297, "prettyPrint", newJBool(prettyPrint))
  result = call_580295.call(path_580296, query_580297, nil, nil, nil)

var androidpublisherEditsListingsDeleteall* = Call_AndroidpublisherEditsListingsDeleteall_580282(
    name: "androidpublisherEditsListingsDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsDeleteall_580283,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsDeleteall_580284,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsUpdate_580315 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsUpdate_580317(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsUpdate_580316(path: JsonNode;
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
  var valid_580318 = path.getOrDefault("packageName")
  valid_580318 = validateParameter(valid_580318, JString, required = true,
                                 default = nil)
  if valid_580318 != nil:
    section.add "packageName", valid_580318
  var valid_580319 = path.getOrDefault("editId")
  valid_580319 = validateParameter(valid_580319, JString, required = true,
                                 default = nil)
  if valid_580319 != nil:
    section.add "editId", valid_580319
  var valid_580320 = path.getOrDefault("language")
  valid_580320 = validateParameter(valid_580320, JString, required = true,
                                 default = nil)
  if valid_580320 != nil:
    section.add "language", valid_580320
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
  var valid_580321 = query.getOrDefault("fields")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "fields", valid_580321
  var valid_580322 = query.getOrDefault("quotaUser")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "quotaUser", valid_580322
  var valid_580323 = query.getOrDefault("alt")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = newJString("json"))
  if valid_580323 != nil:
    section.add "alt", valid_580323
  var valid_580324 = query.getOrDefault("oauth_token")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "oauth_token", valid_580324
  var valid_580325 = query.getOrDefault("userIp")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "userIp", valid_580325
  var valid_580326 = query.getOrDefault("key")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "key", valid_580326
  var valid_580327 = query.getOrDefault("prettyPrint")
  valid_580327 = validateParameter(valid_580327, JBool, required = false,
                                 default = newJBool(true))
  if valid_580327 != nil:
    section.add "prettyPrint", valid_580327
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

proc call*(call_580329: Call_AndroidpublisherEditsListingsUpdate_580315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing.
  ## 
  let valid = call_580329.validator(path, query, header, formData, body)
  let scheme = call_580329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580329.url(scheme.get, call_580329.host, call_580329.base,
                         call_580329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580329, url, valid)

proc call*(call_580330: Call_AndroidpublisherEditsListingsUpdate_580315;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsUpdate
  ## Creates or updates a localized store listing.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580331 = newJObject()
  var query_580332 = newJObject()
  var body_580333 = newJObject()
  add(query_580332, "fields", newJString(fields))
  add(path_580331, "packageName", newJString(packageName))
  add(query_580332, "quotaUser", newJString(quotaUser))
  add(query_580332, "alt", newJString(alt))
  add(path_580331, "editId", newJString(editId))
  add(query_580332, "oauth_token", newJString(oauthToken))
  add(path_580331, "language", newJString(language))
  add(query_580332, "userIp", newJString(userIp))
  add(query_580332, "key", newJString(key))
  if body != nil:
    body_580333 = body
  add(query_580332, "prettyPrint", newJBool(prettyPrint))
  result = call_580330.call(path_580331, query_580332, nil, nil, body_580333)

var androidpublisherEditsListingsUpdate* = Call_AndroidpublisherEditsListingsUpdate_580315(
    name: "androidpublisherEditsListingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsUpdate_580316,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsUpdate_580317, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsGet_580298 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsGet_580300(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsGet_580299(path: JsonNode;
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
  var valid_580301 = path.getOrDefault("packageName")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "packageName", valid_580301
  var valid_580302 = path.getOrDefault("editId")
  valid_580302 = validateParameter(valid_580302, JString, required = true,
                                 default = nil)
  if valid_580302 != nil:
    section.add "editId", valid_580302
  var valid_580303 = path.getOrDefault("language")
  valid_580303 = validateParameter(valid_580303, JString, required = true,
                                 default = nil)
  if valid_580303 != nil:
    section.add "language", valid_580303
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
  var valid_580304 = query.getOrDefault("fields")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "fields", valid_580304
  var valid_580305 = query.getOrDefault("quotaUser")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "quotaUser", valid_580305
  var valid_580306 = query.getOrDefault("alt")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = newJString("json"))
  if valid_580306 != nil:
    section.add "alt", valid_580306
  var valid_580307 = query.getOrDefault("oauth_token")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "oauth_token", valid_580307
  var valid_580308 = query.getOrDefault("userIp")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "userIp", valid_580308
  var valid_580309 = query.getOrDefault("key")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "key", valid_580309
  var valid_580310 = query.getOrDefault("prettyPrint")
  valid_580310 = validateParameter(valid_580310, JBool, required = false,
                                 default = newJBool(true))
  if valid_580310 != nil:
    section.add "prettyPrint", valid_580310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580311: Call_AndroidpublisherEditsListingsGet_580298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches information about a localized store listing.
  ## 
  let valid = call_580311.validator(path, query, header, formData, body)
  let scheme = call_580311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580311.url(scheme.get, call_580311.host, call_580311.base,
                         call_580311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580311, url, valid)

proc call*(call_580312: Call_AndroidpublisherEditsListingsGet_580298;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsGet
  ## Fetches information about a localized store listing.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580313 = newJObject()
  var query_580314 = newJObject()
  add(query_580314, "fields", newJString(fields))
  add(path_580313, "packageName", newJString(packageName))
  add(query_580314, "quotaUser", newJString(quotaUser))
  add(query_580314, "alt", newJString(alt))
  add(path_580313, "editId", newJString(editId))
  add(query_580314, "oauth_token", newJString(oauthToken))
  add(path_580313, "language", newJString(language))
  add(query_580314, "userIp", newJString(userIp))
  add(query_580314, "key", newJString(key))
  add(query_580314, "prettyPrint", newJBool(prettyPrint))
  result = call_580312.call(path_580313, query_580314, nil, nil, nil)

var androidpublisherEditsListingsGet* = Call_AndroidpublisherEditsListingsGet_580298(
    name: "androidpublisherEditsListingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsGet_580299,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsGet_580300, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsPatch_580351 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsPatch_580353(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsPatch_580352(path: JsonNode;
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
  var valid_580354 = path.getOrDefault("packageName")
  valid_580354 = validateParameter(valid_580354, JString, required = true,
                                 default = nil)
  if valid_580354 != nil:
    section.add "packageName", valid_580354
  var valid_580355 = path.getOrDefault("editId")
  valid_580355 = validateParameter(valid_580355, JString, required = true,
                                 default = nil)
  if valid_580355 != nil:
    section.add "editId", valid_580355
  var valid_580356 = path.getOrDefault("language")
  valid_580356 = validateParameter(valid_580356, JString, required = true,
                                 default = nil)
  if valid_580356 != nil:
    section.add "language", valid_580356
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
  var valid_580357 = query.getOrDefault("fields")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "fields", valid_580357
  var valid_580358 = query.getOrDefault("quotaUser")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "quotaUser", valid_580358
  var valid_580359 = query.getOrDefault("alt")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = newJString("json"))
  if valid_580359 != nil:
    section.add "alt", valid_580359
  var valid_580360 = query.getOrDefault("oauth_token")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "oauth_token", valid_580360
  var valid_580361 = query.getOrDefault("userIp")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "userIp", valid_580361
  var valid_580362 = query.getOrDefault("key")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "key", valid_580362
  var valid_580363 = query.getOrDefault("prettyPrint")
  valid_580363 = validateParameter(valid_580363, JBool, required = false,
                                 default = newJBool(true))
  if valid_580363 != nil:
    section.add "prettyPrint", valid_580363
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

proc call*(call_580365: Call_AndroidpublisherEditsListingsPatch_580351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ## 
  let valid = call_580365.validator(path, query, header, formData, body)
  let scheme = call_580365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580365.url(scheme.get, call_580365.host, call_580365.base,
                         call_580365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580365, url, valid)

proc call*(call_580366: Call_AndroidpublisherEditsListingsPatch_580351;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsPatch
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580367 = newJObject()
  var query_580368 = newJObject()
  var body_580369 = newJObject()
  add(query_580368, "fields", newJString(fields))
  add(path_580367, "packageName", newJString(packageName))
  add(query_580368, "quotaUser", newJString(quotaUser))
  add(query_580368, "alt", newJString(alt))
  add(path_580367, "editId", newJString(editId))
  add(query_580368, "oauth_token", newJString(oauthToken))
  add(path_580367, "language", newJString(language))
  add(query_580368, "userIp", newJString(userIp))
  add(query_580368, "key", newJString(key))
  if body != nil:
    body_580369 = body
  add(query_580368, "prettyPrint", newJBool(prettyPrint))
  result = call_580366.call(path_580367, query_580368, nil, nil, body_580369)

var androidpublisherEditsListingsPatch* = Call_AndroidpublisherEditsListingsPatch_580351(
    name: "androidpublisherEditsListingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsPatch_580352,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsPatch_580353, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDelete_580334 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsListingsDelete_580336(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsDelete_580335(path: JsonNode;
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
  var valid_580337 = path.getOrDefault("packageName")
  valid_580337 = validateParameter(valid_580337, JString, required = true,
                                 default = nil)
  if valid_580337 != nil:
    section.add "packageName", valid_580337
  var valid_580338 = path.getOrDefault("editId")
  valid_580338 = validateParameter(valid_580338, JString, required = true,
                                 default = nil)
  if valid_580338 != nil:
    section.add "editId", valid_580338
  var valid_580339 = path.getOrDefault("language")
  valid_580339 = validateParameter(valid_580339, JString, required = true,
                                 default = nil)
  if valid_580339 != nil:
    section.add "language", valid_580339
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
  var valid_580340 = query.getOrDefault("fields")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "fields", valid_580340
  var valid_580341 = query.getOrDefault("quotaUser")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "quotaUser", valid_580341
  var valid_580342 = query.getOrDefault("alt")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = newJString("json"))
  if valid_580342 != nil:
    section.add "alt", valid_580342
  var valid_580343 = query.getOrDefault("oauth_token")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "oauth_token", valid_580343
  var valid_580344 = query.getOrDefault("userIp")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "userIp", valid_580344
  var valid_580345 = query.getOrDefault("key")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "key", valid_580345
  var valid_580346 = query.getOrDefault("prettyPrint")
  valid_580346 = validateParameter(valid_580346, JBool, required = false,
                                 default = newJBool(true))
  if valid_580346 != nil:
    section.add "prettyPrint", valid_580346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580347: Call_AndroidpublisherEditsListingsDelete_580334;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified localized store listing from an edit.
  ## 
  let valid = call_580347.validator(path, query, header, formData, body)
  let scheme = call_580347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580347.url(scheme.get, call_580347.host, call_580347.base,
                         call_580347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580347, url, valid)

proc call*(call_580348: Call_AndroidpublisherEditsListingsDelete_580334;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsListingsDelete
  ## Deletes the specified localized store listing from an edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580349 = newJObject()
  var query_580350 = newJObject()
  add(query_580350, "fields", newJString(fields))
  add(path_580349, "packageName", newJString(packageName))
  add(query_580350, "quotaUser", newJString(quotaUser))
  add(query_580350, "alt", newJString(alt))
  add(path_580349, "editId", newJString(editId))
  add(query_580350, "oauth_token", newJString(oauthToken))
  add(path_580349, "language", newJString(language))
  add(query_580350, "userIp", newJString(userIp))
  add(query_580350, "key", newJString(key))
  add(query_580350, "prettyPrint", newJBool(prettyPrint))
  result = call_580348.call(path_580349, query_580350, nil, nil, nil)

var androidpublisherEditsListingsDelete* = Call_AndroidpublisherEditsListingsDelete_580334(
    name: "androidpublisherEditsListingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsDelete_580335,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsDelete_580336, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesUpload_580388 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsImagesUpload_580390(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesUpload_580389(path: JsonNode;
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
  var valid_580391 = path.getOrDefault("packageName")
  valid_580391 = validateParameter(valid_580391, JString, required = true,
                                 default = nil)
  if valid_580391 != nil:
    section.add "packageName", valid_580391
  var valid_580392 = path.getOrDefault("editId")
  valid_580392 = validateParameter(valid_580392, JString, required = true,
                                 default = nil)
  if valid_580392 != nil:
    section.add "editId", valid_580392
  var valid_580393 = path.getOrDefault("language")
  valid_580393 = validateParameter(valid_580393, JString, required = true,
                                 default = nil)
  if valid_580393 != nil:
    section.add "language", valid_580393
  var valid_580394 = path.getOrDefault("imageType")
  valid_580394 = validateParameter(valid_580394, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_580394 != nil:
    section.add "imageType", valid_580394
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
  var valid_580395 = query.getOrDefault("fields")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "fields", valid_580395
  var valid_580396 = query.getOrDefault("quotaUser")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "quotaUser", valid_580396
  var valid_580397 = query.getOrDefault("alt")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = newJString("json"))
  if valid_580397 != nil:
    section.add "alt", valid_580397
  var valid_580398 = query.getOrDefault("oauth_token")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "oauth_token", valid_580398
  var valid_580399 = query.getOrDefault("userIp")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "userIp", valid_580399
  var valid_580400 = query.getOrDefault("key")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "key", valid_580400
  var valid_580401 = query.getOrDefault("prettyPrint")
  valid_580401 = validateParameter(valid_580401, JBool, required = false,
                                 default = newJBool(true))
  if valid_580401 != nil:
    section.add "prettyPrint", valid_580401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580402: Call_AndroidpublisherEditsImagesUpload_580388;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ## 
  let valid = call_580402.validator(path, query, header, formData, body)
  let scheme = call_580402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580402.url(scheme.get, call_580402.host, call_580402.base,
                         call_580402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580402, url, valid)

proc call*(call_580403: Call_AndroidpublisherEditsImagesUpload_580388;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; imageType: string = "featureGraphic"; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsImagesUpload
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   imageType: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580404 = newJObject()
  var query_580405 = newJObject()
  add(query_580405, "fields", newJString(fields))
  add(path_580404, "packageName", newJString(packageName))
  add(query_580405, "quotaUser", newJString(quotaUser))
  add(query_580405, "alt", newJString(alt))
  add(path_580404, "editId", newJString(editId))
  add(query_580405, "oauth_token", newJString(oauthToken))
  add(path_580404, "language", newJString(language))
  add(query_580405, "userIp", newJString(userIp))
  add(path_580404, "imageType", newJString(imageType))
  add(query_580405, "key", newJString(key))
  add(query_580405, "prettyPrint", newJBool(prettyPrint))
  result = call_580403.call(path_580404, query_580405, nil, nil, nil)

var androidpublisherEditsImagesUpload* = Call_AndroidpublisherEditsImagesUpload_580388(
    name: "androidpublisherEditsImagesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesUpload_580389,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesUpload_580390, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesList_580370 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsImagesList_580372(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesList_580371(path: JsonNode;
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
  var valid_580373 = path.getOrDefault("packageName")
  valid_580373 = validateParameter(valid_580373, JString, required = true,
                                 default = nil)
  if valid_580373 != nil:
    section.add "packageName", valid_580373
  var valid_580374 = path.getOrDefault("editId")
  valid_580374 = validateParameter(valid_580374, JString, required = true,
                                 default = nil)
  if valid_580374 != nil:
    section.add "editId", valid_580374
  var valid_580375 = path.getOrDefault("language")
  valid_580375 = validateParameter(valid_580375, JString, required = true,
                                 default = nil)
  if valid_580375 != nil:
    section.add "language", valid_580375
  var valid_580376 = path.getOrDefault("imageType")
  valid_580376 = validateParameter(valid_580376, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_580376 != nil:
    section.add "imageType", valid_580376
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
  var valid_580377 = query.getOrDefault("fields")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "fields", valid_580377
  var valid_580378 = query.getOrDefault("quotaUser")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "quotaUser", valid_580378
  var valid_580379 = query.getOrDefault("alt")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = newJString("json"))
  if valid_580379 != nil:
    section.add "alt", valid_580379
  var valid_580380 = query.getOrDefault("oauth_token")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "oauth_token", valid_580380
  var valid_580381 = query.getOrDefault("userIp")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "userIp", valid_580381
  var valid_580382 = query.getOrDefault("key")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "key", valid_580382
  var valid_580383 = query.getOrDefault("prettyPrint")
  valid_580383 = validateParameter(valid_580383, JBool, required = false,
                                 default = newJBool(true))
  if valid_580383 != nil:
    section.add "prettyPrint", valid_580383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580384: Call_AndroidpublisherEditsImagesList_580370;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all images for the specified language and image type.
  ## 
  let valid = call_580384.validator(path, query, header, formData, body)
  let scheme = call_580384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580384.url(scheme.get, call_580384.host, call_580384.base,
                         call_580384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580384, url, valid)

proc call*(call_580385: Call_AndroidpublisherEditsImagesList_580370;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; imageType: string = "featureGraphic"; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsImagesList
  ## Lists all images for the specified language and image type.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   imageType: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580386 = newJObject()
  var query_580387 = newJObject()
  add(query_580387, "fields", newJString(fields))
  add(path_580386, "packageName", newJString(packageName))
  add(query_580387, "quotaUser", newJString(quotaUser))
  add(query_580387, "alt", newJString(alt))
  add(path_580386, "editId", newJString(editId))
  add(query_580387, "oauth_token", newJString(oauthToken))
  add(path_580386, "language", newJString(language))
  add(query_580387, "userIp", newJString(userIp))
  add(path_580386, "imageType", newJString(imageType))
  add(query_580387, "key", newJString(key))
  add(query_580387, "prettyPrint", newJBool(prettyPrint))
  result = call_580385.call(path_580386, query_580387, nil, nil, nil)

var androidpublisherEditsImagesList* = Call_AndroidpublisherEditsImagesList_580370(
    name: "androidpublisherEditsImagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesList_580371,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesList_580372, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDeleteall_580406 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsImagesDeleteall_580408(protocol: Scheme;
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

proc validate_AndroidpublisherEditsImagesDeleteall_580407(path: JsonNode;
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
  var valid_580409 = path.getOrDefault("packageName")
  valid_580409 = validateParameter(valid_580409, JString, required = true,
                                 default = nil)
  if valid_580409 != nil:
    section.add "packageName", valid_580409
  var valid_580410 = path.getOrDefault("editId")
  valid_580410 = validateParameter(valid_580410, JString, required = true,
                                 default = nil)
  if valid_580410 != nil:
    section.add "editId", valid_580410
  var valid_580411 = path.getOrDefault("language")
  valid_580411 = validateParameter(valid_580411, JString, required = true,
                                 default = nil)
  if valid_580411 != nil:
    section.add "language", valid_580411
  var valid_580412 = path.getOrDefault("imageType")
  valid_580412 = validateParameter(valid_580412, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_580412 != nil:
    section.add "imageType", valid_580412
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
  var valid_580413 = query.getOrDefault("fields")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "fields", valid_580413
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
  var valid_580418 = query.getOrDefault("key")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "key", valid_580418
  var valid_580419 = query.getOrDefault("prettyPrint")
  valid_580419 = validateParameter(valid_580419, JBool, required = false,
                                 default = newJBool(true))
  if valid_580419 != nil:
    section.add "prettyPrint", valid_580419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580420: Call_AndroidpublisherEditsImagesDeleteall_580406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all images for the specified language and image type.
  ## 
  let valid = call_580420.validator(path, query, header, formData, body)
  let scheme = call_580420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580420.url(scheme.get, call_580420.host, call_580420.base,
                         call_580420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580420, url, valid)

proc call*(call_580421: Call_AndroidpublisherEditsImagesDeleteall_580406;
          packageName: string; editId: string; language: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; imageType: string = "featureGraphic"; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsImagesDeleteall
  ## Deletes all images for the specified language and image type.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   imageType: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580422 = newJObject()
  var query_580423 = newJObject()
  add(query_580423, "fields", newJString(fields))
  add(path_580422, "packageName", newJString(packageName))
  add(query_580423, "quotaUser", newJString(quotaUser))
  add(query_580423, "alt", newJString(alt))
  add(path_580422, "editId", newJString(editId))
  add(query_580423, "oauth_token", newJString(oauthToken))
  add(path_580422, "language", newJString(language))
  add(query_580423, "userIp", newJString(userIp))
  add(path_580422, "imageType", newJString(imageType))
  add(query_580423, "key", newJString(key))
  add(query_580423, "prettyPrint", newJBool(prettyPrint))
  result = call_580421.call(path_580422, query_580423, nil, nil, nil)

var androidpublisherEditsImagesDeleteall* = Call_AndroidpublisherEditsImagesDeleteall_580406(
    name: "androidpublisherEditsImagesDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesDeleteall_580407,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesDeleteall_580408, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDelete_580424 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsImagesDelete_580426(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesDelete_580425(path: JsonNode;
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
  var valid_580427 = path.getOrDefault("imageId")
  valid_580427 = validateParameter(valid_580427, JString, required = true,
                                 default = nil)
  if valid_580427 != nil:
    section.add "imageId", valid_580427
  var valid_580428 = path.getOrDefault("packageName")
  valid_580428 = validateParameter(valid_580428, JString, required = true,
                                 default = nil)
  if valid_580428 != nil:
    section.add "packageName", valid_580428
  var valid_580429 = path.getOrDefault("editId")
  valid_580429 = validateParameter(valid_580429, JString, required = true,
                                 default = nil)
  if valid_580429 != nil:
    section.add "editId", valid_580429
  var valid_580430 = path.getOrDefault("language")
  valid_580430 = validateParameter(valid_580430, JString, required = true,
                                 default = nil)
  if valid_580430 != nil:
    section.add "language", valid_580430
  var valid_580431 = path.getOrDefault("imageType")
  valid_580431 = validateParameter(valid_580431, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_580431 != nil:
    section.add "imageType", valid_580431
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
  var valid_580432 = query.getOrDefault("fields")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "fields", valid_580432
  var valid_580433 = query.getOrDefault("quotaUser")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "quotaUser", valid_580433
  var valid_580434 = query.getOrDefault("alt")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = newJString("json"))
  if valid_580434 != nil:
    section.add "alt", valid_580434
  var valid_580435 = query.getOrDefault("oauth_token")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "oauth_token", valid_580435
  var valid_580436 = query.getOrDefault("userIp")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "userIp", valid_580436
  var valid_580437 = query.getOrDefault("key")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "key", valid_580437
  var valid_580438 = query.getOrDefault("prettyPrint")
  valid_580438 = validateParameter(valid_580438, JBool, required = false,
                                 default = newJBool(true))
  if valid_580438 != nil:
    section.add "prettyPrint", valid_580438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580439: Call_AndroidpublisherEditsImagesDelete_580424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the image (specified by id) from the edit.
  ## 
  let valid = call_580439.validator(path, query, header, formData, body)
  let scheme = call_580439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580439.url(scheme.get, call_580439.host, call_580439.base,
                         call_580439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580439, url, valid)

proc call*(call_580440: Call_AndroidpublisherEditsImagesDelete_580424;
          imageId: string; packageName: string; editId: string; language: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = "";
          imageType: string = "featureGraphic"; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsImagesDelete
  ## Deletes the image (specified by id) from the edit.
  ##   imageId: string (required)
  ##          : Unique identifier an image within the set of images attached to this edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   language: string (required)
  ##           : The language code (a BCP-47 language tag) of the localized listing whose images are to read or modified. For example, to select Austrian German, pass "de-AT".
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   imageType: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580441 = newJObject()
  var query_580442 = newJObject()
  add(path_580441, "imageId", newJString(imageId))
  add(query_580442, "fields", newJString(fields))
  add(path_580441, "packageName", newJString(packageName))
  add(query_580442, "quotaUser", newJString(quotaUser))
  add(query_580442, "alt", newJString(alt))
  add(path_580441, "editId", newJString(editId))
  add(query_580442, "oauth_token", newJString(oauthToken))
  add(path_580441, "language", newJString(language))
  add(query_580442, "userIp", newJString(userIp))
  add(path_580441, "imageType", newJString(imageType))
  add(query_580442, "key", newJString(key))
  add(query_580442, "prettyPrint", newJBool(prettyPrint))
  result = call_580440.call(path_580441, query_580442, nil, nil, nil)

var androidpublisherEditsImagesDelete* = Call_AndroidpublisherEditsImagesDelete_580424(
    name: "androidpublisherEditsImagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}/{imageId}",
    validator: validate_AndroidpublisherEditsImagesDelete_580425,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesDelete_580426, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersUpdate_580460 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTestersUpdate_580462(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersUpdate_580461(path: JsonNode;
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
  var valid_580463 = path.getOrDefault("packageName")
  valid_580463 = validateParameter(valid_580463, JString, required = true,
                                 default = nil)
  if valid_580463 != nil:
    section.add "packageName", valid_580463
  var valid_580464 = path.getOrDefault("editId")
  valid_580464 = validateParameter(valid_580464, JString, required = true,
                                 default = nil)
  if valid_580464 != nil:
    section.add "editId", valid_580464
  var valid_580465 = path.getOrDefault("track")
  valid_580465 = validateParameter(valid_580465, JString, required = true,
                                 default = nil)
  if valid_580465 != nil:
    section.add "track", valid_580465
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

proc call*(call_580474: Call_AndroidpublisherEditsTestersUpdate_580460;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_580474.validator(path, query, header, formData, body)
  let scheme = call_580474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580474.url(scheme.get, call_580474.host, call_580474.base,
                         call_580474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580474, url, valid)

proc call*(call_580475: Call_AndroidpublisherEditsTestersUpdate_580460;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTestersUpdate
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_580476 = newJObject()
  var query_580477 = newJObject()
  var body_580478 = newJObject()
  add(query_580477, "fields", newJString(fields))
  add(path_580476, "packageName", newJString(packageName))
  add(query_580477, "quotaUser", newJString(quotaUser))
  add(query_580477, "alt", newJString(alt))
  add(path_580476, "editId", newJString(editId))
  add(query_580477, "oauth_token", newJString(oauthToken))
  add(query_580477, "userIp", newJString(userIp))
  add(query_580477, "key", newJString(key))
  if body != nil:
    body_580478 = body
  add(query_580477, "prettyPrint", newJBool(prettyPrint))
  add(path_580476, "track", newJString(track))
  result = call_580475.call(path_580476, query_580477, nil, nil, body_580478)

var androidpublisherEditsTestersUpdate* = Call_AndroidpublisherEditsTestersUpdate_580460(
    name: "androidpublisherEditsTestersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersUpdate_580461,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersUpdate_580462, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersGet_580443 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTestersGet_580445(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersGet_580444(path: JsonNode;
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
  var valid_580446 = path.getOrDefault("packageName")
  valid_580446 = validateParameter(valid_580446, JString, required = true,
                                 default = nil)
  if valid_580446 != nil:
    section.add "packageName", valid_580446
  var valid_580447 = path.getOrDefault("editId")
  valid_580447 = validateParameter(valid_580447, JString, required = true,
                                 default = nil)
  if valid_580447 != nil:
    section.add "editId", valid_580447
  var valid_580448 = path.getOrDefault("track")
  valid_580448 = validateParameter(valid_580448, JString, required = true,
                                 default = nil)
  if valid_580448 != nil:
    section.add "track", valid_580448
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
  var valid_580455 = query.getOrDefault("prettyPrint")
  valid_580455 = validateParameter(valid_580455, JBool, required = false,
                                 default = newJBool(true))
  if valid_580455 != nil:
    section.add "prettyPrint", valid_580455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580456: Call_AndroidpublisherEditsTestersGet_580443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_580456.validator(path, query, header, formData, body)
  let scheme = call_580456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580456.url(scheme.get, call_580456.host, call_580456.base,
                         call_580456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580456, url, valid)

proc call*(call_580457: Call_AndroidpublisherEditsTestersGet_580443;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTestersGet
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_580458 = newJObject()
  var query_580459 = newJObject()
  add(query_580459, "fields", newJString(fields))
  add(path_580458, "packageName", newJString(packageName))
  add(query_580459, "quotaUser", newJString(quotaUser))
  add(query_580459, "alt", newJString(alt))
  add(path_580458, "editId", newJString(editId))
  add(query_580459, "oauth_token", newJString(oauthToken))
  add(query_580459, "userIp", newJString(userIp))
  add(query_580459, "key", newJString(key))
  add(query_580459, "prettyPrint", newJBool(prettyPrint))
  add(path_580458, "track", newJString(track))
  result = call_580457.call(path_580458, query_580459, nil, nil, nil)

var androidpublisherEditsTestersGet* = Call_AndroidpublisherEditsTestersGet_580443(
    name: "androidpublisherEditsTestersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersGet_580444,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersGet_580445, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersPatch_580479 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTestersPatch_580481(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersPatch_580480(path: JsonNode;
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
  var valid_580482 = path.getOrDefault("packageName")
  valid_580482 = validateParameter(valid_580482, JString, required = true,
                                 default = nil)
  if valid_580482 != nil:
    section.add "packageName", valid_580482
  var valid_580483 = path.getOrDefault("editId")
  valid_580483 = validateParameter(valid_580483, JString, required = true,
                                 default = nil)
  if valid_580483 != nil:
    section.add "editId", valid_580483
  var valid_580484 = path.getOrDefault("track")
  valid_580484 = validateParameter(valid_580484, JString, required = true,
                                 default = nil)
  if valid_580484 != nil:
    section.add "track", valid_580484
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
  var valid_580485 = query.getOrDefault("fields")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "fields", valid_580485
  var valid_580486 = query.getOrDefault("quotaUser")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "quotaUser", valid_580486
  var valid_580487 = query.getOrDefault("alt")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = newJString("json"))
  if valid_580487 != nil:
    section.add "alt", valid_580487
  var valid_580488 = query.getOrDefault("oauth_token")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "oauth_token", valid_580488
  var valid_580489 = query.getOrDefault("userIp")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "userIp", valid_580489
  var valid_580490 = query.getOrDefault("key")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "key", valid_580490
  var valid_580491 = query.getOrDefault("prettyPrint")
  valid_580491 = validateParameter(valid_580491, JBool, required = false,
                                 default = newJBool(true))
  if valid_580491 != nil:
    section.add "prettyPrint", valid_580491
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

proc call*(call_580493: Call_AndroidpublisherEditsTestersPatch_580479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_580493.validator(path, query, header, formData, body)
  let scheme = call_580493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580493.url(scheme.get, call_580493.host, call_580493.base,
                         call_580493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580493, url, valid)

proc call*(call_580494: Call_AndroidpublisherEditsTestersPatch_580479;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTestersPatch
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_580495 = newJObject()
  var query_580496 = newJObject()
  var body_580497 = newJObject()
  add(query_580496, "fields", newJString(fields))
  add(path_580495, "packageName", newJString(packageName))
  add(query_580496, "quotaUser", newJString(quotaUser))
  add(query_580496, "alt", newJString(alt))
  add(path_580495, "editId", newJString(editId))
  add(query_580496, "oauth_token", newJString(oauthToken))
  add(query_580496, "userIp", newJString(userIp))
  add(query_580496, "key", newJString(key))
  if body != nil:
    body_580497 = body
  add(query_580496, "prettyPrint", newJBool(prettyPrint))
  add(path_580495, "track", newJString(track))
  result = call_580494.call(path_580495, query_580496, nil, nil, body_580497)

var androidpublisherEditsTestersPatch* = Call_AndroidpublisherEditsTestersPatch_580479(
    name: "androidpublisherEditsTestersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersPatch_580480,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersPatch_580481, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksList_580498 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTracksList_580500(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksList_580499(path: JsonNode;
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
  var valid_580501 = path.getOrDefault("packageName")
  valid_580501 = validateParameter(valid_580501, JString, required = true,
                                 default = nil)
  if valid_580501 != nil:
    section.add "packageName", valid_580501
  var valid_580502 = path.getOrDefault("editId")
  valid_580502 = validateParameter(valid_580502, JString, required = true,
                                 default = nil)
  if valid_580502 != nil:
    section.add "editId", valid_580502
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
  var valid_580503 = query.getOrDefault("fields")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "fields", valid_580503
  var valid_580504 = query.getOrDefault("quotaUser")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "quotaUser", valid_580504
  var valid_580505 = query.getOrDefault("alt")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = newJString("json"))
  if valid_580505 != nil:
    section.add "alt", valid_580505
  var valid_580506 = query.getOrDefault("oauth_token")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "oauth_token", valid_580506
  var valid_580507 = query.getOrDefault("userIp")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "userIp", valid_580507
  var valid_580508 = query.getOrDefault("key")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "key", valid_580508
  var valid_580509 = query.getOrDefault("prettyPrint")
  valid_580509 = validateParameter(valid_580509, JBool, required = false,
                                 default = newJBool(true))
  if valid_580509 != nil:
    section.add "prettyPrint", valid_580509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580510: Call_AndroidpublisherEditsTracksList_580498;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the track configurations for this edit.
  ## 
  let valid = call_580510.validator(path, query, header, formData, body)
  let scheme = call_580510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580510.url(scheme.get, call_580510.host, call_580510.base,
                         call_580510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580510, url, valid)

proc call*(call_580511: Call_AndroidpublisherEditsTracksList_580498;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTracksList
  ## Lists all the track configurations for this edit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580512 = newJObject()
  var query_580513 = newJObject()
  add(query_580513, "fields", newJString(fields))
  add(path_580512, "packageName", newJString(packageName))
  add(query_580513, "quotaUser", newJString(quotaUser))
  add(query_580513, "alt", newJString(alt))
  add(path_580512, "editId", newJString(editId))
  add(query_580513, "oauth_token", newJString(oauthToken))
  add(query_580513, "userIp", newJString(userIp))
  add(query_580513, "key", newJString(key))
  add(query_580513, "prettyPrint", newJBool(prettyPrint))
  result = call_580511.call(path_580512, query_580513, nil, nil, nil)

var androidpublisherEditsTracksList* = Call_AndroidpublisherEditsTracksList_580498(
    name: "androidpublisherEditsTracksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/tracks",
    validator: validate_AndroidpublisherEditsTracksList_580499,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksList_580500, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksUpdate_580531 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTracksUpdate_580533(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksUpdate_580532(path: JsonNode;
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
  var valid_580534 = path.getOrDefault("packageName")
  valid_580534 = validateParameter(valid_580534, JString, required = true,
                                 default = nil)
  if valid_580534 != nil:
    section.add "packageName", valid_580534
  var valid_580535 = path.getOrDefault("editId")
  valid_580535 = validateParameter(valid_580535, JString, required = true,
                                 default = nil)
  if valid_580535 != nil:
    section.add "editId", valid_580535
  var valid_580536 = path.getOrDefault("track")
  valid_580536 = validateParameter(valid_580536, JString, required = true,
                                 default = nil)
  if valid_580536 != nil:
    section.add "track", valid_580536
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

proc call*(call_580545: Call_AndroidpublisherEditsTracksUpdate_580531;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type.
  ## 
  let valid = call_580545.validator(path, query, header, formData, body)
  let scheme = call_580545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580545.url(scheme.get, call_580545.host, call_580545.base,
                         call_580545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580545, url, valid)

proc call*(call_580546: Call_AndroidpublisherEditsTracksUpdate_580531;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTracksUpdate
  ## Updates the track configuration for the specified track type.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_580547 = newJObject()
  var query_580548 = newJObject()
  var body_580549 = newJObject()
  add(query_580548, "fields", newJString(fields))
  add(path_580547, "packageName", newJString(packageName))
  add(query_580548, "quotaUser", newJString(quotaUser))
  add(query_580548, "alt", newJString(alt))
  add(path_580547, "editId", newJString(editId))
  add(query_580548, "oauth_token", newJString(oauthToken))
  add(query_580548, "userIp", newJString(userIp))
  add(query_580548, "key", newJString(key))
  if body != nil:
    body_580549 = body
  add(query_580548, "prettyPrint", newJBool(prettyPrint))
  add(path_580547, "track", newJString(track))
  result = call_580546.call(path_580547, query_580548, nil, nil, body_580549)

var androidpublisherEditsTracksUpdate* = Call_AndroidpublisherEditsTracksUpdate_580531(
    name: "androidpublisherEditsTracksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksUpdate_580532,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksUpdate_580533, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksGet_580514 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTracksGet_580516(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksGet_580515(path: JsonNode;
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
  var valid_580517 = path.getOrDefault("packageName")
  valid_580517 = validateParameter(valid_580517, JString, required = true,
                                 default = nil)
  if valid_580517 != nil:
    section.add "packageName", valid_580517
  var valid_580518 = path.getOrDefault("editId")
  valid_580518 = validateParameter(valid_580518, JString, required = true,
                                 default = nil)
  if valid_580518 != nil:
    section.add "editId", valid_580518
  var valid_580519 = path.getOrDefault("track")
  valid_580519 = validateParameter(valid_580519, JString, required = true,
                                 default = nil)
  if valid_580519 != nil:
    section.add "track", valid_580519
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
  var valid_580520 = query.getOrDefault("fields")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "fields", valid_580520
  var valid_580521 = query.getOrDefault("quotaUser")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "quotaUser", valid_580521
  var valid_580522 = query.getOrDefault("alt")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = newJString("json"))
  if valid_580522 != nil:
    section.add "alt", valid_580522
  var valid_580523 = query.getOrDefault("oauth_token")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "oauth_token", valid_580523
  var valid_580524 = query.getOrDefault("userIp")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "userIp", valid_580524
  var valid_580525 = query.getOrDefault("key")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "key", valid_580525
  var valid_580526 = query.getOrDefault("prettyPrint")
  valid_580526 = validateParameter(valid_580526, JBool, required = false,
                                 default = newJBool(true))
  if valid_580526 != nil:
    section.add "prettyPrint", valid_580526
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580527: Call_AndroidpublisherEditsTracksGet_580514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ## 
  let valid = call_580527.validator(path, query, header, formData, body)
  let scheme = call_580527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580527.url(scheme.get, call_580527.host, call_580527.base,
                         call_580527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580527, url, valid)

proc call*(call_580528: Call_AndroidpublisherEditsTracksGet_580514;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTracksGet
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_580529 = newJObject()
  var query_580530 = newJObject()
  add(query_580530, "fields", newJString(fields))
  add(path_580529, "packageName", newJString(packageName))
  add(query_580530, "quotaUser", newJString(quotaUser))
  add(query_580530, "alt", newJString(alt))
  add(path_580529, "editId", newJString(editId))
  add(query_580530, "oauth_token", newJString(oauthToken))
  add(query_580530, "userIp", newJString(userIp))
  add(query_580530, "key", newJString(key))
  add(query_580530, "prettyPrint", newJBool(prettyPrint))
  add(path_580529, "track", newJString(track))
  result = call_580528.call(path_580529, query_580530, nil, nil, nil)

var androidpublisherEditsTracksGet* = Call_AndroidpublisherEditsTracksGet_580514(
    name: "androidpublisherEditsTracksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksGet_580515,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksGet_580516, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksPatch_580550 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsTracksPatch_580552(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksPatch_580551(path: JsonNode;
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
  var valid_580553 = path.getOrDefault("packageName")
  valid_580553 = validateParameter(valid_580553, JString, required = true,
                                 default = nil)
  if valid_580553 != nil:
    section.add "packageName", valid_580553
  var valid_580554 = path.getOrDefault("editId")
  valid_580554 = validateParameter(valid_580554, JString, required = true,
                                 default = nil)
  if valid_580554 != nil:
    section.add "editId", valid_580554
  var valid_580555 = path.getOrDefault("track")
  valid_580555 = validateParameter(valid_580555, JString, required = true,
                                 default = nil)
  if valid_580555 != nil:
    section.add "track", valid_580555
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
  var valid_580562 = query.getOrDefault("prettyPrint")
  valid_580562 = validateParameter(valid_580562, JBool, required = false,
                                 default = newJBool(true))
  if valid_580562 != nil:
    section.add "prettyPrint", valid_580562
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

proc call*(call_580564: Call_AndroidpublisherEditsTracksPatch_580550;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ## 
  let valid = call_580564.validator(path, query, header, formData, body)
  let scheme = call_580564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580564.url(scheme.get, call_580564.host, call_580564.base,
                         call_580564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580564, url, valid)

proc call*(call_580565: Call_AndroidpublisherEditsTracksPatch_580550;
          packageName: string; editId: string; track: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsTracksPatch
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   track: string (required)
  ##        : The track to read or modify.
  var path_580566 = newJObject()
  var query_580567 = newJObject()
  var body_580568 = newJObject()
  add(query_580567, "fields", newJString(fields))
  add(path_580566, "packageName", newJString(packageName))
  add(query_580567, "quotaUser", newJString(quotaUser))
  add(query_580567, "alt", newJString(alt))
  add(path_580566, "editId", newJString(editId))
  add(query_580567, "oauth_token", newJString(oauthToken))
  add(query_580567, "userIp", newJString(userIp))
  add(query_580567, "key", newJString(key))
  if body != nil:
    body_580568 = body
  add(query_580567, "prettyPrint", newJBool(prettyPrint))
  add(path_580566, "track", newJString(track))
  result = call_580565.call(path_580566, query_580567, nil, nil, body_580568)

var androidpublisherEditsTracksPatch* = Call_AndroidpublisherEditsTracksPatch_580550(
    name: "androidpublisherEditsTracksPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksPatch_580551,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksPatch_580552, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsCommit_580569 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsCommit_580571(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsCommit_580570(path: JsonNode; query: JsonNode;
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
  var valid_580572 = path.getOrDefault("packageName")
  valid_580572 = validateParameter(valid_580572, JString, required = true,
                                 default = nil)
  if valid_580572 != nil:
    section.add "packageName", valid_580572
  var valid_580573 = path.getOrDefault("editId")
  valid_580573 = validateParameter(valid_580573, JString, required = true,
                                 default = nil)
  if valid_580573 != nil:
    section.add "editId", valid_580573
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
  if body != nil:
    result.add "body", body

proc call*(call_580581: Call_AndroidpublisherEditsCommit_580569; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commits/applies the changes made in this edit back to the app.
  ## 
  let valid = call_580581.validator(path, query, header, formData, body)
  let scheme = call_580581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580581.url(scheme.get, call_580581.host, call_580581.base,
                         call_580581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580581, url, valid)

proc call*(call_580582: Call_AndroidpublisherEditsCommit_580569;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsCommit
  ## Commits/applies the changes made in this edit back to the app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580583 = newJObject()
  var query_580584 = newJObject()
  add(query_580584, "fields", newJString(fields))
  add(path_580583, "packageName", newJString(packageName))
  add(query_580584, "quotaUser", newJString(quotaUser))
  add(query_580584, "alt", newJString(alt))
  add(path_580583, "editId", newJString(editId))
  add(query_580584, "oauth_token", newJString(oauthToken))
  add(query_580584, "userIp", newJString(userIp))
  add(query_580584, "key", newJString(key))
  add(query_580584, "prettyPrint", newJBool(prettyPrint))
  result = call_580582.call(path_580583, query_580584, nil, nil, nil)

var androidpublisherEditsCommit* = Call_AndroidpublisherEditsCommit_580569(
    name: "androidpublisherEditsCommit", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:commit",
    validator: validate_AndroidpublisherEditsCommit_580570,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsCommit_580571, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsValidate_580585 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherEditsValidate_580587(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsValidate_580586(path: JsonNode; query: JsonNode;
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
  var valid_580588 = path.getOrDefault("packageName")
  valid_580588 = validateParameter(valid_580588, JString, required = true,
                                 default = nil)
  if valid_580588 != nil:
    section.add "packageName", valid_580588
  var valid_580589 = path.getOrDefault("editId")
  valid_580589 = validateParameter(valid_580589, JString, required = true,
                                 default = nil)
  if valid_580589 != nil:
    section.add "editId", valid_580589
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
  var valid_580590 = query.getOrDefault("fields")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "fields", valid_580590
  var valid_580591 = query.getOrDefault("quotaUser")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "quotaUser", valid_580591
  var valid_580592 = query.getOrDefault("alt")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = newJString("json"))
  if valid_580592 != nil:
    section.add "alt", valid_580592
  var valid_580593 = query.getOrDefault("oauth_token")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "oauth_token", valid_580593
  var valid_580594 = query.getOrDefault("userIp")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "userIp", valid_580594
  var valid_580595 = query.getOrDefault("key")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "key", valid_580595
  var valid_580596 = query.getOrDefault("prettyPrint")
  valid_580596 = validateParameter(valid_580596, JBool, required = false,
                                 default = newJBool(true))
  if valid_580596 != nil:
    section.add "prettyPrint", valid_580596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580597: Call_AndroidpublisherEditsValidate_580585; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ## 
  let valid = call_580597.validator(path, query, header, formData, body)
  let scheme = call_580597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580597.url(scheme.get, call_580597.host, call_580597.base,
                         call_580597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580597, url, valid)

proc call*(call_580598: Call_AndroidpublisherEditsValidate_580585;
          packageName: string; editId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherEditsValidate
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   editId: string (required)
  ##         : Unique identifier for this edit.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580599 = newJObject()
  var query_580600 = newJObject()
  add(query_580600, "fields", newJString(fields))
  add(path_580599, "packageName", newJString(packageName))
  add(query_580600, "quotaUser", newJString(quotaUser))
  add(query_580600, "alt", newJString(alt))
  add(path_580599, "editId", newJString(editId))
  add(query_580600, "oauth_token", newJString(oauthToken))
  add(query_580600, "userIp", newJString(userIp))
  add(query_580600, "key", newJString(key))
  add(query_580600, "prettyPrint", newJBool(prettyPrint))
  result = call_580598.call(path_580599, query_580600, nil, nil, nil)

var androidpublisherEditsValidate* = Call_AndroidpublisherEditsValidate_580585(
    name: "androidpublisherEditsValidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:validate",
    validator: validate_AndroidpublisherEditsValidate_580586,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsValidate_580587, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsInsert_580619 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsInsert_580621(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsInsert_580620(path: JsonNode;
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
  var valid_580622 = path.getOrDefault("packageName")
  valid_580622 = validateParameter(valid_580622, JString, required = true,
                                 default = nil)
  if valid_580622 != nil:
    section.add "packageName", valid_580622
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
  ##   autoConvertMissingPrices: JBool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580623 = query.getOrDefault("fields")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = nil)
  if valid_580623 != nil:
    section.add "fields", valid_580623
  var valid_580624 = query.getOrDefault("quotaUser")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "quotaUser", valid_580624
  var valid_580625 = query.getOrDefault("alt")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = newJString("json"))
  if valid_580625 != nil:
    section.add "alt", valid_580625
  var valid_580626 = query.getOrDefault("oauth_token")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "oauth_token", valid_580626
  var valid_580627 = query.getOrDefault("userIp")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "userIp", valid_580627
  var valid_580628 = query.getOrDefault("key")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "key", valid_580628
  var valid_580629 = query.getOrDefault("autoConvertMissingPrices")
  valid_580629 = validateParameter(valid_580629, JBool, required = false, default = nil)
  if valid_580629 != nil:
    section.add "autoConvertMissingPrices", valid_580629
  var valid_580630 = query.getOrDefault("prettyPrint")
  valid_580630 = validateParameter(valid_580630, JBool, required = false,
                                 default = newJBool(true))
  if valid_580630 != nil:
    section.add "prettyPrint", valid_580630
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

proc call*(call_580632: Call_AndroidpublisherInappproductsInsert_580619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new in-app product for an app.
  ## 
  let valid = call_580632.validator(path, query, header, formData, body)
  let scheme = call_580632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580632.url(scheme.get, call_580632.host, call_580632.base,
                         call_580632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580632, url, valid)

proc call*(call_580633: Call_AndroidpublisherInappproductsInsert_580619;
          packageName: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; autoConvertMissingPrices: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherInappproductsInsert
  ## Creates a new in-app product for an app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app; for example, "com.spiffygame".
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
  ##   autoConvertMissingPrices: bool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580634 = newJObject()
  var query_580635 = newJObject()
  var body_580636 = newJObject()
  add(query_580635, "fields", newJString(fields))
  add(path_580634, "packageName", newJString(packageName))
  add(query_580635, "quotaUser", newJString(quotaUser))
  add(query_580635, "alt", newJString(alt))
  add(query_580635, "oauth_token", newJString(oauthToken))
  add(query_580635, "userIp", newJString(userIp))
  add(query_580635, "key", newJString(key))
  add(query_580635, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_580636 = body
  add(query_580635, "prettyPrint", newJBool(prettyPrint))
  result = call_580633.call(path_580634, query_580635, nil, nil, body_580636)

var androidpublisherInappproductsInsert* = Call_AndroidpublisherInappproductsInsert_580619(
    name: "androidpublisherInappproductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsInsert_580620,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsInsert_580621, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsList_580601 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsList_580603(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsList_580602(path: JsonNode;
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
  var valid_580604 = path.getOrDefault("packageName")
  valid_580604 = validateParameter(valid_580604, JString, required = true,
                                 default = nil)
  if valid_580604 != nil:
    section.add "packageName", valid_580604
  result.add "path", section
  ## parameters in `query` object:
  ##   token: JString
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
  ##   maxResults: JInt
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  section = newJObject()
  var valid_580605 = query.getOrDefault("token")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "token", valid_580605
  var valid_580606 = query.getOrDefault("fields")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "fields", valid_580606
  var valid_580607 = query.getOrDefault("quotaUser")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "quotaUser", valid_580607
  var valid_580608 = query.getOrDefault("alt")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = newJString("json"))
  if valid_580608 != nil:
    section.add "alt", valid_580608
  var valid_580609 = query.getOrDefault("oauth_token")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "oauth_token", valid_580609
  var valid_580610 = query.getOrDefault("userIp")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "userIp", valid_580610
  var valid_580611 = query.getOrDefault("maxResults")
  valid_580611 = validateParameter(valid_580611, JInt, required = false, default = nil)
  if valid_580611 != nil:
    section.add "maxResults", valid_580611
  var valid_580612 = query.getOrDefault("key")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "key", valid_580612
  var valid_580613 = query.getOrDefault("prettyPrint")
  valid_580613 = validateParameter(valid_580613, JBool, required = false,
                                 default = newJBool(true))
  if valid_580613 != nil:
    section.add "prettyPrint", valid_580613
  var valid_580614 = query.getOrDefault("startIndex")
  valid_580614 = validateParameter(valid_580614, JInt, required = false, default = nil)
  if valid_580614 != nil:
    section.add "startIndex", valid_580614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580615: Call_AndroidpublisherInappproductsList_580601;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ## 
  let valid = call_580615.validator(path, query, header, formData, body)
  let scheme = call_580615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580615.url(scheme.get, call_580615.host, call_580615.base,
                         call_580615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580615, url, valid)

proc call*(call_580616: Call_AndroidpublisherInappproductsList_580601;
          packageName: string; token: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## androidpublisherInappproductsList
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with in-app products; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  var path_580617 = newJObject()
  var query_580618 = newJObject()
  add(query_580618, "token", newJString(token))
  add(query_580618, "fields", newJString(fields))
  add(path_580617, "packageName", newJString(packageName))
  add(query_580618, "quotaUser", newJString(quotaUser))
  add(query_580618, "alt", newJString(alt))
  add(query_580618, "oauth_token", newJString(oauthToken))
  add(query_580618, "userIp", newJString(userIp))
  add(query_580618, "maxResults", newJInt(maxResults))
  add(query_580618, "key", newJString(key))
  add(query_580618, "prettyPrint", newJBool(prettyPrint))
  add(query_580618, "startIndex", newJInt(startIndex))
  result = call_580616.call(path_580617, query_580618, nil, nil, nil)

var androidpublisherInappproductsList* = Call_AndroidpublisherInappproductsList_580601(
    name: "androidpublisherInappproductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsList_580602,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsList_580603, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsUpdate_580653 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsUpdate_580655(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsUpdate_580654(path: JsonNode;
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
  var valid_580656 = path.getOrDefault("packageName")
  valid_580656 = validateParameter(valid_580656, JString, required = true,
                                 default = nil)
  if valid_580656 != nil:
    section.add "packageName", valid_580656
  var valid_580657 = path.getOrDefault("sku")
  valid_580657 = validateParameter(valid_580657, JString, required = true,
                                 default = nil)
  if valid_580657 != nil:
    section.add "sku", valid_580657
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
  ##   autoConvertMissingPrices: JBool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580658 = query.getOrDefault("fields")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = nil)
  if valid_580658 != nil:
    section.add "fields", valid_580658
  var valid_580659 = query.getOrDefault("quotaUser")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "quotaUser", valid_580659
  var valid_580660 = query.getOrDefault("alt")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = newJString("json"))
  if valid_580660 != nil:
    section.add "alt", valid_580660
  var valid_580661 = query.getOrDefault("oauth_token")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "oauth_token", valid_580661
  var valid_580662 = query.getOrDefault("userIp")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "userIp", valid_580662
  var valid_580663 = query.getOrDefault("key")
  valid_580663 = validateParameter(valid_580663, JString, required = false,
                                 default = nil)
  if valid_580663 != nil:
    section.add "key", valid_580663
  var valid_580664 = query.getOrDefault("autoConvertMissingPrices")
  valid_580664 = validateParameter(valid_580664, JBool, required = false, default = nil)
  if valid_580664 != nil:
    section.add "autoConvertMissingPrices", valid_580664
  var valid_580665 = query.getOrDefault("prettyPrint")
  valid_580665 = validateParameter(valid_580665, JBool, required = false,
                                 default = newJBool(true))
  if valid_580665 != nil:
    section.add "prettyPrint", valid_580665
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

proc call*(call_580667: Call_AndroidpublisherInappproductsUpdate_580653;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product.
  ## 
  let valid = call_580667.validator(path, query, header, formData, body)
  let scheme = call_580667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580667.url(scheme.get, call_580667.host, call_580667.base,
                         call_580667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580667, url, valid)

proc call*(call_580668: Call_AndroidpublisherInappproductsUpdate_580653;
          packageName: string; sku: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; autoConvertMissingPrices: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherInappproductsUpdate
  ## Updates the details of an in-app product.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   autoConvertMissingPrices: bool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580669 = newJObject()
  var query_580670 = newJObject()
  var body_580671 = newJObject()
  add(query_580670, "fields", newJString(fields))
  add(path_580669, "packageName", newJString(packageName))
  add(query_580670, "quotaUser", newJString(quotaUser))
  add(query_580670, "alt", newJString(alt))
  add(query_580670, "oauth_token", newJString(oauthToken))
  add(query_580670, "userIp", newJString(userIp))
  add(path_580669, "sku", newJString(sku))
  add(query_580670, "key", newJString(key))
  add(query_580670, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_580671 = body
  add(query_580670, "prettyPrint", newJBool(prettyPrint))
  result = call_580668.call(path_580669, query_580670, nil, nil, body_580671)

var androidpublisherInappproductsUpdate* = Call_AndroidpublisherInappproductsUpdate_580653(
    name: "androidpublisherInappproductsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsUpdate_580654,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsUpdate_580655, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsGet_580637 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsGet_580639(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsGet_580638(path: JsonNode;
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
  var valid_580640 = path.getOrDefault("packageName")
  valid_580640 = validateParameter(valid_580640, JString, required = true,
                                 default = nil)
  if valid_580640 != nil:
    section.add "packageName", valid_580640
  var valid_580641 = path.getOrDefault("sku")
  valid_580641 = validateParameter(valid_580641, JString, required = true,
                                 default = nil)
  if valid_580641 != nil:
    section.add "sku", valid_580641
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
  var valid_580642 = query.getOrDefault("fields")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "fields", valid_580642
  var valid_580643 = query.getOrDefault("quotaUser")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "quotaUser", valid_580643
  var valid_580644 = query.getOrDefault("alt")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = newJString("json"))
  if valid_580644 != nil:
    section.add "alt", valid_580644
  var valid_580645 = query.getOrDefault("oauth_token")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "oauth_token", valid_580645
  var valid_580646 = query.getOrDefault("userIp")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "userIp", valid_580646
  var valid_580647 = query.getOrDefault("key")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "key", valid_580647
  var valid_580648 = query.getOrDefault("prettyPrint")
  valid_580648 = validateParameter(valid_580648, JBool, required = false,
                                 default = newJBool(true))
  if valid_580648 != nil:
    section.add "prettyPrint", valid_580648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580649: Call_AndroidpublisherInappproductsGet_580637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the in-app product specified.
  ## 
  let valid = call_580649.validator(path, query, header, formData, body)
  let scheme = call_580649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580649.url(scheme.get, call_580649.host, call_580649.base,
                         call_580649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580649, url, valid)

proc call*(call_580650: Call_AndroidpublisherInappproductsGet_580637;
          packageName: string; sku: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherInappproductsGet
  ## Returns information about the in-app product specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580651 = newJObject()
  var query_580652 = newJObject()
  add(query_580652, "fields", newJString(fields))
  add(path_580651, "packageName", newJString(packageName))
  add(query_580652, "quotaUser", newJString(quotaUser))
  add(query_580652, "alt", newJString(alt))
  add(query_580652, "oauth_token", newJString(oauthToken))
  add(query_580652, "userIp", newJString(userIp))
  add(path_580651, "sku", newJString(sku))
  add(query_580652, "key", newJString(key))
  add(query_580652, "prettyPrint", newJBool(prettyPrint))
  result = call_580650.call(path_580651, query_580652, nil, nil, nil)

var androidpublisherInappproductsGet* = Call_AndroidpublisherInappproductsGet_580637(
    name: "androidpublisherInappproductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsGet_580638,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsGet_580639, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsPatch_580688 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsPatch_580690(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsPatch_580689(path: JsonNode;
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
  var valid_580691 = path.getOrDefault("packageName")
  valid_580691 = validateParameter(valid_580691, JString, required = true,
                                 default = nil)
  if valid_580691 != nil:
    section.add "packageName", valid_580691
  var valid_580692 = path.getOrDefault("sku")
  valid_580692 = validateParameter(valid_580692, JString, required = true,
                                 default = nil)
  if valid_580692 != nil:
    section.add "sku", valid_580692
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
  ##   autoConvertMissingPrices: JBool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580693 = query.getOrDefault("fields")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = nil)
  if valid_580693 != nil:
    section.add "fields", valid_580693
  var valid_580694 = query.getOrDefault("quotaUser")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "quotaUser", valid_580694
  var valid_580695 = query.getOrDefault("alt")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = newJString("json"))
  if valid_580695 != nil:
    section.add "alt", valid_580695
  var valid_580696 = query.getOrDefault("oauth_token")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "oauth_token", valid_580696
  var valid_580697 = query.getOrDefault("userIp")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "userIp", valid_580697
  var valid_580698 = query.getOrDefault("key")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "key", valid_580698
  var valid_580699 = query.getOrDefault("autoConvertMissingPrices")
  valid_580699 = validateParameter(valid_580699, JBool, required = false, default = nil)
  if valid_580699 != nil:
    section.add "autoConvertMissingPrices", valid_580699
  var valid_580700 = query.getOrDefault("prettyPrint")
  valid_580700 = validateParameter(valid_580700, JBool, required = false,
                                 default = newJBool(true))
  if valid_580700 != nil:
    section.add "prettyPrint", valid_580700
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

proc call*(call_580702: Call_AndroidpublisherInappproductsPatch_580688;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product. This method supports patch semantics.
  ## 
  let valid = call_580702.validator(path, query, header, formData, body)
  let scheme = call_580702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580702.url(scheme.get, call_580702.host, call_580702.base,
                         call_580702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580702, url, valid)

proc call*(call_580703: Call_AndroidpublisherInappproductsPatch_580688;
          packageName: string; sku: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; autoConvertMissingPrices: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherInappproductsPatch
  ## Updates the details of an in-app product. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   autoConvertMissingPrices: bool
  ##                           : If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the default price. Defaults to false.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580704 = newJObject()
  var query_580705 = newJObject()
  var body_580706 = newJObject()
  add(query_580705, "fields", newJString(fields))
  add(path_580704, "packageName", newJString(packageName))
  add(query_580705, "quotaUser", newJString(quotaUser))
  add(query_580705, "alt", newJString(alt))
  add(query_580705, "oauth_token", newJString(oauthToken))
  add(query_580705, "userIp", newJString(userIp))
  add(path_580704, "sku", newJString(sku))
  add(query_580705, "key", newJString(key))
  add(query_580705, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_580706 = body
  add(query_580705, "prettyPrint", newJBool(prettyPrint))
  result = call_580703.call(path_580704, query_580705, nil, nil, body_580706)

var androidpublisherInappproductsPatch* = Call_AndroidpublisherInappproductsPatch_580688(
    name: "androidpublisherInappproductsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsPatch_580689,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsPatch_580690, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsDelete_580672 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherInappproductsDelete_580674(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsDelete_580673(path: JsonNode;
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
  var valid_580675 = path.getOrDefault("packageName")
  valid_580675 = validateParameter(valid_580675, JString, required = true,
                                 default = nil)
  if valid_580675 != nil:
    section.add "packageName", valid_580675
  var valid_580676 = path.getOrDefault("sku")
  valid_580676 = validateParameter(valid_580676, JString, required = true,
                                 default = nil)
  if valid_580676 != nil:
    section.add "sku", valid_580676
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
  var valid_580677 = query.getOrDefault("fields")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "fields", valid_580677
  var valid_580678 = query.getOrDefault("quotaUser")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "quotaUser", valid_580678
  var valid_580679 = query.getOrDefault("alt")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = newJString("json"))
  if valid_580679 != nil:
    section.add "alt", valid_580679
  var valid_580680 = query.getOrDefault("oauth_token")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "oauth_token", valid_580680
  var valid_580681 = query.getOrDefault("userIp")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = nil)
  if valid_580681 != nil:
    section.add "userIp", valid_580681
  var valid_580682 = query.getOrDefault("key")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = nil)
  if valid_580682 != nil:
    section.add "key", valid_580682
  var valid_580683 = query.getOrDefault("prettyPrint")
  valid_580683 = validateParameter(valid_580683, JBool, required = false,
                                 default = newJBool(true))
  if valid_580683 != nil:
    section.add "prettyPrint", valid_580683
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580684: Call_AndroidpublisherInappproductsDelete_580672;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an in-app product for an app.
  ## 
  let valid = call_580684.validator(path, query, header, formData, body)
  let scheme = call_580684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580684.url(scheme.get, call_580684.host, call_580684.base,
                         call_580684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580684, url, valid)

proc call*(call_580685: Call_AndroidpublisherInappproductsDelete_580672;
          packageName: string; sku: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherInappproductsDelete
  ## Delete an in-app product for an app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app with the in-app product; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sku: string (required)
  ##      : Unique identifier for the in-app product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580686 = newJObject()
  var query_580687 = newJObject()
  add(query_580687, "fields", newJString(fields))
  add(path_580686, "packageName", newJString(packageName))
  add(query_580687, "quotaUser", newJString(quotaUser))
  add(query_580687, "alt", newJString(alt))
  add(query_580687, "oauth_token", newJString(oauthToken))
  add(query_580687, "userIp", newJString(userIp))
  add(path_580686, "sku", newJString(sku))
  add(query_580687, "key", newJString(key))
  add(query_580687, "prettyPrint", newJBool(prettyPrint))
  result = call_580685.call(path_580686, query_580687, nil, nil, nil)

var androidpublisherInappproductsDelete* = Call_AndroidpublisherInappproductsDelete_580672(
    name: "androidpublisherInappproductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsDelete_580673,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsDelete_580674, schemes: {Scheme.Https})
type
  Call_AndroidpublisherOrdersRefund_580707 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherOrdersRefund_580709(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherOrdersRefund_580708(path: JsonNode; query: JsonNode;
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
  var valid_580710 = path.getOrDefault("packageName")
  valid_580710 = validateParameter(valid_580710, JString, required = true,
                                 default = nil)
  if valid_580710 != nil:
    section.add "packageName", valid_580710
  var valid_580711 = path.getOrDefault("orderId")
  valid_580711 = validateParameter(valid_580711, JString, required = true,
                                 default = nil)
  if valid_580711 != nil:
    section.add "orderId", valid_580711
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
  ##   revoke: JBool
  ##         : Whether to revoke the purchased item. If set to true, access to the subscription or in-app item will be terminated immediately. If the item is a recurring subscription, all future payments will also be terminated. Consumed in-app items need to be handled by developer's app. (optional)
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580712 = query.getOrDefault("fields")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "fields", valid_580712
  var valid_580713 = query.getOrDefault("quotaUser")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "quotaUser", valid_580713
  var valid_580714 = query.getOrDefault("alt")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = newJString("json"))
  if valid_580714 != nil:
    section.add "alt", valid_580714
  var valid_580715 = query.getOrDefault("oauth_token")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "oauth_token", valid_580715
  var valid_580716 = query.getOrDefault("userIp")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "userIp", valid_580716
  var valid_580717 = query.getOrDefault("key")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = nil)
  if valid_580717 != nil:
    section.add "key", valid_580717
  var valid_580718 = query.getOrDefault("revoke")
  valid_580718 = validateParameter(valid_580718, JBool, required = false, default = nil)
  if valid_580718 != nil:
    section.add "revoke", valid_580718
  var valid_580719 = query.getOrDefault("prettyPrint")
  valid_580719 = validateParameter(valid_580719, JBool, required = false,
                                 default = newJBool(true))
  if valid_580719 != nil:
    section.add "prettyPrint", valid_580719
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580720: Call_AndroidpublisherOrdersRefund_580707; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refund a user's subscription or in-app purchase order.
  ## 
  let valid = call_580720.validator(path, query, header, formData, body)
  let scheme = call_580720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580720.url(scheme.get, call_580720.host, call_580720.base,
                         call_580720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580720, url, valid)

proc call*(call_580721: Call_AndroidpublisherOrdersRefund_580707;
          packageName: string; orderId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; revoke: bool = false;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherOrdersRefund
  ## Refund a user's subscription or in-app purchase order.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription or in-app item was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   orderId: string (required)
  ##          : The order ID provided to the user when the subscription or in-app order was purchased.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   revoke: bool
  ##         : Whether to revoke the purchased item. If set to true, access to the subscription or in-app item will be terminated immediately. If the item is a recurring subscription, all future payments will also be terminated. Consumed in-app items need to be handled by developer's app. (optional)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580722 = newJObject()
  var query_580723 = newJObject()
  add(query_580723, "fields", newJString(fields))
  add(path_580722, "packageName", newJString(packageName))
  add(query_580723, "quotaUser", newJString(quotaUser))
  add(query_580723, "alt", newJString(alt))
  add(query_580723, "oauth_token", newJString(oauthToken))
  add(query_580723, "userIp", newJString(userIp))
  add(path_580722, "orderId", newJString(orderId))
  add(query_580723, "key", newJString(key))
  add(query_580723, "revoke", newJBool(revoke))
  add(query_580723, "prettyPrint", newJBool(prettyPrint))
  result = call_580721.call(path_580722, query_580723, nil, nil, nil)

var androidpublisherOrdersRefund* = Call_AndroidpublisherOrdersRefund_580707(
    name: "androidpublisherOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/orders/{orderId}:refund",
    validator: validate_AndroidpublisherOrdersRefund_580708,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherOrdersRefund_580709, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsGet_580724 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesProductsGet_580726(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesProductsGet_580725(path: JsonNode;
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
  var valid_580727 = path.getOrDefault("packageName")
  valid_580727 = validateParameter(valid_580727, JString, required = true,
                                 default = nil)
  if valid_580727 != nil:
    section.add "packageName", valid_580727
  var valid_580728 = path.getOrDefault("token")
  valid_580728 = validateParameter(valid_580728, JString, required = true,
                                 default = nil)
  if valid_580728 != nil:
    section.add "token", valid_580728
  var valid_580729 = path.getOrDefault("productId")
  valid_580729 = validateParameter(valid_580729, JString, required = true,
                                 default = nil)
  if valid_580729 != nil:
    section.add "productId", valid_580729
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
  var valid_580730 = query.getOrDefault("fields")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "fields", valid_580730
  var valid_580731 = query.getOrDefault("quotaUser")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "quotaUser", valid_580731
  var valid_580732 = query.getOrDefault("alt")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = newJString("json"))
  if valid_580732 != nil:
    section.add "alt", valid_580732
  var valid_580733 = query.getOrDefault("oauth_token")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "oauth_token", valid_580733
  var valid_580734 = query.getOrDefault("userIp")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "userIp", valid_580734
  var valid_580735 = query.getOrDefault("key")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "key", valid_580735
  var valid_580736 = query.getOrDefault("prettyPrint")
  valid_580736 = validateParameter(valid_580736, JBool, required = false,
                                 default = newJBool(true))
  if valid_580736 != nil:
    section.add "prettyPrint", valid_580736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580737: Call_AndroidpublisherPurchasesProductsGet_580724;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  let valid = call_580737.validator(path, query, header, formData, body)
  let scheme = call_580737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580737.url(scheme.get, call_580737.host, call_580737.base,
                         call_580737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580737, url, valid)

proc call*(call_580738: Call_AndroidpublisherPurchasesProductsGet_580724;
          packageName: string; token: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesProductsGet
  ## Checks the purchase and consumption status of an inapp item.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application the inapp product was sold in (for example, 'com.some.thing').
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
  ##   token: string (required)
  ##        : The token provided to the user's device when the inapp product was purchased.
  ##   productId: string (required)
  ##            : The inapp product SKU (for example, 'com.some.thing.inapp1').
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580739 = newJObject()
  var query_580740 = newJObject()
  add(query_580740, "fields", newJString(fields))
  add(path_580739, "packageName", newJString(packageName))
  add(query_580740, "quotaUser", newJString(quotaUser))
  add(query_580740, "alt", newJString(alt))
  add(query_580740, "oauth_token", newJString(oauthToken))
  add(query_580740, "userIp", newJString(userIp))
  add(query_580740, "key", newJString(key))
  add(path_580739, "token", newJString(token))
  add(path_580739, "productId", newJString(productId))
  add(query_580740, "prettyPrint", newJBool(prettyPrint))
  result = call_580738.call(path_580739, query_580740, nil, nil, nil)

var androidpublisherPurchasesProductsGet* = Call_AndroidpublisherPurchasesProductsGet_580724(
    name: "androidpublisherPurchasesProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/purchases/products/{productId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesProductsGet_580725,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesProductsGet_580726, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsAcknowledge_580741 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesProductsAcknowledge_580743(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesProductsAcknowledge_580742(path: JsonNode;
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
  var valid_580744 = path.getOrDefault("packageName")
  valid_580744 = validateParameter(valid_580744, JString, required = true,
                                 default = nil)
  if valid_580744 != nil:
    section.add "packageName", valid_580744
  var valid_580745 = path.getOrDefault("token")
  valid_580745 = validateParameter(valid_580745, JString, required = true,
                                 default = nil)
  if valid_580745 != nil:
    section.add "token", valid_580745
  var valid_580746 = path.getOrDefault("productId")
  valid_580746 = validateParameter(valid_580746, JString, required = true,
                                 default = nil)
  if valid_580746 != nil:
    section.add "productId", valid_580746
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
  var valid_580747 = query.getOrDefault("fields")
  valid_580747 = validateParameter(valid_580747, JString, required = false,
                                 default = nil)
  if valid_580747 != nil:
    section.add "fields", valid_580747
  var valid_580748 = query.getOrDefault("quotaUser")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = nil)
  if valid_580748 != nil:
    section.add "quotaUser", valid_580748
  var valid_580749 = query.getOrDefault("alt")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = newJString("json"))
  if valid_580749 != nil:
    section.add "alt", valid_580749
  var valid_580750 = query.getOrDefault("oauth_token")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = nil)
  if valid_580750 != nil:
    section.add "oauth_token", valid_580750
  var valid_580751 = query.getOrDefault("userIp")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "userIp", valid_580751
  var valid_580752 = query.getOrDefault("key")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "key", valid_580752
  var valid_580753 = query.getOrDefault("prettyPrint")
  valid_580753 = validateParameter(valid_580753, JBool, required = false,
                                 default = newJBool(true))
  if valid_580753 != nil:
    section.add "prettyPrint", valid_580753
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

proc call*(call_580755: Call_AndroidpublisherPurchasesProductsAcknowledge_580741;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges a purchase of an inapp item.
  ## 
  let valid = call_580755.validator(path, query, header, formData, body)
  let scheme = call_580755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580755.url(scheme.get, call_580755.host, call_580755.base,
                         call_580755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580755, url, valid)

proc call*(call_580756: Call_AndroidpublisherPurchasesProductsAcknowledge_580741;
          packageName: string; token: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesProductsAcknowledge
  ## Acknowledges a purchase of an inapp item.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application the inapp product was sold in (for example, 'com.some.thing').
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
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   productId: string (required)
  ##            : The inapp product SKU (for example, 'com.some.thing.inapp1').
  var path_580757 = newJObject()
  var query_580758 = newJObject()
  var body_580759 = newJObject()
  add(query_580758, "fields", newJString(fields))
  add(path_580757, "packageName", newJString(packageName))
  add(query_580758, "quotaUser", newJString(quotaUser))
  add(query_580758, "alt", newJString(alt))
  add(query_580758, "oauth_token", newJString(oauthToken))
  add(query_580758, "userIp", newJString(userIp))
  add(query_580758, "key", newJString(key))
  add(path_580757, "token", newJString(token))
  if body != nil:
    body_580759 = body
  add(query_580758, "prettyPrint", newJBool(prettyPrint))
  add(path_580757, "productId", newJString(productId))
  result = call_580756.call(path_580757, query_580758, nil, nil, body_580759)

var androidpublisherPurchasesProductsAcknowledge* = Call_AndroidpublisherPurchasesProductsAcknowledge_580741(
    name: "androidpublisherPurchasesProductsAcknowledge",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/products/{productId}/tokens/{token}:acknowledge",
    validator: validate_AndroidpublisherPurchasesProductsAcknowledge_580742,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesProductsAcknowledge_580743,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsGet_580760 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesSubscriptionsGet_580762(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsGet_580761(path: JsonNode;
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
  var valid_580763 = path.getOrDefault("packageName")
  valid_580763 = validateParameter(valid_580763, JString, required = true,
                                 default = nil)
  if valid_580763 != nil:
    section.add "packageName", valid_580763
  var valid_580764 = path.getOrDefault("subscriptionId")
  valid_580764 = validateParameter(valid_580764, JString, required = true,
                                 default = nil)
  if valid_580764 != nil:
    section.add "subscriptionId", valid_580764
  var valid_580765 = path.getOrDefault("token")
  valid_580765 = validateParameter(valid_580765, JString, required = true,
                                 default = nil)
  if valid_580765 != nil:
    section.add "token", valid_580765
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
  var valid_580766 = query.getOrDefault("fields")
  valid_580766 = validateParameter(valid_580766, JString, required = false,
                                 default = nil)
  if valid_580766 != nil:
    section.add "fields", valid_580766
  var valid_580767 = query.getOrDefault("quotaUser")
  valid_580767 = validateParameter(valid_580767, JString, required = false,
                                 default = nil)
  if valid_580767 != nil:
    section.add "quotaUser", valid_580767
  var valid_580768 = query.getOrDefault("alt")
  valid_580768 = validateParameter(valid_580768, JString, required = false,
                                 default = newJString("json"))
  if valid_580768 != nil:
    section.add "alt", valid_580768
  var valid_580769 = query.getOrDefault("oauth_token")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = nil)
  if valid_580769 != nil:
    section.add "oauth_token", valid_580769
  var valid_580770 = query.getOrDefault("userIp")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = nil)
  if valid_580770 != nil:
    section.add "userIp", valid_580770
  var valid_580771 = query.getOrDefault("key")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = nil)
  if valid_580771 != nil:
    section.add "key", valid_580771
  var valid_580772 = query.getOrDefault("prettyPrint")
  valid_580772 = validateParameter(valid_580772, JBool, required = false,
                                 default = newJBool(true))
  if valid_580772 != nil:
    section.add "prettyPrint", valid_580772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580773: Call_AndroidpublisherPurchasesSubscriptionsGet_580760;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_580773.validator(path, query, header, formData, body)
  let scheme = call_580773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580773.url(scheme.get, call_580773.host, call_580773.base,
                         call_580773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580773, url, valid)

proc call*(call_580774: Call_AndroidpublisherPurchasesSubscriptionsGet_580760;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesSubscriptionsGet
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580775 = newJObject()
  var query_580776 = newJObject()
  add(query_580776, "fields", newJString(fields))
  add(path_580775, "packageName", newJString(packageName))
  add(query_580776, "quotaUser", newJString(quotaUser))
  add(query_580776, "alt", newJString(alt))
  add(path_580775, "subscriptionId", newJString(subscriptionId))
  add(query_580776, "oauth_token", newJString(oauthToken))
  add(query_580776, "userIp", newJString(userIp))
  add(query_580776, "key", newJString(key))
  add(path_580775, "token", newJString(token))
  add(query_580776, "prettyPrint", newJBool(prettyPrint))
  result = call_580774.call(path_580775, query_580776, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsGet* = Call_AndroidpublisherPurchasesSubscriptionsGet_580760(
    name: "androidpublisherPurchasesSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesSubscriptionsGet_580761,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsGet_580762,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_580777 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesSubscriptionsAcknowledge_580779(
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

proc validate_AndroidpublisherPurchasesSubscriptionsAcknowledge_580778(
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
  var valid_580780 = path.getOrDefault("packageName")
  valid_580780 = validateParameter(valid_580780, JString, required = true,
                                 default = nil)
  if valid_580780 != nil:
    section.add "packageName", valid_580780
  var valid_580781 = path.getOrDefault("subscriptionId")
  valid_580781 = validateParameter(valid_580781, JString, required = true,
                                 default = nil)
  if valid_580781 != nil:
    section.add "subscriptionId", valid_580781
  var valid_580782 = path.getOrDefault("token")
  valid_580782 = validateParameter(valid_580782, JString, required = true,
                                 default = nil)
  if valid_580782 != nil:
    section.add "token", valid_580782
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
  var valid_580783 = query.getOrDefault("fields")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "fields", valid_580783
  var valid_580784 = query.getOrDefault("quotaUser")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = nil)
  if valid_580784 != nil:
    section.add "quotaUser", valid_580784
  var valid_580785 = query.getOrDefault("alt")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = newJString("json"))
  if valid_580785 != nil:
    section.add "alt", valid_580785
  var valid_580786 = query.getOrDefault("oauth_token")
  valid_580786 = validateParameter(valid_580786, JString, required = false,
                                 default = nil)
  if valid_580786 != nil:
    section.add "oauth_token", valid_580786
  var valid_580787 = query.getOrDefault("userIp")
  valid_580787 = validateParameter(valid_580787, JString, required = false,
                                 default = nil)
  if valid_580787 != nil:
    section.add "userIp", valid_580787
  var valid_580788 = query.getOrDefault("key")
  valid_580788 = validateParameter(valid_580788, JString, required = false,
                                 default = nil)
  if valid_580788 != nil:
    section.add "key", valid_580788
  var valid_580789 = query.getOrDefault("prettyPrint")
  valid_580789 = validateParameter(valid_580789, JBool, required = false,
                                 default = newJBool(true))
  if valid_580789 != nil:
    section.add "prettyPrint", valid_580789
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

proc call*(call_580791: Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_580777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges a subscription purchase.
  ## 
  let valid = call_580791.validator(path, query, header, formData, body)
  let scheme = call_580791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580791.url(scheme.get, call_580791.host, call_580791.base,
                         call_580791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580791, url, valid)

proc call*(call_580792: Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_580777;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesSubscriptionsAcknowledge
  ## Acknowledges a subscription purchase.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580793 = newJObject()
  var query_580794 = newJObject()
  var body_580795 = newJObject()
  add(query_580794, "fields", newJString(fields))
  add(path_580793, "packageName", newJString(packageName))
  add(query_580794, "quotaUser", newJString(quotaUser))
  add(query_580794, "alt", newJString(alt))
  add(path_580793, "subscriptionId", newJString(subscriptionId))
  add(query_580794, "oauth_token", newJString(oauthToken))
  add(query_580794, "userIp", newJString(userIp))
  add(query_580794, "key", newJString(key))
  add(path_580793, "token", newJString(token))
  if body != nil:
    body_580795 = body
  add(query_580794, "prettyPrint", newJBool(prettyPrint))
  result = call_580792.call(path_580793, query_580794, nil, nil, body_580795)

var androidpublisherPurchasesSubscriptionsAcknowledge* = Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_580777(
    name: "androidpublisherPurchasesSubscriptionsAcknowledge",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:acknowledge",
    validator: validate_AndroidpublisherPurchasesSubscriptionsAcknowledge_580778,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsAcknowledge_580779,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsCancel_580796 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesSubscriptionsCancel_580798(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsCancel_580797(path: JsonNode;
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
  var valid_580799 = path.getOrDefault("packageName")
  valid_580799 = validateParameter(valid_580799, JString, required = true,
                                 default = nil)
  if valid_580799 != nil:
    section.add "packageName", valid_580799
  var valid_580800 = path.getOrDefault("subscriptionId")
  valid_580800 = validateParameter(valid_580800, JString, required = true,
                                 default = nil)
  if valid_580800 != nil:
    section.add "subscriptionId", valid_580800
  var valid_580801 = path.getOrDefault("token")
  valid_580801 = validateParameter(valid_580801, JString, required = true,
                                 default = nil)
  if valid_580801 != nil:
    section.add "token", valid_580801
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
  var valid_580802 = query.getOrDefault("fields")
  valid_580802 = validateParameter(valid_580802, JString, required = false,
                                 default = nil)
  if valid_580802 != nil:
    section.add "fields", valid_580802
  var valid_580803 = query.getOrDefault("quotaUser")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = nil)
  if valid_580803 != nil:
    section.add "quotaUser", valid_580803
  var valid_580804 = query.getOrDefault("alt")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = newJString("json"))
  if valid_580804 != nil:
    section.add "alt", valid_580804
  var valid_580805 = query.getOrDefault("oauth_token")
  valid_580805 = validateParameter(valid_580805, JString, required = false,
                                 default = nil)
  if valid_580805 != nil:
    section.add "oauth_token", valid_580805
  var valid_580806 = query.getOrDefault("userIp")
  valid_580806 = validateParameter(valid_580806, JString, required = false,
                                 default = nil)
  if valid_580806 != nil:
    section.add "userIp", valid_580806
  var valid_580807 = query.getOrDefault("key")
  valid_580807 = validateParameter(valid_580807, JString, required = false,
                                 default = nil)
  if valid_580807 != nil:
    section.add "key", valid_580807
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
  if body != nil:
    result.add "body", body

proc call*(call_580809: Call_AndroidpublisherPurchasesSubscriptionsCancel_580796;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_580809.validator(path, query, header, formData, body)
  let scheme = call_580809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580809.url(scheme.get, call_580809.host, call_580809.base,
                         call_580809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580809, url, valid)

proc call*(call_580810: Call_AndroidpublisherPurchasesSubscriptionsCancel_580796;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesSubscriptionsCancel
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580811 = newJObject()
  var query_580812 = newJObject()
  add(query_580812, "fields", newJString(fields))
  add(path_580811, "packageName", newJString(packageName))
  add(query_580812, "quotaUser", newJString(quotaUser))
  add(query_580812, "alt", newJString(alt))
  add(path_580811, "subscriptionId", newJString(subscriptionId))
  add(query_580812, "oauth_token", newJString(oauthToken))
  add(query_580812, "userIp", newJString(userIp))
  add(query_580812, "key", newJString(key))
  add(path_580811, "token", newJString(token))
  add(query_580812, "prettyPrint", newJBool(prettyPrint))
  result = call_580810.call(path_580811, query_580812, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsCancel* = Call_AndroidpublisherPurchasesSubscriptionsCancel_580796(
    name: "androidpublisherPurchasesSubscriptionsCancel",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:cancel",
    validator: validate_AndroidpublisherPurchasesSubscriptionsCancel_580797,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsCancel_580798,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsDefer_580813 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesSubscriptionsDefer_580815(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsDefer_580814(path: JsonNode;
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
  var valid_580816 = path.getOrDefault("packageName")
  valid_580816 = validateParameter(valid_580816, JString, required = true,
                                 default = nil)
  if valid_580816 != nil:
    section.add "packageName", valid_580816
  var valid_580817 = path.getOrDefault("subscriptionId")
  valid_580817 = validateParameter(valid_580817, JString, required = true,
                                 default = nil)
  if valid_580817 != nil:
    section.add "subscriptionId", valid_580817
  var valid_580818 = path.getOrDefault("token")
  valid_580818 = validateParameter(valid_580818, JString, required = true,
                                 default = nil)
  if valid_580818 != nil:
    section.add "token", valid_580818
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
  var valid_580819 = query.getOrDefault("fields")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "fields", valid_580819
  var valid_580820 = query.getOrDefault("quotaUser")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = nil)
  if valid_580820 != nil:
    section.add "quotaUser", valid_580820
  var valid_580821 = query.getOrDefault("alt")
  valid_580821 = validateParameter(valid_580821, JString, required = false,
                                 default = newJString("json"))
  if valid_580821 != nil:
    section.add "alt", valid_580821
  var valid_580822 = query.getOrDefault("oauth_token")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = nil)
  if valid_580822 != nil:
    section.add "oauth_token", valid_580822
  var valid_580823 = query.getOrDefault("userIp")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "userIp", valid_580823
  var valid_580824 = query.getOrDefault("key")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = nil)
  if valid_580824 != nil:
    section.add "key", valid_580824
  var valid_580825 = query.getOrDefault("prettyPrint")
  valid_580825 = validateParameter(valid_580825, JBool, required = false,
                                 default = newJBool(true))
  if valid_580825 != nil:
    section.add "prettyPrint", valid_580825
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

proc call*(call_580827: Call_AndroidpublisherPurchasesSubscriptionsDefer_580813;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Defers a user's subscription purchase until a specified future expiration time.
  ## 
  let valid = call_580827.validator(path, query, header, formData, body)
  let scheme = call_580827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580827.url(scheme.get, call_580827.host, call_580827.base,
                         call_580827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580827, url, valid)

proc call*(call_580828: Call_AndroidpublisherPurchasesSubscriptionsDefer_580813;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesSubscriptionsDefer
  ## Defers a user's subscription purchase until a specified future expiration time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580829 = newJObject()
  var query_580830 = newJObject()
  var body_580831 = newJObject()
  add(query_580830, "fields", newJString(fields))
  add(path_580829, "packageName", newJString(packageName))
  add(query_580830, "quotaUser", newJString(quotaUser))
  add(query_580830, "alt", newJString(alt))
  add(path_580829, "subscriptionId", newJString(subscriptionId))
  add(query_580830, "oauth_token", newJString(oauthToken))
  add(query_580830, "userIp", newJString(userIp))
  add(query_580830, "key", newJString(key))
  add(path_580829, "token", newJString(token))
  if body != nil:
    body_580831 = body
  add(query_580830, "prettyPrint", newJBool(prettyPrint))
  result = call_580828.call(path_580829, query_580830, nil, nil, body_580831)

var androidpublisherPurchasesSubscriptionsDefer* = Call_AndroidpublisherPurchasesSubscriptionsDefer_580813(
    name: "androidpublisherPurchasesSubscriptionsDefer",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:defer",
    validator: validate_AndroidpublisherPurchasesSubscriptionsDefer_580814,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsDefer_580815,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRefund_580832 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesSubscriptionsRefund_580834(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsRefund_580833(path: JsonNode;
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
  var valid_580835 = path.getOrDefault("packageName")
  valid_580835 = validateParameter(valid_580835, JString, required = true,
                                 default = nil)
  if valid_580835 != nil:
    section.add "packageName", valid_580835
  var valid_580836 = path.getOrDefault("subscriptionId")
  valid_580836 = validateParameter(valid_580836, JString, required = true,
                                 default = nil)
  if valid_580836 != nil:
    section.add "subscriptionId", valid_580836
  var valid_580837 = path.getOrDefault("token")
  valid_580837 = validateParameter(valid_580837, JString, required = true,
                                 default = nil)
  if valid_580837 != nil:
    section.add "token", valid_580837
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
  var valid_580838 = query.getOrDefault("fields")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = nil)
  if valid_580838 != nil:
    section.add "fields", valid_580838
  var valid_580839 = query.getOrDefault("quotaUser")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = nil)
  if valid_580839 != nil:
    section.add "quotaUser", valid_580839
  var valid_580840 = query.getOrDefault("alt")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = newJString("json"))
  if valid_580840 != nil:
    section.add "alt", valid_580840
  var valid_580841 = query.getOrDefault("oauth_token")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "oauth_token", valid_580841
  var valid_580842 = query.getOrDefault("userIp")
  valid_580842 = validateParameter(valid_580842, JString, required = false,
                                 default = nil)
  if valid_580842 != nil:
    section.add "userIp", valid_580842
  var valid_580843 = query.getOrDefault("key")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = nil)
  if valid_580843 != nil:
    section.add "key", valid_580843
  var valid_580844 = query.getOrDefault("prettyPrint")
  valid_580844 = validateParameter(valid_580844, JBool, required = false,
                                 default = newJBool(true))
  if valid_580844 != nil:
    section.add "prettyPrint", valid_580844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580845: Call_AndroidpublisherPurchasesSubscriptionsRefund_580832;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ## 
  let valid = call_580845.validator(path, query, header, formData, body)
  let scheme = call_580845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580845.url(scheme.get, call_580845.host, call_580845.base,
                         call_580845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580845, url, valid)

proc call*(call_580846: Call_AndroidpublisherPurchasesSubscriptionsRefund_580832;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesSubscriptionsRefund
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580847 = newJObject()
  var query_580848 = newJObject()
  add(query_580848, "fields", newJString(fields))
  add(path_580847, "packageName", newJString(packageName))
  add(query_580848, "quotaUser", newJString(quotaUser))
  add(query_580848, "alt", newJString(alt))
  add(path_580847, "subscriptionId", newJString(subscriptionId))
  add(query_580848, "oauth_token", newJString(oauthToken))
  add(query_580848, "userIp", newJString(userIp))
  add(query_580848, "key", newJString(key))
  add(path_580847, "token", newJString(token))
  add(query_580848, "prettyPrint", newJBool(prettyPrint))
  result = call_580846.call(path_580847, query_580848, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRefund* = Call_AndroidpublisherPurchasesSubscriptionsRefund_580832(
    name: "androidpublisherPurchasesSubscriptionsRefund",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:refund",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRefund_580833,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRefund_580834,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRevoke_580849 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesSubscriptionsRevoke_580851(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsRevoke_580850(path: JsonNode;
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
  var valid_580852 = path.getOrDefault("packageName")
  valid_580852 = validateParameter(valid_580852, JString, required = true,
                                 default = nil)
  if valid_580852 != nil:
    section.add "packageName", valid_580852
  var valid_580853 = path.getOrDefault("subscriptionId")
  valid_580853 = validateParameter(valid_580853, JString, required = true,
                                 default = nil)
  if valid_580853 != nil:
    section.add "subscriptionId", valid_580853
  var valid_580854 = path.getOrDefault("token")
  valid_580854 = validateParameter(valid_580854, JString, required = true,
                                 default = nil)
  if valid_580854 != nil:
    section.add "token", valid_580854
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
  var valid_580855 = query.getOrDefault("fields")
  valid_580855 = validateParameter(valid_580855, JString, required = false,
                                 default = nil)
  if valid_580855 != nil:
    section.add "fields", valid_580855
  var valid_580856 = query.getOrDefault("quotaUser")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = nil)
  if valid_580856 != nil:
    section.add "quotaUser", valid_580856
  var valid_580857 = query.getOrDefault("alt")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = newJString("json"))
  if valid_580857 != nil:
    section.add "alt", valid_580857
  var valid_580858 = query.getOrDefault("oauth_token")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = nil)
  if valid_580858 != nil:
    section.add "oauth_token", valid_580858
  var valid_580859 = query.getOrDefault("userIp")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "userIp", valid_580859
  var valid_580860 = query.getOrDefault("key")
  valid_580860 = validateParameter(valid_580860, JString, required = false,
                                 default = nil)
  if valid_580860 != nil:
    section.add "key", valid_580860
  var valid_580861 = query.getOrDefault("prettyPrint")
  valid_580861 = validateParameter(valid_580861, JBool, required = false,
                                 default = newJBool(true))
  if valid_580861 != nil:
    section.add "prettyPrint", valid_580861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580862: Call_AndroidpublisherPurchasesSubscriptionsRevoke_580849;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ## 
  let valid = call_580862.validator(path, query, header, formData, body)
  let scheme = call_580862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580862.url(scheme.get, call_580862.host, call_580862.base,
                         call_580862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580862, url, valid)

proc call*(call_580863: Call_AndroidpublisherPurchasesSubscriptionsRevoke_580849;
          packageName: string; subscriptionId: string; token: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherPurchasesSubscriptionsRevoke
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580864 = newJObject()
  var query_580865 = newJObject()
  add(query_580865, "fields", newJString(fields))
  add(path_580864, "packageName", newJString(packageName))
  add(query_580865, "quotaUser", newJString(quotaUser))
  add(query_580865, "alt", newJString(alt))
  add(path_580864, "subscriptionId", newJString(subscriptionId))
  add(query_580865, "oauth_token", newJString(oauthToken))
  add(query_580865, "userIp", newJString(userIp))
  add(query_580865, "key", newJString(key))
  add(path_580864, "token", newJString(token))
  add(query_580865, "prettyPrint", newJBool(prettyPrint))
  result = call_580863.call(path_580864, query_580865, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRevoke* = Call_AndroidpublisherPurchasesSubscriptionsRevoke_580849(
    name: "androidpublisherPurchasesSubscriptionsRevoke",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:revoke",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRevoke_580850,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRevoke_580851,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesVoidedpurchasesList_580866 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherPurchasesVoidedpurchasesList_580868(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesVoidedpurchasesList_580867(path: JsonNode;
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
  var valid_580869 = path.getOrDefault("packageName")
  valid_580869 = validateParameter(valid_580869, JString, required = true,
                                 default = nil)
  if valid_580869 != nil:
    section.add "packageName", valid_580869
  result.add "path", section
  ## parameters in `query` object:
  ##   token: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   type: JInt
  ##       : The type of voided purchases that you want to see in the response. Possible values are:  
  ## - 0: Only voided in-app product purchases will be returned in the response. This is the default value.
  ## - 1: Both voided in-app purchases and voided subscription purchases will be returned in the response.  Note: Before requesting to receive voided subscription purchases, you must switch to use orderId in the response which uniquely identifies one-time purchases and subscriptions. Otherwise, you will receive multiple subscription orders with the same PurchaseToken, because subscription renewal orders share the same PurchaseToken.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   endTime: JString
  ##          : The time, in milliseconds since the Epoch, of the newest voided purchase that you want to see in the response. The value of this parameter cannot be greater than the current time and is ignored if a pagination token is set. Default value is current time. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : The time, in milliseconds since the Epoch, of the oldest voided purchase that you want to see in the response. The value of this parameter cannot be older than 30 days and is ignored if a pagination token is set. Default value is current time minus 30 days. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  ##   startIndex: JInt
  section = newJObject()
  var valid_580870 = query.getOrDefault("token")
  valid_580870 = validateParameter(valid_580870, JString, required = false,
                                 default = nil)
  if valid_580870 != nil:
    section.add "token", valid_580870
  var valid_580871 = query.getOrDefault("fields")
  valid_580871 = validateParameter(valid_580871, JString, required = false,
                                 default = nil)
  if valid_580871 != nil:
    section.add "fields", valid_580871
  var valid_580872 = query.getOrDefault("quotaUser")
  valid_580872 = validateParameter(valid_580872, JString, required = false,
                                 default = nil)
  if valid_580872 != nil:
    section.add "quotaUser", valid_580872
  var valid_580873 = query.getOrDefault("alt")
  valid_580873 = validateParameter(valid_580873, JString, required = false,
                                 default = newJString("json"))
  if valid_580873 != nil:
    section.add "alt", valid_580873
  var valid_580874 = query.getOrDefault("type")
  valid_580874 = validateParameter(valid_580874, JInt, required = false, default = nil)
  if valid_580874 != nil:
    section.add "type", valid_580874
  var valid_580875 = query.getOrDefault("oauth_token")
  valid_580875 = validateParameter(valid_580875, JString, required = false,
                                 default = nil)
  if valid_580875 != nil:
    section.add "oauth_token", valid_580875
  var valid_580876 = query.getOrDefault("endTime")
  valid_580876 = validateParameter(valid_580876, JString, required = false,
                                 default = nil)
  if valid_580876 != nil:
    section.add "endTime", valid_580876
  var valid_580877 = query.getOrDefault("userIp")
  valid_580877 = validateParameter(valid_580877, JString, required = false,
                                 default = nil)
  if valid_580877 != nil:
    section.add "userIp", valid_580877
  var valid_580878 = query.getOrDefault("maxResults")
  valid_580878 = validateParameter(valid_580878, JInt, required = false, default = nil)
  if valid_580878 != nil:
    section.add "maxResults", valid_580878
  var valid_580879 = query.getOrDefault("key")
  valid_580879 = validateParameter(valid_580879, JString, required = false,
                                 default = nil)
  if valid_580879 != nil:
    section.add "key", valid_580879
  var valid_580880 = query.getOrDefault("prettyPrint")
  valid_580880 = validateParameter(valid_580880, JBool, required = false,
                                 default = newJBool(true))
  if valid_580880 != nil:
    section.add "prettyPrint", valid_580880
  var valid_580881 = query.getOrDefault("startTime")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = nil)
  if valid_580881 != nil:
    section.add "startTime", valid_580881
  var valid_580882 = query.getOrDefault("startIndex")
  valid_580882 = validateParameter(valid_580882, JInt, required = false, default = nil)
  if valid_580882 != nil:
    section.add "startIndex", valid_580882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580883: Call_AndroidpublisherPurchasesVoidedpurchasesList_580866;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the purchases that were canceled, refunded or charged-back.
  ## 
  let valid = call_580883.validator(path, query, header, formData, body)
  let scheme = call_580883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580883.url(scheme.get, call_580883.host, call_580883.base,
                         call_580883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580883, url, valid)

proc call*(call_580884: Call_AndroidpublisherPurchasesVoidedpurchasesList_580866;
          packageName: string; token: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; `type`: int = 0;
          oauthToken: string = ""; endTime: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true;
          startTime: string = ""; startIndex: int = 0): Recallable =
  ## androidpublisherPurchasesVoidedpurchasesList
  ## Lists the purchases that were canceled, refunded or charged-back.
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : The package name of the application for which voided purchases need to be returned (for example, 'com.some.thing').
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   type: int
  ##       : The type of voided purchases that you want to see in the response. Possible values are:  
  ## - 0: Only voided in-app product purchases will be returned in the response. This is the default value.
  ## - 1: Both voided in-app purchases and voided subscription purchases will be returned in the response.  Note: Before requesting to receive voided subscription purchases, you must switch to use orderId in the response which uniquely identifies one-time purchases and subscriptions. Otherwise, you will receive multiple subscription orders with the same PurchaseToken, because subscription renewal orders share the same PurchaseToken.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   endTime: string
  ##          : The time, in milliseconds since the Epoch, of the newest voided purchase that you want to see in the response. The value of this parameter cannot be greater than the current time and is ignored if a pagination token is set. Default value is current time. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : The time, in milliseconds since the Epoch, of the oldest voided purchase that you want to see in the response. The value of this parameter cannot be older than 30 days and is ignored if a pagination token is set. Default value is current time minus 30 days. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  ##   startIndex: int
  var path_580885 = newJObject()
  var query_580886 = newJObject()
  add(query_580886, "token", newJString(token))
  add(query_580886, "fields", newJString(fields))
  add(path_580885, "packageName", newJString(packageName))
  add(query_580886, "quotaUser", newJString(quotaUser))
  add(query_580886, "alt", newJString(alt))
  add(query_580886, "type", newJInt(`type`))
  add(query_580886, "oauth_token", newJString(oauthToken))
  add(query_580886, "endTime", newJString(endTime))
  add(query_580886, "userIp", newJString(userIp))
  add(query_580886, "maxResults", newJInt(maxResults))
  add(query_580886, "key", newJString(key))
  add(query_580886, "prettyPrint", newJBool(prettyPrint))
  add(query_580886, "startTime", newJString(startTime))
  add(query_580886, "startIndex", newJInt(startIndex))
  result = call_580884.call(path_580885, query_580886, nil, nil, nil)

var androidpublisherPurchasesVoidedpurchasesList* = Call_AndroidpublisherPurchasesVoidedpurchasesList_580866(
    name: "androidpublisherPurchasesVoidedpurchasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{packageName}/purchases/voidedpurchases",
    validator: validate_AndroidpublisherPurchasesVoidedpurchasesList_580867,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesVoidedpurchasesList_580868,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsList_580887 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherReviewsList_580889(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsList_580888(path: JsonNode; query: JsonNode;
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
  var valid_580890 = path.getOrDefault("packageName")
  valid_580890 = validateParameter(valid_580890, JString, required = true,
                                 default = nil)
  if valid_580890 != nil:
    section.add "packageName", valid_580890
  result.add "path", section
  ## parameters in `query` object:
  ##   translationLanguage: JString
  ##   token: JString
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
  ##   maxResults: JInt
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  section = newJObject()
  var valid_580891 = query.getOrDefault("translationLanguage")
  valid_580891 = validateParameter(valid_580891, JString, required = false,
                                 default = nil)
  if valid_580891 != nil:
    section.add "translationLanguage", valid_580891
  var valid_580892 = query.getOrDefault("token")
  valid_580892 = validateParameter(valid_580892, JString, required = false,
                                 default = nil)
  if valid_580892 != nil:
    section.add "token", valid_580892
  var valid_580893 = query.getOrDefault("fields")
  valid_580893 = validateParameter(valid_580893, JString, required = false,
                                 default = nil)
  if valid_580893 != nil:
    section.add "fields", valid_580893
  var valid_580894 = query.getOrDefault("quotaUser")
  valid_580894 = validateParameter(valid_580894, JString, required = false,
                                 default = nil)
  if valid_580894 != nil:
    section.add "quotaUser", valid_580894
  var valid_580895 = query.getOrDefault("alt")
  valid_580895 = validateParameter(valid_580895, JString, required = false,
                                 default = newJString("json"))
  if valid_580895 != nil:
    section.add "alt", valid_580895
  var valid_580896 = query.getOrDefault("oauth_token")
  valid_580896 = validateParameter(valid_580896, JString, required = false,
                                 default = nil)
  if valid_580896 != nil:
    section.add "oauth_token", valid_580896
  var valid_580897 = query.getOrDefault("userIp")
  valid_580897 = validateParameter(valid_580897, JString, required = false,
                                 default = nil)
  if valid_580897 != nil:
    section.add "userIp", valid_580897
  var valid_580898 = query.getOrDefault("maxResults")
  valid_580898 = validateParameter(valid_580898, JInt, required = false, default = nil)
  if valid_580898 != nil:
    section.add "maxResults", valid_580898
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
  var valid_580901 = query.getOrDefault("startIndex")
  valid_580901 = validateParameter(valid_580901, JInt, required = false, default = nil)
  if valid_580901 != nil:
    section.add "startIndex", valid_580901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580902: Call_AndroidpublisherReviewsList_580887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ## 
  let valid = call_580902.validator(path, query, header, formData, body)
  let scheme = call_580902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580902.url(scheme.get, call_580902.host, call_580902.base,
                         call_580902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580902, url, valid)

proc call*(call_580903: Call_AndroidpublisherReviewsList_580887;
          packageName: string; translationLanguage: string = ""; token: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## androidpublisherReviewsList
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ##   translationLanguage: string
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  var path_580904 = newJObject()
  var query_580905 = newJObject()
  add(query_580905, "translationLanguage", newJString(translationLanguage))
  add(query_580905, "token", newJString(token))
  add(query_580905, "fields", newJString(fields))
  add(path_580904, "packageName", newJString(packageName))
  add(query_580905, "quotaUser", newJString(quotaUser))
  add(query_580905, "alt", newJString(alt))
  add(query_580905, "oauth_token", newJString(oauthToken))
  add(query_580905, "userIp", newJString(userIp))
  add(query_580905, "maxResults", newJInt(maxResults))
  add(query_580905, "key", newJString(key))
  add(query_580905, "prettyPrint", newJBool(prettyPrint))
  add(query_580905, "startIndex", newJInt(startIndex))
  result = call_580903.call(path_580904, query_580905, nil, nil, nil)

var androidpublisherReviewsList* = Call_AndroidpublisherReviewsList_580887(
    name: "androidpublisherReviewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews",
    validator: validate_AndroidpublisherReviewsList_580888,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsList_580889, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsGet_580906 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherReviewsGet_580908(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsGet_580907(path: JsonNode; query: JsonNode;
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
  var valid_580909 = path.getOrDefault("packageName")
  valid_580909 = validateParameter(valid_580909, JString, required = true,
                                 default = nil)
  if valid_580909 != nil:
    section.add "packageName", valid_580909
  var valid_580910 = path.getOrDefault("reviewId")
  valid_580910 = validateParameter(valid_580910, JString, required = true,
                                 default = nil)
  if valid_580910 != nil:
    section.add "reviewId", valid_580910
  result.add "path", section
  ## parameters in `query` object:
  ##   translationLanguage: JString
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
  var valid_580911 = query.getOrDefault("translationLanguage")
  valid_580911 = validateParameter(valid_580911, JString, required = false,
                                 default = nil)
  if valid_580911 != nil:
    section.add "translationLanguage", valid_580911
  var valid_580912 = query.getOrDefault("fields")
  valid_580912 = validateParameter(valid_580912, JString, required = false,
                                 default = nil)
  if valid_580912 != nil:
    section.add "fields", valid_580912
  var valid_580913 = query.getOrDefault("quotaUser")
  valid_580913 = validateParameter(valid_580913, JString, required = false,
                                 default = nil)
  if valid_580913 != nil:
    section.add "quotaUser", valid_580913
  var valid_580914 = query.getOrDefault("alt")
  valid_580914 = validateParameter(valid_580914, JString, required = false,
                                 default = newJString("json"))
  if valid_580914 != nil:
    section.add "alt", valid_580914
  var valid_580915 = query.getOrDefault("oauth_token")
  valid_580915 = validateParameter(valid_580915, JString, required = false,
                                 default = nil)
  if valid_580915 != nil:
    section.add "oauth_token", valid_580915
  var valid_580916 = query.getOrDefault("userIp")
  valid_580916 = validateParameter(valid_580916, JString, required = false,
                                 default = nil)
  if valid_580916 != nil:
    section.add "userIp", valid_580916
  var valid_580917 = query.getOrDefault("key")
  valid_580917 = validateParameter(valid_580917, JString, required = false,
                                 default = nil)
  if valid_580917 != nil:
    section.add "key", valid_580917
  var valid_580918 = query.getOrDefault("prettyPrint")
  valid_580918 = validateParameter(valid_580918, JBool, required = false,
                                 default = newJBool(true))
  if valid_580918 != nil:
    section.add "prettyPrint", valid_580918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580919: Call_AndroidpublisherReviewsGet_580906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single review.
  ## 
  let valid = call_580919.validator(path, query, header, formData, body)
  let scheme = call_580919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580919.url(scheme.get, call_580919.host, call_580919.base,
                         call_580919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580919, url, valid)

proc call*(call_580920: Call_AndroidpublisherReviewsGet_580906;
          packageName: string; reviewId: string; translationLanguage: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidpublisherReviewsGet
  ## Returns a single review.
  ##   translationLanguage: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   reviewId: string (required)
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580921 = newJObject()
  var query_580922 = newJObject()
  add(query_580922, "translationLanguage", newJString(translationLanguage))
  add(query_580922, "fields", newJString(fields))
  add(path_580921, "packageName", newJString(packageName))
  add(query_580922, "quotaUser", newJString(quotaUser))
  add(query_580922, "alt", newJString(alt))
  add(query_580922, "oauth_token", newJString(oauthToken))
  add(path_580921, "reviewId", newJString(reviewId))
  add(query_580922, "userIp", newJString(userIp))
  add(query_580922, "key", newJString(key))
  add(query_580922, "prettyPrint", newJBool(prettyPrint))
  result = call_580920.call(path_580921, query_580922, nil, nil, nil)

var androidpublisherReviewsGet* = Call_AndroidpublisherReviewsGet_580906(
    name: "androidpublisherReviewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}",
    validator: validate_AndroidpublisherReviewsGet_580907,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsGet_580908, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsReply_580923 = ref object of OpenApiRestCall_579421
proc url_AndroidpublisherReviewsReply_580925(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsReply_580924(path: JsonNode; query: JsonNode;
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
  var valid_580926 = path.getOrDefault("packageName")
  valid_580926 = validateParameter(valid_580926, JString, required = true,
                                 default = nil)
  if valid_580926 != nil:
    section.add "packageName", valid_580926
  var valid_580927 = path.getOrDefault("reviewId")
  valid_580927 = validateParameter(valid_580927, JString, required = true,
                                 default = nil)
  if valid_580927 != nil:
    section.add "reviewId", valid_580927
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
  var valid_580928 = query.getOrDefault("fields")
  valid_580928 = validateParameter(valid_580928, JString, required = false,
                                 default = nil)
  if valid_580928 != nil:
    section.add "fields", valid_580928
  var valid_580929 = query.getOrDefault("quotaUser")
  valid_580929 = validateParameter(valid_580929, JString, required = false,
                                 default = nil)
  if valid_580929 != nil:
    section.add "quotaUser", valid_580929
  var valid_580930 = query.getOrDefault("alt")
  valid_580930 = validateParameter(valid_580930, JString, required = false,
                                 default = newJString("json"))
  if valid_580930 != nil:
    section.add "alt", valid_580930
  var valid_580931 = query.getOrDefault("oauth_token")
  valid_580931 = validateParameter(valid_580931, JString, required = false,
                                 default = nil)
  if valid_580931 != nil:
    section.add "oauth_token", valid_580931
  var valid_580932 = query.getOrDefault("userIp")
  valid_580932 = validateParameter(valid_580932, JString, required = false,
                                 default = nil)
  if valid_580932 != nil:
    section.add "userIp", valid_580932
  var valid_580933 = query.getOrDefault("key")
  valid_580933 = validateParameter(valid_580933, JString, required = false,
                                 default = nil)
  if valid_580933 != nil:
    section.add "key", valid_580933
  var valid_580934 = query.getOrDefault("prettyPrint")
  valid_580934 = validateParameter(valid_580934, JBool, required = false,
                                 default = newJBool(true))
  if valid_580934 != nil:
    section.add "prettyPrint", valid_580934
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

proc call*(call_580936: Call_AndroidpublisherReviewsReply_580923; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reply to a single review, or update an existing reply.
  ## 
  let valid = call_580936.validator(path, query, header, formData, body)
  let scheme = call_580936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580936.url(scheme.get, call_580936.host, call_580936.base,
                         call_580936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580936, url, valid)

proc call*(call_580937: Call_AndroidpublisherReviewsReply_580923;
          packageName: string; reviewId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidpublisherReviewsReply
  ## Reply to a single review, or update an existing reply.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   packageName: string (required)
  ##              : Unique identifier for the Android app for which we want reviews; for example, "com.spiffygame".
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   reviewId: string (required)
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580938 = newJObject()
  var query_580939 = newJObject()
  var body_580940 = newJObject()
  add(query_580939, "fields", newJString(fields))
  add(path_580938, "packageName", newJString(packageName))
  add(query_580939, "quotaUser", newJString(quotaUser))
  add(query_580939, "alt", newJString(alt))
  add(query_580939, "oauth_token", newJString(oauthToken))
  add(path_580938, "reviewId", newJString(reviewId))
  add(query_580939, "userIp", newJString(userIp))
  add(query_580939, "key", newJString(key))
  if body != nil:
    body_580940 = body
  add(query_580939, "prettyPrint", newJBool(prettyPrint))
  result = call_580937.call(path_580938, query_580939, nil, nil, body_580940)

var androidpublisherReviewsReply* = Call_AndroidpublisherReviewsReply_580923(
    name: "androidpublisherReviewsReply", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}:reply",
    validator: validate_AndroidpublisherReviewsReply_580924,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsReply_580925, schemes: {Scheme.Https})
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
