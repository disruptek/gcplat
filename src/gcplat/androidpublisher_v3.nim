
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "androidpublisher"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidpublisherInternalappsharingartifactsUploadapk_588718 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInternalappsharingartifactsUploadapk_588720(
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

proc validate_AndroidpublisherInternalappsharingartifactsUploadapk_588719(
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
  var valid_588846 = path.getOrDefault("packageName")
  valid_588846 = validateParameter(valid_588846, JString, required = true,
                                 default = nil)
  if valid_588846 != nil:
    section.add "packageName", valid_588846
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
  var valid_588847 = query.getOrDefault("fields")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "fields", valid_588847
  var valid_588848 = query.getOrDefault("quotaUser")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "quotaUser", valid_588848
  var valid_588862 = query.getOrDefault("alt")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = newJString("json"))
  if valid_588862 != nil:
    section.add "alt", valid_588862
  var valid_588863 = query.getOrDefault("oauth_token")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = nil)
  if valid_588863 != nil:
    section.add "oauth_token", valid_588863
  var valid_588864 = query.getOrDefault("userIp")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "userIp", valid_588864
  var valid_588865 = query.getOrDefault("key")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "key", valid_588865
  var valid_588866 = query.getOrDefault("prettyPrint")
  valid_588866 = validateParameter(valid_588866, JBool, required = false,
                                 default = newJBool(true))
  if valid_588866 != nil:
    section.add "prettyPrint", valid_588866
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588889: Call_AndroidpublisherInternalappsharingartifactsUploadapk_588718;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads an APK to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_588889.validator(path, query, header, formData, body)
  let scheme = call_588889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588889.url(scheme.get, call_588889.host, call_588889.base,
                         call_588889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588889, url, valid)

proc call*(call_588960: Call_AndroidpublisherInternalappsharingartifactsUploadapk_588718;
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
  var path_588961 = newJObject()
  var query_588963 = newJObject()
  add(query_588963, "fields", newJString(fields))
  add(path_588961, "packageName", newJString(packageName))
  add(query_588963, "quotaUser", newJString(quotaUser))
  add(query_588963, "alt", newJString(alt))
  add(query_588963, "oauth_token", newJString(oauthToken))
  add(query_588963, "userIp", newJString(userIp))
  add(query_588963, "key", newJString(key))
  add(query_588963, "prettyPrint", newJBool(prettyPrint))
  result = call_588960.call(path_588961, query_588963, nil, nil, nil)

var androidpublisherInternalappsharingartifactsUploadapk* = Call_AndroidpublisherInternalappsharingartifactsUploadapk_588718(
    name: "androidpublisherInternalappsharingartifactsUploadapk",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/internalappsharing/{packageName}/artifacts/apk",
    validator: validate_AndroidpublisherInternalappsharingartifactsUploadapk_588719,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInternalappsharingartifactsUploadapk_588720,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherInternalappsharingartifactsUploadbundle_589002 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInternalappsharingartifactsUploadbundle_589004(
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

proc validate_AndroidpublisherInternalappsharingartifactsUploadbundle_589003(
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
  var valid_589005 = path.getOrDefault("packageName")
  valid_589005 = validateParameter(valid_589005, JString, required = true,
                                 default = nil)
  if valid_589005 != nil:
    section.add "packageName", valid_589005
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
  var valid_589006 = query.getOrDefault("fields")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "fields", valid_589006
  var valid_589007 = query.getOrDefault("quotaUser")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "quotaUser", valid_589007
  var valid_589008 = query.getOrDefault("alt")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = newJString("json"))
  if valid_589008 != nil:
    section.add "alt", valid_589008
  var valid_589009 = query.getOrDefault("oauth_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "oauth_token", valid_589009
  var valid_589010 = query.getOrDefault("userIp")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "userIp", valid_589010
  var valid_589011 = query.getOrDefault("key")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "key", valid_589011
  var valid_589012 = query.getOrDefault("prettyPrint")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "prettyPrint", valid_589012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589013: Call_AndroidpublisherInternalappsharingartifactsUploadbundle_589002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads an app bundle to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_589013.validator(path, query, header, formData, body)
  let scheme = call_589013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589013.url(scheme.get, call_589013.host, call_589013.base,
                         call_589013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589013, url, valid)

proc call*(call_589014: Call_AndroidpublisherInternalappsharingartifactsUploadbundle_589002;
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
  var path_589015 = newJObject()
  var query_589016 = newJObject()
  add(query_589016, "fields", newJString(fields))
  add(path_589015, "packageName", newJString(packageName))
  add(query_589016, "quotaUser", newJString(quotaUser))
  add(query_589016, "alt", newJString(alt))
  add(query_589016, "oauth_token", newJString(oauthToken))
  add(query_589016, "userIp", newJString(userIp))
  add(query_589016, "key", newJString(key))
  add(query_589016, "prettyPrint", newJBool(prettyPrint))
  result = call_589014.call(path_589015, query_589016, nil, nil, nil)

var androidpublisherInternalappsharingartifactsUploadbundle* = Call_AndroidpublisherInternalappsharingartifactsUploadbundle_589002(
    name: "androidpublisherInternalappsharingartifactsUploadbundle",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/internalappsharing/{packageName}/artifacts/bundle", validator: validate_AndroidpublisherInternalappsharingartifactsUploadbundle_589003,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInternalappsharingartifactsUploadbundle_589004,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsInsert_589017 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsInsert_589019(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsInsert_589018(path: JsonNode; query: JsonNode;
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
  var valid_589020 = path.getOrDefault("packageName")
  valid_589020 = validateParameter(valid_589020, JString, required = true,
                                 default = nil)
  if valid_589020 != nil:
    section.add "packageName", valid_589020
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
  var valid_589021 = query.getOrDefault("fields")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "fields", valid_589021
  var valid_589022 = query.getOrDefault("quotaUser")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "quotaUser", valid_589022
  var valid_589023 = query.getOrDefault("alt")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = newJString("json"))
  if valid_589023 != nil:
    section.add "alt", valid_589023
  var valid_589024 = query.getOrDefault("oauth_token")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "oauth_token", valid_589024
  var valid_589025 = query.getOrDefault("userIp")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "userIp", valid_589025
  var valid_589026 = query.getOrDefault("key")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "key", valid_589026
  var valid_589027 = query.getOrDefault("prettyPrint")
  valid_589027 = validateParameter(valid_589027, JBool, required = false,
                                 default = newJBool(true))
  if valid_589027 != nil:
    section.add "prettyPrint", valid_589027
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

proc call*(call_589029: Call_AndroidpublisherEditsInsert_589017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new edit for an app, populated with the app's current state.
  ## 
  let valid = call_589029.validator(path, query, header, formData, body)
  let scheme = call_589029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589029.url(scheme.get, call_589029.host, call_589029.base,
                         call_589029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589029, url, valid)

proc call*(call_589030: Call_AndroidpublisherEditsInsert_589017;
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
  var path_589031 = newJObject()
  var query_589032 = newJObject()
  var body_589033 = newJObject()
  add(query_589032, "fields", newJString(fields))
  add(path_589031, "packageName", newJString(packageName))
  add(query_589032, "quotaUser", newJString(quotaUser))
  add(query_589032, "alt", newJString(alt))
  add(query_589032, "oauth_token", newJString(oauthToken))
  add(query_589032, "userIp", newJString(userIp))
  add(query_589032, "key", newJString(key))
  if body != nil:
    body_589033 = body
  add(query_589032, "prettyPrint", newJBool(prettyPrint))
  result = call_589030.call(path_589031, query_589032, nil, nil, body_589033)

var androidpublisherEditsInsert* = Call_AndroidpublisherEditsInsert_589017(
    name: "androidpublisherEditsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits",
    validator: validate_AndroidpublisherEditsInsert_589018,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsInsert_589019, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsGet_589034 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsGet_589036(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsGet_589035(path: JsonNode; query: JsonNode;
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
  var valid_589037 = path.getOrDefault("packageName")
  valid_589037 = validateParameter(valid_589037, JString, required = true,
                                 default = nil)
  if valid_589037 != nil:
    section.add "packageName", valid_589037
  var valid_589038 = path.getOrDefault("editId")
  valid_589038 = validateParameter(valid_589038, JString, required = true,
                                 default = nil)
  if valid_589038 != nil:
    section.add "editId", valid_589038
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
  var valid_589039 = query.getOrDefault("fields")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "fields", valid_589039
  var valid_589040 = query.getOrDefault("quotaUser")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "quotaUser", valid_589040
  var valid_589041 = query.getOrDefault("alt")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = newJString("json"))
  if valid_589041 != nil:
    section.add "alt", valid_589041
  var valid_589042 = query.getOrDefault("oauth_token")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "oauth_token", valid_589042
  var valid_589043 = query.getOrDefault("userIp")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "userIp", valid_589043
  var valid_589044 = query.getOrDefault("key")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "key", valid_589044
  var valid_589045 = query.getOrDefault("prettyPrint")
  valid_589045 = validateParameter(valid_589045, JBool, required = false,
                                 default = newJBool(true))
  if valid_589045 != nil:
    section.add "prettyPrint", valid_589045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589046: Call_AndroidpublisherEditsGet_589034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ## 
  let valid = call_589046.validator(path, query, header, formData, body)
  let scheme = call_589046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589046.url(scheme.get, call_589046.host, call_589046.base,
                         call_589046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589046, url, valid)

proc call*(call_589047: Call_AndroidpublisherEditsGet_589034; packageName: string;
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
  var path_589048 = newJObject()
  var query_589049 = newJObject()
  add(query_589049, "fields", newJString(fields))
  add(path_589048, "packageName", newJString(packageName))
  add(query_589049, "quotaUser", newJString(quotaUser))
  add(query_589049, "alt", newJString(alt))
  add(path_589048, "editId", newJString(editId))
  add(query_589049, "oauth_token", newJString(oauthToken))
  add(query_589049, "userIp", newJString(userIp))
  add(query_589049, "key", newJString(key))
  add(query_589049, "prettyPrint", newJBool(prettyPrint))
  result = call_589047.call(path_589048, query_589049, nil, nil, nil)

var androidpublisherEditsGet* = Call_AndroidpublisherEditsGet_589034(
    name: "androidpublisherEditsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsGet_589035,
    base: "/androidpublisher/v3/applications", url: url_AndroidpublisherEditsGet_589036,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDelete_589050 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsDelete_589052(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDelete_589051(path: JsonNode; query: JsonNode;
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
  var valid_589053 = path.getOrDefault("packageName")
  valid_589053 = validateParameter(valid_589053, JString, required = true,
                                 default = nil)
  if valid_589053 != nil:
    section.add "packageName", valid_589053
  var valid_589054 = path.getOrDefault("editId")
  valid_589054 = validateParameter(valid_589054, JString, required = true,
                                 default = nil)
  if valid_589054 != nil:
    section.add "editId", valid_589054
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
  var valid_589055 = query.getOrDefault("fields")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "fields", valid_589055
  var valid_589056 = query.getOrDefault("quotaUser")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "quotaUser", valid_589056
  var valid_589057 = query.getOrDefault("alt")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = newJString("json"))
  if valid_589057 != nil:
    section.add "alt", valid_589057
  var valid_589058 = query.getOrDefault("oauth_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "oauth_token", valid_589058
  var valid_589059 = query.getOrDefault("userIp")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "userIp", valid_589059
  var valid_589060 = query.getOrDefault("key")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "key", valid_589060
  var valid_589061 = query.getOrDefault("prettyPrint")
  valid_589061 = validateParameter(valid_589061, JBool, required = false,
                                 default = newJBool(true))
  if valid_589061 != nil:
    section.add "prettyPrint", valid_589061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589062: Call_AndroidpublisherEditsDelete_589050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ## 
  let valid = call_589062.validator(path, query, header, formData, body)
  let scheme = call_589062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589062.url(scheme.get, call_589062.host, call_589062.base,
                         call_589062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589062, url, valid)

proc call*(call_589063: Call_AndroidpublisherEditsDelete_589050;
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
  var path_589064 = newJObject()
  var query_589065 = newJObject()
  add(query_589065, "fields", newJString(fields))
  add(path_589064, "packageName", newJString(packageName))
  add(query_589065, "quotaUser", newJString(quotaUser))
  add(query_589065, "alt", newJString(alt))
  add(path_589064, "editId", newJString(editId))
  add(query_589065, "oauth_token", newJString(oauthToken))
  add(query_589065, "userIp", newJString(userIp))
  add(query_589065, "key", newJString(key))
  add(query_589065, "prettyPrint", newJBool(prettyPrint))
  result = call_589063.call(path_589064, query_589065, nil, nil, nil)

var androidpublisherEditsDelete* = Call_AndroidpublisherEditsDelete_589050(
    name: "androidpublisherEditsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsDelete_589051,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDelete_589052, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksUpload_589082 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApksUpload_589084(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsApksUpload_589083(path: JsonNode;
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
  var valid_589085 = path.getOrDefault("packageName")
  valid_589085 = validateParameter(valid_589085, JString, required = true,
                                 default = nil)
  if valid_589085 != nil:
    section.add "packageName", valid_589085
  var valid_589086 = path.getOrDefault("editId")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "editId", valid_589086
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
  var valid_589087 = query.getOrDefault("fields")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "fields", valid_589087
  var valid_589088 = query.getOrDefault("quotaUser")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "quotaUser", valid_589088
  var valid_589089 = query.getOrDefault("alt")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = newJString("json"))
  if valid_589089 != nil:
    section.add "alt", valid_589089
  var valid_589090 = query.getOrDefault("oauth_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "oauth_token", valid_589090
  var valid_589091 = query.getOrDefault("userIp")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "userIp", valid_589091
  var valid_589092 = query.getOrDefault("key")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "key", valid_589092
  var valid_589093 = query.getOrDefault("prettyPrint")
  valid_589093 = validateParameter(valid_589093, JBool, required = false,
                                 default = newJBool(true))
  if valid_589093 != nil:
    section.add "prettyPrint", valid_589093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589094: Call_AndroidpublisherEditsApksUpload_589082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_589094.validator(path, query, header, formData, body)
  let scheme = call_589094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589094.url(scheme.get, call_589094.host, call_589094.base,
                         call_589094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589094, url, valid)

proc call*(call_589095: Call_AndroidpublisherEditsApksUpload_589082;
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
  var path_589096 = newJObject()
  var query_589097 = newJObject()
  add(query_589097, "fields", newJString(fields))
  add(path_589096, "packageName", newJString(packageName))
  add(query_589097, "quotaUser", newJString(quotaUser))
  add(query_589097, "alt", newJString(alt))
  add(path_589096, "editId", newJString(editId))
  add(query_589097, "oauth_token", newJString(oauthToken))
  add(query_589097, "userIp", newJString(userIp))
  add(query_589097, "key", newJString(key))
  add(query_589097, "prettyPrint", newJBool(prettyPrint))
  result = call_589095.call(path_589096, query_589097, nil, nil, nil)

var androidpublisherEditsApksUpload* = Call_AndroidpublisherEditsApksUpload_589082(
    name: "androidpublisherEditsApksUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksUpload_589083,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksUpload_589084, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksList_589066 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApksList_589068(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsApksList_589067(path: JsonNode; query: JsonNode;
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
  var valid_589069 = path.getOrDefault("packageName")
  valid_589069 = validateParameter(valid_589069, JString, required = true,
                                 default = nil)
  if valid_589069 != nil:
    section.add "packageName", valid_589069
  var valid_589070 = path.getOrDefault("editId")
  valid_589070 = validateParameter(valid_589070, JString, required = true,
                                 default = nil)
  if valid_589070 != nil:
    section.add "editId", valid_589070
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
  var valid_589071 = query.getOrDefault("fields")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "fields", valid_589071
  var valid_589072 = query.getOrDefault("quotaUser")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "quotaUser", valid_589072
  var valid_589073 = query.getOrDefault("alt")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = newJString("json"))
  if valid_589073 != nil:
    section.add "alt", valid_589073
  var valid_589074 = query.getOrDefault("oauth_token")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "oauth_token", valid_589074
  var valid_589075 = query.getOrDefault("userIp")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "userIp", valid_589075
  var valid_589076 = query.getOrDefault("key")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "key", valid_589076
  var valid_589077 = query.getOrDefault("prettyPrint")
  valid_589077 = validateParameter(valid_589077, JBool, required = false,
                                 default = newJBool(true))
  if valid_589077 != nil:
    section.add "prettyPrint", valid_589077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589078: Call_AndroidpublisherEditsApksList_589066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_589078.validator(path, query, header, formData, body)
  let scheme = call_589078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589078.url(scheme.get, call_589078.host, call_589078.base,
                         call_589078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589078, url, valid)

proc call*(call_589079: Call_AndroidpublisherEditsApksList_589066;
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
  var path_589080 = newJObject()
  var query_589081 = newJObject()
  add(query_589081, "fields", newJString(fields))
  add(path_589080, "packageName", newJString(packageName))
  add(query_589081, "quotaUser", newJString(quotaUser))
  add(query_589081, "alt", newJString(alt))
  add(path_589080, "editId", newJString(editId))
  add(query_589081, "oauth_token", newJString(oauthToken))
  add(query_589081, "userIp", newJString(userIp))
  add(query_589081, "key", newJString(key))
  add(query_589081, "prettyPrint", newJBool(prettyPrint))
  result = call_589079.call(path_589080, query_589081, nil, nil, nil)

var androidpublisherEditsApksList* = Call_AndroidpublisherEditsApksList_589066(
    name: "androidpublisherEditsApksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksList_589067,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksList_589068, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksAddexternallyhosted_589098 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsApksAddexternallyhosted_589100(protocol: Scheme;
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

proc validate_AndroidpublisherEditsApksAddexternallyhosted_589099(path: JsonNode;
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
  var valid_589101 = path.getOrDefault("packageName")
  valid_589101 = validateParameter(valid_589101, JString, required = true,
                                 default = nil)
  if valid_589101 != nil:
    section.add "packageName", valid_589101
  var valid_589102 = path.getOrDefault("editId")
  valid_589102 = validateParameter(valid_589102, JString, required = true,
                                 default = nil)
  if valid_589102 != nil:
    section.add "editId", valid_589102
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
  var valid_589103 = query.getOrDefault("fields")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "fields", valid_589103
  var valid_589104 = query.getOrDefault("quotaUser")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "quotaUser", valid_589104
  var valid_589105 = query.getOrDefault("alt")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = newJString("json"))
  if valid_589105 != nil:
    section.add "alt", valid_589105
  var valid_589106 = query.getOrDefault("oauth_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "oauth_token", valid_589106
  var valid_589107 = query.getOrDefault("userIp")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "userIp", valid_589107
  var valid_589108 = query.getOrDefault("key")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "key", valid_589108
  var valid_589109 = query.getOrDefault("prettyPrint")
  valid_589109 = validateParameter(valid_589109, JBool, required = false,
                                 default = newJBool(true))
  if valid_589109 != nil:
    section.add "prettyPrint", valid_589109
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

proc call*(call_589111: Call_AndroidpublisherEditsApksAddexternallyhosted_589098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ## 
  let valid = call_589111.validator(path, query, header, formData, body)
  let scheme = call_589111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589111.url(scheme.get, call_589111.host, call_589111.base,
                         call_589111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589111, url, valid)

proc call*(call_589112: Call_AndroidpublisherEditsApksAddexternallyhosted_589098;
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
  var path_589113 = newJObject()
  var query_589114 = newJObject()
  var body_589115 = newJObject()
  add(query_589114, "fields", newJString(fields))
  add(path_589113, "packageName", newJString(packageName))
  add(query_589114, "quotaUser", newJString(quotaUser))
  add(query_589114, "alt", newJString(alt))
  add(path_589113, "editId", newJString(editId))
  add(query_589114, "oauth_token", newJString(oauthToken))
  add(query_589114, "userIp", newJString(userIp))
  add(query_589114, "key", newJString(key))
  if body != nil:
    body_589115 = body
  add(query_589114, "prettyPrint", newJBool(prettyPrint))
  result = call_589112.call(path_589113, query_589114, nil, nil, body_589115)

var androidpublisherEditsApksAddexternallyhosted* = Call_AndroidpublisherEditsApksAddexternallyhosted_589098(
    name: "androidpublisherEditsApksAddexternallyhosted",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/externallyHosted",
    validator: validate_AndroidpublisherEditsApksAddexternallyhosted_589099,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksAddexternallyhosted_589100,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDeobfuscationfilesUpload_589116 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsDeobfuscationfilesUpload_589118(protocol: Scheme;
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

proc validate_AndroidpublisherEditsDeobfuscationfilesUpload_589117(
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
  var valid_589119 = path.getOrDefault("packageName")
  valid_589119 = validateParameter(valid_589119, JString, required = true,
                                 default = nil)
  if valid_589119 != nil:
    section.add "packageName", valid_589119
  var valid_589120 = path.getOrDefault("deobfuscationFileType")
  valid_589120 = validateParameter(valid_589120, JString, required = true,
                                 default = newJString("proguard"))
  if valid_589120 != nil:
    section.add "deobfuscationFileType", valid_589120
  var valid_589121 = path.getOrDefault("editId")
  valid_589121 = validateParameter(valid_589121, JString, required = true,
                                 default = nil)
  if valid_589121 != nil:
    section.add "editId", valid_589121
  var valid_589122 = path.getOrDefault("apkVersionCode")
  valid_589122 = validateParameter(valid_589122, JInt, required = true, default = nil)
  if valid_589122 != nil:
    section.add "apkVersionCode", valid_589122
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
  var valid_589123 = query.getOrDefault("fields")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "fields", valid_589123
  var valid_589124 = query.getOrDefault("quotaUser")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "quotaUser", valid_589124
  var valid_589125 = query.getOrDefault("alt")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = newJString("json"))
  if valid_589125 != nil:
    section.add "alt", valid_589125
  var valid_589126 = query.getOrDefault("oauth_token")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "oauth_token", valid_589126
  var valid_589127 = query.getOrDefault("userIp")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "userIp", valid_589127
  var valid_589128 = query.getOrDefault("key")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "key", valid_589128
  var valid_589129 = query.getOrDefault("prettyPrint")
  valid_589129 = validateParameter(valid_589129, JBool, required = false,
                                 default = newJBool(true))
  if valid_589129 != nil:
    section.add "prettyPrint", valid_589129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589130: Call_AndroidpublisherEditsDeobfuscationfilesUpload_589116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ## 
  let valid = call_589130.validator(path, query, header, formData, body)
  let scheme = call_589130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589130.url(scheme.get, call_589130.host, call_589130.base,
                         call_589130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589130, url, valid)

proc call*(call_589131: Call_AndroidpublisherEditsDeobfuscationfilesUpload_589116;
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
  var path_589132 = newJObject()
  var query_589133 = newJObject()
  add(query_589133, "fields", newJString(fields))
  add(path_589132, "packageName", newJString(packageName))
  add(query_589133, "quotaUser", newJString(quotaUser))
  add(path_589132, "deobfuscationFileType", newJString(deobfuscationFileType))
  add(query_589133, "alt", newJString(alt))
  add(path_589132, "editId", newJString(editId))
  add(query_589133, "oauth_token", newJString(oauthToken))
  add(query_589133, "userIp", newJString(userIp))
  add(query_589133, "key", newJString(key))
  add(query_589133, "prettyPrint", newJBool(prettyPrint))
  add(path_589132, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589131.call(path_589132, query_589133, nil, nil, nil)

var androidpublisherEditsDeobfuscationfilesUpload* = Call_AndroidpublisherEditsDeobfuscationfilesUpload_589116(
    name: "androidpublisherEditsDeobfuscationfilesUpload",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType}",
    validator: validate_AndroidpublisherEditsDeobfuscationfilesUpload_589117,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDeobfuscationfilesUpload_589118,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpdate_589152 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsExpansionfilesUpdate_589154(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesUpdate_589153(path: JsonNode;
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
  var valid_589155 = path.getOrDefault("packageName")
  valid_589155 = validateParameter(valid_589155, JString, required = true,
                                 default = nil)
  if valid_589155 != nil:
    section.add "packageName", valid_589155
  var valid_589156 = path.getOrDefault("editId")
  valid_589156 = validateParameter(valid_589156, JString, required = true,
                                 default = nil)
  if valid_589156 != nil:
    section.add "editId", valid_589156
  var valid_589157 = path.getOrDefault("expansionFileType")
  valid_589157 = validateParameter(valid_589157, JString, required = true,
                                 default = newJString("main"))
  if valid_589157 != nil:
    section.add "expansionFileType", valid_589157
  var valid_589158 = path.getOrDefault("apkVersionCode")
  valid_589158 = validateParameter(valid_589158, JInt, required = true, default = nil)
  if valid_589158 != nil:
    section.add "apkVersionCode", valid_589158
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
  var valid_589159 = query.getOrDefault("fields")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "fields", valid_589159
  var valid_589160 = query.getOrDefault("quotaUser")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "quotaUser", valid_589160
  var valid_589161 = query.getOrDefault("alt")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = newJString("json"))
  if valid_589161 != nil:
    section.add "alt", valid_589161
  var valid_589162 = query.getOrDefault("oauth_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "oauth_token", valid_589162
  var valid_589163 = query.getOrDefault("userIp")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "userIp", valid_589163
  var valid_589164 = query.getOrDefault("key")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "key", valid_589164
  var valid_589165 = query.getOrDefault("prettyPrint")
  valid_589165 = validateParameter(valid_589165, JBool, required = false,
                                 default = newJBool(true))
  if valid_589165 != nil:
    section.add "prettyPrint", valid_589165
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

proc call*(call_589167: Call_AndroidpublisherEditsExpansionfilesUpdate_589152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ## 
  let valid = call_589167.validator(path, query, header, formData, body)
  let scheme = call_589167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589167.url(scheme.get, call_589167.host, call_589167.base,
                         call_589167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589167, url, valid)

proc call*(call_589168: Call_AndroidpublisherEditsExpansionfilesUpdate_589152;
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
  var path_589169 = newJObject()
  var query_589170 = newJObject()
  var body_589171 = newJObject()
  add(query_589170, "fields", newJString(fields))
  add(path_589169, "packageName", newJString(packageName))
  add(query_589170, "quotaUser", newJString(quotaUser))
  add(query_589170, "alt", newJString(alt))
  add(path_589169, "editId", newJString(editId))
  add(query_589170, "oauth_token", newJString(oauthToken))
  add(query_589170, "userIp", newJString(userIp))
  add(query_589170, "key", newJString(key))
  add(path_589169, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_589171 = body
  add(query_589170, "prettyPrint", newJBool(prettyPrint))
  add(path_589169, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589168.call(path_589169, query_589170, nil, nil, body_589171)

var androidpublisherEditsExpansionfilesUpdate* = Call_AndroidpublisherEditsExpansionfilesUpdate_589152(
    name: "androidpublisherEditsExpansionfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpdate_589153,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpdate_589154,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpload_589172 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsExpansionfilesUpload_589174(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesUpload_589173(path: JsonNode;
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
  var valid_589175 = path.getOrDefault("packageName")
  valid_589175 = validateParameter(valid_589175, JString, required = true,
                                 default = nil)
  if valid_589175 != nil:
    section.add "packageName", valid_589175
  var valid_589176 = path.getOrDefault("editId")
  valid_589176 = validateParameter(valid_589176, JString, required = true,
                                 default = nil)
  if valid_589176 != nil:
    section.add "editId", valid_589176
  var valid_589177 = path.getOrDefault("expansionFileType")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = newJString("main"))
  if valid_589177 != nil:
    section.add "expansionFileType", valid_589177
  var valid_589178 = path.getOrDefault("apkVersionCode")
  valid_589178 = validateParameter(valid_589178, JInt, required = true, default = nil)
  if valid_589178 != nil:
    section.add "apkVersionCode", valid_589178
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
  var valid_589179 = query.getOrDefault("fields")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "fields", valid_589179
  var valid_589180 = query.getOrDefault("quotaUser")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "quotaUser", valid_589180
  var valid_589181 = query.getOrDefault("alt")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = newJString("json"))
  if valid_589181 != nil:
    section.add "alt", valid_589181
  var valid_589182 = query.getOrDefault("oauth_token")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "oauth_token", valid_589182
  var valid_589183 = query.getOrDefault("userIp")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "userIp", valid_589183
  var valid_589184 = query.getOrDefault("key")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "key", valid_589184
  var valid_589185 = query.getOrDefault("prettyPrint")
  valid_589185 = validateParameter(valid_589185, JBool, required = false,
                                 default = newJBool(true))
  if valid_589185 != nil:
    section.add "prettyPrint", valid_589185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589186: Call_AndroidpublisherEditsExpansionfilesUpload_589172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads and attaches a new Expansion File to the APK specified.
  ## 
  let valid = call_589186.validator(path, query, header, formData, body)
  let scheme = call_589186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589186.url(scheme.get, call_589186.host, call_589186.base,
                         call_589186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589186, url, valid)

proc call*(call_589187: Call_AndroidpublisherEditsExpansionfilesUpload_589172;
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
  var path_589188 = newJObject()
  var query_589189 = newJObject()
  add(query_589189, "fields", newJString(fields))
  add(path_589188, "packageName", newJString(packageName))
  add(query_589189, "quotaUser", newJString(quotaUser))
  add(query_589189, "alt", newJString(alt))
  add(path_589188, "editId", newJString(editId))
  add(query_589189, "oauth_token", newJString(oauthToken))
  add(query_589189, "userIp", newJString(userIp))
  add(query_589189, "key", newJString(key))
  add(path_589188, "expansionFileType", newJString(expansionFileType))
  add(query_589189, "prettyPrint", newJBool(prettyPrint))
  add(path_589188, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589187.call(path_589188, query_589189, nil, nil, nil)

var androidpublisherEditsExpansionfilesUpload* = Call_AndroidpublisherEditsExpansionfilesUpload_589172(
    name: "androidpublisherEditsExpansionfilesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpload_589173,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpload_589174,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesGet_589134 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsExpansionfilesGet_589136(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesGet_589135(path: JsonNode;
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
  var valid_589137 = path.getOrDefault("packageName")
  valid_589137 = validateParameter(valid_589137, JString, required = true,
                                 default = nil)
  if valid_589137 != nil:
    section.add "packageName", valid_589137
  var valid_589138 = path.getOrDefault("editId")
  valid_589138 = validateParameter(valid_589138, JString, required = true,
                                 default = nil)
  if valid_589138 != nil:
    section.add "editId", valid_589138
  var valid_589139 = path.getOrDefault("expansionFileType")
  valid_589139 = validateParameter(valid_589139, JString, required = true,
                                 default = newJString("main"))
  if valid_589139 != nil:
    section.add "expansionFileType", valid_589139
  var valid_589140 = path.getOrDefault("apkVersionCode")
  valid_589140 = validateParameter(valid_589140, JInt, required = true, default = nil)
  if valid_589140 != nil:
    section.add "apkVersionCode", valid_589140
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
  var valid_589141 = query.getOrDefault("fields")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "fields", valid_589141
  var valid_589142 = query.getOrDefault("quotaUser")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "quotaUser", valid_589142
  var valid_589143 = query.getOrDefault("alt")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = newJString("json"))
  if valid_589143 != nil:
    section.add "alt", valid_589143
  var valid_589144 = query.getOrDefault("oauth_token")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "oauth_token", valid_589144
  var valid_589145 = query.getOrDefault("userIp")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "userIp", valid_589145
  var valid_589146 = query.getOrDefault("key")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "key", valid_589146
  var valid_589147 = query.getOrDefault("prettyPrint")
  valid_589147 = validateParameter(valid_589147, JBool, required = false,
                                 default = newJBool(true))
  if valid_589147 != nil:
    section.add "prettyPrint", valid_589147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589148: Call_AndroidpublisherEditsExpansionfilesGet_589134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the Expansion File configuration for the APK specified.
  ## 
  let valid = call_589148.validator(path, query, header, formData, body)
  let scheme = call_589148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589148.url(scheme.get, call_589148.host, call_589148.base,
                         call_589148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589148, url, valid)

proc call*(call_589149: Call_AndroidpublisherEditsExpansionfilesGet_589134;
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
  var path_589150 = newJObject()
  var query_589151 = newJObject()
  add(query_589151, "fields", newJString(fields))
  add(path_589150, "packageName", newJString(packageName))
  add(query_589151, "quotaUser", newJString(quotaUser))
  add(query_589151, "alt", newJString(alt))
  add(path_589150, "editId", newJString(editId))
  add(query_589151, "oauth_token", newJString(oauthToken))
  add(query_589151, "userIp", newJString(userIp))
  add(query_589151, "key", newJString(key))
  add(path_589150, "expansionFileType", newJString(expansionFileType))
  add(query_589151, "prettyPrint", newJBool(prettyPrint))
  add(path_589150, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589149.call(path_589150, query_589151, nil, nil, nil)

var androidpublisherEditsExpansionfilesGet* = Call_AndroidpublisherEditsExpansionfilesGet_589134(
    name: "androidpublisherEditsExpansionfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesGet_589135,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesGet_589136,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesPatch_589190 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsExpansionfilesPatch_589192(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesPatch_589191(path: JsonNode;
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
  var valid_589193 = path.getOrDefault("packageName")
  valid_589193 = validateParameter(valid_589193, JString, required = true,
                                 default = nil)
  if valid_589193 != nil:
    section.add "packageName", valid_589193
  var valid_589194 = path.getOrDefault("editId")
  valid_589194 = validateParameter(valid_589194, JString, required = true,
                                 default = nil)
  if valid_589194 != nil:
    section.add "editId", valid_589194
  var valid_589195 = path.getOrDefault("expansionFileType")
  valid_589195 = validateParameter(valid_589195, JString, required = true,
                                 default = newJString("main"))
  if valid_589195 != nil:
    section.add "expansionFileType", valid_589195
  var valid_589196 = path.getOrDefault("apkVersionCode")
  valid_589196 = validateParameter(valid_589196, JInt, required = true, default = nil)
  if valid_589196 != nil:
    section.add "apkVersionCode", valid_589196
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
  var valid_589197 = query.getOrDefault("fields")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "fields", valid_589197
  var valid_589198 = query.getOrDefault("quotaUser")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "quotaUser", valid_589198
  var valid_589199 = query.getOrDefault("alt")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = newJString("json"))
  if valid_589199 != nil:
    section.add "alt", valid_589199
  var valid_589200 = query.getOrDefault("oauth_token")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "oauth_token", valid_589200
  var valid_589201 = query.getOrDefault("userIp")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "userIp", valid_589201
  var valid_589202 = query.getOrDefault("key")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "key", valid_589202
  var valid_589203 = query.getOrDefault("prettyPrint")
  valid_589203 = validateParameter(valid_589203, JBool, required = false,
                                 default = newJBool(true))
  if valid_589203 != nil:
    section.add "prettyPrint", valid_589203
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

proc call*(call_589205: Call_AndroidpublisherEditsExpansionfilesPatch_589190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ## 
  let valid = call_589205.validator(path, query, header, formData, body)
  let scheme = call_589205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589205.url(scheme.get, call_589205.host, call_589205.base,
                         call_589205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589205, url, valid)

proc call*(call_589206: Call_AndroidpublisherEditsExpansionfilesPatch_589190;
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
  var path_589207 = newJObject()
  var query_589208 = newJObject()
  var body_589209 = newJObject()
  add(query_589208, "fields", newJString(fields))
  add(path_589207, "packageName", newJString(packageName))
  add(query_589208, "quotaUser", newJString(quotaUser))
  add(query_589208, "alt", newJString(alt))
  add(path_589207, "editId", newJString(editId))
  add(query_589208, "oauth_token", newJString(oauthToken))
  add(query_589208, "userIp", newJString(userIp))
  add(query_589208, "key", newJString(key))
  add(path_589207, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_589209 = body
  add(query_589208, "prettyPrint", newJBool(prettyPrint))
  add(path_589207, "apkVersionCode", newJInt(apkVersionCode))
  result = call_589206.call(path_589207, query_589208, nil, nil, body_589209)

var androidpublisherEditsExpansionfilesPatch* = Call_AndroidpublisherEditsExpansionfilesPatch_589190(
    name: "androidpublisherEditsExpansionfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesPatch_589191,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesPatch_589192,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesUpload_589226 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsBundlesUpload_589228(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsBundlesUpload_589227(path: JsonNode;
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
  var valid_589229 = path.getOrDefault("packageName")
  valid_589229 = validateParameter(valid_589229, JString, required = true,
                                 default = nil)
  if valid_589229 != nil:
    section.add "packageName", valid_589229
  var valid_589230 = path.getOrDefault("editId")
  valid_589230 = validateParameter(valid_589230, JString, required = true,
                                 default = nil)
  if valid_589230 != nil:
    section.add "editId", valid_589230
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
  var valid_589231 = query.getOrDefault("fields")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "fields", valid_589231
  var valid_589232 = query.getOrDefault("quotaUser")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "quotaUser", valid_589232
  var valid_589233 = query.getOrDefault("alt")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = newJString("json"))
  if valid_589233 != nil:
    section.add "alt", valid_589233
  var valid_589234 = query.getOrDefault("oauth_token")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "oauth_token", valid_589234
  var valid_589235 = query.getOrDefault("userIp")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "userIp", valid_589235
  var valid_589236 = query.getOrDefault("key")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "key", valid_589236
  var valid_589237 = query.getOrDefault("prettyPrint")
  valid_589237 = validateParameter(valid_589237, JBool, required = false,
                                 default = newJBool(true))
  if valid_589237 != nil:
    section.add "prettyPrint", valid_589237
  var valid_589238 = query.getOrDefault("ackBundleInstallationWarning")
  valid_589238 = validateParameter(valid_589238, JBool, required = false, default = nil)
  if valid_589238 != nil:
    section.add "ackBundleInstallationWarning", valid_589238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589239: Call_AndroidpublisherEditsBundlesUpload_589226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_589239.validator(path, query, header, formData, body)
  let scheme = call_589239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589239.url(scheme.get, call_589239.host, call_589239.base,
                         call_589239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589239, url, valid)

proc call*(call_589240: Call_AndroidpublisherEditsBundlesUpload_589226;
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
  var path_589241 = newJObject()
  var query_589242 = newJObject()
  add(query_589242, "fields", newJString(fields))
  add(path_589241, "packageName", newJString(packageName))
  add(query_589242, "quotaUser", newJString(quotaUser))
  add(query_589242, "alt", newJString(alt))
  add(path_589241, "editId", newJString(editId))
  add(query_589242, "oauth_token", newJString(oauthToken))
  add(query_589242, "userIp", newJString(userIp))
  add(query_589242, "key", newJString(key))
  add(query_589242, "prettyPrint", newJBool(prettyPrint))
  add(query_589242, "ackBundleInstallationWarning",
      newJBool(ackBundleInstallationWarning))
  result = call_589240.call(path_589241, query_589242, nil, nil, nil)

var androidpublisherEditsBundlesUpload* = Call_AndroidpublisherEditsBundlesUpload_589226(
    name: "androidpublisherEditsBundlesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesUpload_589227,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsBundlesUpload_589228, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesList_589210 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsBundlesList_589212(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsBundlesList_589211(path: JsonNode;
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
  var valid_589213 = path.getOrDefault("packageName")
  valid_589213 = validateParameter(valid_589213, JString, required = true,
                                 default = nil)
  if valid_589213 != nil:
    section.add "packageName", valid_589213
  var valid_589214 = path.getOrDefault("editId")
  valid_589214 = validateParameter(valid_589214, JString, required = true,
                                 default = nil)
  if valid_589214 != nil:
    section.add "editId", valid_589214
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
  var valid_589215 = query.getOrDefault("fields")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "fields", valid_589215
  var valid_589216 = query.getOrDefault("quotaUser")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "quotaUser", valid_589216
  var valid_589217 = query.getOrDefault("alt")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = newJString("json"))
  if valid_589217 != nil:
    section.add "alt", valid_589217
  var valid_589218 = query.getOrDefault("oauth_token")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "oauth_token", valid_589218
  var valid_589219 = query.getOrDefault("userIp")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "userIp", valid_589219
  var valid_589220 = query.getOrDefault("key")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "key", valid_589220
  var valid_589221 = query.getOrDefault("prettyPrint")
  valid_589221 = validateParameter(valid_589221, JBool, required = false,
                                 default = newJBool(true))
  if valid_589221 != nil:
    section.add "prettyPrint", valid_589221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589222: Call_AndroidpublisherEditsBundlesList_589210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_589222.validator(path, query, header, formData, body)
  let scheme = call_589222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589222.url(scheme.get, call_589222.host, call_589222.base,
                         call_589222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589222, url, valid)

proc call*(call_589223: Call_AndroidpublisherEditsBundlesList_589210;
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
  var path_589224 = newJObject()
  var query_589225 = newJObject()
  add(query_589225, "fields", newJString(fields))
  add(path_589224, "packageName", newJString(packageName))
  add(query_589225, "quotaUser", newJString(quotaUser))
  add(query_589225, "alt", newJString(alt))
  add(path_589224, "editId", newJString(editId))
  add(query_589225, "oauth_token", newJString(oauthToken))
  add(query_589225, "userIp", newJString(userIp))
  add(query_589225, "key", newJString(key))
  add(query_589225, "prettyPrint", newJBool(prettyPrint))
  result = call_589223.call(path_589224, query_589225, nil, nil, nil)

var androidpublisherEditsBundlesList* = Call_AndroidpublisherEditsBundlesList_589210(
    name: "androidpublisherEditsBundlesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesList_589211,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsBundlesList_589212, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsUpdate_589259 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsDetailsUpdate_589261(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsUpdate_589260(path: JsonNode;
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
  var valid_589262 = path.getOrDefault("packageName")
  valid_589262 = validateParameter(valid_589262, JString, required = true,
                                 default = nil)
  if valid_589262 != nil:
    section.add "packageName", valid_589262
  var valid_589263 = path.getOrDefault("editId")
  valid_589263 = validateParameter(valid_589263, JString, required = true,
                                 default = nil)
  if valid_589263 != nil:
    section.add "editId", valid_589263
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
  var valid_589264 = query.getOrDefault("fields")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "fields", valid_589264
  var valid_589265 = query.getOrDefault("quotaUser")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "quotaUser", valid_589265
  var valid_589266 = query.getOrDefault("alt")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = newJString("json"))
  if valid_589266 != nil:
    section.add "alt", valid_589266
  var valid_589267 = query.getOrDefault("oauth_token")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "oauth_token", valid_589267
  var valid_589268 = query.getOrDefault("userIp")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "userIp", valid_589268
  var valid_589269 = query.getOrDefault("key")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "key", valid_589269
  var valid_589270 = query.getOrDefault("prettyPrint")
  valid_589270 = validateParameter(valid_589270, JBool, required = false,
                                 default = newJBool(true))
  if valid_589270 != nil:
    section.add "prettyPrint", valid_589270
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

proc call*(call_589272: Call_AndroidpublisherEditsDetailsUpdate_589259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit.
  ## 
  let valid = call_589272.validator(path, query, header, formData, body)
  let scheme = call_589272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589272.url(scheme.get, call_589272.host, call_589272.base,
                         call_589272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589272, url, valid)

proc call*(call_589273: Call_AndroidpublisherEditsDetailsUpdate_589259;
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
  var path_589274 = newJObject()
  var query_589275 = newJObject()
  var body_589276 = newJObject()
  add(query_589275, "fields", newJString(fields))
  add(path_589274, "packageName", newJString(packageName))
  add(query_589275, "quotaUser", newJString(quotaUser))
  add(query_589275, "alt", newJString(alt))
  add(path_589274, "editId", newJString(editId))
  add(query_589275, "oauth_token", newJString(oauthToken))
  add(query_589275, "userIp", newJString(userIp))
  add(query_589275, "key", newJString(key))
  if body != nil:
    body_589276 = body
  add(query_589275, "prettyPrint", newJBool(prettyPrint))
  result = call_589273.call(path_589274, query_589275, nil, nil, body_589276)

var androidpublisherEditsDetailsUpdate* = Call_AndroidpublisherEditsDetailsUpdate_589259(
    name: "androidpublisherEditsDetailsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsUpdate_589260,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsUpdate_589261, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsGet_589243 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsDetailsGet_589245(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsGet_589244(path: JsonNode;
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
  var valid_589246 = path.getOrDefault("packageName")
  valid_589246 = validateParameter(valid_589246, JString, required = true,
                                 default = nil)
  if valid_589246 != nil:
    section.add "packageName", valid_589246
  var valid_589247 = path.getOrDefault("editId")
  valid_589247 = validateParameter(valid_589247, JString, required = true,
                                 default = nil)
  if valid_589247 != nil:
    section.add "editId", valid_589247
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

proc call*(call_589255: Call_AndroidpublisherEditsDetailsGet_589243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ## 
  let valid = call_589255.validator(path, query, header, formData, body)
  let scheme = call_589255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589255.url(scheme.get, call_589255.host, call_589255.base,
                         call_589255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589255, url, valid)

proc call*(call_589256: Call_AndroidpublisherEditsDetailsGet_589243;
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
  var path_589257 = newJObject()
  var query_589258 = newJObject()
  add(query_589258, "fields", newJString(fields))
  add(path_589257, "packageName", newJString(packageName))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(path_589257, "editId", newJString(editId))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(query_589258, "userIp", newJString(userIp))
  add(query_589258, "key", newJString(key))
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  result = call_589256.call(path_589257, query_589258, nil, nil, nil)

var androidpublisherEditsDetailsGet* = Call_AndroidpublisherEditsDetailsGet_589243(
    name: "androidpublisherEditsDetailsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsGet_589244,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsGet_589245, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsPatch_589277 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsDetailsPatch_589279(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsPatch_589278(path: JsonNode;
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
  var valid_589280 = path.getOrDefault("packageName")
  valid_589280 = validateParameter(valid_589280, JString, required = true,
                                 default = nil)
  if valid_589280 != nil:
    section.add "packageName", valid_589280
  var valid_589281 = path.getOrDefault("editId")
  valid_589281 = validateParameter(valid_589281, JString, required = true,
                                 default = nil)
  if valid_589281 != nil:
    section.add "editId", valid_589281
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
  var valid_589282 = query.getOrDefault("fields")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "fields", valid_589282
  var valid_589283 = query.getOrDefault("quotaUser")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "quotaUser", valid_589283
  var valid_589284 = query.getOrDefault("alt")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = newJString("json"))
  if valid_589284 != nil:
    section.add "alt", valid_589284
  var valid_589285 = query.getOrDefault("oauth_token")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "oauth_token", valid_589285
  var valid_589286 = query.getOrDefault("userIp")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "userIp", valid_589286
  var valid_589287 = query.getOrDefault("key")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "key", valid_589287
  var valid_589288 = query.getOrDefault("prettyPrint")
  valid_589288 = validateParameter(valid_589288, JBool, required = false,
                                 default = newJBool(true))
  if valid_589288 != nil:
    section.add "prettyPrint", valid_589288
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

proc call*(call_589290: Call_AndroidpublisherEditsDetailsPatch_589277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit. This method supports patch semantics.
  ## 
  let valid = call_589290.validator(path, query, header, formData, body)
  let scheme = call_589290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589290.url(scheme.get, call_589290.host, call_589290.base,
                         call_589290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589290, url, valid)

proc call*(call_589291: Call_AndroidpublisherEditsDetailsPatch_589277;
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
  var path_589292 = newJObject()
  var query_589293 = newJObject()
  var body_589294 = newJObject()
  add(query_589293, "fields", newJString(fields))
  add(path_589292, "packageName", newJString(packageName))
  add(query_589293, "quotaUser", newJString(quotaUser))
  add(query_589293, "alt", newJString(alt))
  add(path_589292, "editId", newJString(editId))
  add(query_589293, "oauth_token", newJString(oauthToken))
  add(query_589293, "userIp", newJString(userIp))
  add(query_589293, "key", newJString(key))
  if body != nil:
    body_589294 = body
  add(query_589293, "prettyPrint", newJBool(prettyPrint))
  result = call_589291.call(path_589292, query_589293, nil, nil, body_589294)

var androidpublisherEditsDetailsPatch* = Call_AndroidpublisherEditsDetailsPatch_589277(
    name: "androidpublisherEditsDetailsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsPatch_589278,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsPatch_589279, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsList_589295 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsList_589297(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsList_589296(path: JsonNode;
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
  var valid_589298 = path.getOrDefault("packageName")
  valid_589298 = validateParameter(valid_589298, JString, required = true,
                                 default = nil)
  if valid_589298 != nil:
    section.add "packageName", valid_589298
  var valid_589299 = path.getOrDefault("editId")
  valid_589299 = validateParameter(valid_589299, JString, required = true,
                                 default = nil)
  if valid_589299 != nil:
    section.add "editId", valid_589299
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
  var valid_589300 = query.getOrDefault("fields")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "fields", valid_589300
  var valid_589301 = query.getOrDefault("quotaUser")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "quotaUser", valid_589301
  var valid_589302 = query.getOrDefault("alt")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = newJString("json"))
  if valid_589302 != nil:
    section.add "alt", valid_589302
  var valid_589303 = query.getOrDefault("oauth_token")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "oauth_token", valid_589303
  var valid_589304 = query.getOrDefault("userIp")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "userIp", valid_589304
  var valid_589305 = query.getOrDefault("key")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "key", valid_589305
  var valid_589306 = query.getOrDefault("prettyPrint")
  valid_589306 = validateParameter(valid_589306, JBool, required = false,
                                 default = newJBool(true))
  if valid_589306 != nil:
    section.add "prettyPrint", valid_589306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589307: Call_AndroidpublisherEditsListingsList_589295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the localized store listings attached to this edit.
  ## 
  let valid = call_589307.validator(path, query, header, formData, body)
  let scheme = call_589307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589307.url(scheme.get, call_589307.host, call_589307.base,
                         call_589307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589307, url, valid)

proc call*(call_589308: Call_AndroidpublisherEditsListingsList_589295;
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
  var path_589309 = newJObject()
  var query_589310 = newJObject()
  add(query_589310, "fields", newJString(fields))
  add(path_589309, "packageName", newJString(packageName))
  add(query_589310, "quotaUser", newJString(quotaUser))
  add(query_589310, "alt", newJString(alt))
  add(path_589309, "editId", newJString(editId))
  add(query_589310, "oauth_token", newJString(oauthToken))
  add(query_589310, "userIp", newJString(userIp))
  add(query_589310, "key", newJString(key))
  add(query_589310, "prettyPrint", newJBool(prettyPrint))
  result = call_589308.call(path_589309, query_589310, nil, nil, nil)

var androidpublisherEditsListingsList* = Call_AndroidpublisherEditsListingsList_589295(
    name: "androidpublisherEditsListingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsList_589296,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsList_589297, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDeleteall_589311 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsDeleteall_589313(protocol: Scheme;
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

proc validate_AndroidpublisherEditsListingsDeleteall_589312(path: JsonNode;
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
  var valid_589314 = path.getOrDefault("packageName")
  valid_589314 = validateParameter(valid_589314, JString, required = true,
                                 default = nil)
  if valid_589314 != nil:
    section.add "packageName", valid_589314
  var valid_589315 = path.getOrDefault("editId")
  valid_589315 = validateParameter(valid_589315, JString, required = true,
                                 default = nil)
  if valid_589315 != nil:
    section.add "editId", valid_589315
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
  var valid_589316 = query.getOrDefault("fields")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "fields", valid_589316
  var valid_589317 = query.getOrDefault("quotaUser")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "quotaUser", valid_589317
  var valid_589318 = query.getOrDefault("alt")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = newJString("json"))
  if valid_589318 != nil:
    section.add "alt", valid_589318
  var valid_589319 = query.getOrDefault("oauth_token")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "oauth_token", valid_589319
  var valid_589320 = query.getOrDefault("userIp")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "userIp", valid_589320
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

proc call*(call_589323: Call_AndroidpublisherEditsListingsDeleteall_589311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all localized listings from an edit.
  ## 
  let valid = call_589323.validator(path, query, header, formData, body)
  let scheme = call_589323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589323.url(scheme.get, call_589323.host, call_589323.base,
                         call_589323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589323, url, valid)

proc call*(call_589324: Call_AndroidpublisherEditsListingsDeleteall_589311;
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
  var path_589325 = newJObject()
  var query_589326 = newJObject()
  add(query_589326, "fields", newJString(fields))
  add(path_589325, "packageName", newJString(packageName))
  add(query_589326, "quotaUser", newJString(quotaUser))
  add(query_589326, "alt", newJString(alt))
  add(path_589325, "editId", newJString(editId))
  add(query_589326, "oauth_token", newJString(oauthToken))
  add(query_589326, "userIp", newJString(userIp))
  add(query_589326, "key", newJString(key))
  add(query_589326, "prettyPrint", newJBool(prettyPrint))
  result = call_589324.call(path_589325, query_589326, nil, nil, nil)

var androidpublisherEditsListingsDeleteall* = Call_AndroidpublisherEditsListingsDeleteall_589311(
    name: "androidpublisherEditsListingsDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsDeleteall_589312,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsDeleteall_589313,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsUpdate_589344 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsUpdate_589346(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsUpdate_589345(path: JsonNode;
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
  var valid_589347 = path.getOrDefault("packageName")
  valid_589347 = validateParameter(valid_589347, JString, required = true,
                                 default = nil)
  if valid_589347 != nil:
    section.add "packageName", valid_589347
  var valid_589348 = path.getOrDefault("editId")
  valid_589348 = validateParameter(valid_589348, JString, required = true,
                                 default = nil)
  if valid_589348 != nil:
    section.add "editId", valid_589348
  var valid_589349 = path.getOrDefault("language")
  valid_589349 = validateParameter(valid_589349, JString, required = true,
                                 default = nil)
  if valid_589349 != nil:
    section.add "language", valid_589349
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
  var valid_589350 = query.getOrDefault("fields")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "fields", valid_589350
  var valid_589351 = query.getOrDefault("quotaUser")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "quotaUser", valid_589351
  var valid_589352 = query.getOrDefault("alt")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = newJString("json"))
  if valid_589352 != nil:
    section.add "alt", valid_589352
  var valid_589353 = query.getOrDefault("oauth_token")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "oauth_token", valid_589353
  var valid_589354 = query.getOrDefault("userIp")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "userIp", valid_589354
  var valid_589355 = query.getOrDefault("key")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "key", valid_589355
  var valid_589356 = query.getOrDefault("prettyPrint")
  valid_589356 = validateParameter(valid_589356, JBool, required = false,
                                 default = newJBool(true))
  if valid_589356 != nil:
    section.add "prettyPrint", valid_589356
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

proc call*(call_589358: Call_AndroidpublisherEditsListingsUpdate_589344;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing.
  ## 
  let valid = call_589358.validator(path, query, header, formData, body)
  let scheme = call_589358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589358.url(scheme.get, call_589358.host, call_589358.base,
                         call_589358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589358, url, valid)

proc call*(call_589359: Call_AndroidpublisherEditsListingsUpdate_589344;
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
  var path_589360 = newJObject()
  var query_589361 = newJObject()
  var body_589362 = newJObject()
  add(query_589361, "fields", newJString(fields))
  add(path_589360, "packageName", newJString(packageName))
  add(query_589361, "quotaUser", newJString(quotaUser))
  add(query_589361, "alt", newJString(alt))
  add(path_589360, "editId", newJString(editId))
  add(query_589361, "oauth_token", newJString(oauthToken))
  add(path_589360, "language", newJString(language))
  add(query_589361, "userIp", newJString(userIp))
  add(query_589361, "key", newJString(key))
  if body != nil:
    body_589362 = body
  add(query_589361, "prettyPrint", newJBool(prettyPrint))
  result = call_589359.call(path_589360, query_589361, nil, nil, body_589362)

var androidpublisherEditsListingsUpdate* = Call_AndroidpublisherEditsListingsUpdate_589344(
    name: "androidpublisherEditsListingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsUpdate_589345,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsUpdate_589346, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsGet_589327 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsGet_589329(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsGet_589328(path: JsonNode;
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
  var valid_589330 = path.getOrDefault("packageName")
  valid_589330 = validateParameter(valid_589330, JString, required = true,
                                 default = nil)
  if valid_589330 != nil:
    section.add "packageName", valid_589330
  var valid_589331 = path.getOrDefault("editId")
  valid_589331 = validateParameter(valid_589331, JString, required = true,
                                 default = nil)
  if valid_589331 != nil:
    section.add "editId", valid_589331
  var valid_589332 = path.getOrDefault("language")
  valid_589332 = validateParameter(valid_589332, JString, required = true,
                                 default = nil)
  if valid_589332 != nil:
    section.add "language", valid_589332
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
  var valid_589333 = query.getOrDefault("fields")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "fields", valid_589333
  var valid_589334 = query.getOrDefault("quotaUser")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "quotaUser", valid_589334
  var valid_589335 = query.getOrDefault("alt")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = newJString("json"))
  if valid_589335 != nil:
    section.add "alt", valid_589335
  var valid_589336 = query.getOrDefault("oauth_token")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "oauth_token", valid_589336
  var valid_589337 = query.getOrDefault("userIp")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "userIp", valid_589337
  var valid_589338 = query.getOrDefault("key")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "key", valid_589338
  var valid_589339 = query.getOrDefault("prettyPrint")
  valid_589339 = validateParameter(valid_589339, JBool, required = false,
                                 default = newJBool(true))
  if valid_589339 != nil:
    section.add "prettyPrint", valid_589339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589340: Call_AndroidpublisherEditsListingsGet_589327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches information about a localized store listing.
  ## 
  let valid = call_589340.validator(path, query, header, formData, body)
  let scheme = call_589340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589340.url(scheme.get, call_589340.host, call_589340.base,
                         call_589340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589340, url, valid)

proc call*(call_589341: Call_AndroidpublisherEditsListingsGet_589327;
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
  var path_589342 = newJObject()
  var query_589343 = newJObject()
  add(query_589343, "fields", newJString(fields))
  add(path_589342, "packageName", newJString(packageName))
  add(query_589343, "quotaUser", newJString(quotaUser))
  add(query_589343, "alt", newJString(alt))
  add(path_589342, "editId", newJString(editId))
  add(query_589343, "oauth_token", newJString(oauthToken))
  add(path_589342, "language", newJString(language))
  add(query_589343, "userIp", newJString(userIp))
  add(query_589343, "key", newJString(key))
  add(query_589343, "prettyPrint", newJBool(prettyPrint))
  result = call_589341.call(path_589342, query_589343, nil, nil, nil)

var androidpublisherEditsListingsGet* = Call_AndroidpublisherEditsListingsGet_589327(
    name: "androidpublisherEditsListingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsGet_589328,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsGet_589329, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsPatch_589380 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsPatch_589382(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsPatch_589381(path: JsonNode;
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
  var valid_589383 = path.getOrDefault("packageName")
  valid_589383 = validateParameter(valid_589383, JString, required = true,
                                 default = nil)
  if valid_589383 != nil:
    section.add "packageName", valid_589383
  var valid_589384 = path.getOrDefault("editId")
  valid_589384 = validateParameter(valid_589384, JString, required = true,
                                 default = nil)
  if valid_589384 != nil:
    section.add "editId", valid_589384
  var valid_589385 = path.getOrDefault("language")
  valid_589385 = validateParameter(valid_589385, JString, required = true,
                                 default = nil)
  if valid_589385 != nil:
    section.add "language", valid_589385
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
  var valid_589386 = query.getOrDefault("fields")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "fields", valid_589386
  var valid_589387 = query.getOrDefault("quotaUser")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "quotaUser", valid_589387
  var valid_589388 = query.getOrDefault("alt")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = newJString("json"))
  if valid_589388 != nil:
    section.add "alt", valid_589388
  var valid_589389 = query.getOrDefault("oauth_token")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "oauth_token", valid_589389
  var valid_589390 = query.getOrDefault("userIp")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "userIp", valid_589390
  var valid_589391 = query.getOrDefault("key")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "key", valid_589391
  var valid_589392 = query.getOrDefault("prettyPrint")
  valid_589392 = validateParameter(valid_589392, JBool, required = false,
                                 default = newJBool(true))
  if valid_589392 != nil:
    section.add "prettyPrint", valid_589392
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

proc call*(call_589394: Call_AndroidpublisherEditsListingsPatch_589380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ## 
  let valid = call_589394.validator(path, query, header, formData, body)
  let scheme = call_589394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589394.url(scheme.get, call_589394.host, call_589394.base,
                         call_589394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589394, url, valid)

proc call*(call_589395: Call_AndroidpublisherEditsListingsPatch_589380;
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
  var path_589396 = newJObject()
  var query_589397 = newJObject()
  var body_589398 = newJObject()
  add(query_589397, "fields", newJString(fields))
  add(path_589396, "packageName", newJString(packageName))
  add(query_589397, "quotaUser", newJString(quotaUser))
  add(query_589397, "alt", newJString(alt))
  add(path_589396, "editId", newJString(editId))
  add(query_589397, "oauth_token", newJString(oauthToken))
  add(path_589396, "language", newJString(language))
  add(query_589397, "userIp", newJString(userIp))
  add(query_589397, "key", newJString(key))
  if body != nil:
    body_589398 = body
  add(query_589397, "prettyPrint", newJBool(prettyPrint))
  result = call_589395.call(path_589396, query_589397, nil, nil, body_589398)

var androidpublisherEditsListingsPatch* = Call_AndroidpublisherEditsListingsPatch_589380(
    name: "androidpublisherEditsListingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsPatch_589381,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsPatch_589382, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDelete_589363 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsListingsDelete_589365(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsDelete_589364(path: JsonNode;
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
  var valid_589366 = path.getOrDefault("packageName")
  valid_589366 = validateParameter(valid_589366, JString, required = true,
                                 default = nil)
  if valid_589366 != nil:
    section.add "packageName", valid_589366
  var valid_589367 = path.getOrDefault("editId")
  valid_589367 = validateParameter(valid_589367, JString, required = true,
                                 default = nil)
  if valid_589367 != nil:
    section.add "editId", valid_589367
  var valid_589368 = path.getOrDefault("language")
  valid_589368 = validateParameter(valid_589368, JString, required = true,
                                 default = nil)
  if valid_589368 != nil:
    section.add "language", valid_589368
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
  var valid_589369 = query.getOrDefault("fields")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "fields", valid_589369
  var valid_589370 = query.getOrDefault("quotaUser")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "quotaUser", valid_589370
  var valid_589371 = query.getOrDefault("alt")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = newJString("json"))
  if valid_589371 != nil:
    section.add "alt", valid_589371
  var valid_589372 = query.getOrDefault("oauth_token")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "oauth_token", valid_589372
  var valid_589373 = query.getOrDefault("userIp")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "userIp", valid_589373
  var valid_589374 = query.getOrDefault("key")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "key", valid_589374
  var valid_589375 = query.getOrDefault("prettyPrint")
  valid_589375 = validateParameter(valid_589375, JBool, required = false,
                                 default = newJBool(true))
  if valid_589375 != nil:
    section.add "prettyPrint", valid_589375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589376: Call_AndroidpublisherEditsListingsDelete_589363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified localized store listing from an edit.
  ## 
  let valid = call_589376.validator(path, query, header, formData, body)
  let scheme = call_589376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589376.url(scheme.get, call_589376.host, call_589376.base,
                         call_589376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589376, url, valid)

proc call*(call_589377: Call_AndroidpublisherEditsListingsDelete_589363;
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
  var path_589378 = newJObject()
  var query_589379 = newJObject()
  add(query_589379, "fields", newJString(fields))
  add(path_589378, "packageName", newJString(packageName))
  add(query_589379, "quotaUser", newJString(quotaUser))
  add(query_589379, "alt", newJString(alt))
  add(path_589378, "editId", newJString(editId))
  add(query_589379, "oauth_token", newJString(oauthToken))
  add(path_589378, "language", newJString(language))
  add(query_589379, "userIp", newJString(userIp))
  add(query_589379, "key", newJString(key))
  add(query_589379, "prettyPrint", newJBool(prettyPrint))
  result = call_589377.call(path_589378, query_589379, nil, nil, nil)

var androidpublisherEditsListingsDelete* = Call_AndroidpublisherEditsListingsDelete_589363(
    name: "androidpublisherEditsListingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsDelete_589364,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsDelete_589365, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesUpload_589417 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsImagesUpload_589419(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesUpload_589418(path: JsonNode;
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
  var valid_589420 = path.getOrDefault("packageName")
  valid_589420 = validateParameter(valid_589420, JString, required = true,
                                 default = nil)
  if valid_589420 != nil:
    section.add "packageName", valid_589420
  var valid_589421 = path.getOrDefault("editId")
  valid_589421 = validateParameter(valid_589421, JString, required = true,
                                 default = nil)
  if valid_589421 != nil:
    section.add "editId", valid_589421
  var valid_589422 = path.getOrDefault("language")
  valid_589422 = validateParameter(valid_589422, JString, required = true,
                                 default = nil)
  if valid_589422 != nil:
    section.add "language", valid_589422
  var valid_589423 = path.getOrDefault("imageType")
  valid_589423 = validateParameter(valid_589423, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_589423 != nil:
    section.add "imageType", valid_589423
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
  var valid_589424 = query.getOrDefault("fields")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "fields", valid_589424
  var valid_589425 = query.getOrDefault("quotaUser")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "quotaUser", valid_589425
  var valid_589426 = query.getOrDefault("alt")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = newJString("json"))
  if valid_589426 != nil:
    section.add "alt", valid_589426
  var valid_589427 = query.getOrDefault("oauth_token")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = nil)
  if valid_589427 != nil:
    section.add "oauth_token", valid_589427
  var valid_589428 = query.getOrDefault("userIp")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = nil)
  if valid_589428 != nil:
    section.add "userIp", valid_589428
  var valid_589429 = query.getOrDefault("key")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "key", valid_589429
  var valid_589430 = query.getOrDefault("prettyPrint")
  valid_589430 = validateParameter(valid_589430, JBool, required = false,
                                 default = newJBool(true))
  if valid_589430 != nil:
    section.add "prettyPrint", valid_589430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589431: Call_AndroidpublisherEditsImagesUpload_589417;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ## 
  let valid = call_589431.validator(path, query, header, formData, body)
  let scheme = call_589431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589431.url(scheme.get, call_589431.host, call_589431.base,
                         call_589431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589431, url, valid)

proc call*(call_589432: Call_AndroidpublisherEditsImagesUpload_589417;
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
  var path_589433 = newJObject()
  var query_589434 = newJObject()
  add(query_589434, "fields", newJString(fields))
  add(path_589433, "packageName", newJString(packageName))
  add(query_589434, "quotaUser", newJString(quotaUser))
  add(query_589434, "alt", newJString(alt))
  add(path_589433, "editId", newJString(editId))
  add(query_589434, "oauth_token", newJString(oauthToken))
  add(path_589433, "language", newJString(language))
  add(query_589434, "userIp", newJString(userIp))
  add(path_589433, "imageType", newJString(imageType))
  add(query_589434, "key", newJString(key))
  add(query_589434, "prettyPrint", newJBool(prettyPrint))
  result = call_589432.call(path_589433, query_589434, nil, nil, nil)

var androidpublisherEditsImagesUpload* = Call_AndroidpublisherEditsImagesUpload_589417(
    name: "androidpublisherEditsImagesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesUpload_589418,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesUpload_589419, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesList_589399 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsImagesList_589401(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesList_589400(path: JsonNode;
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
  var valid_589402 = path.getOrDefault("packageName")
  valid_589402 = validateParameter(valid_589402, JString, required = true,
                                 default = nil)
  if valid_589402 != nil:
    section.add "packageName", valid_589402
  var valid_589403 = path.getOrDefault("editId")
  valid_589403 = validateParameter(valid_589403, JString, required = true,
                                 default = nil)
  if valid_589403 != nil:
    section.add "editId", valid_589403
  var valid_589404 = path.getOrDefault("language")
  valid_589404 = validateParameter(valid_589404, JString, required = true,
                                 default = nil)
  if valid_589404 != nil:
    section.add "language", valid_589404
  var valid_589405 = path.getOrDefault("imageType")
  valid_589405 = validateParameter(valid_589405, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_589405 != nil:
    section.add "imageType", valid_589405
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
  var valid_589406 = query.getOrDefault("fields")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "fields", valid_589406
  var valid_589407 = query.getOrDefault("quotaUser")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = nil)
  if valid_589407 != nil:
    section.add "quotaUser", valid_589407
  var valid_589408 = query.getOrDefault("alt")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = newJString("json"))
  if valid_589408 != nil:
    section.add "alt", valid_589408
  var valid_589409 = query.getOrDefault("oauth_token")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "oauth_token", valid_589409
  var valid_589410 = query.getOrDefault("userIp")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "userIp", valid_589410
  var valid_589411 = query.getOrDefault("key")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "key", valid_589411
  var valid_589412 = query.getOrDefault("prettyPrint")
  valid_589412 = validateParameter(valid_589412, JBool, required = false,
                                 default = newJBool(true))
  if valid_589412 != nil:
    section.add "prettyPrint", valid_589412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589413: Call_AndroidpublisherEditsImagesList_589399;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all images for the specified language and image type.
  ## 
  let valid = call_589413.validator(path, query, header, formData, body)
  let scheme = call_589413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589413.url(scheme.get, call_589413.host, call_589413.base,
                         call_589413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589413, url, valid)

proc call*(call_589414: Call_AndroidpublisherEditsImagesList_589399;
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
  var path_589415 = newJObject()
  var query_589416 = newJObject()
  add(query_589416, "fields", newJString(fields))
  add(path_589415, "packageName", newJString(packageName))
  add(query_589416, "quotaUser", newJString(quotaUser))
  add(query_589416, "alt", newJString(alt))
  add(path_589415, "editId", newJString(editId))
  add(query_589416, "oauth_token", newJString(oauthToken))
  add(path_589415, "language", newJString(language))
  add(query_589416, "userIp", newJString(userIp))
  add(path_589415, "imageType", newJString(imageType))
  add(query_589416, "key", newJString(key))
  add(query_589416, "prettyPrint", newJBool(prettyPrint))
  result = call_589414.call(path_589415, query_589416, nil, nil, nil)

var androidpublisherEditsImagesList* = Call_AndroidpublisherEditsImagesList_589399(
    name: "androidpublisherEditsImagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesList_589400,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesList_589401, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDeleteall_589435 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsImagesDeleteall_589437(protocol: Scheme;
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

proc validate_AndroidpublisherEditsImagesDeleteall_589436(path: JsonNode;
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
  var valid_589438 = path.getOrDefault("packageName")
  valid_589438 = validateParameter(valid_589438, JString, required = true,
                                 default = nil)
  if valid_589438 != nil:
    section.add "packageName", valid_589438
  var valid_589439 = path.getOrDefault("editId")
  valid_589439 = validateParameter(valid_589439, JString, required = true,
                                 default = nil)
  if valid_589439 != nil:
    section.add "editId", valid_589439
  var valid_589440 = path.getOrDefault("language")
  valid_589440 = validateParameter(valid_589440, JString, required = true,
                                 default = nil)
  if valid_589440 != nil:
    section.add "language", valid_589440
  var valid_589441 = path.getOrDefault("imageType")
  valid_589441 = validateParameter(valid_589441, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_589441 != nil:
    section.add "imageType", valid_589441
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
  var valid_589442 = query.getOrDefault("fields")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "fields", valid_589442
  var valid_589443 = query.getOrDefault("quotaUser")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "quotaUser", valid_589443
  var valid_589444 = query.getOrDefault("alt")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = newJString("json"))
  if valid_589444 != nil:
    section.add "alt", valid_589444
  var valid_589445 = query.getOrDefault("oauth_token")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "oauth_token", valid_589445
  var valid_589446 = query.getOrDefault("userIp")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "userIp", valid_589446
  var valid_589447 = query.getOrDefault("key")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = nil)
  if valid_589447 != nil:
    section.add "key", valid_589447
  var valid_589448 = query.getOrDefault("prettyPrint")
  valid_589448 = validateParameter(valid_589448, JBool, required = false,
                                 default = newJBool(true))
  if valid_589448 != nil:
    section.add "prettyPrint", valid_589448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589449: Call_AndroidpublisherEditsImagesDeleteall_589435;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all images for the specified language and image type.
  ## 
  let valid = call_589449.validator(path, query, header, formData, body)
  let scheme = call_589449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589449.url(scheme.get, call_589449.host, call_589449.base,
                         call_589449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589449, url, valid)

proc call*(call_589450: Call_AndroidpublisherEditsImagesDeleteall_589435;
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
  var path_589451 = newJObject()
  var query_589452 = newJObject()
  add(query_589452, "fields", newJString(fields))
  add(path_589451, "packageName", newJString(packageName))
  add(query_589452, "quotaUser", newJString(quotaUser))
  add(query_589452, "alt", newJString(alt))
  add(path_589451, "editId", newJString(editId))
  add(query_589452, "oauth_token", newJString(oauthToken))
  add(path_589451, "language", newJString(language))
  add(query_589452, "userIp", newJString(userIp))
  add(path_589451, "imageType", newJString(imageType))
  add(query_589452, "key", newJString(key))
  add(query_589452, "prettyPrint", newJBool(prettyPrint))
  result = call_589450.call(path_589451, query_589452, nil, nil, nil)

var androidpublisherEditsImagesDeleteall* = Call_AndroidpublisherEditsImagesDeleteall_589435(
    name: "androidpublisherEditsImagesDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesDeleteall_589436,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesDeleteall_589437, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDelete_589453 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsImagesDelete_589455(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesDelete_589454(path: JsonNode;
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
  var valid_589456 = path.getOrDefault("imageId")
  valid_589456 = validateParameter(valid_589456, JString, required = true,
                                 default = nil)
  if valid_589456 != nil:
    section.add "imageId", valid_589456
  var valid_589457 = path.getOrDefault("packageName")
  valid_589457 = validateParameter(valid_589457, JString, required = true,
                                 default = nil)
  if valid_589457 != nil:
    section.add "packageName", valid_589457
  var valid_589458 = path.getOrDefault("editId")
  valid_589458 = validateParameter(valid_589458, JString, required = true,
                                 default = nil)
  if valid_589458 != nil:
    section.add "editId", valid_589458
  var valid_589459 = path.getOrDefault("language")
  valid_589459 = validateParameter(valid_589459, JString, required = true,
                                 default = nil)
  if valid_589459 != nil:
    section.add "language", valid_589459
  var valid_589460 = path.getOrDefault("imageType")
  valid_589460 = validateParameter(valid_589460, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_589460 != nil:
    section.add "imageType", valid_589460
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
  var valid_589461 = query.getOrDefault("fields")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "fields", valid_589461
  var valid_589462 = query.getOrDefault("quotaUser")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "quotaUser", valid_589462
  var valid_589463 = query.getOrDefault("alt")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = newJString("json"))
  if valid_589463 != nil:
    section.add "alt", valid_589463
  var valid_589464 = query.getOrDefault("oauth_token")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "oauth_token", valid_589464
  var valid_589465 = query.getOrDefault("userIp")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "userIp", valid_589465
  var valid_589466 = query.getOrDefault("key")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "key", valid_589466
  var valid_589467 = query.getOrDefault("prettyPrint")
  valid_589467 = validateParameter(valid_589467, JBool, required = false,
                                 default = newJBool(true))
  if valid_589467 != nil:
    section.add "prettyPrint", valid_589467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589468: Call_AndroidpublisherEditsImagesDelete_589453;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the image (specified by id) from the edit.
  ## 
  let valid = call_589468.validator(path, query, header, formData, body)
  let scheme = call_589468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589468.url(scheme.get, call_589468.host, call_589468.base,
                         call_589468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589468, url, valid)

proc call*(call_589469: Call_AndroidpublisherEditsImagesDelete_589453;
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
  var path_589470 = newJObject()
  var query_589471 = newJObject()
  add(path_589470, "imageId", newJString(imageId))
  add(query_589471, "fields", newJString(fields))
  add(path_589470, "packageName", newJString(packageName))
  add(query_589471, "quotaUser", newJString(quotaUser))
  add(query_589471, "alt", newJString(alt))
  add(path_589470, "editId", newJString(editId))
  add(query_589471, "oauth_token", newJString(oauthToken))
  add(path_589470, "language", newJString(language))
  add(query_589471, "userIp", newJString(userIp))
  add(path_589470, "imageType", newJString(imageType))
  add(query_589471, "key", newJString(key))
  add(query_589471, "prettyPrint", newJBool(prettyPrint))
  result = call_589469.call(path_589470, query_589471, nil, nil, nil)

var androidpublisherEditsImagesDelete* = Call_AndroidpublisherEditsImagesDelete_589453(
    name: "androidpublisherEditsImagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}/{imageId}",
    validator: validate_AndroidpublisherEditsImagesDelete_589454,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesDelete_589455, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersUpdate_589489 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTestersUpdate_589491(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersUpdate_589490(path: JsonNode;
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
  var valid_589492 = path.getOrDefault("packageName")
  valid_589492 = validateParameter(valid_589492, JString, required = true,
                                 default = nil)
  if valid_589492 != nil:
    section.add "packageName", valid_589492
  var valid_589493 = path.getOrDefault("editId")
  valid_589493 = validateParameter(valid_589493, JString, required = true,
                                 default = nil)
  if valid_589493 != nil:
    section.add "editId", valid_589493
  var valid_589494 = path.getOrDefault("track")
  valid_589494 = validateParameter(valid_589494, JString, required = true,
                                 default = nil)
  if valid_589494 != nil:
    section.add "track", valid_589494
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
  var valid_589495 = query.getOrDefault("fields")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "fields", valid_589495
  var valid_589496 = query.getOrDefault("quotaUser")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "quotaUser", valid_589496
  var valid_589497 = query.getOrDefault("alt")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = newJString("json"))
  if valid_589497 != nil:
    section.add "alt", valid_589497
  var valid_589498 = query.getOrDefault("oauth_token")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "oauth_token", valid_589498
  var valid_589499 = query.getOrDefault("userIp")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "userIp", valid_589499
  var valid_589500 = query.getOrDefault("key")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "key", valid_589500
  var valid_589501 = query.getOrDefault("prettyPrint")
  valid_589501 = validateParameter(valid_589501, JBool, required = false,
                                 default = newJBool(true))
  if valid_589501 != nil:
    section.add "prettyPrint", valid_589501
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

proc call*(call_589503: Call_AndroidpublisherEditsTestersUpdate_589489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_589503.validator(path, query, header, formData, body)
  let scheme = call_589503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589503.url(scheme.get, call_589503.host, call_589503.base,
                         call_589503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589503, url, valid)

proc call*(call_589504: Call_AndroidpublisherEditsTestersUpdate_589489;
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
  var path_589505 = newJObject()
  var query_589506 = newJObject()
  var body_589507 = newJObject()
  add(query_589506, "fields", newJString(fields))
  add(path_589505, "packageName", newJString(packageName))
  add(query_589506, "quotaUser", newJString(quotaUser))
  add(query_589506, "alt", newJString(alt))
  add(path_589505, "editId", newJString(editId))
  add(query_589506, "oauth_token", newJString(oauthToken))
  add(query_589506, "userIp", newJString(userIp))
  add(query_589506, "key", newJString(key))
  if body != nil:
    body_589507 = body
  add(query_589506, "prettyPrint", newJBool(prettyPrint))
  add(path_589505, "track", newJString(track))
  result = call_589504.call(path_589505, query_589506, nil, nil, body_589507)

var androidpublisherEditsTestersUpdate* = Call_AndroidpublisherEditsTestersUpdate_589489(
    name: "androidpublisherEditsTestersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersUpdate_589490,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersUpdate_589491, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersGet_589472 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTestersGet_589474(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersGet_589473(path: JsonNode;
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
  var valid_589475 = path.getOrDefault("packageName")
  valid_589475 = validateParameter(valid_589475, JString, required = true,
                                 default = nil)
  if valid_589475 != nil:
    section.add "packageName", valid_589475
  var valid_589476 = path.getOrDefault("editId")
  valid_589476 = validateParameter(valid_589476, JString, required = true,
                                 default = nil)
  if valid_589476 != nil:
    section.add "editId", valid_589476
  var valid_589477 = path.getOrDefault("track")
  valid_589477 = validateParameter(valid_589477, JString, required = true,
                                 default = nil)
  if valid_589477 != nil:
    section.add "track", valid_589477
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
  var valid_589478 = query.getOrDefault("fields")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "fields", valid_589478
  var valid_589479 = query.getOrDefault("quotaUser")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "quotaUser", valid_589479
  var valid_589480 = query.getOrDefault("alt")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = newJString("json"))
  if valid_589480 != nil:
    section.add "alt", valid_589480
  var valid_589481 = query.getOrDefault("oauth_token")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "oauth_token", valid_589481
  var valid_589482 = query.getOrDefault("userIp")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "userIp", valid_589482
  var valid_589483 = query.getOrDefault("key")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "key", valid_589483
  var valid_589484 = query.getOrDefault("prettyPrint")
  valid_589484 = validateParameter(valid_589484, JBool, required = false,
                                 default = newJBool(true))
  if valid_589484 != nil:
    section.add "prettyPrint", valid_589484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589485: Call_AndroidpublisherEditsTestersGet_589472;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_589485.validator(path, query, header, formData, body)
  let scheme = call_589485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589485.url(scheme.get, call_589485.host, call_589485.base,
                         call_589485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589485, url, valid)

proc call*(call_589486: Call_AndroidpublisherEditsTestersGet_589472;
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
  var path_589487 = newJObject()
  var query_589488 = newJObject()
  add(query_589488, "fields", newJString(fields))
  add(path_589487, "packageName", newJString(packageName))
  add(query_589488, "quotaUser", newJString(quotaUser))
  add(query_589488, "alt", newJString(alt))
  add(path_589487, "editId", newJString(editId))
  add(query_589488, "oauth_token", newJString(oauthToken))
  add(query_589488, "userIp", newJString(userIp))
  add(query_589488, "key", newJString(key))
  add(query_589488, "prettyPrint", newJBool(prettyPrint))
  add(path_589487, "track", newJString(track))
  result = call_589486.call(path_589487, query_589488, nil, nil, nil)

var androidpublisherEditsTestersGet* = Call_AndroidpublisherEditsTestersGet_589472(
    name: "androidpublisherEditsTestersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersGet_589473,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersGet_589474, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersPatch_589508 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTestersPatch_589510(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersPatch_589509(path: JsonNode;
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
  var valid_589511 = path.getOrDefault("packageName")
  valid_589511 = validateParameter(valid_589511, JString, required = true,
                                 default = nil)
  if valid_589511 != nil:
    section.add "packageName", valid_589511
  var valid_589512 = path.getOrDefault("editId")
  valid_589512 = validateParameter(valid_589512, JString, required = true,
                                 default = nil)
  if valid_589512 != nil:
    section.add "editId", valid_589512
  var valid_589513 = path.getOrDefault("track")
  valid_589513 = validateParameter(valid_589513, JString, required = true,
                                 default = nil)
  if valid_589513 != nil:
    section.add "track", valid_589513
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
  var valid_589514 = query.getOrDefault("fields")
  valid_589514 = validateParameter(valid_589514, JString, required = false,
                                 default = nil)
  if valid_589514 != nil:
    section.add "fields", valid_589514
  var valid_589515 = query.getOrDefault("quotaUser")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = nil)
  if valid_589515 != nil:
    section.add "quotaUser", valid_589515
  var valid_589516 = query.getOrDefault("alt")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = newJString("json"))
  if valid_589516 != nil:
    section.add "alt", valid_589516
  var valid_589517 = query.getOrDefault("oauth_token")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "oauth_token", valid_589517
  var valid_589518 = query.getOrDefault("userIp")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "userIp", valid_589518
  var valid_589519 = query.getOrDefault("key")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "key", valid_589519
  var valid_589520 = query.getOrDefault("prettyPrint")
  valid_589520 = validateParameter(valid_589520, JBool, required = false,
                                 default = newJBool(true))
  if valid_589520 != nil:
    section.add "prettyPrint", valid_589520
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

proc call*(call_589522: Call_AndroidpublisherEditsTestersPatch_589508;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_589522.validator(path, query, header, formData, body)
  let scheme = call_589522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589522.url(scheme.get, call_589522.host, call_589522.base,
                         call_589522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589522, url, valid)

proc call*(call_589523: Call_AndroidpublisherEditsTestersPatch_589508;
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
  var path_589524 = newJObject()
  var query_589525 = newJObject()
  var body_589526 = newJObject()
  add(query_589525, "fields", newJString(fields))
  add(path_589524, "packageName", newJString(packageName))
  add(query_589525, "quotaUser", newJString(quotaUser))
  add(query_589525, "alt", newJString(alt))
  add(path_589524, "editId", newJString(editId))
  add(query_589525, "oauth_token", newJString(oauthToken))
  add(query_589525, "userIp", newJString(userIp))
  add(query_589525, "key", newJString(key))
  if body != nil:
    body_589526 = body
  add(query_589525, "prettyPrint", newJBool(prettyPrint))
  add(path_589524, "track", newJString(track))
  result = call_589523.call(path_589524, query_589525, nil, nil, body_589526)

var androidpublisherEditsTestersPatch* = Call_AndroidpublisherEditsTestersPatch_589508(
    name: "androidpublisherEditsTestersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersPatch_589509,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersPatch_589510, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksList_589527 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTracksList_589529(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksList_589528(path: JsonNode;
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
  var valid_589530 = path.getOrDefault("packageName")
  valid_589530 = validateParameter(valid_589530, JString, required = true,
                                 default = nil)
  if valid_589530 != nil:
    section.add "packageName", valid_589530
  var valid_589531 = path.getOrDefault("editId")
  valid_589531 = validateParameter(valid_589531, JString, required = true,
                                 default = nil)
  if valid_589531 != nil:
    section.add "editId", valid_589531
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
  var valid_589532 = query.getOrDefault("fields")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = nil)
  if valid_589532 != nil:
    section.add "fields", valid_589532
  var valid_589533 = query.getOrDefault("quotaUser")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = nil)
  if valid_589533 != nil:
    section.add "quotaUser", valid_589533
  var valid_589534 = query.getOrDefault("alt")
  valid_589534 = validateParameter(valid_589534, JString, required = false,
                                 default = newJString("json"))
  if valid_589534 != nil:
    section.add "alt", valid_589534
  var valid_589535 = query.getOrDefault("oauth_token")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = nil)
  if valid_589535 != nil:
    section.add "oauth_token", valid_589535
  var valid_589536 = query.getOrDefault("userIp")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "userIp", valid_589536
  var valid_589537 = query.getOrDefault("key")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "key", valid_589537
  var valid_589538 = query.getOrDefault("prettyPrint")
  valid_589538 = validateParameter(valid_589538, JBool, required = false,
                                 default = newJBool(true))
  if valid_589538 != nil:
    section.add "prettyPrint", valid_589538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589539: Call_AndroidpublisherEditsTracksList_589527;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the track configurations for this edit.
  ## 
  let valid = call_589539.validator(path, query, header, formData, body)
  let scheme = call_589539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589539.url(scheme.get, call_589539.host, call_589539.base,
                         call_589539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589539, url, valid)

proc call*(call_589540: Call_AndroidpublisherEditsTracksList_589527;
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
  var path_589541 = newJObject()
  var query_589542 = newJObject()
  add(query_589542, "fields", newJString(fields))
  add(path_589541, "packageName", newJString(packageName))
  add(query_589542, "quotaUser", newJString(quotaUser))
  add(query_589542, "alt", newJString(alt))
  add(path_589541, "editId", newJString(editId))
  add(query_589542, "oauth_token", newJString(oauthToken))
  add(query_589542, "userIp", newJString(userIp))
  add(query_589542, "key", newJString(key))
  add(query_589542, "prettyPrint", newJBool(prettyPrint))
  result = call_589540.call(path_589541, query_589542, nil, nil, nil)

var androidpublisherEditsTracksList* = Call_AndroidpublisherEditsTracksList_589527(
    name: "androidpublisherEditsTracksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/tracks",
    validator: validate_AndroidpublisherEditsTracksList_589528,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksList_589529, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksUpdate_589560 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTracksUpdate_589562(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksUpdate_589561(path: JsonNode;
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
  var valid_589563 = path.getOrDefault("packageName")
  valid_589563 = validateParameter(valid_589563, JString, required = true,
                                 default = nil)
  if valid_589563 != nil:
    section.add "packageName", valid_589563
  var valid_589564 = path.getOrDefault("editId")
  valid_589564 = validateParameter(valid_589564, JString, required = true,
                                 default = nil)
  if valid_589564 != nil:
    section.add "editId", valid_589564
  var valid_589565 = path.getOrDefault("track")
  valid_589565 = validateParameter(valid_589565, JString, required = true,
                                 default = nil)
  if valid_589565 != nil:
    section.add "track", valid_589565
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
  var valid_589566 = query.getOrDefault("fields")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "fields", valid_589566
  var valid_589567 = query.getOrDefault("quotaUser")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = nil)
  if valid_589567 != nil:
    section.add "quotaUser", valid_589567
  var valid_589568 = query.getOrDefault("alt")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = newJString("json"))
  if valid_589568 != nil:
    section.add "alt", valid_589568
  var valid_589569 = query.getOrDefault("oauth_token")
  valid_589569 = validateParameter(valid_589569, JString, required = false,
                                 default = nil)
  if valid_589569 != nil:
    section.add "oauth_token", valid_589569
  var valid_589570 = query.getOrDefault("userIp")
  valid_589570 = validateParameter(valid_589570, JString, required = false,
                                 default = nil)
  if valid_589570 != nil:
    section.add "userIp", valid_589570
  var valid_589571 = query.getOrDefault("key")
  valid_589571 = validateParameter(valid_589571, JString, required = false,
                                 default = nil)
  if valid_589571 != nil:
    section.add "key", valid_589571
  var valid_589572 = query.getOrDefault("prettyPrint")
  valid_589572 = validateParameter(valid_589572, JBool, required = false,
                                 default = newJBool(true))
  if valid_589572 != nil:
    section.add "prettyPrint", valid_589572
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

proc call*(call_589574: Call_AndroidpublisherEditsTracksUpdate_589560;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type.
  ## 
  let valid = call_589574.validator(path, query, header, formData, body)
  let scheme = call_589574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589574.url(scheme.get, call_589574.host, call_589574.base,
                         call_589574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589574, url, valid)

proc call*(call_589575: Call_AndroidpublisherEditsTracksUpdate_589560;
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
  var path_589576 = newJObject()
  var query_589577 = newJObject()
  var body_589578 = newJObject()
  add(query_589577, "fields", newJString(fields))
  add(path_589576, "packageName", newJString(packageName))
  add(query_589577, "quotaUser", newJString(quotaUser))
  add(query_589577, "alt", newJString(alt))
  add(path_589576, "editId", newJString(editId))
  add(query_589577, "oauth_token", newJString(oauthToken))
  add(query_589577, "userIp", newJString(userIp))
  add(query_589577, "key", newJString(key))
  if body != nil:
    body_589578 = body
  add(query_589577, "prettyPrint", newJBool(prettyPrint))
  add(path_589576, "track", newJString(track))
  result = call_589575.call(path_589576, query_589577, nil, nil, body_589578)

var androidpublisherEditsTracksUpdate* = Call_AndroidpublisherEditsTracksUpdate_589560(
    name: "androidpublisherEditsTracksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksUpdate_589561,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksUpdate_589562, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksGet_589543 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTracksGet_589545(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksGet_589544(path: JsonNode;
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
  var valid_589546 = path.getOrDefault("packageName")
  valid_589546 = validateParameter(valid_589546, JString, required = true,
                                 default = nil)
  if valid_589546 != nil:
    section.add "packageName", valid_589546
  var valid_589547 = path.getOrDefault("editId")
  valid_589547 = validateParameter(valid_589547, JString, required = true,
                                 default = nil)
  if valid_589547 != nil:
    section.add "editId", valid_589547
  var valid_589548 = path.getOrDefault("track")
  valid_589548 = validateParameter(valid_589548, JString, required = true,
                                 default = nil)
  if valid_589548 != nil:
    section.add "track", valid_589548
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
  var valid_589549 = query.getOrDefault("fields")
  valid_589549 = validateParameter(valid_589549, JString, required = false,
                                 default = nil)
  if valid_589549 != nil:
    section.add "fields", valid_589549
  var valid_589550 = query.getOrDefault("quotaUser")
  valid_589550 = validateParameter(valid_589550, JString, required = false,
                                 default = nil)
  if valid_589550 != nil:
    section.add "quotaUser", valid_589550
  var valid_589551 = query.getOrDefault("alt")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = newJString("json"))
  if valid_589551 != nil:
    section.add "alt", valid_589551
  var valid_589552 = query.getOrDefault("oauth_token")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = nil)
  if valid_589552 != nil:
    section.add "oauth_token", valid_589552
  var valid_589553 = query.getOrDefault("userIp")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "userIp", valid_589553
  var valid_589554 = query.getOrDefault("key")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = nil)
  if valid_589554 != nil:
    section.add "key", valid_589554
  var valid_589555 = query.getOrDefault("prettyPrint")
  valid_589555 = validateParameter(valid_589555, JBool, required = false,
                                 default = newJBool(true))
  if valid_589555 != nil:
    section.add "prettyPrint", valid_589555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589556: Call_AndroidpublisherEditsTracksGet_589543; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ## 
  let valid = call_589556.validator(path, query, header, formData, body)
  let scheme = call_589556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589556.url(scheme.get, call_589556.host, call_589556.base,
                         call_589556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589556, url, valid)

proc call*(call_589557: Call_AndroidpublisherEditsTracksGet_589543;
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
  var path_589558 = newJObject()
  var query_589559 = newJObject()
  add(query_589559, "fields", newJString(fields))
  add(path_589558, "packageName", newJString(packageName))
  add(query_589559, "quotaUser", newJString(quotaUser))
  add(query_589559, "alt", newJString(alt))
  add(path_589558, "editId", newJString(editId))
  add(query_589559, "oauth_token", newJString(oauthToken))
  add(query_589559, "userIp", newJString(userIp))
  add(query_589559, "key", newJString(key))
  add(query_589559, "prettyPrint", newJBool(prettyPrint))
  add(path_589558, "track", newJString(track))
  result = call_589557.call(path_589558, query_589559, nil, nil, nil)

var androidpublisherEditsTracksGet* = Call_AndroidpublisherEditsTracksGet_589543(
    name: "androidpublisherEditsTracksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksGet_589544,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksGet_589545, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksPatch_589579 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsTracksPatch_589581(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksPatch_589580(path: JsonNode;
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
  var valid_589582 = path.getOrDefault("packageName")
  valid_589582 = validateParameter(valid_589582, JString, required = true,
                                 default = nil)
  if valid_589582 != nil:
    section.add "packageName", valid_589582
  var valid_589583 = path.getOrDefault("editId")
  valid_589583 = validateParameter(valid_589583, JString, required = true,
                                 default = nil)
  if valid_589583 != nil:
    section.add "editId", valid_589583
  var valid_589584 = path.getOrDefault("track")
  valid_589584 = validateParameter(valid_589584, JString, required = true,
                                 default = nil)
  if valid_589584 != nil:
    section.add "track", valid_589584
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
  var valid_589585 = query.getOrDefault("fields")
  valid_589585 = validateParameter(valid_589585, JString, required = false,
                                 default = nil)
  if valid_589585 != nil:
    section.add "fields", valid_589585
  var valid_589586 = query.getOrDefault("quotaUser")
  valid_589586 = validateParameter(valid_589586, JString, required = false,
                                 default = nil)
  if valid_589586 != nil:
    section.add "quotaUser", valid_589586
  var valid_589587 = query.getOrDefault("alt")
  valid_589587 = validateParameter(valid_589587, JString, required = false,
                                 default = newJString("json"))
  if valid_589587 != nil:
    section.add "alt", valid_589587
  var valid_589588 = query.getOrDefault("oauth_token")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = nil)
  if valid_589588 != nil:
    section.add "oauth_token", valid_589588
  var valid_589589 = query.getOrDefault("userIp")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = nil)
  if valid_589589 != nil:
    section.add "userIp", valid_589589
  var valid_589590 = query.getOrDefault("key")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = nil)
  if valid_589590 != nil:
    section.add "key", valid_589590
  var valid_589591 = query.getOrDefault("prettyPrint")
  valid_589591 = validateParameter(valid_589591, JBool, required = false,
                                 default = newJBool(true))
  if valid_589591 != nil:
    section.add "prettyPrint", valid_589591
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

proc call*(call_589593: Call_AndroidpublisherEditsTracksPatch_589579;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ## 
  let valid = call_589593.validator(path, query, header, formData, body)
  let scheme = call_589593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589593.url(scheme.get, call_589593.host, call_589593.base,
                         call_589593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589593, url, valid)

proc call*(call_589594: Call_AndroidpublisherEditsTracksPatch_589579;
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
  var path_589595 = newJObject()
  var query_589596 = newJObject()
  var body_589597 = newJObject()
  add(query_589596, "fields", newJString(fields))
  add(path_589595, "packageName", newJString(packageName))
  add(query_589596, "quotaUser", newJString(quotaUser))
  add(query_589596, "alt", newJString(alt))
  add(path_589595, "editId", newJString(editId))
  add(query_589596, "oauth_token", newJString(oauthToken))
  add(query_589596, "userIp", newJString(userIp))
  add(query_589596, "key", newJString(key))
  if body != nil:
    body_589597 = body
  add(query_589596, "prettyPrint", newJBool(prettyPrint))
  add(path_589595, "track", newJString(track))
  result = call_589594.call(path_589595, query_589596, nil, nil, body_589597)

var androidpublisherEditsTracksPatch* = Call_AndroidpublisherEditsTracksPatch_589579(
    name: "androidpublisherEditsTracksPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksPatch_589580,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksPatch_589581, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsCommit_589598 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsCommit_589600(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsCommit_589599(path: JsonNode; query: JsonNode;
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
  var valid_589601 = path.getOrDefault("packageName")
  valid_589601 = validateParameter(valid_589601, JString, required = true,
                                 default = nil)
  if valid_589601 != nil:
    section.add "packageName", valid_589601
  var valid_589602 = path.getOrDefault("editId")
  valid_589602 = validateParameter(valid_589602, JString, required = true,
                                 default = nil)
  if valid_589602 != nil:
    section.add "editId", valid_589602
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
  var valid_589603 = query.getOrDefault("fields")
  valid_589603 = validateParameter(valid_589603, JString, required = false,
                                 default = nil)
  if valid_589603 != nil:
    section.add "fields", valid_589603
  var valid_589604 = query.getOrDefault("quotaUser")
  valid_589604 = validateParameter(valid_589604, JString, required = false,
                                 default = nil)
  if valid_589604 != nil:
    section.add "quotaUser", valid_589604
  var valid_589605 = query.getOrDefault("alt")
  valid_589605 = validateParameter(valid_589605, JString, required = false,
                                 default = newJString("json"))
  if valid_589605 != nil:
    section.add "alt", valid_589605
  var valid_589606 = query.getOrDefault("oauth_token")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "oauth_token", valid_589606
  var valid_589607 = query.getOrDefault("userIp")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "userIp", valid_589607
  var valid_589608 = query.getOrDefault("key")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = nil)
  if valid_589608 != nil:
    section.add "key", valid_589608
  var valid_589609 = query.getOrDefault("prettyPrint")
  valid_589609 = validateParameter(valid_589609, JBool, required = false,
                                 default = newJBool(true))
  if valid_589609 != nil:
    section.add "prettyPrint", valid_589609
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589610: Call_AndroidpublisherEditsCommit_589598; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commits/applies the changes made in this edit back to the app.
  ## 
  let valid = call_589610.validator(path, query, header, formData, body)
  let scheme = call_589610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589610.url(scheme.get, call_589610.host, call_589610.base,
                         call_589610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589610, url, valid)

proc call*(call_589611: Call_AndroidpublisherEditsCommit_589598;
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
  var path_589612 = newJObject()
  var query_589613 = newJObject()
  add(query_589613, "fields", newJString(fields))
  add(path_589612, "packageName", newJString(packageName))
  add(query_589613, "quotaUser", newJString(quotaUser))
  add(query_589613, "alt", newJString(alt))
  add(path_589612, "editId", newJString(editId))
  add(query_589613, "oauth_token", newJString(oauthToken))
  add(query_589613, "userIp", newJString(userIp))
  add(query_589613, "key", newJString(key))
  add(query_589613, "prettyPrint", newJBool(prettyPrint))
  result = call_589611.call(path_589612, query_589613, nil, nil, nil)

var androidpublisherEditsCommit* = Call_AndroidpublisherEditsCommit_589598(
    name: "androidpublisherEditsCommit", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:commit",
    validator: validate_AndroidpublisherEditsCommit_589599,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsCommit_589600, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsValidate_589614 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherEditsValidate_589616(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsValidate_589615(path: JsonNode; query: JsonNode;
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
  var valid_589617 = path.getOrDefault("packageName")
  valid_589617 = validateParameter(valid_589617, JString, required = true,
                                 default = nil)
  if valid_589617 != nil:
    section.add "packageName", valid_589617
  var valid_589618 = path.getOrDefault("editId")
  valid_589618 = validateParameter(valid_589618, JString, required = true,
                                 default = nil)
  if valid_589618 != nil:
    section.add "editId", valid_589618
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
  var valid_589619 = query.getOrDefault("fields")
  valid_589619 = validateParameter(valid_589619, JString, required = false,
                                 default = nil)
  if valid_589619 != nil:
    section.add "fields", valid_589619
  var valid_589620 = query.getOrDefault("quotaUser")
  valid_589620 = validateParameter(valid_589620, JString, required = false,
                                 default = nil)
  if valid_589620 != nil:
    section.add "quotaUser", valid_589620
  var valid_589621 = query.getOrDefault("alt")
  valid_589621 = validateParameter(valid_589621, JString, required = false,
                                 default = newJString("json"))
  if valid_589621 != nil:
    section.add "alt", valid_589621
  var valid_589622 = query.getOrDefault("oauth_token")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = nil)
  if valid_589622 != nil:
    section.add "oauth_token", valid_589622
  var valid_589623 = query.getOrDefault("userIp")
  valid_589623 = validateParameter(valid_589623, JString, required = false,
                                 default = nil)
  if valid_589623 != nil:
    section.add "userIp", valid_589623
  var valid_589624 = query.getOrDefault("key")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = nil)
  if valid_589624 != nil:
    section.add "key", valid_589624
  var valid_589625 = query.getOrDefault("prettyPrint")
  valid_589625 = validateParameter(valid_589625, JBool, required = false,
                                 default = newJBool(true))
  if valid_589625 != nil:
    section.add "prettyPrint", valid_589625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589626: Call_AndroidpublisherEditsValidate_589614; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ## 
  let valid = call_589626.validator(path, query, header, formData, body)
  let scheme = call_589626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589626.url(scheme.get, call_589626.host, call_589626.base,
                         call_589626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589626, url, valid)

proc call*(call_589627: Call_AndroidpublisherEditsValidate_589614;
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
  var path_589628 = newJObject()
  var query_589629 = newJObject()
  add(query_589629, "fields", newJString(fields))
  add(path_589628, "packageName", newJString(packageName))
  add(query_589629, "quotaUser", newJString(quotaUser))
  add(query_589629, "alt", newJString(alt))
  add(path_589628, "editId", newJString(editId))
  add(query_589629, "oauth_token", newJString(oauthToken))
  add(query_589629, "userIp", newJString(userIp))
  add(query_589629, "key", newJString(key))
  add(query_589629, "prettyPrint", newJBool(prettyPrint))
  result = call_589627.call(path_589628, query_589629, nil, nil, nil)

var androidpublisherEditsValidate* = Call_AndroidpublisherEditsValidate_589614(
    name: "androidpublisherEditsValidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:validate",
    validator: validate_AndroidpublisherEditsValidate_589615,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsValidate_589616, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsInsert_589648 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsInsert_589650(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsInsert_589649(path: JsonNode;
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
  var valid_589651 = path.getOrDefault("packageName")
  valid_589651 = validateParameter(valid_589651, JString, required = true,
                                 default = nil)
  if valid_589651 != nil:
    section.add "packageName", valid_589651
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
  var valid_589652 = query.getOrDefault("fields")
  valid_589652 = validateParameter(valid_589652, JString, required = false,
                                 default = nil)
  if valid_589652 != nil:
    section.add "fields", valid_589652
  var valid_589653 = query.getOrDefault("quotaUser")
  valid_589653 = validateParameter(valid_589653, JString, required = false,
                                 default = nil)
  if valid_589653 != nil:
    section.add "quotaUser", valid_589653
  var valid_589654 = query.getOrDefault("alt")
  valid_589654 = validateParameter(valid_589654, JString, required = false,
                                 default = newJString("json"))
  if valid_589654 != nil:
    section.add "alt", valid_589654
  var valid_589655 = query.getOrDefault("oauth_token")
  valid_589655 = validateParameter(valid_589655, JString, required = false,
                                 default = nil)
  if valid_589655 != nil:
    section.add "oauth_token", valid_589655
  var valid_589656 = query.getOrDefault("userIp")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "userIp", valid_589656
  var valid_589657 = query.getOrDefault("key")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "key", valid_589657
  var valid_589658 = query.getOrDefault("autoConvertMissingPrices")
  valid_589658 = validateParameter(valid_589658, JBool, required = false, default = nil)
  if valid_589658 != nil:
    section.add "autoConvertMissingPrices", valid_589658
  var valid_589659 = query.getOrDefault("prettyPrint")
  valid_589659 = validateParameter(valid_589659, JBool, required = false,
                                 default = newJBool(true))
  if valid_589659 != nil:
    section.add "prettyPrint", valid_589659
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

proc call*(call_589661: Call_AndroidpublisherInappproductsInsert_589648;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new in-app product for an app.
  ## 
  let valid = call_589661.validator(path, query, header, formData, body)
  let scheme = call_589661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589661.url(scheme.get, call_589661.host, call_589661.base,
                         call_589661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589661, url, valid)

proc call*(call_589662: Call_AndroidpublisherInappproductsInsert_589648;
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
  var path_589663 = newJObject()
  var query_589664 = newJObject()
  var body_589665 = newJObject()
  add(query_589664, "fields", newJString(fields))
  add(path_589663, "packageName", newJString(packageName))
  add(query_589664, "quotaUser", newJString(quotaUser))
  add(query_589664, "alt", newJString(alt))
  add(query_589664, "oauth_token", newJString(oauthToken))
  add(query_589664, "userIp", newJString(userIp))
  add(query_589664, "key", newJString(key))
  add(query_589664, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_589665 = body
  add(query_589664, "prettyPrint", newJBool(prettyPrint))
  result = call_589662.call(path_589663, query_589664, nil, nil, body_589665)

var androidpublisherInappproductsInsert* = Call_AndroidpublisherInappproductsInsert_589648(
    name: "androidpublisherInappproductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsInsert_589649,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsInsert_589650, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsList_589630 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsList_589632(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsList_589631(path: JsonNode;
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
  var valid_589633 = path.getOrDefault("packageName")
  valid_589633 = validateParameter(valid_589633, JString, required = true,
                                 default = nil)
  if valid_589633 != nil:
    section.add "packageName", valid_589633
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
  var valid_589634 = query.getOrDefault("token")
  valid_589634 = validateParameter(valid_589634, JString, required = false,
                                 default = nil)
  if valid_589634 != nil:
    section.add "token", valid_589634
  var valid_589635 = query.getOrDefault("fields")
  valid_589635 = validateParameter(valid_589635, JString, required = false,
                                 default = nil)
  if valid_589635 != nil:
    section.add "fields", valid_589635
  var valid_589636 = query.getOrDefault("quotaUser")
  valid_589636 = validateParameter(valid_589636, JString, required = false,
                                 default = nil)
  if valid_589636 != nil:
    section.add "quotaUser", valid_589636
  var valid_589637 = query.getOrDefault("alt")
  valid_589637 = validateParameter(valid_589637, JString, required = false,
                                 default = newJString("json"))
  if valid_589637 != nil:
    section.add "alt", valid_589637
  var valid_589638 = query.getOrDefault("oauth_token")
  valid_589638 = validateParameter(valid_589638, JString, required = false,
                                 default = nil)
  if valid_589638 != nil:
    section.add "oauth_token", valid_589638
  var valid_589639 = query.getOrDefault("userIp")
  valid_589639 = validateParameter(valid_589639, JString, required = false,
                                 default = nil)
  if valid_589639 != nil:
    section.add "userIp", valid_589639
  var valid_589640 = query.getOrDefault("maxResults")
  valid_589640 = validateParameter(valid_589640, JInt, required = false, default = nil)
  if valid_589640 != nil:
    section.add "maxResults", valid_589640
  var valid_589641 = query.getOrDefault("key")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = nil)
  if valid_589641 != nil:
    section.add "key", valid_589641
  var valid_589642 = query.getOrDefault("prettyPrint")
  valid_589642 = validateParameter(valid_589642, JBool, required = false,
                                 default = newJBool(true))
  if valid_589642 != nil:
    section.add "prettyPrint", valid_589642
  var valid_589643 = query.getOrDefault("startIndex")
  valid_589643 = validateParameter(valid_589643, JInt, required = false, default = nil)
  if valid_589643 != nil:
    section.add "startIndex", valid_589643
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589644: Call_AndroidpublisherInappproductsList_589630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ## 
  let valid = call_589644.validator(path, query, header, formData, body)
  let scheme = call_589644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589644.url(scheme.get, call_589644.host, call_589644.base,
                         call_589644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589644, url, valid)

proc call*(call_589645: Call_AndroidpublisherInappproductsList_589630;
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
  var path_589646 = newJObject()
  var query_589647 = newJObject()
  add(query_589647, "token", newJString(token))
  add(query_589647, "fields", newJString(fields))
  add(path_589646, "packageName", newJString(packageName))
  add(query_589647, "quotaUser", newJString(quotaUser))
  add(query_589647, "alt", newJString(alt))
  add(query_589647, "oauth_token", newJString(oauthToken))
  add(query_589647, "userIp", newJString(userIp))
  add(query_589647, "maxResults", newJInt(maxResults))
  add(query_589647, "key", newJString(key))
  add(query_589647, "prettyPrint", newJBool(prettyPrint))
  add(query_589647, "startIndex", newJInt(startIndex))
  result = call_589645.call(path_589646, query_589647, nil, nil, nil)

var androidpublisherInappproductsList* = Call_AndroidpublisherInappproductsList_589630(
    name: "androidpublisherInappproductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsList_589631,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsList_589632, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsUpdate_589682 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsUpdate_589684(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsUpdate_589683(path: JsonNode;
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
  var valid_589685 = path.getOrDefault("packageName")
  valid_589685 = validateParameter(valid_589685, JString, required = true,
                                 default = nil)
  if valid_589685 != nil:
    section.add "packageName", valid_589685
  var valid_589686 = path.getOrDefault("sku")
  valid_589686 = validateParameter(valid_589686, JString, required = true,
                                 default = nil)
  if valid_589686 != nil:
    section.add "sku", valid_589686
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
  var valid_589687 = query.getOrDefault("fields")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = nil)
  if valid_589687 != nil:
    section.add "fields", valid_589687
  var valid_589688 = query.getOrDefault("quotaUser")
  valid_589688 = validateParameter(valid_589688, JString, required = false,
                                 default = nil)
  if valid_589688 != nil:
    section.add "quotaUser", valid_589688
  var valid_589689 = query.getOrDefault("alt")
  valid_589689 = validateParameter(valid_589689, JString, required = false,
                                 default = newJString("json"))
  if valid_589689 != nil:
    section.add "alt", valid_589689
  var valid_589690 = query.getOrDefault("oauth_token")
  valid_589690 = validateParameter(valid_589690, JString, required = false,
                                 default = nil)
  if valid_589690 != nil:
    section.add "oauth_token", valid_589690
  var valid_589691 = query.getOrDefault("userIp")
  valid_589691 = validateParameter(valid_589691, JString, required = false,
                                 default = nil)
  if valid_589691 != nil:
    section.add "userIp", valid_589691
  var valid_589692 = query.getOrDefault("key")
  valid_589692 = validateParameter(valid_589692, JString, required = false,
                                 default = nil)
  if valid_589692 != nil:
    section.add "key", valid_589692
  var valid_589693 = query.getOrDefault("autoConvertMissingPrices")
  valid_589693 = validateParameter(valid_589693, JBool, required = false, default = nil)
  if valid_589693 != nil:
    section.add "autoConvertMissingPrices", valid_589693
  var valid_589694 = query.getOrDefault("prettyPrint")
  valid_589694 = validateParameter(valid_589694, JBool, required = false,
                                 default = newJBool(true))
  if valid_589694 != nil:
    section.add "prettyPrint", valid_589694
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

proc call*(call_589696: Call_AndroidpublisherInappproductsUpdate_589682;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product.
  ## 
  let valid = call_589696.validator(path, query, header, formData, body)
  let scheme = call_589696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589696.url(scheme.get, call_589696.host, call_589696.base,
                         call_589696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589696, url, valid)

proc call*(call_589697: Call_AndroidpublisherInappproductsUpdate_589682;
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
  var path_589698 = newJObject()
  var query_589699 = newJObject()
  var body_589700 = newJObject()
  add(query_589699, "fields", newJString(fields))
  add(path_589698, "packageName", newJString(packageName))
  add(query_589699, "quotaUser", newJString(quotaUser))
  add(query_589699, "alt", newJString(alt))
  add(query_589699, "oauth_token", newJString(oauthToken))
  add(query_589699, "userIp", newJString(userIp))
  add(path_589698, "sku", newJString(sku))
  add(query_589699, "key", newJString(key))
  add(query_589699, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_589700 = body
  add(query_589699, "prettyPrint", newJBool(prettyPrint))
  result = call_589697.call(path_589698, query_589699, nil, nil, body_589700)

var androidpublisherInappproductsUpdate* = Call_AndroidpublisherInappproductsUpdate_589682(
    name: "androidpublisherInappproductsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsUpdate_589683,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsUpdate_589684, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsGet_589666 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsGet_589668(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsGet_589667(path: JsonNode;
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
  var valid_589669 = path.getOrDefault("packageName")
  valid_589669 = validateParameter(valid_589669, JString, required = true,
                                 default = nil)
  if valid_589669 != nil:
    section.add "packageName", valid_589669
  var valid_589670 = path.getOrDefault("sku")
  valid_589670 = validateParameter(valid_589670, JString, required = true,
                                 default = nil)
  if valid_589670 != nil:
    section.add "sku", valid_589670
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
  var valid_589671 = query.getOrDefault("fields")
  valid_589671 = validateParameter(valid_589671, JString, required = false,
                                 default = nil)
  if valid_589671 != nil:
    section.add "fields", valid_589671
  var valid_589672 = query.getOrDefault("quotaUser")
  valid_589672 = validateParameter(valid_589672, JString, required = false,
                                 default = nil)
  if valid_589672 != nil:
    section.add "quotaUser", valid_589672
  var valid_589673 = query.getOrDefault("alt")
  valid_589673 = validateParameter(valid_589673, JString, required = false,
                                 default = newJString("json"))
  if valid_589673 != nil:
    section.add "alt", valid_589673
  var valid_589674 = query.getOrDefault("oauth_token")
  valid_589674 = validateParameter(valid_589674, JString, required = false,
                                 default = nil)
  if valid_589674 != nil:
    section.add "oauth_token", valid_589674
  var valid_589675 = query.getOrDefault("userIp")
  valid_589675 = validateParameter(valid_589675, JString, required = false,
                                 default = nil)
  if valid_589675 != nil:
    section.add "userIp", valid_589675
  var valid_589676 = query.getOrDefault("key")
  valid_589676 = validateParameter(valid_589676, JString, required = false,
                                 default = nil)
  if valid_589676 != nil:
    section.add "key", valid_589676
  var valid_589677 = query.getOrDefault("prettyPrint")
  valid_589677 = validateParameter(valid_589677, JBool, required = false,
                                 default = newJBool(true))
  if valid_589677 != nil:
    section.add "prettyPrint", valid_589677
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589678: Call_AndroidpublisherInappproductsGet_589666;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the in-app product specified.
  ## 
  let valid = call_589678.validator(path, query, header, formData, body)
  let scheme = call_589678.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589678.url(scheme.get, call_589678.host, call_589678.base,
                         call_589678.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589678, url, valid)

proc call*(call_589679: Call_AndroidpublisherInappproductsGet_589666;
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
  var path_589680 = newJObject()
  var query_589681 = newJObject()
  add(query_589681, "fields", newJString(fields))
  add(path_589680, "packageName", newJString(packageName))
  add(query_589681, "quotaUser", newJString(quotaUser))
  add(query_589681, "alt", newJString(alt))
  add(query_589681, "oauth_token", newJString(oauthToken))
  add(query_589681, "userIp", newJString(userIp))
  add(path_589680, "sku", newJString(sku))
  add(query_589681, "key", newJString(key))
  add(query_589681, "prettyPrint", newJBool(prettyPrint))
  result = call_589679.call(path_589680, query_589681, nil, nil, nil)

var androidpublisherInappproductsGet* = Call_AndroidpublisherInappproductsGet_589666(
    name: "androidpublisherInappproductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsGet_589667,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsGet_589668, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsPatch_589717 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsPatch_589719(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsPatch_589718(path: JsonNode;
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
  var valid_589720 = path.getOrDefault("packageName")
  valid_589720 = validateParameter(valid_589720, JString, required = true,
                                 default = nil)
  if valid_589720 != nil:
    section.add "packageName", valid_589720
  var valid_589721 = path.getOrDefault("sku")
  valid_589721 = validateParameter(valid_589721, JString, required = true,
                                 default = nil)
  if valid_589721 != nil:
    section.add "sku", valid_589721
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
  var valid_589722 = query.getOrDefault("fields")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = nil)
  if valid_589722 != nil:
    section.add "fields", valid_589722
  var valid_589723 = query.getOrDefault("quotaUser")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = nil)
  if valid_589723 != nil:
    section.add "quotaUser", valid_589723
  var valid_589724 = query.getOrDefault("alt")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = newJString("json"))
  if valid_589724 != nil:
    section.add "alt", valid_589724
  var valid_589725 = query.getOrDefault("oauth_token")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "oauth_token", valid_589725
  var valid_589726 = query.getOrDefault("userIp")
  valid_589726 = validateParameter(valid_589726, JString, required = false,
                                 default = nil)
  if valid_589726 != nil:
    section.add "userIp", valid_589726
  var valid_589727 = query.getOrDefault("key")
  valid_589727 = validateParameter(valid_589727, JString, required = false,
                                 default = nil)
  if valid_589727 != nil:
    section.add "key", valid_589727
  var valid_589728 = query.getOrDefault("autoConvertMissingPrices")
  valid_589728 = validateParameter(valid_589728, JBool, required = false, default = nil)
  if valid_589728 != nil:
    section.add "autoConvertMissingPrices", valid_589728
  var valid_589729 = query.getOrDefault("prettyPrint")
  valid_589729 = validateParameter(valid_589729, JBool, required = false,
                                 default = newJBool(true))
  if valid_589729 != nil:
    section.add "prettyPrint", valid_589729
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

proc call*(call_589731: Call_AndroidpublisherInappproductsPatch_589717;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product. This method supports patch semantics.
  ## 
  let valid = call_589731.validator(path, query, header, formData, body)
  let scheme = call_589731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589731.url(scheme.get, call_589731.host, call_589731.base,
                         call_589731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589731, url, valid)

proc call*(call_589732: Call_AndroidpublisherInappproductsPatch_589717;
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
  var path_589733 = newJObject()
  var query_589734 = newJObject()
  var body_589735 = newJObject()
  add(query_589734, "fields", newJString(fields))
  add(path_589733, "packageName", newJString(packageName))
  add(query_589734, "quotaUser", newJString(quotaUser))
  add(query_589734, "alt", newJString(alt))
  add(query_589734, "oauth_token", newJString(oauthToken))
  add(query_589734, "userIp", newJString(userIp))
  add(path_589733, "sku", newJString(sku))
  add(query_589734, "key", newJString(key))
  add(query_589734, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_589735 = body
  add(query_589734, "prettyPrint", newJBool(prettyPrint))
  result = call_589732.call(path_589733, query_589734, nil, nil, body_589735)

var androidpublisherInappproductsPatch* = Call_AndroidpublisherInappproductsPatch_589717(
    name: "androidpublisherInappproductsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsPatch_589718,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsPatch_589719, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsDelete_589701 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherInappproductsDelete_589703(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsDelete_589702(path: JsonNode;
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
  var valid_589704 = path.getOrDefault("packageName")
  valid_589704 = validateParameter(valid_589704, JString, required = true,
                                 default = nil)
  if valid_589704 != nil:
    section.add "packageName", valid_589704
  var valid_589705 = path.getOrDefault("sku")
  valid_589705 = validateParameter(valid_589705, JString, required = true,
                                 default = nil)
  if valid_589705 != nil:
    section.add "sku", valid_589705
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
  var valid_589706 = query.getOrDefault("fields")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = nil)
  if valid_589706 != nil:
    section.add "fields", valid_589706
  var valid_589707 = query.getOrDefault("quotaUser")
  valid_589707 = validateParameter(valid_589707, JString, required = false,
                                 default = nil)
  if valid_589707 != nil:
    section.add "quotaUser", valid_589707
  var valid_589708 = query.getOrDefault("alt")
  valid_589708 = validateParameter(valid_589708, JString, required = false,
                                 default = newJString("json"))
  if valid_589708 != nil:
    section.add "alt", valid_589708
  var valid_589709 = query.getOrDefault("oauth_token")
  valid_589709 = validateParameter(valid_589709, JString, required = false,
                                 default = nil)
  if valid_589709 != nil:
    section.add "oauth_token", valid_589709
  var valid_589710 = query.getOrDefault("userIp")
  valid_589710 = validateParameter(valid_589710, JString, required = false,
                                 default = nil)
  if valid_589710 != nil:
    section.add "userIp", valid_589710
  var valid_589711 = query.getOrDefault("key")
  valid_589711 = validateParameter(valid_589711, JString, required = false,
                                 default = nil)
  if valid_589711 != nil:
    section.add "key", valid_589711
  var valid_589712 = query.getOrDefault("prettyPrint")
  valid_589712 = validateParameter(valid_589712, JBool, required = false,
                                 default = newJBool(true))
  if valid_589712 != nil:
    section.add "prettyPrint", valid_589712
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589713: Call_AndroidpublisherInappproductsDelete_589701;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an in-app product for an app.
  ## 
  let valid = call_589713.validator(path, query, header, formData, body)
  let scheme = call_589713.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589713.url(scheme.get, call_589713.host, call_589713.base,
                         call_589713.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589713, url, valid)

proc call*(call_589714: Call_AndroidpublisherInappproductsDelete_589701;
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
  var path_589715 = newJObject()
  var query_589716 = newJObject()
  add(query_589716, "fields", newJString(fields))
  add(path_589715, "packageName", newJString(packageName))
  add(query_589716, "quotaUser", newJString(quotaUser))
  add(query_589716, "alt", newJString(alt))
  add(query_589716, "oauth_token", newJString(oauthToken))
  add(query_589716, "userIp", newJString(userIp))
  add(path_589715, "sku", newJString(sku))
  add(query_589716, "key", newJString(key))
  add(query_589716, "prettyPrint", newJBool(prettyPrint))
  result = call_589714.call(path_589715, query_589716, nil, nil, nil)

var androidpublisherInappproductsDelete* = Call_AndroidpublisherInappproductsDelete_589701(
    name: "androidpublisherInappproductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsDelete_589702,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsDelete_589703, schemes: {Scheme.Https})
type
  Call_AndroidpublisherOrdersRefund_589736 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherOrdersRefund_589738(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherOrdersRefund_589737(path: JsonNode; query: JsonNode;
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
  var valid_589739 = path.getOrDefault("packageName")
  valid_589739 = validateParameter(valid_589739, JString, required = true,
                                 default = nil)
  if valid_589739 != nil:
    section.add "packageName", valid_589739
  var valid_589740 = path.getOrDefault("orderId")
  valid_589740 = validateParameter(valid_589740, JString, required = true,
                                 default = nil)
  if valid_589740 != nil:
    section.add "orderId", valid_589740
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
  var valid_589741 = query.getOrDefault("fields")
  valid_589741 = validateParameter(valid_589741, JString, required = false,
                                 default = nil)
  if valid_589741 != nil:
    section.add "fields", valid_589741
  var valid_589742 = query.getOrDefault("quotaUser")
  valid_589742 = validateParameter(valid_589742, JString, required = false,
                                 default = nil)
  if valid_589742 != nil:
    section.add "quotaUser", valid_589742
  var valid_589743 = query.getOrDefault("alt")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = newJString("json"))
  if valid_589743 != nil:
    section.add "alt", valid_589743
  var valid_589744 = query.getOrDefault("oauth_token")
  valid_589744 = validateParameter(valid_589744, JString, required = false,
                                 default = nil)
  if valid_589744 != nil:
    section.add "oauth_token", valid_589744
  var valid_589745 = query.getOrDefault("userIp")
  valid_589745 = validateParameter(valid_589745, JString, required = false,
                                 default = nil)
  if valid_589745 != nil:
    section.add "userIp", valid_589745
  var valid_589746 = query.getOrDefault("key")
  valid_589746 = validateParameter(valid_589746, JString, required = false,
                                 default = nil)
  if valid_589746 != nil:
    section.add "key", valid_589746
  var valid_589747 = query.getOrDefault("revoke")
  valid_589747 = validateParameter(valid_589747, JBool, required = false, default = nil)
  if valid_589747 != nil:
    section.add "revoke", valid_589747
  var valid_589748 = query.getOrDefault("prettyPrint")
  valid_589748 = validateParameter(valid_589748, JBool, required = false,
                                 default = newJBool(true))
  if valid_589748 != nil:
    section.add "prettyPrint", valid_589748
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589749: Call_AndroidpublisherOrdersRefund_589736; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refund a user's subscription or in-app purchase order.
  ## 
  let valid = call_589749.validator(path, query, header, formData, body)
  let scheme = call_589749.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589749.url(scheme.get, call_589749.host, call_589749.base,
                         call_589749.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589749, url, valid)

proc call*(call_589750: Call_AndroidpublisherOrdersRefund_589736;
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
  var path_589751 = newJObject()
  var query_589752 = newJObject()
  add(query_589752, "fields", newJString(fields))
  add(path_589751, "packageName", newJString(packageName))
  add(query_589752, "quotaUser", newJString(quotaUser))
  add(query_589752, "alt", newJString(alt))
  add(query_589752, "oauth_token", newJString(oauthToken))
  add(query_589752, "userIp", newJString(userIp))
  add(path_589751, "orderId", newJString(orderId))
  add(query_589752, "key", newJString(key))
  add(query_589752, "revoke", newJBool(revoke))
  add(query_589752, "prettyPrint", newJBool(prettyPrint))
  result = call_589750.call(path_589751, query_589752, nil, nil, nil)

var androidpublisherOrdersRefund* = Call_AndroidpublisherOrdersRefund_589736(
    name: "androidpublisherOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/orders/{orderId}:refund",
    validator: validate_AndroidpublisherOrdersRefund_589737,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherOrdersRefund_589738, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsGet_589753 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesProductsGet_589755(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesProductsGet_589754(path: JsonNode;
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
  var valid_589756 = path.getOrDefault("packageName")
  valid_589756 = validateParameter(valid_589756, JString, required = true,
                                 default = nil)
  if valid_589756 != nil:
    section.add "packageName", valid_589756
  var valid_589757 = path.getOrDefault("token")
  valid_589757 = validateParameter(valid_589757, JString, required = true,
                                 default = nil)
  if valid_589757 != nil:
    section.add "token", valid_589757
  var valid_589758 = path.getOrDefault("productId")
  valid_589758 = validateParameter(valid_589758, JString, required = true,
                                 default = nil)
  if valid_589758 != nil:
    section.add "productId", valid_589758
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
  var valid_589759 = query.getOrDefault("fields")
  valid_589759 = validateParameter(valid_589759, JString, required = false,
                                 default = nil)
  if valid_589759 != nil:
    section.add "fields", valid_589759
  var valid_589760 = query.getOrDefault("quotaUser")
  valid_589760 = validateParameter(valid_589760, JString, required = false,
                                 default = nil)
  if valid_589760 != nil:
    section.add "quotaUser", valid_589760
  var valid_589761 = query.getOrDefault("alt")
  valid_589761 = validateParameter(valid_589761, JString, required = false,
                                 default = newJString("json"))
  if valid_589761 != nil:
    section.add "alt", valid_589761
  var valid_589762 = query.getOrDefault("oauth_token")
  valid_589762 = validateParameter(valid_589762, JString, required = false,
                                 default = nil)
  if valid_589762 != nil:
    section.add "oauth_token", valid_589762
  var valid_589763 = query.getOrDefault("userIp")
  valid_589763 = validateParameter(valid_589763, JString, required = false,
                                 default = nil)
  if valid_589763 != nil:
    section.add "userIp", valid_589763
  var valid_589764 = query.getOrDefault("key")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = nil)
  if valid_589764 != nil:
    section.add "key", valid_589764
  var valid_589765 = query.getOrDefault("prettyPrint")
  valid_589765 = validateParameter(valid_589765, JBool, required = false,
                                 default = newJBool(true))
  if valid_589765 != nil:
    section.add "prettyPrint", valid_589765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589766: Call_AndroidpublisherPurchasesProductsGet_589753;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  let valid = call_589766.validator(path, query, header, formData, body)
  let scheme = call_589766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589766.url(scheme.get, call_589766.host, call_589766.base,
                         call_589766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589766, url, valid)

proc call*(call_589767: Call_AndroidpublisherPurchasesProductsGet_589753;
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
  var path_589768 = newJObject()
  var query_589769 = newJObject()
  add(query_589769, "fields", newJString(fields))
  add(path_589768, "packageName", newJString(packageName))
  add(query_589769, "quotaUser", newJString(quotaUser))
  add(query_589769, "alt", newJString(alt))
  add(query_589769, "oauth_token", newJString(oauthToken))
  add(query_589769, "userIp", newJString(userIp))
  add(query_589769, "key", newJString(key))
  add(path_589768, "token", newJString(token))
  add(path_589768, "productId", newJString(productId))
  add(query_589769, "prettyPrint", newJBool(prettyPrint))
  result = call_589767.call(path_589768, query_589769, nil, nil, nil)

var androidpublisherPurchasesProductsGet* = Call_AndroidpublisherPurchasesProductsGet_589753(
    name: "androidpublisherPurchasesProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/purchases/products/{productId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesProductsGet_589754,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesProductsGet_589755, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsAcknowledge_589770 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesProductsAcknowledge_589772(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesProductsAcknowledge_589771(path: JsonNode;
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
  var valid_589773 = path.getOrDefault("packageName")
  valid_589773 = validateParameter(valid_589773, JString, required = true,
                                 default = nil)
  if valid_589773 != nil:
    section.add "packageName", valid_589773
  var valid_589774 = path.getOrDefault("token")
  valid_589774 = validateParameter(valid_589774, JString, required = true,
                                 default = nil)
  if valid_589774 != nil:
    section.add "token", valid_589774
  var valid_589775 = path.getOrDefault("productId")
  valid_589775 = validateParameter(valid_589775, JString, required = true,
                                 default = nil)
  if valid_589775 != nil:
    section.add "productId", valid_589775
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
  var valid_589776 = query.getOrDefault("fields")
  valid_589776 = validateParameter(valid_589776, JString, required = false,
                                 default = nil)
  if valid_589776 != nil:
    section.add "fields", valid_589776
  var valid_589777 = query.getOrDefault("quotaUser")
  valid_589777 = validateParameter(valid_589777, JString, required = false,
                                 default = nil)
  if valid_589777 != nil:
    section.add "quotaUser", valid_589777
  var valid_589778 = query.getOrDefault("alt")
  valid_589778 = validateParameter(valid_589778, JString, required = false,
                                 default = newJString("json"))
  if valid_589778 != nil:
    section.add "alt", valid_589778
  var valid_589779 = query.getOrDefault("oauth_token")
  valid_589779 = validateParameter(valid_589779, JString, required = false,
                                 default = nil)
  if valid_589779 != nil:
    section.add "oauth_token", valid_589779
  var valid_589780 = query.getOrDefault("userIp")
  valid_589780 = validateParameter(valid_589780, JString, required = false,
                                 default = nil)
  if valid_589780 != nil:
    section.add "userIp", valid_589780
  var valid_589781 = query.getOrDefault("key")
  valid_589781 = validateParameter(valid_589781, JString, required = false,
                                 default = nil)
  if valid_589781 != nil:
    section.add "key", valid_589781
  var valid_589782 = query.getOrDefault("prettyPrint")
  valid_589782 = validateParameter(valid_589782, JBool, required = false,
                                 default = newJBool(true))
  if valid_589782 != nil:
    section.add "prettyPrint", valid_589782
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

proc call*(call_589784: Call_AndroidpublisherPurchasesProductsAcknowledge_589770;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges a purchase of an inapp item.
  ## 
  let valid = call_589784.validator(path, query, header, formData, body)
  let scheme = call_589784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589784.url(scheme.get, call_589784.host, call_589784.base,
                         call_589784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589784, url, valid)

proc call*(call_589785: Call_AndroidpublisherPurchasesProductsAcknowledge_589770;
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
  var path_589786 = newJObject()
  var query_589787 = newJObject()
  var body_589788 = newJObject()
  add(query_589787, "fields", newJString(fields))
  add(path_589786, "packageName", newJString(packageName))
  add(query_589787, "quotaUser", newJString(quotaUser))
  add(query_589787, "alt", newJString(alt))
  add(query_589787, "oauth_token", newJString(oauthToken))
  add(query_589787, "userIp", newJString(userIp))
  add(query_589787, "key", newJString(key))
  add(path_589786, "token", newJString(token))
  if body != nil:
    body_589788 = body
  add(query_589787, "prettyPrint", newJBool(prettyPrint))
  add(path_589786, "productId", newJString(productId))
  result = call_589785.call(path_589786, query_589787, nil, nil, body_589788)

var androidpublisherPurchasesProductsAcknowledge* = Call_AndroidpublisherPurchasesProductsAcknowledge_589770(
    name: "androidpublisherPurchasesProductsAcknowledge",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/products/{productId}/tokens/{token}:acknowledge",
    validator: validate_AndroidpublisherPurchasesProductsAcknowledge_589771,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesProductsAcknowledge_589772,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsGet_589789 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesSubscriptionsGet_589791(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsGet_589790(path: JsonNode;
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
  var valid_589792 = path.getOrDefault("packageName")
  valid_589792 = validateParameter(valid_589792, JString, required = true,
                                 default = nil)
  if valid_589792 != nil:
    section.add "packageName", valid_589792
  var valid_589793 = path.getOrDefault("subscriptionId")
  valid_589793 = validateParameter(valid_589793, JString, required = true,
                                 default = nil)
  if valid_589793 != nil:
    section.add "subscriptionId", valid_589793
  var valid_589794 = path.getOrDefault("token")
  valid_589794 = validateParameter(valid_589794, JString, required = true,
                                 default = nil)
  if valid_589794 != nil:
    section.add "token", valid_589794
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
  var valid_589795 = query.getOrDefault("fields")
  valid_589795 = validateParameter(valid_589795, JString, required = false,
                                 default = nil)
  if valid_589795 != nil:
    section.add "fields", valid_589795
  var valid_589796 = query.getOrDefault("quotaUser")
  valid_589796 = validateParameter(valid_589796, JString, required = false,
                                 default = nil)
  if valid_589796 != nil:
    section.add "quotaUser", valid_589796
  var valid_589797 = query.getOrDefault("alt")
  valid_589797 = validateParameter(valid_589797, JString, required = false,
                                 default = newJString("json"))
  if valid_589797 != nil:
    section.add "alt", valid_589797
  var valid_589798 = query.getOrDefault("oauth_token")
  valid_589798 = validateParameter(valid_589798, JString, required = false,
                                 default = nil)
  if valid_589798 != nil:
    section.add "oauth_token", valid_589798
  var valid_589799 = query.getOrDefault("userIp")
  valid_589799 = validateParameter(valid_589799, JString, required = false,
                                 default = nil)
  if valid_589799 != nil:
    section.add "userIp", valid_589799
  var valid_589800 = query.getOrDefault("key")
  valid_589800 = validateParameter(valid_589800, JString, required = false,
                                 default = nil)
  if valid_589800 != nil:
    section.add "key", valid_589800
  var valid_589801 = query.getOrDefault("prettyPrint")
  valid_589801 = validateParameter(valid_589801, JBool, required = false,
                                 default = newJBool(true))
  if valid_589801 != nil:
    section.add "prettyPrint", valid_589801
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589802: Call_AndroidpublisherPurchasesSubscriptionsGet_589789;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_589802.validator(path, query, header, formData, body)
  let scheme = call_589802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589802.url(scheme.get, call_589802.host, call_589802.base,
                         call_589802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589802, url, valid)

proc call*(call_589803: Call_AndroidpublisherPurchasesSubscriptionsGet_589789;
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
  var path_589804 = newJObject()
  var query_589805 = newJObject()
  add(query_589805, "fields", newJString(fields))
  add(path_589804, "packageName", newJString(packageName))
  add(query_589805, "quotaUser", newJString(quotaUser))
  add(query_589805, "alt", newJString(alt))
  add(path_589804, "subscriptionId", newJString(subscriptionId))
  add(query_589805, "oauth_token", newJString(oauthToken))
  add(query_589805, "userIp", newJString(userIp))
  add(query_589805, "key", newJString(key))
  add(path_589804, "token", newJString(token))
  add(query_589805, "prettyPrint", newJBool(prettyPrint))
  result = call_589803.call(path_589804, query_589805, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsGet* = Call_AndroidpublisherPurchasesSubscriptionsGet_589789(
    name: "androidpublisherPurchasesSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesSubscriptionsGet_589790,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsGet_589791,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_589806 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesSubscriptionsAcknowledge_589808(
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

proc validate_AndroidpublisherPurchasesSubscriptionsAcknowledge_589807(
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
  var valid_589809 = path.getOrDefault("packageName")
  valid_589809 = validateParameter(valid_589809, JString, required = true,
                                 default = nil)
  if valid_589809 != nil:
    section.add "packageName", valid_589809
  var valid_589810 = path.getOrDefault("subscriptionId")
  valid_589810 = validateParameter(valid_589810, JString, required = true,
                                 default = nil)
  if valid_589810 != nil:
    section.add "subscriptionId", valid_589810
  var valid_589811 = path.getOrDefault("token")
  valid_589811 = validateParameter(valid_589811, JString, required = true,
                                 default = nil)
  if valid_589811 != nil:
    section.add "token", valid_589811
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
  var valid_589817 = query.getOrDefault("key")
  valid_589817 = validateParameter(valid_589817, JString, required = false,
                                 default = nil)
  if valid_589817 != nil:
    section.add "key", valid_589817
  var valid_589818 = query.getOrDefault("prettyPrint")
  valid_589818 = validateParameter(valid_589818, JBool, required = false,
                                 default = newJBool(true))
  if valid_589818 != nil:
    section.add "prettyPrint", valid_589818
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

proc call*(call_589820: Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_589806;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges a subscription purchase.
  ## 
  let valid = call_589820.validator(path, query, header, formData, body)
  let scheme = call_589820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589820.url(scheme.get, call_589820.host, call_589820.base,
                         call_589820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589820, url, valid)

proc call*(call_589821: Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_589806;
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
  var path_589822 = newJObject()
  var query_589823 = newJObject()
  var body_589824 = newJObject()
  add(query_589823, "fields", newJString(fields))
  add(path_589822, "packageName", newJString(packageName))
  add(query_589823, "quotaUser", newJString(quotaUser))
  add(query_589823, "alt", newJString(alt))
  add(path_589822, "subscriptionId", newJString(subscriptionId))
  add(query_589823, "oauth_token", newJString(oauthToken))
  add(query_589823, "userIp", newJString(userIp))
  add(query_589823, "key", newJString(key))
  add(path_589822, "token", newJString(token))
  if body != nil:
    body_589824 = body
  add(query_589823, "prettyPrint", newJBool(prettyPrint))
  result = call_589821.call(path_589822, query_589823, nil, nil, body_589824)

var androidpublisherPurchasesSubscriptionsAcknowledge* = Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_589806(
    name: "androidpublisherPurchasesSubscriptionsAcknowledge",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:acknowledge",
    validator: validate_AndroidpublisherPurchasesSubscriptionsAcknowledge_589807,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsAcknowledge_589808,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsCancel_589825 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesSubscriptionsCancel_589827(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsCancel_589826(path: JsonNode;
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
  var valid_589828 = path.getOrDefault("packageName")
  valid_589828 = validateParameter(valid_589828, JString, required = true,
                                 default = nil)
  if valid_589828 != nil:
    section.add "packageName", valid_589828
  var valid_589829 = path.getOrDefault("subscriptionId")
  valid_589829 = validateParameter(valid_589829, JString, required = true,
                                 default = nil)
  if valid_589829 != nil:
    section.add "subscriptionId", valid_589829
  var valid_589830 = path.getOrDefault("token")
  valid_589830 = validateParameter(valid_589830, JString, required = true,
                                 default = nil)
  if valid_589830 != nil:
    section.add "token", valid_589830
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
  var valid_589835 = query.getOrDefault("userIp")
  valid_589835 = validateParameter(valid_589835, JString, required = false,
                                 default = nil)
  if valid_589835 != nil:
    section.add "userIp", valid_589835
  var valid_589836 = query.getOrDefault("key")
  valid_589836 = validateParameter(valid_589836, JString, required = false,
                                 default = nil)
  if valid_589836 != nil:
    section.add "key", valid_589836
  var valid_589837 = query.getOrDefault("prettyPrint")
  valid_589837 = validateParameter(valid_589837, JBool, required = false,
                                 default = newJBool(true))
  if valid_589837 != nil:
    section.add "prettyPrint", valid_589837
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589838: Call_AndroidpublisherPurchasesSubscriptionsCancel_589825;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_589838.validator(path, query, header, formData, body)
  let scheme = call_589838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589838.url(scheme.get, call_589838.host, call_589838.base,
                         call_589838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589838, url, valid)

proc call*(call_589839: Call_AndroidpublisherPurchasesSubscriptionsCancel_589825;
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
  var path_589840 = newJObject()
  var query_589841 = newJObject()
  add(query_589841, "fields", newJString(fields))
  add(path_589840, "packageName", newJString(packageName))
  add(query_589841, "quotaUser", newJString(quotaUser))
  add(query_589841, "alt", newJString(alt))
  add(path_589840, "subscriptionId", newJString(subscriptionId))
  add(query_589841, "oauth_token", newJString(oauthToken))
  add(query_589841, "userIp", newJString(userIp))
  add(query_589841, "key", newJString(key))
  add(path_589840, "token", newJString(token))
  add(query_589841, "prettyPrint", newJBool(prettyPrint))
  result = call_589839.call(path_589840, query_589841, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsCancel* = Call_AndroidpublisherPurchasesSubscriptionsCancel_589825(
    name: "androidpublisherPurchasesSubscriptionsCancel",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:cancel",
    validator: validate_AndroidpublisherPurchasesSubscriptionsCancel_589826,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsCancel_589827,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsDefer_589842 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesSubscriptionsDefer_589844(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsDefer_589843(path: JsonNode;
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
  var valid_589845 = path.getOrDefault("packageName")
  valid_589845 = validateParameter(valid_589845, JString, required = true,
                                 default = nil)
  if valid_589845 != nil:
    section.add "packageName", valid_589845
  var valid_589846 = path.getOrDefault("subscriptionId")
  valid_589846 = validateParameter(valid_589846, JString, required = true,
                                 default = nil)
  if valid_589846 != nil:
    section.add "subscriptionId", valid_589846
  var valid_589847 = path.getOrDefault("token")
  valid_589847 = validateParameter(valid_589847, JString, required = true,
                                 default = nil)
  if valid_589847 != nil:
    section.add "token", valid_589847
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
  var valid_589848 = query.getOrDefault("fields")
  valid_589848 = validateParameter(valid_589848, JString, required = false,
                                 default = nil)
  if valid_589848 != nil:
    section.add "fields", valid_589848
  var valid_589849 = query.getOrDefault("quotaUser")
  valid_589849 = validateParameter(valid_589849, JString, required = false,
                                 default = nil)
  if valid_589849 != nil:
    section.add "quotaUser", valid_589849
  var valid_589850 = query.getOrDefault("alt")
  valid_589850 = validateParameter(valid_589850, JString, required = false,
                                 default = newJString("json"))
  if valid_589850 != nil:
    section.add "alt", valid_589850
  var valid_589851 = query.getOrDefault("oauth_token")
  valid_589851 = validateParameter(valid_589851, JString, required = false,
                                 default = nil)
  if valid_589851 != nil:
    section.add "oauth_token", valid_589851
  var valid_589852 = query.getOrDefault("userIp")
  valid_589852 = validateParameter(valid_589852, JString, required = false,
                                 default = nil)
  if valid_589852 != nil:
    section.add "userIp", valid_589852
  var valid_589853 = query.getOrDefault("key")
  valid_589853 = validateParameter(valid_589853, JString, required = false,
                                 default = nil)
  if valid_589853 != nil:
    section.add "key", valid_589853
  var valid_589854 = query.getOrDefault("prettyPrint")
  valid_589854 = validateParameter(valid_589854, JBool, required = false,
                                 default = newJBool(true))
  if valid_589854 != nil:
    section.add "prettyPrint", valid_589854
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

proc call*(call_589856: Call_AndroidpublisherPurchasesSubscriptionsDefer_589842;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Defers a user's subscription purchase until a specified future expiration time.
  ## 
  let valid = call_589856.validator(path, query, header, formData, body)
  let scheme = call_589856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589856.url(scheme.get, call_589856.host, call_589856.base,
                         call_589856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589856, url, valid)

proc call*(call_589857: Call_AndroidpublisherPurchasesSubscriptionsDefer_589842;
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
  var path_589858 = newJObject()
  var query_589859 = newJObject()
  var body_589860 = newJObject()
  add(query_589859, "fields", newJString(fields))
  add(path_589858, "packageName", newJString(packageName))
  add(query_589859, "quotaUser", newJString(quotaUser))
  add(query_589859, "alt", newJString(alt))
  add(path_589858, "subscriptionId", newJString(subscriptionId))
  add(query_589859, "oauth_token", newJString(oauthToken))
  add(query_589859, "userIp", newJString(userIp))
  add(query_589859, "key", newJString(key))
  add(path_589858, "token", newJString(token))
  if body != nil:
    body_589860 = body
  add(query_589859, "prettyPrint", newJBool(prettyPrint))
  result = call_589857.call(path_589858, query_589859, nil, nil, body_589860)

var androidpublisherPurchasesSubscriptionsDefer* = Call_AndroidpublisherPurchasesSubscriptionsDefer_589842(
    name: "androidpublisherPurchasesSubscriptionsDefer",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:defer",
    validator: validate_AndroidpublisherPurchasesSubscriptionsDefer_589843,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsDefer_589844,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRefund_589861 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesSubscriptionsRefund_589863(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsRefund_589862(path: JsonNode;
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
  var valid_589864 = path.getOrDefault("packageName")
  valid_589864 = validateParameter(valid_589864, JString, required = true,
                                 default = nil)
  if valid_589864 != nil:
    section.add "packageName", valid_589864
  var valid_589865 = path.getOrDefault("subscriptionId")
  valid_589865 = validateParameter(valid_589865, JString, required = true,
                                 default = nil)
  if valid_589865 != nil:
    section.add "subscriptionId", valid_589865
  var valid_589866 = path.getOrDefault("token")
  valid_589866 = validateParameter(valid_589866, JString, required = true,
                                 default = nil)
  if valid_589866 != nil:
    section.add "token", valid_589866
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
  var valid_589867 = query.getOrDefault("fields")
  valid_589867 = validateParameter(valid_589867, JString, required = false,
                                 default = nil)
  if valid_589867 != nil:
    section.add "fields", valid_589867
  var valid_589868 = query.getOrDefault("quotaUser")
  valid_589868 = validateParameter(valid_589868, JString, required = false,
                                 default = nil)
  if valid_589868 != nil:
    section.add "quotaUser", valid_589868
  var valid_589869 = query.getOrDefault("alt")
  valid_589869 = validateParameter(valid_589869, JString, required = false,
                                 default = newJString("json"))
  if valid_589869 != nil:
    section.add "alt", valid_589869
  var valid_589870 = query.getOrDefault("oauth_token")
  valid_589870 = validateParameter(valid_589870, JString, required = false,
                                 default = nil)
  if valid_589870 != nil:
    section.add "oauth_token", valid_589870
  var valid_589871 = query.getOrDefault("userIp")
  valid_589871 = validateParameter(valid_589871, JString, required = false,
                                 default = nil)
  if valid_589871 != nil:
    section.add "userIp", valid_589871
  var valid_589872 = query.getOrDefault("key")
  valid_589872 = validateParameter(valid_589872, JString, required = false,
                                 default = nil)
  if valid_589872 != nil:
    section.add "key", valid_589872
  var valid_589873 = query.getOrDefault("prettyPrint")
  valid_589873 = validateParameter(valid_589873, JBool, required = false,
                                 default = newJBool(true))
  if valid_589873 != nil:
    section.add "prettyPrint", valid_589873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589874: Call_AndroidpublisherPurchasesSubscriptionsRefund_589861;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ## 
  let valid = call_589874.validator(path, query, header, formData, body)
  let scheme = call_589874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589874.url(scheme.get, call_589874.host, call_589874.base,
                         call_589874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589874, url, valid)

proc call*(call_589875: Call_AndroidpublisherPurchasesSubscriptionsRefund_589861;
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
  var path_589876 = newJObject()
  var query_589877 = newJObject()
  add(query_589877, "fields", newJString(fields))
  add(path_589876, "packageName", newJString(packageName))
  add(query_589877, "quotaUser", newJString(quotaUser))
  add(query_589877, "alt", newJString(alt))
  add(path_589876, "subscriptionId", newJString(subscriptionId))
  add(query_589877, "oauth_token", newJString(oauthToken))
  add(query_589877, "userIp", newJString(userIp))
  add(query_589877, "key", newJString(key))
  add(path_589876, "token", newJString(token))
  add(query_589877, "prettyPrint", newJBool(prettyPrint))
  result = call_589875.call(path_589876, query_589877, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRefund* = Call_AndroidpublisherPurchasesSubscriptionsRefund_589861(
    name: "androidpublisherPurchasesSubscriptionsRefund",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:refund",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRefund_589862,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRefund_589863,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRevoke_589878 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesSubscriptionsRevoke_589880(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsRevoke_589879(path: JsonNode;
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
  var valid_589881 = path.getOrDefault("packageName")
  valid_589881 = validateParameter(valid_589881, JString, required = true,
                                 default = nil)
  if valid_589881 != nil:
    section.add "packageName", valid_589881
  var valid_589882 = path.getOrDefault("subscriptionId")
  valid_589882 = validateParameter(valid_589882, JString, required = true,
                                 default = nil)
  if valid_589882 != nil:
    section.add "subscriptionId", valid_589882
  var valid_589883 = path.getOrDefault("token")
  valid_589883 = validateParameter(valid_589883, JString, required = true,
                                 default = nil)
  if valid_589883 != nil:
    section.add "token", valid_589883
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
  var valid_589884 = query.getOrDefault("fields")
  valid_589884 = validateParameter(valid_589884, JString, required = false,
                                 default = nil)
  if valid_589884 != nil:
    section.add "fields", valid_589884
  var valid_589885 = query.getOrDefault("quotaUser")
  valid_589885 = validateParameter(valid_589885, JString, required = false,
                                 default = nil)
  if valid_589885 != nil:
    section.add "quotaUser", valid_589885
  var valid_589886 = query.getOrDefault("alt")
  valid_589886 = validateParameter(valid_589886, JString, required = false,
                                 default = newJString("json"))
  if valid_589886 != nil:
    section.add "alt", valid_589886
  var valid_589887 = query.getOrDefault("oauth_token")
  valid_589887 = validateParameter(valid_589887, JString, required = false,
                                 default = nil)
  if valid_589887 != nil:
    section.add "oauth_token", valid_589887
  var valid_589888 = query.getOrDefault("userIp")
  valid_589888 = validateParameter(valid_589888, JString, required = false,
                                 default = nil)
  if valid_589888 != nil:
    section.add "userIp", valid_589888
  var valid_589889 = query.getOrDefault("key")
  valid_589889 = validateParameter(valid_589889, JString, required = false,
                                 default = nil)
  if valid_589889 != nil:
    section.add "key", valid_589889
  var valid_589890 = query.getOrDefault("prettyPrint")
  valid_589890 = validateParameter(valid_589890, JBool, required = false,
                                 default = newJBool(true))
  if valid_589890 != nil:
    section.add "prettyPrint", valid_589890
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589891: Call_AndroidpublisherPurchasesSubscriptionsRevoke_589878;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ## 
  let valid = call_589891.validator(path, query, header, formData, body)
  let scheme = call_589891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589891.url(scheme.get, call_589891.host, call_589891.base,
                         call_589891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589891, url, valid)

proc call*(call_589892: Call_AndroidpublisherPurchasesSubscriptionsRevoke_589878;
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
  var path_589893 = newJObject()
  var query_589894 = newJObject()
  add(query_589894, "fields", newJString(fields))
  add(path_589893, "packageName", newJString(packageName))
  add(query_589894, "quotaUser", newJString(quotaUser))
  add(query_589894, "alt", newJString(alt))
  add(path_589893, "subscriptionId", newJString(subscriptionId))
  add(query_589894, "oauth_token", newJString(oauthToken))
  add(query_589894, "userIp", newJString(userIp))
  add(query_589894, "key", newJString(key))
  add(path_589893, "token", newJString(token))
  add(query_589894, "prettyPrint", newJBool(prettyPrint))
  result = call_589892.call(path_589893, query_589894, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRevoke* = Call_AndroidpublisherPurchasesSubscriptionsRevoke_589878(
    name: "androidpublisherPurchasesSubscriptionsRevoke",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:revoke",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRevoke_589879,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRevoke_589880,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesVoidedpurchasesList_589895 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherPurchasesVoidedpurchasesList_589897(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesVoidedpurchasesList_589896(path: JsonNode;
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
  var valid_589898 = path.getOrDefault("packageName")
  valid_589898 = validateParameter(valid_589898, JString, required = true,
                                 default = nil)
  if valid_589898 != nil:
    section.add "packageName", valid_589898
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
  var valid_589899 = query.getOrDefault("token")
  valid_589899 = validateParameter(valid_589899, JString, required = false,
                                 default = nil)
  if valid_589899 != nil:
    section.add "token", valid_589899
  var valid_589900 = query.getOrDefault("fields")
  valid_589900 = validateParameter(valid_589900, JString, required = false,
                                 default = nil)
  if valid_589900 != nil:
    section.add "fields", valid_589900
  var valid_589901 = query.getOrDefault("quotaUser")
  valid_589901 = validateParameter(valid_589901, JString, required = false,
                                 default = nil)
  if valid_589901 != nil:
    section.add "quotaUser", valid_589901
  var valid_589902 = query.getOrDefault("alt")
  valid_589902 = validateParameter(valid_589902, JString, required = false,
                                 default = newJString("json"))
  if valid_589902 != nil:
    section.add "alt", valid_589902
  var valid_589903 = query.getOrDefault("type")
  valid_589903 = validateParameter(valid_589903, JInt, required = false, default = nil)
  if valid_589903 != nil:
    section.add "type", valid_589903
  var valid_589904 = query.getOrDefault("oauth_token")
  valid_589904 = validateParameter(valid_589904, JString, required = false,
                                 default = nil)
  if valid_589904 != nil:
    section.add "oauth_token", valid_589904
  var valid_589905 = query.getOrDefault("endTime")
  valid_589905 = validateParameter(valid_589905, JString, required = false,
                                 default = nil)
  if valid_589905 != nil:
    section.add "endTime", valid_589905
  var valid_589906 = query.getOrDefault("userIp")
  valid_589906 = validateParameter(valid_589906, JString, required = false,
                                 default = nil)
  if valid_589906 != nil:
    section.add "userIp", valid_589906
  var valid_589907 = query.getOrDefault("maxResults")
  valid_589907 = validateParameter(valid_589907, JInt, required = false, default = nil)
  if valid_589907 != nil:
    section.add "maxResults", valid_589907
  var valid_589908 = query.getOrDefault("key")
  valid_589908 = validateParameter(valid_589908, JString, required = false,
                                 default = nil)
  if valid_589908 != nil:
    section.add "key", valid_589908
  var valid_589909 = query.getOrDefault("prettyPrint")
  valid_589909 = validateParameter(valid_589909, JBool, required = false,
                                 default = newJBool(true))
  if valid_589909 != nil:
    section.add "prettyPrint", valid_589909
  var valid_589910 = query.getOrDefault("startTime")
  valid_589910 = validateParameter(valid_589910, JString, required = false,
                                 default = nil)
  if valid_589910 != nil:
    section.add "startTime", valid_589910
  var valid_589911 = query.getOrDefault("startIndex")
  valid_589911 = validateParameter(valid_589911, JInt, required = false, default = nil)
  if valid_589911 != nil:
    section.add "startIndex", valid_589911
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589912: Call_AndroidpublisherPurchasesVoidedpurchasesList_589895;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the purchases that were canceled, refunded or charged-back.
  ## 
  let valid = call_589912.validator(path, query, header, formData, body)
  let scheme = call_589912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589912.url(scheme.get, call_589912.host, call_589912.base,
                         call_589912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589912, url, valid)

proc call*(call_589913: Call_AndroidpublisherPurchasesVoidedpurchasesList_589895;
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
  var path_589914 = newJObject()
  var query_589915 = newJObject()
  add(query_589915, "token", newJString(token))
  add(query_589915, "fields", newJString(fields))
  add(path_589914, "packageName", newJString(packageName))
  add(query_589915, "quotaUser", newJString(quotaUser))
  add(query_589915, "alt", newJString(alt))
  add(query_589915, "type", newJInt(`type`))
  add(query_589915, "oauth_token", newJString(oauthToken))
  add(query_589915, "endTime", newJString(endTime))
  add(query_589915, "userIp", newJString(userIp))
  add(query_589915, "maxResults", newJInt(maxResults))
  add(query_589915, "key", newJString(key))
  add(query_589915, "prettyPrint", newJBool(prettyPrint))
  add(query_589915, "startTime", newJString(startTime))
  add(query_589915, "startIndex", newJInt(startIndex))
  result = call_589913.call(path_589914, query_589915, nil, nil, nil)

var androidpublisherPurchasesVoidedpurchasesList* = Call_AndroidpublisherPurchasesVoidedpurchasesList_589895(
    name: "androidpublisherPurchasesVoidedpurchasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{packageName}/purchases/voidedpurchases",
    validator: validate_AndroidpublisherPurchasesVoidedpurchasesList_589896,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesVoidedpurchasesList_589897,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsList_589916 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherReviewsList_589918(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsList_589917(path: JsonNode; query: JsonNode;
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
  var valid_589919 = path.getOrDefault("packageName")
  valid_589919 = validateParameter(valid_589919, JString, required = true,
                                 default = nil)
  if valid_589919 != nil:
    section.add "packageName", valid_589919
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
  var valid_589920 = query.getOrDefault("translationLanguage")
  valid_589920 = validateParameter(valid_589920, JString, required = false,
                                 default = nil)
  if valid_589920 != nil:
    section.add "translationLanguage", valid_589920
  var valid_589921 = query.getOrDefault("token")
  valid_589921 = validateParameter(valid_589921, JString, required = false,
                                 default = nil)
  if valid_589921 != nil:
    section.add "token", valid_589921
  var valid_589922 = query.getOrDefault("fields")
  valid_589922 = validateParameter(valid_589922, JString, required = false,
                                 default = nil)
  if valid_589922 != nil:
    section.add "fields", valid_589922
  var valid_589923 = query.getOrDefault("quotaUser")
  valid_589923 = validateParameter(valid_589923, JString, required = false,
                                 default = nil)
  if valid_589923 != nil:
    section.add "quotaUser", valid_589923
  var valid_589924 = query.getOrDefault("alt")
  valid_589924 = validateParameter(valid_589924, JString, required = false,
                                 default = newJString("json"))
  if valid_589924 != nil:
    section.add "alt", valid_589924
  var valid_589925 = query.getOrDefault("oauth_token")
  valid_589925 = validateParameter(valid_589925, JString, required = false,
                                 default = nil)
  if valid_589925 != nil:
    section.add "oauth_token", valid_589925
  var valid_589926 = query.getOrDefault("userIp")
  valid_589926 = validateParameter(valid_589926, JString, required = false,
                                 default = nil)
  if valid_589926 != nil:
    section.add "userIp", valid_589926
  var valid_589927 = query.getOrDefault("maxResults")
  valid_589927 = validateParameter(valid_589927, JInt, required = false, default = nil)
  if valid_589927 != nil:
    section.add "maxResults", valid_589927
  var valid_589928 = query.getOrDefault("key")
  valid_589928 = validateParameter(valid_589928, JString, required = false,
                                 default = nil)
  if valid_589928 != nil:
    section.add "key", valid_589928
  var valid_589929 = query.getOrDefault("prettyPrint")
  valid_589929 = validateParameter(valid_589929, JBool, required = false,
                                 default = newJBool(true))
  if valid_589929 != nil:
    section.add "prettyPrint", valid_589929
  var valid_589930 = query.getOrDefault("startIndex")
  valid_589930 = validateParameter(valid_589930, JInt, required = false, default = nil)
  if valid_589930 != nil:
    section.add "startIndex", valid_589930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589931: Call_AndroidpublisherReviewsList_589916; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ## 
  let valid = call_589931.validator(path, query, header, formData, body)
  let scheme = call_589931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589931.url(scheme.get, call_589931.host, call_589931.base,
                         call_589931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589931, url, valid)

proc call*(call_589932: Call_AndroidpublisherReviewsList_589916;
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
  var path_589933 = newJObject()
  var query_589934 = newJObject()
  add(query_589934, "translationLanguage", newJString(translationLanguage))
  add(query_589934, "token", newJString(token))
  add(query_589934, "fields", newJString(fields))
  add(path_589933, "packageName", newJString(packageName))
  add(query_589934, "quotaUser", newJString(quotaUser))
  add(query_589934, "alt", newJString(alt))
  add(query_589934, "oauth_token", newJString(oauthToken))
  add(query_589934, "userIp", newJString(userIp))
  add(query_589934, "maxResults", newJInt(maxResults))
  add(query_589934, "key", newJString(key))
  add(query_589934, "prettyPrint", newJBool(prettyPrint))
  add(query_589934, "startIndex", newJInt(startIndex))
  result = call_589932.call(path_589933, query_589934, nil, nil, nil)

var androidpublisherReviewsList* = Call_AndroidpublisherReviewsList_589916(
    name: "androidpublisherReviewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews",
    validator: validate_AndroidpublisherReviewsList_589917,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsList_589918, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsGet_589935 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherReviewsGet_589937(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsGet_589936(path: JsonNode; query: JsonNode;
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
  var valid_589938 = path.getOrDefault("packageName")
  valid_589938 = validateParameter(valid_589938, JString, required = true,
                                 default = nil)
  if valid_589938 != nil:
    section.add "packageName", valid_589938
  var valid_589939 = path.getOrDefault("reviewId")
  valid_589939 = validateParameter(valid_589939, JString, required = true,
                                 default = nil)
  if valid_589939 != nil:
    section.add "reviewId", valid_589939
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
  var valid_589940 = query.getOrDefault("translationLanguage")
  valid_589940 = validateParameter(valid_589940, JString, required = false,
                                 default = nil)
  if valid_589940 != nil:
    section.add "translationLanguage", valid_589940
  var valid_589941 = query.getOrDefault("fields")
  valid_589941 = validateParameter(valid_589941, JString, required = false,
                                 default = nil)
  if valid_589941 != nil:
    section.add "fields", valid_589941
  var valid_589942 = query.getOrDefault("quotaUser")
  valid_589942 = validateParameter(valid_589942, JString, required = false,
                                 default = nil)
  if valid_589942 != nil:
    section.add "quotaUser", valid_589942
  var valid_589943 = query.getOrDefault("alt")
  valid_589943 = validateParameter(valid_589943, JString, required = false,
                                 default = newJString("json"))
  if valid_589943 != nil:
    section.add "alt", valid_589943
  var valid_589944 = query.getOrDefault("oauth_token")
  valid_589944 = validateParameter(valid_589944, JString, required = false,
                                 default = nil)
  if valid_589944 != nil:
    section.add "oauth_token", valid_589944
  var valid_589945 = query.getOrDefault("userIp")
  valid_589945 = validateParameter(valid_589945, JString, required = false,
                                 default = nil)
  if valid_589945 != nil:
    section.add "userIp", valid_589945
  var valid_589946 = query.getOrDefault("key")
  valid_589946 = validateParameter(valid_589946, JString, required = false,
                                 default = nil)
  if valid_589946 != nil:
    section.add "key", valid_589946
  var valid_589947 = query.getOrDefault("prettyPrint")
  valid_589947 = validateParameter(valid_589947, JBool, required = false,
                                 default = newJBool(true))
  if valid_589947 != nil:
    section.add "prettyPrint", valid_589947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589948: Call_AndroidpublisherReviewsGet_589935; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single review.
  ## 
  let valid = call_589948.validator(path, query, header, formData, body)
  let scheme = call_589948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589948.url(scheme.get, call_589948.host, call_589948.base,
                         call_589948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589948, url, valid)

proc call*(call_589949: Call_AndroidpublisherReviewsGet_589935;
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
  var path_589950 = newJObject()
  var query_589951 = newJObject()
  add(query_589951, "translationLanguage", newJString(translationLanguage))
  add(query_589951, "fields", newJString(fields))
  add(path_589950, "packageName", newJString(packageName))
  add(query_589951, "quotaUser", newJString(quotaUser))
  add(query_589951, "alt", newJString(alt))
  add(query_589951, "oauth_token", newJString(oauthToken))
  add(path_589950, "reviewId", newJString(reviewId))
  add(query_589951, "userIp", newJString(userIp))
  add(query_589951, "key", newJString(key))
  add(query_589951, "prettyPrint", newJBool(prettyPrint))
  result = call_589949.call(path_589950, query_589951, nil, nil, nil)

var androidpublisherReviewsGet* = Call_AndroidpublisherReviewsGet_589935(
    name: "androidpublisherReviewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}",
    validator: validate_AndroidpublisherReviewsGet_589936,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsGet_589937, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsReply_589952 = ref object of OpenApiRestCall_588450
proc url_AndroidpublisherReviewsReply_589954(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsReply_589953(path: JsonNode; query: JsonNode;
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
  var valid_589955 = path.getOrDefault("packageName")
  valid_589955 = validateParameter(valid_589955, JString, required = true,
                                 default = nil)
  if valid_589955 != nil:
    section.add "packageName", valid_589955
  var valid_589956 = path.getOrDefault("reviewId")
  valid_589956 = validateParameter(valid_589956, JString, required = true,
                                 default = nil)
  if valid_589956 != nil:
    section.add "reviewId", valid_589956
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
  var valid_589957 = query.getOrDefault("fields")
  valid_589957 = validateParameter(valid_589957, JString, required = false,
                                 default = nil)
  if valid_589957 != nil:
    section.add "fields", valid_589957
  var valid_589958 = query.getOrDefault("quotaUser")
  valid_589958 = validateParameter(valid_589958, JString, required = false,
                                 default = nil)
  if valid_589958 != nil:
    section.add "quotaUser", valid_589958
  var valid_589959 = query.getOrDefault("alt")
  valid_589959 = validateParameter(valid_589959, JString, required = false,
                                 default = newJString("json"))
  if valid_589959 != nil:
    section.add "alt", valid_589959
  var valid_589960 = query.getOrDefault("oauth_token")
  valid_589960 = validateParameter(valid_589960, JString, required = false,
                                 default = nil)
  if valid_589960 != nil:
    section.add "oauth_token", valid_589960
  var valid_589961 = query.getOrDefault("userIp")
  valid_589961 = validateParameter(valid_589961, JString, required = false,
                                 default = nil)
  if valid_589961 != nil:
    section.add "userIp", valid_589961
  var valid_589962 = query.getOrDefault("key")
  valid_589962 = validateParameter(valid_589962, JString, required = false,
                                 default = nil)
  if valid_589962 != nil:
    section.add "key", valid_589962
  var valid_589963 = query.getOrDefault("prettyPrint")
  valid_589963 = validateParameter(valid_589963, JBool, required = false,
                                 default = newJBool(true))
  if valid_589963 != nil:
    section.add "prettyPrint", valid_589963
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

proc call*(call_589965: Call_AndroidpublisherReviewsReply_589952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reply to a single review, or update an existing reply.
  ## 
  let valid = call_589965.validator(path, query, header, formData, body)
  let scheme = call_589965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589965.url(scheme.get, call_589965.host, call_589965.base,
                         call_589965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589965, url, valid)

proc call*(call_589966: Call_AndroidpublisherReviewsReply_589952;
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
  var path_589967 = newJObject()
  var query_589968 = newJObject()
  var body_589969 = newJObject()
  add(query_589968, "fields", newJString(fields))
  add(path_589967, "packageName", newJString(packageName))
  add(query_589968, "quotaUser", newJString(quotaUser))
  add(query_589968, "alt", newJString(alt))
  add(query_589968, "oauth_token", newJString(oauthToken))
  add(path_589967, "reviewId", newJString(reviewId))
  add(query_589968, "userIp", newJString(userIp))
  add(query_589968, "key", newJString(key))
  if body != nil:
    body_589969 = body
  add(query_589968, "prettyPrint", newJBool(prettyPrint))
  result = call_589966.call(path_589967, query_589968, nil, nil, body_589969)

var androidpublisherReviewsReply* = Call_AndroidpublisherReviewsReply_589952(
    name: "androidpublisherReviewsReply", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}:reply",
    validator: validate_AndroidpublisherReviewsReply_589953,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsReply_589954, schemes: {Scheme.Https})
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
