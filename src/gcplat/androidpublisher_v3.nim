
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidpublisherInternalappsharingartifactsUploadapk_597689 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInternalappsharingartifactsUploadapk_597691(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInternalappsharingartifactsUploadapk_597690(
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
  var valid_597817 = path.getOrDefault("packageName")
  valid_597817 = validateParameter(valid_597817, JString, required = true,
                                 default = nil)
  if valid_597817 != nil:
    section.add "packageName", valid_597817
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
  var valid_597818 = query.getOrDefault("fields")
  valid_597818 = validateParameter(valid_597818, JString, required = false,
                                 default = nil)
  if valid_597818 != nil:
    section.add "fields", valid_597818
  var valid_597819 = query.getOrDefault("quotaUser")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = nil)
  if valid_597819 != nil:
    section.add "quotaUser", valid_597819
  var valid_597833 = query.getOrDefault("alt")
  valid_597833 = validateParameter(valid_597833, JString, required = false,
                                 default = newJString("json"))
  if valid_597833 != nil:
    section.add "alt", valid_597833
  var valid_597834 = query.getOrDefault("oauth_token")
  valid_597834 = validateParameter(valid_597834, JString, required = false,
                                 default = nil)
  if valid_597834 != nil:
    section.add "oauth_token", valid_597834
  var valid_597835 = query.getOrDefault("userIp")
  valid_597835 = validateParameter(valid_597835, JString, required = false,
                                 default = nil)
  if valid_597835 != nil:
    section.add "userIp", valid_597835
  var valid_597836 = query.getOrDefault("key")
  valid_597836 = validateParameter(valid_597836, JString, required = false,
                                 default = nil)
  if valid_597836 != nil:
    section.add "key", valid_597836
  var valid_597837 = query.getOrDefault("prettyPrint")
  valid_597837 = validateParameter(valid_597837, JBool, required = false,
                                 default = newJBool(true))
  if valid_597837 != nil:
    section.add "prettyPrint", valid_597837
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597860: Call_AndroidpublisherInternalappsharingartifactsUploadapk_597689;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads an APK to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_597860.validator(path, query, header, formData, body)
  let scheme = call_597860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597860.url(scheme.get, call_597860.host, call_597860.base,
                         call_597860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597860, url, valid)

proc call*(call_597931: Call_AndroidpublisherInternalappsharingartifactsUploadapk_597689;
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
  var path_597932 = newJObject()
  var query_597934 = newJObject()
  add(query_597934, "fields", newJString(fields))
  add(path_597932, "packageName", newJString(packageName))
  add(query_597934, "quotaUser", newJString(quotaUser))
  add(query_597934, "alt", newJString(alt))
  add(query_597934, "oauth_token", newJString(oauthToken))
  add(query_597934, "userIp", newJString(userIp))
  add(query_597934, "key", newJString(key))
  add(query_597934, "prettyPrint", newJBool(prettyPrint))
  result = call_597931.call(path_597932, query_597934, nil, nil, nil)

var androidpublisherInternalappsharingartifactsUploadapk* = Call_AndroidpublisherInternalappsharingartifactsUploadapk_597689(
    name: "androidpublisherInternalappsharingartifactsUploadapk",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/internalappsharing/{packageName}/artifacts/apk",
    validator: validate_AndroidpublisherInternalappsharingartifactsUploadapk_597690,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInternalappsharingartifactsUploadapk_597691,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherInternalappsharingartifactsUploadbundle_597973 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInternalappsharingartifactsUploadbundle_597975(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInternalappsharingartifactsUploadbundle_597974(
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
  var valid_597976 = path.getOrDefault("packageName")
  valid_597976 = validateParameter(valid_597976, JString, required = true,
                                 default = nil)
  if valid_597976 != nil:
    section.add "packageName", valid_597976
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
  var valid_597977 = query.getOrDefault("fields")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "fields", valid_597977
  var valid_597978 = query.getOrDefault("quotaUser")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "quotaUser", valid_597978
  var valid_597979 = query.getOrDefault("alt")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = newJString("json"))
  if valid_597979 != nil:
    section.add "alt", valid_597979
  var valid_597980 = query.getOrDefault("oauth_token")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "oauth_token", valid_597980
  var valid_597981 = query.getOrDefault("userIp")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "userIp", valid_597981
  var valid_597982 = query.getOrDefault("key")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "key", valid_597982
  var valid_597983 = query.getOrDefault("prettyPrint")
  valid_597983 = validateParameter(valid_597983, JBool, required = false,
                                 default = newJBool(true))
  if valid_597983 != nil:
    section.add "prettyPrint", valid_597983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597984: Call_AndroidpublisherInternalappsharingartifactsUploadbundle_597973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads an app bundle to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_597984.validator(path, query, header, formData, body)
  let scheme = call_597984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597984.url(scheme.get, call_597984.host, call_597984.base,
                         call_597984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597984, url, valid)

proc call*(call_597985: Call_AndroidpublisherInternalappsharingartifactsUploadbundle_597973;
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
  var path_597986 = newJObject()
  var query_597987 = newJObject()
  add(query_597987, "fields", newJString(fields))
  add(path_597986, "packageName", newJString(packageName))
  add(query_597987, "quotaUser", newJString(quotaUser))
  add(query_597987, "alt", newJString(alt))
  add(query_597987, "oauth_token", newJString(oauthToken))
  add(query_597987, "userIp", newJString(userIp))
  add(query_597987, "key", newJString(key))
  add(query_597987, "prettyPrint", newJBool(prettyPrint))
  result = call_597985.call(path_597986, query_597987, nil, nil, nil)

var androidpublisherInternalappsharingartifactsUploadbundle* = Call_AndroidpublisherInternalappsharingartifactsUploadbundle_597973(
    name: "androidpublisherInternalappsharingartifactsUploadbundle",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/internalappsharing/{packageName}/artifacts/bundle", validator: validate_AndroidpublisherInternalappsharingartifactsUploadbundle_597974,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInternalappsharingartifactsUploadbundle_597975,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsInsert_597988 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsInsert_597990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsInsert_597989(path: JsonNode; query: JsonNode;
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
  var valid_597991 = path.getOrDefault("packageName")
  valid_597991 = validateParameter(valid_597991, JString, required = true,
                                 default = nil)
  if valid_597991 != nil:
    section.add "packageName", valid_597991
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
  var valid_597992 = query.getOrDefault("fields")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "fields", valid_597992
  var valid_597993 = query.getOrDefault("quotaUser")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "quotaUser", valid_597993
  var valid_597994 = query.getOrDefault("alt")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = newJString("json"))
  if valid_597994 != nil:
    section.add "alt", valid_597994
  var valid_597995 = query.getOrDefault("oauth_token")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "oauth_token", valid_597995
  var valid_597996 = query.getOrDefault("userIp")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "userIp", valid_597996
  var valid_597997 = query.getOrDefault("key")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "key", valid_597997
  var valid_597998 = query.getOrDefault("prettyPrint")
  valid_597998 = validateParameter(valid_597998, JBool, required = false,
                                 default = newJBool(true))
  if valid_597998 != nil:
    section.add "prettyPrint", valid_597998
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

proc call*(call_598000: Call_AndroidpublisherEditsInsert_597988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new edit for an app, populated with the app's current state.
  ## 
  let valid = call_598000.validator(path, query, header, formData, body)
  let scheme = call_598000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598000.url(scheme.get, call_598000.host, call_598000.base,
                         call_598000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598000, url, valid)

proc call*(call_598001: Call_AndroidpublisherEditsInsert_597988;
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
  var path_598002 = newJObject()
  var query_598003 = newJObject()
  var body_598004 = newJObject()
  add(query_598003, "fields", newJString(fields))
  add(path_598002, "packageName", newJString(packageName))
  add(query_598003, "quotaUser", newJString(quotaUser))
  add(query_598003, "alt", newJString(alt))
  add(query_598003, "oauth_token", newJString(oauthToken))
  add(query_598003, "userIp", newJString(userIp))
  add(query_598003, "key", newJString(key))
  if body != nil:
    body_598004 = body
  add(query_598003, "prettyPrint", newJBool(prettyPrint))
  result = call_598001.call(path_598002, query_598003, nil, nil, body_598004)

var androidpublisherEditsInsert* = Call_AndroidpublisherEditsInsert_597988(
    name: "androidpublisherEditsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits",
    validator: validate_AndroidpublisherEditsInsert_597989,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsInsert_597990, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsGet_598005 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsGet_598007(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsGet_598006(path: JsonNode; query: JsonNode;
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
  var valid_598008 = path.getOrDefault("packageName")
  valid_598008 = validateParameter(valid_598008, JString, required = true,
                                 default = nil)
  if valid_598008 != nil:
    section.add "packageName", valid_598008
  var valid_598009 = path.getOrDefault("editId")
  valid_598009 = validateParameter(valid_598009, JString, required = true,
                                 default = nil)
  if valid_598009 != nil:
    section.add "editId", valid_598009
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
  var valid_598010 = query.getOrDefault("fields")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "fields", valid_598010
  var valid_598011 = query.getOrDefault("quotaUser")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "quotaUser", valid_598011
  var valid_598012 = query.getOrDefault("alt")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = newJString("json"))
  if valid_598012 != nil:
    section.add "alt", valid_598012
  var valid_598013 = query.getOrDefault("oauth_token")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "oauth_token", valid_598013
  var valid_598014 = query.getOrDefault("userIp")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "userIp", valid_598014
  var valid_598015 = query.getOrDefault("key")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "key", valid_598015
  var valid_598016 = query.getOrDefault("prettyPrint")
  valid_598016 = validateParameter(valid_598016, JBool, required = false,
                                 default = newJBool(true))
  if valid_598016 != nil:
    section.add "prettyPrint", valid_598016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598017: Call_AndroidpublisherEditsGet_598005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ## 
  let valid = call_598017.validator(path, query, header, formData, body)
  let scheme = call_598017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598017.url(scheme.get, call_598017.host, call_598017.base,
                         call_598017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598017, url, valid)

proc call*(call_598018: Call_AndroidpublisherEditsGet_598005; packageName: string;
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
  var path_598019 = newJObject()
  var query_598020 = newJObject()
  add(query_598020, "fields", newJString(fields))
  add(path_598019, "packageName", newJString(packageName))
  add(query_598020, "quotaUser", newJString(quotaUser))
  add(query_598020, "alt", newJString(alt))
  add(path_598019, "editId", newJString(editId))
  add(query_598020, "oauth_token", newJString(oauthToken))
  add(query_598020, "userIp", newJString(userIp))
  add(query_598020, "key", newJString(key))
  add(query_598020, "prettyPrint", newJBool(prettyPrint))
  result = call_598018.call(path_598019, query_598020, nil, nil, nil)

var androidpublisherEditsGet* = Call_AndroidpublisherEditsGet_598005(
    name: "androidpublisherEditsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsGet_598006,
    base: "/androidpublisher/v3/applications", url: url_AndroidpublisherEditsGet_598007,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDelete_598021 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsDelete_598023(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsDelete_598022(path: JsonNode; query: JsonNode;
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
  var valid_598024 = path.getOrDefault("packageName")
  valid_598024 = validateParameter(valid_598024, JString, required = true,
                                 default = nil)
  if valid_598024 != nil:
    section.add "packageName", valid_598024
  var valid_598025 = path.getOrDefault("editId")
  valid_598025 = validateParameter(valid_598025, JString, required = true,
                                 default = nil)
  if valid_598025 != nil:
    section.add "editId", valid_598025
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
  var valid_598026 = query.getOrDefault("fields")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "fields", valid_598026
  var valid_598027 = query.getOrDefault("quotaUser")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "quotaUser", valid_598027
  var valid_598028 = query.getOrDefault("alt")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = newJString("json"))
  if valid_598028 != nil:
    section.add "alt", valid_598028
  var valid_598029 = query.getOrDefault("oauth_token")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "oauth_token", valid_598029
  var valid_598030 = query.getOrDefault("userIp")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "userIp", valid_598030
  var valid_598031 = query.getOrDefault("key")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "key", valid_598031
  var valid_598032 = query.getOrDefault("prettyPrint")
  valid_598032 = validateParameter(valid_598032, JBool, required = false,
                                 default = newJBool(true))
  if valid_598032 != nil:
    section.add "prettyPrint", valid_598032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598033: Call_AndroidpublisherEditsDelete_598021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ## 
  let valid = call_598033.validator(path, query, header, formData, body)
  let scheme = call_598033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598033.url(scheme.get, call_598033.host, call_598033.base,
                         call_598033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598033, url, valid)

proc call*(call_598034: Call_AndroidpublisherEditsDelete_598021;
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
  var path_598035 = newJObject()
  var query_598036 = newJObject()
  add(query_598036, "fields", newJString(fields))
  add(path_598035, "packageName", newJString(packageName))
  add(query_598036, "quotaUser", newJString(quotaUser))
  add(query_598036, "alt", newJString(alt))
  add(path_598035, "editId", newJString(editId))
  add(query_598036, "oauth_token", newJString(oauthToken))
  add(query_598036, "userIp", newJString(userIp))
  add(query_598036, "key", newJString(key))
  add(query_598036, "prettyPrint", newJBool(prettyPrint))
  result = call_598034.call(path_598035, query_598036, nil, nil, nil)

var androidpublisherEditsDelete* = Call_AndroidpublisherEditsDelete_598021(
    name: "androidpublisherEditsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsDelete_598022,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDelete_598023, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksUpload_598053 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApksUpload_598055(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApksUpload_598054(path: JsonNode;
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
  var valid_598056 = path.getOrDefault("packageName")
  valid_598056 = validateParameter(valid_598056, JString, required = true,
                                 default = nil)
  if valid_598056 != nil:
    section.add "packageName", valid_598056
  var valid_598057 = path.getOrDefault("editId")
  valid_598057 = validateParameter(valid_598057, JString, required = true,
                                 default = nil)
  if valid_598057 != nil:
    section.add "editId", valid_598057
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
  var valid_598058 = query.getOrDefault("fields")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "fields", valid_598058
  var valid_598059 = query.getOrDefault("quotaUser")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "quotaUser", valid_598059
  var valid_598060 = query.getOrDefault("alt")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = newJString("json"))
  if valid_598060 != nil:
    section.add "alt", valid_598060
  var valid_598061 = query.getOrDefault("oauth_token")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "oauth_token", valid_598061
  var valid_598062 = query.getOrDefault("userIp")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "userIp", valid_598062
  var valid_598063 = query.getOrDefault("key")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "key", valid_598063
  var valid_598064 = query.getOrDefault("prettyPrint")
  valid_598064 = validateParameter(valid_598064, JBool, required = false,
                                 default = newJBool(true))
  if valid_598064 != nil:
    section.add "prettyPrint", valid_598064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598065: Call_AndroidpublisherEditsApksUpload_598053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_598065.validator(path, query, header, formData, body)
  let scheme = call_598065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598065.url(scheme.get, call_598065.host, call_598065.base,
                         call_598065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598065, url, valid)

proc call*(call_598066: Call_AndroidpublisherEditsApksUpload_598053;
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
  var path_598067 = newJObject()
  var query_598068 = newJObject()
  add(query_598068, "fields", newJString(fields))
  add(path_598067, "packageName", newJString(packageName))
  add(query_598068, "quotaUser", newJString(quotaUser))
  add(query_598068, "alt", newJString(alt))
  add(path_598067, "editId", newJString(editId))
  add(query_598068, "oauth_token", newJString(oauthToken))
  add(query_598068, "userIp", newJString(userIp))
  add(query_598068, "key", newJString(key))
  add(query_598068, "prettyPrint", newJBool(prettyPrint))
  result = call_598066.call(path_598067, query_598068, nil, nil, nil)

var androidpublisherEditsApksUpload* = Call_AndroidpublisherEditsApksUpload_598053(
    name: "androidpublisherEditsApksUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksUpload_598054,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksUpload_598055, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksList_598037 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApksList_598039(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApksList_598038(path: JsonNode; query: JsonNode;
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
  var valid_598040 = path.getOrDefault("packageName")
  valid_598040 = validateParameter(valid_598040, JString, required = true,
                                 default = nil)
  if valid_598040 != nil:
    section.add "packageName", valid_598040
  var valid_598041 = path.getOrDefault("editId")
  valid_598041 = validateParameter(valid_598041, JString, required = true,
                                 default = nil)
  if valid_598041 != nil:
    section.add "editId", valid_598041
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
  var valid_598042 = query.getOrDefault("fields")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = nil)
  if valid_598042 != nil:
    section.add "fields", valid_598042
  var valid_598043 = query.getOrDefault("quotaUser")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = nil)
  if valid_598043 != nil:
    section.add "quotaUser", valid_598043
  var valid_598044 = query.getOrDefault("alt")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = newJString("json"))
  if valid_598044 != nil:
    section.add "alt", valid_598044
  var valid_598045 = query.getOrDefault("oauth_token")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "oauth_token", valid_598045
  var valid_598046 = query.getOrDefault("userIp")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "userIp", valid_598046
  var valid_598047 = query.getOrDefault("key")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "key", valid_598047
  var valid_598048 = query.getOrDefault("prettyPrint")
  valid_598048 = validateParameter(valid_598048, JBool, required = false,
                                 default = newJBool(true))
  if valid_598048 != nil:
    section.add "prettyPrint", valid_598048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598049: Call_AndroidpublisherEditsApksList_598037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_598049.validator(path, query, header, formData, body)
  let scheme = call_598049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598049.url(scheme.get, call_598049.host, call_598049.base,
                         call_598049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598049, url, valid)

proc call*(call_598050: Call_AndroidpublisherEditsApksList_598037;
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
  var path_598051 = newJObject()
  var query_598052 = newJObject()
  add(query_598052, "fields", newJString(fields))
  add(path_598051, "packageName", newJString(packageName))
  add(query_598052, "quotaUser", newJString(quotaUser))
  add(query_598052, "alt", newJString(alt))
  add(path_598051, "editId", newJString(editId))
  add(query_598052, "oauth_token", newJString(oauthToken))
  add(query_598052, "userIp", newJString(userIp))
  add(query_598052, "key", newJString(key))
  add(query_598052, "prettyPrint", newJBool(prettyPrint))
  result = call_598050.call(path_598051, query_598052, nil, nil, nil)

var androidpublisherEditsApksList* = Call_AndroidpublisherEditsApksList_598037(
    name: "androidpublisherEditsApksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksList_598038,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksList_598039, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksAddexternallyhosted_598069 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsApksAddexternallyhosted_598071(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsApksAddexternallyhosted_598070(path: JsonNode;
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
  var valid_598072 = path.getOrDefault("packageName")
  valid_598072 = validateParameter(valid_598072, JString, required = true,
                                 default = nil)
  if valid_598072 != nil:
    section.add "packageName", valid_598072
  var valid_598073 = path.getOrDefault("editId")
  valid_598073 = validateParameter(valid_598073, JString, required = true,
                                 default = nil)
  if valid_598073 != nil:
    section.add "editId", valid_598073
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
  var valid_598074 = query.getOrDefault("fields")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "fields", valid_598074
  var valid_598075 = query.getOrDefault("quotaUser")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "quotaUser", valid_598075
  var valid_598076 = query.getOrDefault("alt")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = newJString("json"))
  if valid_598076 != nil:
    section.add "alt", valid_598076
  var valid_598077 = query.getOrDefault("oauth_token")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "oauth_token", valid_598077
  var valid_598078 = query.getOrDefault("userIp")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "userIp", valid_598078
  var valid_598079 = query.getOrDefault("key")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "key", valid_598079
  var valid_598080 = query.getOrDefault("prettyPrint")
  valid_598080 = validateParameter(valid_598080, JBool, required = false,
                                 default = newJBool(true))
  if valid_598080 != nil:
    section.add "prettyPrint", valid_598080
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

proc call*(call_598082: Call_AndroidpublisherEditsApksAddexternallyhosted_598069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ## 
  let valid = call_598082.validator(path, query, header, formData, body)
  let scheme = call_598082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598082.url(scheme.get, call_598082.host, call_598082.base,
                         call_598082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598082, url, valid)

proc call*(call_598083: Call_AndroidpublisherEditsApksAddexternallyhosted_598069;
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
  var path_598084 = newJObject()
  var query_598085 = newJObject()
  var body_598086 = newJObject()
  add(query_598085, "fields", newJString(fields))
  add(path_598084, "packageName", newJString(packageName))
  add(query_598085, "quotaUser", newJString(quotaUser))
  add(query_598085, "alt", newJString(alt))
  add(path_598084, "editId", newJString(editId))
  add(query_598085, "oauth_token", newJString(oauthToken))
  add(query_598085, "userIp", newJString(userIp))
  add(query_598085, "key", newJString(key))
  if body != nil:
    body_598086 = body
  add(query_598085, "prettyPrint", newJBool(prettyPrint))
  result = call_598083.call(path_598084, query_598085, nil, nil, body_598086)

var androidpublisherEditsApksAddexternallyhosted* = Call_AndroidpublisherEditsApksAddexternallyhosted_598069(
    name: "androidpublisherEditsApksAddexternallyhosted",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/externallyHosted",
    validator: validate_AndroidpublisherEditsApksAddexternallyhosted_598070,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsApksAddexternallyhosted_598071,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDeobfuscationfilesUpload_598087 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsDeobfuscationfilesUpload_598089(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsDeobfuscationfilesUpload_598088(
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
  var valid_598090 = path.getOrDefault("packageName")
  valid_598090 = validateParameter(valid_598090, JString, required = true,
                                 default = nil)
  if valid_598090 != nil:
    section.add "packageName", valid_598090
  var valid_598091 = path.getOrDefault("deobfuscationFileType")
  valid_598091 = validateParameter(valid_598091, JString, required = true,
                                 default = newJString("proguard"))
  if valid_598091 != nil:
    section.add "deobfuscationFileType", valid_598091
  var valid_598092 = path.getOrDefault("editId")
  valid_598092 = validateParameter(valid_598092, JString, required = true,
                                 default = nil)
  if valid_598092 != nil:
    section.add "editId", valid_598092
  var valid_598093 = path.getOrDefault("apkVersionCode")
  valid_598093 = validateParameter(valid_598093, JInt, required = true, default = nil)
  if valid_598093 != nil:
    section.add "apkVersionCode", valid_598093
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
  var valid_598094 = query.getOrDefault("fields")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "fields", valid_598094
  var valid_598095 = query.getOrDefault("quotaUser")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "quotaUser", valid_598095
  var valid_598096 = query.getOrDefault("alt")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = newJString("json"))
  if valid_598096 != nil:
    section.add "alt", valid_598096
  var valid_598097 = query.getOrDefault("oauth_token")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "oauth_token", valid_598097
  var valid_598098 = query.getOrDefault("userIp")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "userIp", valid_598098
  var valid_598099 = query.getOrDefault("key")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "key", valid_598099
  var valid_598100 = query.getOrDefault("prettyPrint")
  valid_598100 = validateParameter(valid_598100, JBool, required = false,
                                 default = newJBool(true))
  if valid_598100 != nil:
    section.add "prettyPrint", valid_598100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598101: Call_AndroidpublisherEditsDeobfuscationfilesUpload_598087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ## 
  let valid = call_598101.validator(path, query, header, formData, body)
  let scheme = call_598101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598101.url(scheme.get, call_598101.host, call_598101.base,
                         call_598101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598101, url, valid)

proc call*(call_598102: Call_AndroidpublisherEditsDeobfuscationfilesUpload_598087;
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
  var path_598103 = newJObject()
  var query_598104 = newJObject()
  add(query_598104, "fields", newJString(fields))
  add(path_598103, "packageName", newJString(packageName))
  add(query_598104, "quotaUser", newJString(quotaUser))
  add(path_598103, "deobfuscationFileType", newJString(deobfuscationFileType))
  add(query_598104, "alt", newJString(alt))
  add(path_598103, "editId", newJString(editId))
  add(query_598104, "oauth_token", newJString(oauthToken))
  add(query_598104, "userIp", newJString(userIp))
  add(query_598104, "key", newJString(key))
  add(query_598104, "prettyPrint", newJBool(prettyPrint))
  add(path_598103, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598102.call(path_598103, query_598104, nil, nil, nil)

var androidpublisherEditsDeobfuscationfilesUpload* = Call_AndroidpublisherEditsDeobfuscationfilesUpload_598087(
    name: "androidpublisherEditsDeobfuscationfilesUpload",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType}",
    validator: validate_AndroidpublisherEditsDeobfuscationfilesUpload_598088,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDeobfuscationfilesUpload_598089,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpdate_598123 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsExpansionfilesUpdate_598125(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsExpansionfilesUpdate_598124(path: JsonNode;
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
  var valid_598126 = path.getOrDefault("packageName")
  valid_598126 = validateParameter(valid_598126, JString, required = true,
                                 default = nil)
  if valid_598126 != nil:
    section.add "packageName", valid_598126
  var valid_598127 = path.getOrDefault("editId")
  valid_598127 = validateParameter(valid_598127, JString, required = true,
                                 default = nil)
  if valid_598127 != nil:
    section.add "editId", valid_598127
  var valid_598128 = path.getOrDefault("expansionFileType")
  valid_598128 = validateParameter(valid_598128, JString, required = true,
                                 default = newJString("main"))
  if valid_598128 != nil:
    section.add "expansionFileType", valid_598128
  var valid_598129 = path.getOrDefault("apkVersionCode")
  valid_598129 = validateParameter(valid_598129, JInt, required = true, default = nil)
  if valid_598129 != nil:
    section.add "apkVersionCode", valid_598129
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
  var valid_598130 = query.getOrDefault("fields")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "fields", valid_598130
  var valid_598131 = query.getOrDefault("quotaUser")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "quotaUser", valid_598131
  var valid_598132 = query.getOrDefault("alt")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = newJString("json"))
  if valid_598132 != nil:
    section.add "alt", valid_598132
  var valid_598133 = query.getOrDefault("oauth_token")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "oauth_token", valid_598133
  var valid_598134 = query.getOrDefault("userIp")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "userIp", valid_598134
  var valid_598135 = query.getOrDefault("key")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "key", valid_598135
  var valid_598136 = query.getOrDefault("prettyPrint")
  valid_598136 = validateParameter(valid_598136, JBool, required = false,
                                 default = newJBool(true))
  if valid_598136 != nil:
    section.add "prettyPrint", valid_598136
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

proc call*(call_598138: Call_AndroidpublisherEditsExpansionfilesUpdate_598123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ## 
  let valid = call_598138.validator(path, query, header, formData, body)
  let scheme = call_598138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598138.url(scheme.get, call_598138.host, call_598138.base,
                         call_598138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598138, url, valid)

proc call*(call_598139: Call_AndroidpublisherEditsExpansionfilesUpdate_598123;
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
  var path_598140 = newJObject()
  var query_598141 = newJObject()
  var body_598142 = newJObject()
  add(query_598141, "fields", newJString(fields))
  add(path_598140, "packageName", newJString(packageName))
  add(query_598141, "quotaUser", newJString(quotaUser))
  add(query_598141, "alt", newJString(alt))
  add(path_598140, "editId", newJString(editId))
  add(query_598141, "oauth_token", newJString(oauthToken))
  add(query_598141, "userIp", newJString(userIp))
  add(query_598141, "key", newJString(key))
  add(path_598140, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_598142 = body
  add(query_598141, "prettyPrint", newJBool(prettyPrint))
  add(path_598140, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598139.call(path_598140, query_598141, nil, nil, body_598142)

var androidpublisherEditsExpansionfilesUpdate* = Call_AndroidpublisherEditsExpansionfilesUpdate_598123(
    name: "androidpublisherEditsExpansionfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpdate_598124,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpdate_598125,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpload_598143 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsExpansionfilesUpload_598145(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsExpansionfilesUpload_598144(path: JsonNode;
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
  var valid_598146 = path.getOrDefault("packageName")
  valid_598146 = validateParameter(valid_598146, JString, required = true,
                                 default = nil)
  if valid_598146 != nil:
    section.add "packageName", valid_598146
  var valid_598147 = path.getOrDefault("editId")
  valid_598147 = validateParameter(valid_598147, JString, required = true,
                                 default = nil)
  if valid_598147 != nil:
    section.add "editId", valid_598147
  var valid_598148 = path.getOrDefault("expansionFileType")
  valid_598148 = validateParameter(valid_598148, JString, required = true,
                                 default = newJString("main"))
  if valid_598148 != nil:
    section.add "expansionFileType", valid_598148
  var valid_598149 = path.getOrDefault("apkVersionCode")
  valid_598149 = validateParameter(valid_598149, JInt, required = true, default = nil)
  if valid_598149 != nil:
    section.add "apkVersionCode", valid_598149
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
  var valid_598150 = query.getOrDefault("fields")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = nil)
  if valid_598150 != nil:
    section.add "fields", valid_598150
  var valid_598151 = query.getOrDefault("quotaUser")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "quotaUser", valid_598151
  var valid_598152 = query.getOrDefault("alt")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = newJString("json"))
  if valid_598152 != nil:
    section.add "alt", valid_598152
  var valid_598153 = query.getOrDefault("oauth_token")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "oauth_token", valid_598153
  var valid_598154 = query.getOrDefault("userIp")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "userIp", valid_598154
  var valid_598155 = query.getOrDefault("key")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "key", valid_598155
  var valid_598156 = query.getOrDefault("prettyPrint")
  valid_598156 = validateParameter(valid_598156, JBool, required = false,
                                 default = newJBool(true))
  if valid_598156 != nil:
    section.add "prettyPrint", valid_598156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598157: Call_AndroidpublisherEditsExpansionfilesUpload_598143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads and attaches a new Expansion File to the APK specified.
  ## 
  let valid = call_598157.validator(path, query, header, formData, body)
  let scheme = call_598157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598157.url(scheme.get, call_598157.host, call_598157.base,
                         call_598157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598157, url, valid)

proc call*(call_598158: Call_AndroidpublisherEditsExpansionfilesUpload_598143;
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
  var path_598159 = newJObject()
  var query_598160 = newJObject()
  add(query_598160, "fields", newJString(fields))
  add(path_598159, "packageName", newJString(packageName))
  add(query_598160, "quotaUser", newJString(quotaUser))
  add(query_598160, "alt", newJString(alt))
  add(path_598159, "editId", newJString(editId))
  add(query_598160, "oauth_token", newJString(oauthToken))
  add(query_598160, "userIp", newJString(userIp))
  add(query_598160, "key", newJString(key))
  add(path_598159, "expansionFileType", newJString(expansionFileType))
  add(query_598160, "prettyPrint", newJBool(prettyPrint))
  add(path_598159, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598158.call(path_598159, query_598160, nil, nil, nil)

var androidpublisherEditsExpansionfilesUpload* = Call_AndroidpublisherEditsExpansionfilesUpload_598143(
    name: "androidpublisherEditsExpansionfilesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpload_598144,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpload_598145,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesGet_598105 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsExpansionfilesGet_598107(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsExpansionfilesGet_598106(path: JsonNode;
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
  var valid_598108 = path.getOrDefault("packageName")
  valid_598108 = validateParameter(valid_598108, JString, required = true,
                                 default = nil)
  if valid_598108 != nil:
    section.add "packageName", valid_598108
  var valid_598109 = path.getOrDefault("editId")
  valid_598109 = validateParameter(valid_598109, JString, required = true,
                                 default = nil)
  if valid_598109 != nil:
    section.add "editId", valid_598109
  var valid_598110 = path.getOrDefault("expansionFileType")
  valid_598110 = validateParameter(valid_598110, JString, required = true,
                                 default = newJString("main"))
  if valid_598110 != nil:
    section.add "expansionFileType", valid_598110
  var valid_598111 = path.getOrDefault("apkVersionCode")
  valid_598111 = validateParameter(valid_598111, JInt, required = true, default = nil)
  if valid_598111 != nil:
    section.add "apkVersionCode", valid_598111
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
  var valid_598112 = query.getOrDefault("fields")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "fields", valid_598112
  var valid_598113 = query.getOrDefault("quotaUser")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "quotaUser", valid_598113
  var valid_598114 = query.getOrDefault("alt")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = newJString("json"))
  if valid_598114 != nil:
    section.add "alt", valid_598114
  var valid_598115 = query.getOrDefault("oauth_token")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "oauth_token", valid_598115
  var valid_598116 = query.getOrDefault("userIp")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "userIp", valid_598116
  var valid_598117 = query.getOrDefault("key")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "key", valid_598117
  var valid_598118 = query.getOrDefault("prettyPrint")
  valid_598118 = validateParameter(valid_598118, JBool, required = false,
                                 default = newJBool(true))
  if valid_598118 != nil:
    section.add "prettyPrint", valid_598118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598119: Call_AndroidpublisherEditsExpansionfilesGet_598105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the Expansion File configuration for the APK specified.
  ## 
  let valid = call_598119.validator(path, query, header, formData, body)
  let scheme = call_598119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598119.url(scheme.get, call_598119.host, call_598119.base,
                         call_598119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598119, url, valid)

proc call*(call_598120: Call_AndroidpublisherEditsExpansionfilesGet_598105;
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
  var path_598121 = newJObject()
  var query_598122 = newJObject()
  add(query_598122, "fields", newJString(fields))
  add(path_598121, "packageName", newJString(packageName))
  add(query_598122, "quotaUser", newJString(quotaUser))
  add(query_598122, "alt", newJString(alt))
  add(path_598121, "editId", newJString(editId))
  add(query_598122, "oauth_token", newJString(oauthToken))
  add(query_598122, "userIp", newJString(userIp))
  add(query_598122, "key", newJString(key))
  add(path_598121, "expansionFileType", newJString(expansionFileType))
  add(query_598122, "prettyPrint", newJBool(prettyPrint))
  add(path_598121, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598120.call(path_598121, query_598122, nil, nil, nil)

var androidpublisherEditsExpansionfilesGet* = Call_AndroidpublisherEditsExpansionfilesGet_598105(
    name: "androidpublisherEditsExpansionfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesGet_598106,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesGet_598107,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesPatch_598161 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsExpansionfilesPatch_598163(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsExpansionfilesPatch_598162(path: JsonNode;
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
  var valid_598164 = path.getOrDefault("packageName")
  valid_598164 = validateParameter(valid_598164, JString, required = true,
                                 default = nil)
  if valid_598164 != nil:
    section.add "packageName", valid_598164
  var valid_598165 = path.getOrDefault("editId")
  valid_598165 = validateParameter(valid_598165, JString, required = true,
                                 default = nil)
  if valid_598165 != nil:
    section.add "editId", valid_598165
  var valid_598166 = path.getOrDefault("expansionFileType")
  valid_598166 = validateParameter(valid_598166, JString, required = true,
                                 default = newJString("main"))
  if valid_598166 != nil:
    section.add "expansionFileType", valid_598166
  var valid_598167 = path.getOrDefault("apkVersionCode")
  valid_598167 = validateParameter(valid_598167, JInt, required = true, default = nil)
  if valid_598167 != nil:
    section.add "apkVersionCode", valid_598167
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
  var valid_598168 = query.getOrDefault("fields")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "fields", valid_598168
  var valid_598169 = query.getOrDefault("quotaUser")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "quotaUser", valid_598169
  var valid_598170 = query.getOrDefault("alt")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = newJString("json"))
  if valid_598170 != nil:
    section.add "alt", valid_598170
  var valid_598171 = query.getOrDefault("oauth_token")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = nil)
  if valid_598171 != nil:
    section.add "oauth_token", valid_598171
  var valid_598172 = query.getOrDefault("userIp")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = nil)
  if valid_598172 != nil:
    section.add "userIp", valid_598172
  var valid_598173 = query.getOrDefault("key")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = nil)
  if valid_598173 != nil:
    section.add "key", valid_598173
  var valid_598174 = query.getOrDefault("prettyPrint")
  valid_598174 = validateParameter(valid_598174, JBool, required = false,
                                 default = newJBool(true))
  if valid_598174 != nil:
    section.add "prettyPrint", valid_598174
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

proc call*(call_598176: Call_AndroidpublisherEditsExpansionfilesPatch_598161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ## 
  let valid = call_598176.validator(path, query, header, formData, body)
  let scheme = call_598176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598176.url(scheme.get, call_598176.host, call_598176.base,
                         call_598176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598176, url, valid)

proc call*(call_598177: Call_AndroidpublisherEditsExpansionfilesPatch_598161;
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
  var path_598178 = newJObject()
  var query_598179 = newJObject()
  var body_598180 = newJObject()
  add(query_598179, "fields", newJString(fields))
  add(path_598178, "packageName", newJString(packageName))
  add(query_598179, "quotaUser", newJString(quotaUser))
  add(query_598179, "alt", newJString(alt))
  add(path_598178, "editId", newJString(editId))
  add(query_598179, "oauth_token", newJString(oauthToken))
  add(query_598179, "userIp", newJString(userIp))
  add(query_598179, "key", newJString(key))
  add(path_598178, "expansionFileType", newJString(expansionFileType))
  if body != nil:
    body_598180 = body
  add(query_598179, "prettyPrint", newJBool(prettyPrint))
  add(path_598178, "apkVersionCode", newJInt(apkVersionCode))
  result = call_598177.call(path_598178, query_598179, nil, nil, body_598180)

var androidpublisherEditsExpansionfilesPatch* = Call_AndroidpublisherEditsExpansionfilesPatch_598161(
    name: "androidpublisherEditsExpansionfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesPatch_598162,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsExpansionfilesPatch_598163,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesUpload_598197 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsBundlesUpload_598199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsBundlesUpload_598198(path: JsonNode;
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
  var valid_598200 = path.getOrDefault("packageName")
  valid_598200 = validateParameter(valid_598200, JString, required = true,
                                 default = nil)
  if valid_598200 != nil:
    section.add "packageName", valid_598200
  var valid_598201 = path.getOrDefault("editId")
  valid_598201 = validateParameter(valid_598201, JString, required = true,
                                 default = nil)
  if valid_598201 != nil:
    section.add "editId", valid_598201
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
  var valid_598202 = query.getOrDefault("fields")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "fields", valid_598202
  var valid_598203 = query.getOrDefault("quotaUser")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "quotaUser", valid_598203
  var valid_598204 = query.getOrDefault("alt")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = newJString("json"))
  if valid_598204 != nil:
    section.add "alt", valid_598204
  var valid_598205 = query.getOrDefault("oauth_token")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "oauth_token", valid_598205
  var valid_598206 = query.getOrDefault("userIp")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "userIp", valid_598206
  var valid_598207 = query.getOrDefault("key")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "key", valid_598207
  var valid_598208 = query.getOrDefault("prettyPrint")
  valid_598208 = validateParameter(valid_598208, JBool, required = false,
                                 default = newJBool(true))
  if valid_598208 != nil:
    section.add "prettyPrint", valid_598208
  var valid_598209 = query.getOrDefault("ackBundleInstallationWarning")
  valid_598209 = validateParameter(valid_598209, JBool, required = false, default = nil)
  if valid_598209 != nil:
    section.add "ackBundleInstallationWarning", valid_598209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598210: Call_AndroidpublisherEditsBundlesUpload_598197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_598210.validator(path, query, header, formData, body)
  let scheme = call_598210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598210.url(scheme.get, call_598210.host, call_598210.base,
                         call_598210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598210, url, valid)

proc call*(call_598211: Call_AndroidpublisherEditsBundlesUpload_598197;
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
  var path_598212 = newJObject()
  var query_598213 = newJObject()
  add(query_598213, "fields", newJString(fields))
  add(path_598212, "packageName", newJString(packageName))
  add(query_598213, "quotaUser", newJString(quotaUser))
  add(query_598213, "alt", newJString(alt))
  add(path_598212, "editId", newJString(editId))
  add(query_598213, "oauth_token", newJString(oauthToken))
  add(query_598213, "userIp", newJString(userIp))
  add(query_598213, "key", newJString(key))
  add(query_598213, "prettyPrint", newJBool(prettyPrint))
  add(query_598213, "ackBundleInstallationWarning",
      newJBool(ackBundleInstallationWarning))
  result = call_598211.call(path_598212, query_598213, nil, nil, nil)

var androidpublisherEditsBundlesUpload* = Call_AndroidpublisherEditsBundlesUpload_598197(
    name: "androidpublisherEditsBundlesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesUpload_598198,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsBundlesUpload_598199, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesList_598181 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsBundlesList_598183(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsBundlesList_598182(path: JsonNode;
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
  var valid_598184 = path.getOrDefault("packageName")
  valid_598184 = validateParameter(valid_598184, JString, required = true,
                                 default = nil)
  if valid_598184 != nil:
    section.add "packageName", valid_598184
  var valid_598185 = path.getOrDefault("editId")
  valid_598185 = validateParameter(valid_598185, JString, required = true,
                                 default = nil)
  if valid_598185 != nil:
    section.add "editId", valid_598185
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
  var valid_598186 = query.getOrDefault("fields")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "fields", valid_598186
  var valid_598187 = query.getOrDefault("quotaUser")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "quotaUser", valid_598187
  var valid_598188 = query.getOrDefault("alt")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = newJString("json"))
  if valid_598188 != nil:
    section.add "alt", valid_598188
  var valid_598189 = query.getOrDefault("oauth_token")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "oauth_token", valid_598189
  var valid_598190 = query.getOrDefault("userIp")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "userIp", valid_598190
  var valid_598191 = query.getOrDefault("key")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "key", valid_598191
  var valid_598192 = query.getOrDefault("prettyPrint")
  valid_598192 = validateParameter(valid_598192, JBool, required = false,
                                 default = newJBool(true))
  if valid_598192 != nil:
    section.add "prettyPrint", valid_598192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598193: Call_AndroidpublisherEditsBundlesList_598181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_598193.validator(path, query, header, formData, body)
  let scheme = call_598193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598193.url(scheme.get, call_598193.host, call_598193.base,
                         call_598193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598193, url, valid)

proc call*(call_598194: Call_AndroidpublisherEditsBundlesList_598181;
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
  var path_598195 = newJObject()
  var query_598196 = newJObject()
  add(query_598196, "fields", newJString(fields))
  add(path_598195, "packageName", newJString(packageName))
  add(query_598196, "quotaUser", newJString(quotaUser))
  add(query_598196, "alt", newJString(alt))
  add(path_598195, "editId", newJString(editId))
  add(query_598196, "oauth_token", newJString(oauthToken))
  add(query_598196, "userIp", newJString(userIp))
  add(query_598196, "key", newJString(key))
  add(query_598196, "prettyPrint", newJBool(prettyPrint))
  result = call_598194.call(path_598195, query_598196, nil, nil, nil)

var androidpublisherEditsBundlesList* = Call_AndroidpublisherEditsBundlesList_598181(
    name: "androidpublisherEditsBundlesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesList_598182,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsBundlesList_598183, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsUpdate_598230 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsDetailsUpdate_598232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsDetailsUpdate_598231(path: JsonNode;
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
  var valid_598233 = path.getOrDefault("packageName")
  valid_598233 = validateParameter(valid_598233, JString, required = true,
                                 default = nil)
  if valid_598233 != nil:
    section.add "packageName", valid_598233
  var valid_598234 = path.getOrDefault("editId")
  valid_598234 = validateParameter(valid_598234, JString, required = true,
                                 default = nil)
  if valid_598234 != nil:
    section.add "editId", valid_598234
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
  var valid_598235 = query.getOrDefault("fields")
  valid_598235 = validateParameter(valid_598235, JString, required = false,
                                 default = nil)
  if valid_598235 != nil:
    section.add "fields", valid_598235
  var valid_598236 = query.getOrDefault("quotaUser")
  valid_598236 = validateParameter(valid_598236, JString, required = false,
                                 default = nil)
  if valid_598236 != nil:
    section.add "quotaUser", valid_598236
  var valid_598237 = query.getOrDefault("alt")
  valid_598237 = validateParameter(valid_598237, JString, required = false,
                                 default = newJString("json"))
  if valid_598237 != nil:
    section.add "alt", valid_598237
  var valid_598238 = query.getOrDefault("oauth_token")
  valid_598238 = validateParameter(valid_598238, JString, required = false,
                                 default = nil)
  if valid_598238 != nil:
    section.add "oauth_token", valid_598238
  var valid_598239 = query.getOrDefault("userIp")
  valid_598239 = validateParameter(valid_598239, JString, required = false,
                                 default = nil)
  if valid_598239 != nil:
    section.add "userIp", valid_598239
  var valid_598240 = query.getOrDefault("key")
  valid_598240 = validateParameter(valid_598240, JString, required = false,
                                 default = nil)
  if valid_598240 != nil:
    section.add "key", valid_598240
  var valid_598241 = query.getOrDefault("prettyPrint")
  valid_598241 = validateParameter(valid_598241, JBool, required = false,
                                 default = newJBool(true))
  if valid_598241 != nil:
    section.add "prettyPrint", valid_598241
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

proc call*(call_598243: Call_AndroidpublisherEditsDetailsUpdate_598230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit.
  ## 
  let valid = call_598243.validator(path, query, header, formData, body)
  let scheme = call_598243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598243.url(scheme.get, call_598243.host, call_598243.base,
                         call_598243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598243, url, valid)

proc call*(call_598244: Call_AndroidpublisherEditsDetailsUpdate_598230;
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
  var path_598245 = newJObject()
  var query_598246 = newJObject()
  var body_598247 = newJObject()
  add(query_598246, "fields", newJString(fields))
  add(path_598245, "packageName", newJString(packageName))
  add(query_598246, "quotaUser", newJString(quotaUser))
  add(query_598246, "alt", newJString(alt))
  add(path_598245, "editId", newJString(editId))
  add(query_598246, "oauth_token", newJString(oauthToken))
  add(query_598246, "userIp", newJString(userIp))
  add(query_598246, "key", newJString(key))
  if body != nil:
    body_598247 = body
  add(query_598246, "prettyPrint", newJBool(prettyPrint))
  result = call_598244.call(path_598245, query_598246, nil, nil, body_598247)

var androidpublisherEditsDetailsUpdate* = Call_AndroidpublisherEditsDetailsUpdate_598230(
    name: "androidpublisherEditsDetailsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsUpdate_598231,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsUpdate_598232, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsGet_598214 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsDetailsGet_598216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsDetailsGet_598215(path: JsonNode;
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
  var valid_598217 = path.getOrDefault("packageName")
  valid_598217 = validateParameter(valid_598217, JString, required = true,
                                 default = nil)
  if valid_598217 != nil:
    section.add "packageName", valid_598217
  var valid_598218 = path.getOrDefault("editId")
  valid_598218 = validateParameter(valid_598218, JString, required = true,
                                 default = nil)
  if valid_598218 != nil:
    section.add "editId", valid_598218
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
  var valid_598219 = query.getOrDefault("fields")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "fields", valid_598219
  var valid_598220 = query.getOrDefault("quotaUser")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = nil)
  if valid_598220 != nil:
    section.add "quotaUser", valid_598220
  var valid_598221 = query.getOrDefault("alt")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = newJString("json"))
  if valid_598221 != nil:
    section.add "alt", valid_598221
  var valid_598222 = query.getOrDefault("oauth_token")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "oauth_token", valid_598222
  var valid_598223 = query.getOrDefault("userIp")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "userIp", valid_598223
  var valid_598224 = query.getOrDefault("key")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "key", valid_598224
  var valid_598225 = query.getOrDefault("prettyPrint")
  valid_598225 = validateParameter(valid_598225, JBool, required = false,
                                 default = newJBool(true))
  if valid_598225 != nil:
    section.add "prettyPrint", valid_598225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598226: Call_AndroidpublisherEditsDetailsGet_598214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ## 
  let valid = call_598226.validator(path, query, header, formData, body)
  let scheme = call_598226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598226.url(scheme.get, call_598226.host, call_598226.base,
                         call_598226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598226, url, valid)

proc call*(call_598227: Call_AndroidpublisherEditsDetailsGet_598214;
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
  var path_598228 = newJObject()
  var query_598229 = newJObject()
  add(query_598229, "fields", newJString(fields))
  add(path_598228, "packageName", newJString(packageName))
  add(query_598229, "quotaUser", newJString(quotaUser))
  add(query_598229, "alt", newJString(alt))
  add(path_598228, "editId", newJString(editId))
  add(query_598229, "oauth_token", newJString(oauthToken))
  add(query_598229, "userIp", newJString(userIp))
  add(query_598229, "key", newJString(key))
  add(query_598229, "prettyPrint", newJBool(prettyPrint))
  result = call_598227.call(path_598228, query_598229, nil, nil, nil)

var androidpublisherEditsDetailsGet* = Call_AndroidpublisherEditsDetailsGet_598214(
    name: "androidpublisherEditsDetailsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsGet_598215,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsGet_598216, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsPatch_598248 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsDetailsPatch_598250(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsDetailsPatch_598249(path: JsonNode;
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
  var valid_598251 = path.getOrDefault("packageName")
  valid_598251 = validateParameter(valid_598251, JString, required = true,
                                 default = nil)
  if valid_598251 != nil:
    section.add "packageName", valid_598251
  var valid_598252 = path.getOrDefault("editId")
  valid_598252 = validateParameter(valid_598252, JString, required = true,
                                 default = nil)
  if valid_598252 != nil:
    section.add "editId", valid_598252
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
  var valid_598253 = query.getOrDefault("fields")
  valid_598253 = validateParameter(valid_598253, JString, required = false,
                                 default = nil)
  if valid_598253 != nil:
    section.add "fields", valid_598253
  var valid_598254 = query.getOrDefault("quotaUser")
  valid_598254 = validateParameter(valid_598254, JString, required = false,
                                 default = nil)
  if valid_598254 != nil:
    section.add "quotaUser", valid_598254
  var valid_598255 = query.getOrDefault("alt")
  valid_598255 = validateParameter(valid_598255, JString, required = false,
                                 default = newJString("json"))
  if valid_598255 != nil:
    section.add "alt", valid_598255
  var valid_598256 = query.getOrDefault("oauth_token")
  valid_598256 = validateParameter(valid_598256, JString, required = false,
                                 default = nil)
  if valid_598256 != nil:
    section.add "oauth_token", valid_598256
  var valid_598257 = query.getOrDefault("userIp")
  valid_598257 = validateParameter(valid_598257, JString, required = false,
                                 default = nil)
  if valid_598257 != nil:
    section.add "userIp", valid_598257
  var valid_598258 = query.getOrDefault("key")
  valid_598258 = validateParameter(valid_598258, JString, required = false,
                                 default = nil)
  if valid_598258 != nil:
    section.add "key", valid_598258
  var valid_598259 = query.getOrDefault("prettyPrint")
  valid_598259 = validateParameter(valid_598259, JBool, required = false,
                                 default = newJBool(true))
  if valid_598259 != nil:
    section.add "prettyPrint", valid_598259
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

proc call*(call_598261: Call_AndroidpublisherEditsDetailsPatch_598248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit. This method supports patch semantics.
  ## 
  let valid = call_598261.validator(path, query, header, formData, body)
  let scheme = call_598261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598261.url(scheme.get, call_598261.host, call_598261.base,
                         call_598261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598261, url, valid)

proc call*(call_598262: Call_AndroidpublisherEditsDetailsPatch_598248;
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
  var path_598263 = newJObject()
  var query_598264 = newJObject()
  var body_598265 = newJObject()
  add(query_598264, "fields", newJString(fields))
  add(path_598263, "packageName", newJString(packageName))
  add(query_598264, "quotaUser", newJString(quotaUser))
  add(query_598264, "alt", newJString(alt))
  add(path_598263, "editId", newJString(editId))
  add(query_598264, "oauth_token", newJString(oauthToken))
  add(query_598264, "userIp", newJString(userIp))
  add(query_598264, "key", newJString(key))
  if body != nil:
    body_598265 = body
  add(query_598264, "prettyPrint", newJBool(prettyPrint))
  result = call_598262.call(path_598263, query_598264, nil, nil, body_598265)

var androidpublisherEditsDetailsPatch* = Call_AndroidpublisherEditsDetailsPatch_598248(
    name: "androidpublisherEditsDetailsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsPatch_598249,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsDetailsPatch_598250, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsList_598266 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsList_598268(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsList_598267(path: JsonNode;
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
  var valid_598269 = path.getOrDefault("packageName")
  valid_598269 = validateParameter(valid_598269, JString, required = true,
                                 default = nil)
  if valid_598269 != nil:
    section.add "packageName", valid_598269
  var valid_598270 = path.getOrDefault("editId")
  valid_598270 = validateParameter(valid_598270, JString, required = true,
                                 default = nil)
  if valid_598270 != nil:
    section.add "editId", valid_598270
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
  var valid_598271 = query.getOrDefault("fields")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "fields", valid_598271
  var valid_598272 = query.getOrDefault("quotaUser")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = nil)
  if valid_598272 != nil:
    section.add "quotaUser", valid_598272
  var valid_598273 = query.getOrDefault("alt")
  valid_598273 = validateParameter(valid_598273, JString, required = false,
                                 default = newJString("json"))
  if valid_598273 != nil:
    section.add "alt", valid_598273
  var valid_598274 = query.getOrDefault("oauth_token")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = nil)
  if valid_598274 != nil:
    section.add "oauth_token", valid_598274
  var valid_598275 = query.getOrDefault("userIp")
  valid_598275 = validateParameter(valid_598275, JString, required = false,
                                 default = nil)
  if valid_598275 != nil:
    section.add "userIp", valid_598275
  var valid_598276 = query.getOrDefault("key")
  valid_598276 = validateParameter(valid_598276, JString, required = false,
                                 default = nil)
  if valid_598276 != nil:
    section.add "key", valid_598276
  var valid_598277 = query.getOrDefault("prettyPrint")
  valid_598277 = validateParameter(valid_598277, JBool, required = false,
                                 default = newJBool(true))
  if valid_598277 != nil:
    section.add "prettyPrint", valid_598277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598278: Call_AndroidpublisherEditsListingsList_598266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the localized store listings attached to this edit.
  ## 
  let valid = call_598278.validator(path, query, header, formData, body)
  let scheme = call_598278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598278.url(scheme.get, call_598278.host, call_598278.base,
                         call_598278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598278, url, valid)

proc call*(call_598279: Call_AndroidpublisherEditsListingsList_598266;
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
  var path_598280 = newJObject()
  var query_598281 = newJObject()
  add(query_598281, "fields", newJString(fields))
  add(path_598280, "packageName", newJString(packageName))
  add(query_598281, "quotaUser", newJString(quotaUser))
  add(query_598281, "alt", newJString(alt))
  add(path_598280, "editId", newJString(editId))
  add(query_598281, "oauth_token", newJString(oauthToken))
  add(query_598281, "userIp", newJString(userIp))
  add(query_598281, "key", newJString(key))
  add(query_598281, "prettyPrint", newJBool(prettyPrint))
  result = call_598279.call(path_598280, query_598281, nil, nil, nil)

var androidpublisherEditsListingsList* = Call_AndroidpublisherEditsListingsList_598266(
    name: "androidpublisherEditsListingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsList_598267,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsList_598268, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDeleteall_598282 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsDeleteall_598284(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsDeleteall_598283(path: JsonNode;
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
  var valid_598285 = path.getOrDefault("packageName")
  valid_598285 = validateParameter(valid_598285, JString, required = true,
                                 default = nil)
  if valid_598285 != nil:
    section.add "packageName", valid_598285
  var valid_598286 = path.getOrDefault("editId")
  valid_598286 = validateParameter(valid_598286, JString, required = true,
                                 default = nil)
  if valid_598286 != nil:
    section.add "editId", valid_598286
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
  var valid_598287 = query.getOrDefault("fields")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "fields", valid_598287
  var valid_598288 = query.getOrDefault("quotaUser")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = nil)
  if valid_598288 != nil:
    section.add "quotaUser", valid_598288
  var valid_598289 = query.getOrDefault("alt")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = newJString("json"))
  if valid_598289 != nil:
    section.add "alt", valid_598289
  var valid_598290 = query.getOrDefault("oauth_token")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = nil)
  if valid_598290 != nil:
    section.add "oauth_token", valid_598290
  var valid_598291 = query.getOrDefault("userIp")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "userIp", valid_598291
  var valid_598292 = query.getOrDefault("key")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = nil)
  if valid_598292 != nil:
    section.add "key", valid_598292
  var valid_598293 = query.getOrDefault("prettyPrint")
  valid_598293 = validateParameter(valid_598293, JBool, required = false,
                                 default = newJBool(true))
  if valid_598293 != nil:
    section.add "prettyPrint", valid_598293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598294: Call_AndroidpublisherEditsListingsDeleteall_598282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all localized listings from an edit.
  ## 
  let valid = call_598294.validator(path, query, header, formData, body)
  let scheme = call_598294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598294.url(scheme.get, call_598294.host, call_598294.base,
                         call_598294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598294, url, valid)

proc call*(call_598295: Call_AndroidpublisherEditsListingsDeleteall_598282;
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
  var path_598296 = newJObject()
  var query_598297 = newJObject()
  add(query_598297, "fields", newJString(fields))
  add(path_598296, "packageName", newJString(packageName))
  add(query_598297, "quotaUser", newJString(quotaUser))
  add(query_598297, "alt", newJString(alt))
  add(path_598296, "editId", newJString(editId))
  add(query_598297, "oauth_token", newJString(oauthToken))
  add(query_598297, "userIp", newJString(userIp))
  add(query_598297, "key", newJString(key))
  add(query_598297, "prettyPrint", newJBool(prettyPrint))
  result = call_598295.call(path_598296, query_598297, nil, nil, nil)

var androidpublisherEditsListingsDeleteall* = Call_AndroidpublisherEditsListingsDeleteall_598282(
    name: "androidpublisherEditsListingsDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsDeleteall_598283,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsDeleteall_598284,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsUpdate_598315 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsUpdate_598317(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsUpdate_598316(path: JsonNode;
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
  var valid_598318 = path.getOrDefault("packageName")
  valid_598318 = validateParameter(valid_598318, JString, required = true,
                                 default = nil)
  if valid_598318 != nil:
    section.add "packageName", valid_598318
  var valid_598319 = path.getOrDefault("editId")
  valid_598319 = validateParameter(valid_598319, JString, required = true,
                                 default = nil)
  if valid_598319 != nil:
    section.add "editId", valid_598319
  var valid_598320 = path.getOrDefault("language")
  valid_598320 = validateParameter(valid_598320, JString, required = true,
                                 default = nil)
  if valid_598320 != nil:
    section.add "language", valid_598320
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
  var valid_598321 = query.getOrDefault("fields")
  valid_598321 = validateParameter(valid_598321, JString, required = false,
                                 default = nil)
  if valid_598321 != nil:
    section.add "fields", valid_598321
  var valid_598322 = query.getOrDefault("quotaUser")
  valid_598322 = validateParameter(valid_598322, JString, required = false,
                                 default = nil)
  if valid_598322 != nil:
    section.add "quotaUser", valid_598322
  var valid_598323 = query.getOrDefault("alt")
  valid_598323 = validateParameter(valid_598323, JString, required = false,
                                 default = newJString("json"))
  if valid_598323 != nil:
    section.add "alt", valid_598323
  var valid_598324 = query.getOrDefault("oauth_token")
  valid_598324 = validateParameter(valid_598324, JString, required = false,
                                 default = nil)
  if valid_598324 != nil:
    section.add "oauth_token", valid_598324
  var valid_598325 = query.getOrDefault("userIp")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = nil)
  if valid_598325 != nil:
    section.add "userIp", valid_598325
  var valid_598326 = query.getOrDefault("key")
  valid_598326 = validateParameter(valid_598326, JString, required = false,
                                 default = nil)
  if valid_598326 != nil:
    section.add "key", valid_598326
  var valid_598327 = query.getOrDefault("prettyPrint")
  valid_598327 = validateParameter(valid_598327, JBool, required = false,
                                 default = newJBool(true))
  if valid_598327 != nil:
    section.add "prettyPrint", valid_598327
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

proc call*(call_598329: Call_AndroidpublisherEditsListingsUpdate_598315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing.
  ## 
  let valid = call_598329.validator(path, query, header, formData, body)
  let scheme = call_598329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598329.url(scheme.get, call_598329.host, call_598329.base,
                         call_598329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598329, url, valid)

proc call*(call_598330: Call_AndroidpublisherEditsListingsUpdate_598315;
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
  var path_598331 = newJObject()
  var query_598332 = newJObject()
  var body_598333 = newJObject()
  add(query_598332, "fields", newJString(fields))
  add(path_598331, "packageName", newJString(packageName))
  add(query_598332, "quotaUser", newJString(quotaUser))
  add(query_598332, "alt", newJString(alt))
  add(path_598331, "editId", newJString(editId))
  add(query_598332, "oauth_token", newJString(oauthToken))
  add(path_598331, "language", newJString(language))
  add(query_598332, "userIp", newJString(userIp))
  add(query_598332, "key", newJString(key))
  if body != nil:
    body_598333 = body
  add(query_598332, "prettyPrint", newJBool(prettyPrint))
  result = call_598330.call(path_598331, query_598332, nil, nil, body_598333)

var androidpublisherEditsListingsUpdate* = Call_AndroidpublisherEditsListingsUpdate_598315(
    name: "androidpublisherEditsListingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsUpdate_598316,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsUpdate_598317, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsGet_598298 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsGet_598300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsGet_598299(path: JsonNode;
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
  var valid_598301 = path.getOrDefault("packageName")
  valid_598301 = validateParameter(valid_598301, JString, required = true,
                                 default = nil)
  if valid_598301 != nil:
    section.add "packageName", valid_598301
  var valid_598302 = path.getOrDefault("editId")
  valid_598302 = validateParameter(valid_598302, JString, required = true,
                                 default = nil)
  if valid_598302 != nil:
    section.add "editId", valid_598302
  var valid_598303 = path.getOrDefault("language")
  valid_598303 = validateParameter(valid_598303, JString, required = true,
                                 default = nil)
  if valid_598303 != nil:
    section.add "language", valid_598303
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
  var valid_598304 = query.getOrDefault("fields")
  valid_598304 = validateParameter(valid_598304, JString, required = false,
                                 default = nil)
  if valid_598304 != nil:
    section.add "fields", valid_598304
  var valid_598305 = query.getOrDefault("quotaUser")
  valid_598305 = validateParameter(valid_598305, JString, required = false,
                                 default = nil)
  if valid_598305 != nil:
    section.add "quotaUser", valid_598305
  var valid_598306 = query.getOrDefault("alt")
  valid_598306 = validateParameter(valid_598306, JString, required = false,
                                 default = newJString("json"))
  if valid_598306 != nil:
    section.add "alt", valid_598306
  var valid_598307 = query.getOrDefault("oauth_token")
  valid_598307 = validateParameter(valid_598307, JString, required = false,
                                 default = nil)
  if valid_598307 != nil:
    section.add "oauth_token", valid_598307
  var valid_598308 = query.getOrDefault("userIp")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "userIp", valid_598308
  var valid_598309 = query.getOrDefault("key")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "key", valid_598309
  var valid_598310 = query.getOrDefault("prettyPrint")
  valid_598310 = validateParameter(valid_598310, JBool, required = false,
                                 default = newJBool(true))
  if valid_598310 != nil:
    section.add "prettyPrint", valid_598310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598311: Call_AndroidpublisherEditsListingsGet_598298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches information about a localized store listing.
  ## 
  let valid = call_598311.validator(path, query, header, formData, body)
  let scheme = call_598311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598311.url(scheme.get, call_598311.host, call_598311.base,
                         call_598311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598311, url, valid)

proc call*(call_598312: Call_AndroidpublisherEditsListingsGet_598298;
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
  var path_598313 = newJObject()
  var query_598314 = newJObject()
  add(query_598314, "fields", newJString(fields))
  add(path_598313, "packageName", newJString(packageName))
  add(query_598314, "quotaUser", newJString(quotaUser))
  add(query_598314, "alt", newJString(alt))
  add(path_598313, "editId", newJString(editId))
  add(query_598314, "oauth_token", newJString(oauthToken))
  add(path_598313, "language", newJString(language))
  add(query_598314, "userIp", newJString(userIp))
  add(query_598314, "key", newJString(key))
  add(query_598314, "prettyPrint", newJBool(prettyPrint))
  result = call_598312.call(path_598313, query_598314, nil, nil, nil)

var androidpublisherEditsListingsGet* = Call_AndroidpublisherEditsListingsGet_598298(
    name: "androidpublisherEditsListingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsGet_598299,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsGet_598300, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsPatch_598351 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsPatch_598353(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsPatch_598352(path: JsonNode;
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
  var valid_598354 = path.getOrDefault("packageName")
  valid_598354 = validateParameter(valid_598354, JString, required = true,
                                 default = nil)
  if valid_598354 != nil:
    section.add "packageName", valid_598354
  var valid_598355 = path.getOrDefault("editId")
  valid_598355 = validateParameter(valid_598355, JString, required = true,
                                 default = nil)
  if valid_598355 != nil:
    section.add "editId", valid_598355
  var valid_598356 = path.getOrDefault("language")
  valid_598356 = validateParameter(valid_598356, JString, required = true,
                                 default = nil)
  if valid_598356 != nil:
    section.add "language", valid_598356
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
  var valid_598357 = query.getOrDefault("fields")
  valid_598357 = validateParameter(valid_598357, JString, required = false,
                                 default = nil)
  if valid_598357 != nil:
    section.add "fields", valid_598357
  var valid_598358 = query.getOrDefault("quotaUser")
  valid_598358 = validateParameter(valid_598358, JString, required = false,
                                 default = nil)
  if valid_598358 != nil:
    section.add "quotaUser", valid_598358
  var valid_598359 = query.getOrDefault("alt")
  valid_598359 = validateParameter(valid_598359, JString, required = false,
                                 default = newJString("json"))
  if valid_598359 != nil:
    section.add "alt", valid_598359
  var valid_598360 = query.getOrDefault("oauth_token")
  valid_598360 = validateParameter(valid_598360, JString, required = false,
                                 default = nil)
  if valid_598360 != nil:
    section.add "oauth_token", valid_598360
  var valid_598361 = query.getOrDefault("userIp")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = nil)
  if valid_598361 != nil:
    section.add "userIp", valid_598361
  var valid_598362 = query.getOrDefault("key")
  valid_598362 = validateParameter(valid_598362, JString, required = false,
                                 default = nil)
  if valid_598362 != nil:
    section.add "key", valid_598362
  var valid_598363 = query.getOrDefault("prettyPrint")
  valid_598363 = validateParameter(valid_598363, JBool, required = false,
                                 default = newJBool(true))
  if valid_598363 != nil:
    section.add "prettyPrint", valid_598363
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

proc call*(call_598365: Call_AndroidpublisherEditsListingsPatch_598351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ## 
  let valid = call_598365.validator(path, query, header, formData, body)
  let scheme = call_598365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598365.url(scheme.get, call_598365.host, call_598365.base,
                         call_598365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598365, url, valid)

proc call*(call_598366: Call_AndroidpublisherEditsListingsPatch_598351;
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
  var path_598367 = newJObject()
  var query_598368 = newJObject()
  var body_598369 = newJObject()
  add(query_598368, "fields", newJString(fields))
  add(path_598367, "packageName", newJString(packageName))
  add(query_598368, "quotaUser", newJString(quotaUser))
  add(query_598368, "alt", newJString(alt))
  add(path_598367, "editId", newJString(editId))
  add(query_598368, "oauth_token", newJString(oauthToken))
  add(path_598367, "language", newJString(language))
  add(query_598368, "userIp", newJString(userIp))
  add(query_598368, "key", newJString(key))
  if body != nil:
    body_598369 = body
  add(query_598368, "prettyPrint", newJBool(prettyPrint))
  result = call_598366.call(path_598367, query_598368, nil, nil, body_598369)

var androidpublisherEditsListingsPatch* = Call_AndroidpublisherEditsListingsPatch_598351(
    name: "androidpublisherEditsListingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsPatch_598352,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsPatch_598353, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDelete_598334 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsListingsDelete_598336(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsListingsDelete_598335(path: JsonNode;
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
  var valid_598337 = path.getOrDefault("packageName")
  valid_598337 = validateParameter(valid_598337, JString, required = true,
                                 default = nil)
  if valid_598337 != nil:
    section.add "packageName", valid_598337
  var valid_598338 = path.getOrDefault("editId")
  valid_598338 = validateParameter(valid_598338, JString, required = true,
                                 default = nil)
  if valid_598338 != nil:
    section.add "editId", valid_598338
  var valid_598339 = path.getOrDefault("language")
  valid_598339 = validateParameter(valid_598339, JString, required = true,
                                 default = nil)
  if valid_598339 != nil:
    section.add "language", valid_598339
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
  var valid_598340 = query.getOrDefault("fields")
  valid_598340 = validateParameter(valid_598340, JString, required = false,
                                 default = nil)
  if valid_598340 != nil:
    section.add "fields", valid_598340
  var valid_598341 = query.getOrDefault("quotaUser")
  valid_598341 = validateParameter(valid_598341, JString, required = false,
                                 default = nil)
  if valid_598341 != nil:
    section.add "quotaUser", valid_598341
  var valid_598342 = query.getOrDefault("alt")
  valid_598342 = validateParameter(valid_598342, JString, required = false,
                                 default = newJString("json"))
  if valid_598342 != nil:
    section.add "alt", valid_598342
  var valid_598343 = query.getOrDefault("oauth_token")
  valid_598343 = validateParameter(valid_598343, JString, required = false,
                                 default = nil)
  if valid_598343 != nil:
    section.add "oauth_token", valid_598343
  var valid_598344 = query.getOrDefault("userIp")
  valid_598344 = validateParameter(valid_598344, JString, required = false,
                                 default = nil)
  if valid_598344 != nil:
    section.add "userIp", valid_598344
  var valid_598345 = query.getOrDefault("key")
  valid_598345 = validateParameter(valid_598345, JString, required = false,
                                 default = nil)
  if valid_598345 != nil:
    section.add "key", valid_598345
  var valid_598346 = query.getOrDefault("prettyPrint")
  valid_598346 = validateParameter(valid_598346, JBool, required = false,
                                 default = newJBool(true))
  if valid_598346 != nil:
    section.add "prettyPrint", valid_598346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598347: Call_AndroidpublisherEditsListingsDelete_598334;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified localized store listing from an edit.
  ## 
  let valid = call_598347.validator(path, query, header, formData, body)
  let scheme = call_598347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598347.url(scheme.get, call_598347.host, call_598347.base,
                         call_598347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598347, url, valid)

proc call*(call_598348: Call_AndroidpublisherEditsListingsDelete_598334;
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
  var path_598349 = newJObject()
  var query_598350 = newJObject()
  add(query_598350, "fields", newJString(fields))
  add(path_598349, "packageName", newJString(packageName))
  add(query_598350, "quotaUser", newJString(quotaUser))
  add(query_598350, "alt", newJString(alt))
  add(path_598349, "editId", newJString(editId))
  add(query_598350, "oauth_token", newJString(oauthToken))
  add(path_598349, "language", newJString(language))
  add(query_598350, "userIp", newJString(userIp))
  add(query_598350, "key", newJString(key))
  add(query_598350, "prettyPrint", newJBool(prettyPrint))
  result = call_598348.call(path_598349, query_598350, nil, nil, nil)

var androidpublisherEditsListingsDelete* = Call_AndroidpublisherEditsListingsDelete_598334(
    name: "androidpublisherEditsListingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsDelete_598335,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsListingsDelete_598336, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesUpload_598388 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsImagesUpload_598390(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsImagesUpload_598389(path: JsonNode;
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
  var valid_598391 = path.getOrDefault("packageName")
  valid_598391 = validateParameter(valid_598391, JString, required = true,
                                 default = nil)
  if valid_598391 != nil:
    section.add "packageName", valid_598391
  var valid_598392 = path.getOrDefault("editId")
  valid_598392 = validateParameter(valid_598392, JString, required = true,
                                 default = nil)
  if valid_598392 != nil:
    section.add "editId", valid_598392
  var valid_598393 = path.getOrDefault("language")
  valid_598393 = validateParameter(valid_598393, JString, required = true,
                                 default = nil)
  if valid_598393 != nil:
    section.add "language", valid_598393
  var valid_598394 = path.getOrDefault("imageType")
  valid_598394 = validateParameter(valid_598394, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_598394 != nil:
    section.add "imageType", valid_598394
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
  var valid_598395 = query.getOrDefault("fields")
  valid_598395 = validateParameter(valid_598395, JString, required = false,
                                 default = nil)
  if valid_598395 != nil:
    section.add "fields", valid_598395
  var valid_598396 = query.getOrDefault("quotaUser")
  valid_598396 = validateParameter(valid_598396, JString, required = false,
                                 default = nil)
  if valid_598396 != nil:
    section.add "quotaUser", valid_598396
  var valid_598397 = query.getOrDefault("alt")
  valid_598397 = validateParameter(valid_598397, JString, required = false,
                                 default = newJString("json"))
  if valid_598397 != nil:
    section.add "alt", valid_598397
  var valid_598398 = query.getOrDefault("oauth_token")
  valid_598398 = validateParameter(valid_598398, JString, required = false,
                                 default = nil)
  if valid_598398 != nil:
    section.add "oauth_token", valid_598398
  var valid_598399 = query.getOrDefault("userIp")
  valid_598399 = validateParameter(valid_598399, JString, required = false,
                                 default = nil)
  if valid_598399 != nil:
    section.add "userIp", valid_598399
  var valid_598400 = query.getOrDefault("key")
  valid_598400 = validateParameter(valid_598400, JString, required = false,
                                 default = nil)
  if valid_598400 != nil:
    section.add "key", valid_598400
  var valid_598401 = query.getOrDefault("prettyPrint")
  valid_598401 = validateParameter(valid_598401, JBool, required = false,
                                 default = newJBool(true))
  if valid_598401 != nil:
    section.add "prettyPrint", valid_598401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598402: Call_AndroidpublisherEditsImagesUpload_598388;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ## 
  let valid = call_598402.validator(path, query, header, formData, body)
  let scheme = call_598402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598402.url(scheme.get, call_598402.host, call_598402.base,
                         call_598402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598402, url, valid)

proc call*(call_598403: Call_AndroidpublisherEditsImagesUpload_598388;
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
  var path_598404 = newJObject()
  var query_598405 = newJObject()
  add(query_598405, "fields", newJString(fields))
  add(path_598404, "packageName", newJString(packageName))
  add(query_598405, "quotaUser", newJString(quotaUser))
  add(query_598405, "alt", newJString(alt))
  add(path_598404, "editId", newJString(editId))
  add(query_598405, "oauth_token", newJString(oauthToken))
  add(path_598404, "language", newJString(language))
  add(query_598405, "userIp", newJString(userIp))
  add(path_598404, "imageType", newJString(imageType))
  add(query_598405, "key", newJString(key))
  add(query_598405, "prettyPrint", newJBool(prettyPrint))
  result = call_598403.call(path_598404, query_598405, nil, nil, nil)

var androidpublisherEditsImagesUpload* = Call_AndroidpublisherEditsImagesUpload_598388(
    name: "androidpublisherEditsImagesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesUpload_598389,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesUpload_598390, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesList_598370 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsImagesList_598372(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsImagesList_598371(path: JsonNode;
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
  var valid_598373 = path.getOrDefault("packageName")
  valid_598373 = validateParameter(valid_598373, JString, required = true,
                                 default = nil)
  if valid_598373 != nil:
    section.add "packageName", valid_598373
  var valid_598374 = path.getOrDefault("editId")
  valid_598374 = validateParameter(valid_598374, JString, required = true,
                                 default = nil)
  if valid_598374 != nil:
    section.add "editId", valid_598374
  var valid_598375 = path.getOrDefault("language")
  valid_598375 = validateParameter(valid_598375, JString, required = true,
                                 default = nil)
  if valid_598375 != nil:
    section.add "language", valid_598375
  var valid_598376 = path.getOrDefault("imageType")
  valid_598376 = validateParameter(valid_598376, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_598376 != nil:
    section.add "imageType", valid_598376
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
  var valid_598377 = query.getOrDefault("fields")
  valid_598377 = validateParameter(valid_598377, JString, required = false,
                                 default = nil)
  if valid_598377 != nil:
    section.add "fields", valid_598377
  var valid_598378 = query.getOrDefault("quotaUser")
  valid_598378 = validateParameter(valid_598378, JString, required = false,
                                 default = nil)
  if valid_598378 != nil:
    section.add "quotaUser", valid_598378
  var valid_598379 = query.getOrDefault("alt")
  valid_598379 = validateParameter(valid_598379, JString, required = false,
                                 default = newJString("json"))
  if valid_598379 != nil:
    section.add "alt", valid_598379
  var valid_598380 = query.getOrDefault("oauth_token")
  valid_598380 = validateParameter(valid_598380, JString, required = false,
                                 default = nil)
  if valid_598380 != nil:
    section.add "oauth_token", valid_598380
  var valid_598381 = query.getOrDefault("userIp")
  valid_598381 = validateParameter(valid_598381, JString, required = false,
                                 default = nil)
  if valid_598381 != nil:
    section.add "userIp", valid_598381
  var valid_598382 = query.getOrDefault("key")
  valid_598382 = validateParameter(valid_598382, JString, required = false,
                                 default = nil)
  if valid_598382 != nil:
    section.add "key", valid_598382
  var valid_598383 = query.getOrDefault("prettyPrint")
  valid_598383 = validateParameter(valid_598383, JBool, required = false,
                                 default = newJBool(true))
  if valid_598383 != nil:
    section.add "prettyPrint", valid_598383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598384: Call_AndroidpublisherEditsImagesList_598370;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all images for the specified language and image type.
  ## 
  let valid = call_598384.validator(path, query, header, formData, body)
  let scheme = call_598384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598384.url(scheme.get, call_598384.host, call_598384.base,
                         call_598384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598384, url, valid)

proc call*(call_598385: Call_AndroidpublisherEditsImagesList_598370;
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
  var path_598386 = newJObject()
  var query_598387 = newJObject()
  add(query_598387, "fields", newJString(fields))
  add(path_598386, "packageName", newJString(packageName))
  add(query_598387, "quotaUser", newJString(quotaUser))
  add(query_598387, "alt", newJString(alt))
  add(path_598386, "editId", newJString(editId))
  add(query_598387, "oauth_token", newJString(oauthToken))
  add(path_598386, "language", newJString(language))
  add(query_598387, "userIp", newJString(userIp))
  add(path_598386, "imageType", newJString(imageType))
  add(query_598387, "key", newJString(key))
  add(query_598387, "prettyPrint", newJBool(prettyPrint))
  result = call_598385.call(path_598386, query_598387, nil, nil, nil)

var androidpublisherEditsImagesList* = Call_AndroidpublisherEditsImagesList_598370(
    name: "androidpublisherEditsImagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesList_598371,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesList_598372, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDeleteall_598406 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsImagesDeleteall_598408(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsImagesDeleteall_598407(path: JsonNode;
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
  var valid_598409 = path.getOrDefault("packageName")
  valid_598409 = validateParameter(valid_598409, JString, required = true,
                                 default = nil)
  if valid_598409 != nil:
    section.add "packageName", valid_598409
  var valid_598410 = path.getOrDefault("editId")
  valid_598410 = validateParameter(valid_598410, JString, required = true,
                                 default = nil)
  if valid_598410 != nil:
    section.add "editId", valid_598410
  var valid_598411 = path.getOrDefault("language")
  valid_598411 = validateParameter(valid_598411, JString, required = true,
                                 default = nil)
  if valid_598411 != nil:
    section.add "language", valid_598411
  var valid_598412 = path.getOrDefault("imageType")
  valid_598412 = validateParameter(valid_598412, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_598412 != nil:
    section.add "imageType", valid_598412
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
  var valid_598413 = query.getOrDefault("fields")
  valid_598413 = validateParameter(valid_598413, JString, required = false,
                                 default = nil)
  if valid_598413 != nil:
    section.add "fields", valid_598413
  var valid_598414 = query.getOrDefault("quotaUser")
  valid_598414 = validateParameter(valid_598414, JString, required = false,
                                 default = nil)
  if valid_598414 != nil:
    section.add "quotaUser", valid_598414
  var valid_598415 = query.getOrDefault("alt")
  valid_598415 = validateParameter(valid_598415, JString, required = false,
                                 default = newJString("json"))
  if valid_598415 != nil:
    section.add "alt", valid_598415
  var valid_598416 = query.getOrDefault("oauth_token")
  valid_598416 = validateParameter(valid_598416, JString, required = false,
                                 default = nil)
  if valid_598416 != nil:
    section.add "oauth_token", valid_598416
  var valid_598417 = query.getOrDefault("userIp")
  valid_598417 = validateParameter(valid_598417, JString, required = false,
                                 default = nil)
  if valid_598417 != nil:
    section.add "userIp", valid_598417
  var valid_598418 = query.getOrDefault("key")
  valid_598418 = validateParameter(valid_598418, JString, required = false,
                                 default = nil)
  if valid_598418 != nil:
    section.add "key", valid_598418
  var valid_598419 = query.getOrDefault("prettyPrint")
  valid_598419 = validateParameter(valid_598419, JBool, required = false,
                                 default = newJBool(true))
  if valid_598419 != nil:
    section.add "prettyPrint", valid_598419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598420: Call_AndroidpublisherEditsImagesDeleteall_598406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all images for the specified language and image type.
  ## 
  let valid = call_598420.validator(path, query, header, formData, body)
  let scheme = call_598420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598420.url(scheme.get, call_598420.host, call_598420.base,
                         call_598420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598420, url, valid)

proc call*(call_598421: Call_AndroidpublisherEditsImagesDeleteall_598406;
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
  var path_598422 = newJObject()
  var query_598423 = newJObject()
  add(query_598423, "fields", newJString(fields))
  add(path_598422, "packageName", newJString(packageName))
  add(query_598423, "quotaUser", newJString(quotaUser))
  add(query_598423, "alt", newJString(alt))
  add(path_598422, "editId", newJString(editId))
  add(query_598423, "oauth_token", newJString(oauthToken))
  add(path_598422, "language", newJString(language))
  add(query_598423, "userIp", newJString(userIp))
  add(path_598422, "imageType", newJString(imageType))
  add(query_598423, "key", newJString(key))
  add(query_598423, "prettyPrint", newJBool(prettyPrint))
  result = call_598421.call(path_598422, query_598423, nil, nil, nil)

var androidpublisherEditsImagesDeleteall* = Call_AndroidpublisherEditsImagesDeleteall_598406(
    name: "androidpublisherEditsImagesDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesDeleteall_598407,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesDeleteall_598408, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDelete_598424 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsImagesDelete_598426(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsImagesDelete_598425(path: JsonNode;
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
  var valid_598427 = path.getOrDefault("imageId")
  valid_598427 = validateParameter(valid_598427, JString, required = true,
                                 default = nil)
  if valid_598427 != nil:
    section.add "imageId", valid_598427
  var valid_598428 = path.getOrDefault("packageName")
  valid_598428 = validateParameter(valid_598428, JString, required = true,
                                 default = nil)
  if valid_598428 != nil:
    section.add "packageName", valid_598428
  var valid_598429 = path.getOrDefault("editId")
  valid_598429 = validateParameter(valid_598429, JString, required = true,
                                 default = nil)
  if valid_598429 != nil:
    section.add "editId", valid_598429
  var valid_598430 = path.getOrDefault("language")
  valid_598430 = validateParameter(valid_598430, JString, required = true,
                                 default = nil)
  if valid_598430 != nil:
    section.add "language", valid_598430
  var valid_598431 = path.getOrDefault("imageType")
  valid_598431 = validateParameter(valid_598431, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_598431 != nil:
    section.add "imageType", valid_598431
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
  var valid_598432 = query.getOrDefault("fields")
  valid_598432 = validateParameter(valid_598432, JString, required = false,
                                 default = nil)
  if valid_598432 != nil:
    section.add "fields", valid_598432
  var valid_598433 = query.getOrDefault("quotaUser")
  valid_598433 = validateParameter(valid_598433, JString, required = false,
                                 default = nil)
  if valid_598433 != nil:
    section.add "quotaUser", valid_598433
  var valid_598434 = query.getOrDefault("alt")
  valid_598434 = validateParameter(valid_598434, JString, required = false,
                                 default = newJString("json"))
  if valid_598434 != nil:
    section.add "alt", valid_598434
  var valid_598435 = query.getOrDefault("oauth_token")
  valid_598435 = validateParameter(valid_598435, JString, required = false,
                                 default = nil)
  if valid_598435 != nil:
    section.add "oauth_token", valid_598435
  var valid_598436 = query.getOrDefault("userIp")
  valid_598436 = validateParameter(valid_598436, JString, required = false,
                                 default = nil)
  if valid_598436 != nil:
    section.add "userIp", valid_598436
  var valid_598437 = query.getOrDefault("key")
  valid_598437 = validateParameter(valid_598437, JString, required = false,
                                 default = nil)
  if valid_598437 != nil:
    section.add "key", valid_598437
  var valid_598438 = query.getOrDefault("prettyPrint")
  valid_598438 = validateParameter(valid_598438, JBool, required = false,
                                 default = newJBool(true))
  if valid_598438 != nil:
    section.add "prettyPrint", valid_598438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598439: Call_AndroidpublisherEditsImagesDelete_598424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the image (specified by id) from the edit.
  ## 
  let valid = call_598439.validator(path, query, header, formData, body)
  let scheme = call_598439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598439.url(scheme.get, call_598439.host, call_598439.base,
                         call_598439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598439, url, valid)

proc call*(call_598440: Call_AndroidpublisherEditsImagesDelete_598424;
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
  var path_598441 = newJObject()
  var query_598442 = newJObject()
  add(path_598441, "imageId", newJString(imageId))
  add(query_598442, "fields", newJString(fields))
  add(path_598441, "packageName", newJString(packageName))
  add(query_598442, "quotaUser", newJString(quotaUser))
  add(query_598442, "alt", newJString(alt))
  add(path_598441, "editId", newJString(editId))
  add(query_598442, "oauth_token", newJString(oauthToken))
  add(path_598441, "language", newJString(language))
  add(query_598442, "userIp", newJString(userIp))
  add(path_598441, "imageType", newJString(imageType))
  add(query_598442, "key", newJString(key))
  add(query_598442, "prettyPrint", newJBool(prettyPrint))
  result = call_598440.call(path_598441, query_598442, nil, nil, nil)

var androidpublisherEditsImagesDelete* = Call_AndroidpublisherEditsImagesDelete_598424(
    name: "androidpublisherEditsImagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}/{imageId}",
    validator: validate_AndroidpublisherEditsImagesDelete_598425,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsImagesDelete_598426, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersUpdate_598460 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTestersUpdate_598462(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTestersUpdate_598461(path: JsonNode;
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
  var valid_598463 = path.getOrDefault("packageName")
  valid_598463 = validateParameter(valid_598463, JString, required = true,
                                 default = nil)
  if valid_598463 != nil:
    section.add "packageName", valid_598463
  var valid_598464 = path.getOrDefault("editId")
  valid_598464 = validateParameter(valid_598464, JString, required = true,
                                 default = nil)
  if valid_598464 != nil:
    section.add "editId", valid_598464
  var valid_598465 = path.getOrDefault("track")
  valid_598465 = validateParameter(valid_598465, JString, required = true,
                                 default = nil)
  if valid_598465 != nil:
    section.add "track", valid_598465
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
  var valid_598466 = query.getOrDefault("fields")
  valid_598466 = validateParameter(valid_598466, JString, required = false,
                                 default = nil)
  if valid_598466 != nil:
    section.add "fields", valid_598466
  var valid_598467 = query.getOrDefault("quotaUser")
  valid_598467 = validateParameter(valid_598467, JString, required = false,
                                 default = nil)
  if valid_598467 != nil:
    section.add "quotaUser", valid_598467
  var valid_598468 = query.getOrDefault("alt")
  valid_598468 = validateParameter(valid_598468, JString, required = false,
                                 default = newJString("json"))
  if valid_598468 != nil:
    section.add "alt", valid_598468
  var valid_598469 = query.getOrDefault("oauth_token")
  valid_598469 = validateParameter(valid_598469, JString, required = false,
                                 default = nil)
  if valid_598469 != nil:
    section.add "oauth_token", valid_598469
  var valid_598470 = query.getOrDefault("userIp")
  valid_598470 = validateParameter(valid_598470, JString, required = false,
                                 default = nil)
  if valid_598470 != nil:
    section.add "userIp", valid_598470
  var valid_598471 = query.getOrDefault("key")
  valid_598471 = validateParameter(valid_598471, JString, required = false,
                                 default = nil)
  if valid_598471 != nil:
    section.add "key", valid_598471
  var valid_598472 = query.getOrDefault("prettyPrint")
  valid_598472 = validateParameter(valid_598472, JBool, required = false,
                                 default = newJBool(true))
  if valid_598472 != nil:
    section.add "prettyPrint", valid_598472
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

proc call*(call_598474: Call_AndroidpublisherEditsTestersUpdate_598460;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_598474.validator(path, query, header, formData, body)
  let scheme = call_598474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598474.url(scheme.get, call_598474.host, call_598474.base,
                         call_598474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598474, url, valid)

proc call*(call_598475: Call_AndroidpublisherEditsTestersUpdate_598460;
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
  var path_598476 = newJObject()
  var query_598477 = newJObject()
  var body_598478 = newJObject()
  add(query_598477, "fields", newJString(fields))
  add(path_598476, "packageName", newJString(packageName))
  add(query_598477, "quotaUser", newJString(quotaUser))
  add(query_598477, "alt", newJString(alt))
  add(path_598476, "editId", newJString(editId))
  add(query_598477, "oauth_token", newJString(oauthToken))
  add(query_598477, "userIp", newJString(userIp))
  add(query_598477, "key", newJString(key))
  if body != nil:
    body_598478 = body
  add(query_598477, "prettyPrint", newJBool(prettyPrint))
  add(path_598476, "track", newJString(track))
  result = call_598475.call(path_598476, query_598477, nil, nil, body_598478)

var androidpublisherEditsTestersUpdate* = Call_AndroidpublisherEditsTestersUpdate_598460(
    name: "androidpublisherEditsTestersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersUpdate_598461,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersUpdate_598462, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersGet_598443 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTestersGet_598445(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTestersGet_598444(path: JsonNode;
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
  var valid_598446 = path.getOrDefault("packageName")
  valid_598446 = validateParameter(valid_598446, JString, required = true,
                                 default = nil)
  if valid_598446 != nil:
    section.add "packageName", valid_598446
  var valid_598447 = path.getOrDefault("editId")
  valid_598447 = validateParameter(valid_598447, JString, required = true,
                                 default = nil)
  if valid_598447 != nil:
    section.add "editId", valid_598447
  var valid_598448 = path.getOrDefault("track")
  valid_598448 = validateParameter(valid_598448, JString, required = true,
                                 default = nil)
  if valid_598448 != nil:
    section.add "track", valid_598448
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
  var valid_598449 = query.getOrDefault("fields")
  valid_598449 = validateParameter(valid_598449, JString, required = false,
                                 default = nil)
  if valid_598449 != nil:
    section.add "fields", valid_598449
  var valid_598450 = query.getOrDefault("quotaUser")
  valid_598450 = validateParameter(valid_598450, JString, required = false,
                                 default = nil)
  if valid_598450 != nil:
    section.add "quotaUser", valid_598450
  var valid_598451 = query.getOrDefault("alt")
  valid_598451 = validateParameter(valid_598451, JString, required = false,
                                 default = newJString("json"))
  if valid_598451 != nil:
    section.add "alt", valid_598451
  var valid_598452 = query.getOrDefault("oauth_token")
  valid_598452 = validateParameter(valid_598452, JString, required = false,
                                 default = nil)
  if valid_598452 != nil:
    section.add "oauth_token", valid_598452
  var valid_598453 = query.getOrDefault("userIp")
  valid_598453 = validateParameter(valid_598453, JString, required = false,
                                 default = nil)
  if valid_598453 != nil:
    section.add "userIp", valid_598453
  var valid_598454 = query.getOrDefault("key")
  valid_598454 = validateParameter(valid_598454, JString, required = false,
                                 default = nil)
  if valid_598454 != nil:
    section.add "key", valid_598454
  var valid_598455 = query.getOrDefault("prettyPrint")
  valid_598455 = validateParameter(valid_598455, JBool, required = false,
                                 default = newJBool(true))
  if valid_598455 != nil:
    section.add "prettyPrint", valid_598455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598456: Call_AndroidpublisherEditsTestersGet_598443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_598456.validator(path, query, header, formData, body)
  let scheme = call_598456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598456.url(scheme.get, call_598456.host, call_598456.base,
                         call_598456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598456, url, valid)

proc call*(call_598457: Call_AndroidpublisherEditsTestersGet_598443;
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
  var path_598458 = newJObject()
  var query_598459 = newJObject()
  add(query_598459, "fields", newJString(fields))
  add(path_598458, "packageName", newJString(packageName))
  add(query_598459, "quotaUser", newJString(quotaUser))
  add(query_598459, "alt", newJString(alt))
  add(path_598458, "editId", newJString(editId))
  add(query_598459, "oauth_token", newJString(oauthToken))
  add(query_598459, "userIp", newJString(userIp))
  add(query_598459, "key", newJString(key))
  add(query_598459, "prettyPrint", newJBool(prettyPrint))
  add(path_598458, "track", newJString(track))
  result = call_598457.call(path_598458, query_598459, nil, nil, nil)

var androidpublisherEditsTestersGet* = Call_AndroidpublisherEditsTestersGet_598443(
    name: "androidpublisherEditsTestersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersGet_598444,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersGet_598445, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersPatch_598479 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTestersPatch_598481(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTestersPatch_598480(path: JsonNode;
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
  var valid_598482 = path.getOrDefault("packageName")
  valid_598482 = validateParameter(valid_598482, JString, required = true,
                                 default = nil)
  if valid_598482 != nil:
    section.add "packageName", valid_598482
  var valid_598483 = path.getOrDefault("editId")
  valid_598483 = validateParameter(valid_598483, JString, required = true,
                                 default = nil)
  if valid_598483 != nil:
    section.add "editId", valid_598483
  var valid_598484 = path.getOrDefault("track")
  valid_598484 = validateParameter(valid_598484, JString, required = true,
                                 default = nil)
  if valid_598484 != nil:
    section.add "track", valid_598484
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
  var valid_598485 = query.getOrDefault("fields")
  valid_598485 = validateParameter(valid_598485, JString, required = false,
                                 default = nil)
  if valid_598485 != nil:
    section.add "fields", valid_598485
  var valid_598486 = query.getOrDefault("quotaUser")
  valid_598486 = validateParameter(valid_598486, JString, required = false,
                                 default = nil)
  if valid_598486 != nil:
    section.add "quotaUser", valid_598486
  var valid_598487 = query.getOrDefault("alt")
  valid_598487 = validateParameter(valid_598487, JString, required = false,
                                 default = newJString("json"))
  if valid_598487 != nil:
    section.add "alt", valid_598487
  var valid_598488 = query.getOrDefault("oauth_token")
  valid_598488 = validateParameter(valid_598488, JString, required = false,
                                 default = nil)
  if valid_598488 != nil:
    section.add "oauth_token", valid_598488
  var valid_598489 = query.getOrDefault("userIp")
  valid_598489 = validateParameter(valid_598489, JString, required = false,
                                 default = nil)
  if valid_598489 != nil:
    section.add "userIp", valid_598489
  var valid_598490 = query.getOrDefault("key")
  valid_598490 = validateParameter(valid_598490, JString, required = false,
                                 default = nil)
  if valid_598490 != nil:
    section.add "key", valid_598490
  var valid_598491 = query.getOrDefault("prettyPrint")
  valid_598491 = validateParameter(valid_598491, JBool, required = false,
                                 default = newJBool(true))
  if valid_598491 != nil:
    section.add "prettyPrint", valid_598491
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

proc call*(call_598493: Call_AndroidpublisherEditsTestersPatch_598479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_598493.validator(path, query, header, formData, body)
  let scheme = call_598493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598493.url(scheme.get, call_598493.host, call_598493.base,
                         call_598493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598493, url, valid)

proc call*(call_598494: Call_AndroidpublisherEditsTestersPatch_598479;
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
  var path_598495 = newJObject()
  var query_598496 = newJObject()
  var body_598497 = newJObject()
  add(query_598496, "fields", newJString(fields))
  add(path_598495, "packageName", newJString(packageName))
  add(query_598496, "quotaUser", newJString(quotaUser))
  add(query_598496, "alt", newJString(alt))
  add(path_598495, "editId", newJString(editId))
  add(query_598496, "oauth_token", newJString(oauthToken))
  add(query_598496, "userIp", newJString(userIp))
  add(query_598496, "key", newJString(key))
  if body != nil:
    body_598497 = body
  add(query_598496, "prettyPrint", newJBool(prettyPrint))
  add(path_598495, "track", newJString(track))
  result = call_598494.call(path_598495, query_598496, nil, nil, body_598497)

var androidpublisherEditsTestersPatch* = Call_AndroidpublisherEditsTestersPatch_598479(
    name: "androidpublisherEditsTestersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersPatch_598480,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTestersPatch_598481, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksList_598498 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTracksList_598500(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTracksList_598499(path: JsonNode;
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
  var valid_598501 = path.getOrDefault("packageName")
  valid_598501 = validateParameter(valid_598501, JString, required = true,
                                 default = nil)
  if valid_598501 != nil:
    section.add "packageName", valid_598501
  var valid_598502 = path.getOrDefault("editId")
  valid_598502 = validateParameter(valid_598502, JString, required = true,
                                 default = nil)
  if valid_598502 != nil:
    section.add "editId", valid_598502
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
  var valid_598503 = query.getOrDefault("fields")
  valid_598503 = validateParameter(valid_598503, JString, required = false,
                                 default = nil)
  if valid_598503 != nil:
    section.add "fields", valid_598503
  var valid_598504 = query.getOrDefault("quotaUser")
  valid_598504 = validateParameter(valid_598504, JString, required = false,
                                 default = nil)
  if valid_598504 != nil:
    section.add "quotaUser", valid_598504
  var valid_598505 = query.getOrDefault("alt")
  valid_598505 = validateParameter(valid_598505, JString, required = false,
                                 default = newJString("json"))
  if valid_598505 != nil:
    section.add "alt", valid_598505
  var valid_598506 = query.getOrDefault("oauth_token")
  valid_598506 = validateParameter(valid_598506, JString, required = false,
                                 default = nil)
  if valid_598506 != nil:
    section.add "oauth_token", valid_598506
  var valid_598507 = query.getOrDefault("userIp")
  valid_598507 = validateParameter(valid_598507, JString, required = false,
                                 default = nil)
  if valid_598507 != nil:
    section.add "userIp", valid_598507
  var valid_598508 = query.getOrDefault("key")
  valid_598508 = validateParameter(valid_598508, JString, required = false,
                                 default = nil)
  if valid_598508 != nil:
    section.add "key", valid_598508
  var valid_598509 = query.getOrDefault("prettyPrint")
  valid_598509 = validateParameter(valid_598509, JBool, required = false,
                                 default = newJBool(true))
  if valid_598509 != nil:
    section.add "prettyPrint", valid_598509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598510: Call_AndroidpublisherEditsTracksList_598498;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the track configurations for this edit.
  ## 
  let valid = call_598510.validator(path, query, header, formData, body)
  let scheme = call_598510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598510.url(scheme.get, call_598510.host, call_598510.base,
                         call_598510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598510, url, valid)

proc call*(call_598511: Call_AndroidpublisherEditsTracksList_598498;
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
  var path_598512 = newJObject()
  var query_598513 = newJObject()
  add(query_598513, "fields", newJString(fields))
  add(path_598512, "packageName", newJString(packageName))
  add(query_598513, "quotaUser", newJString(quotaUser))
  add(query_598513, "alt", newJString(alt))
  add(path_598512, "editId", newJString(editId))
  add(query_598513, "oauth_token", newJString(oauthToken))
  add(query_598513, "userIp", newJString(userIp))
  add(query_598513, "key", newJString(key))
  add(query_598513, "prettyPrint", newJBool(prettyPrint))
  result = call_598511.call(path_598512, query_598513, nil, nil, nil)

var androidpublisherEditsTracksList* = Call_AndroidpublisherEditsTracksList_598498(
    name: "androidpublisherEditsTracksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/tracks",
    validator: validate_AndroidpublisherEditsTracksList_598499,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksList_598500, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksUpdate_598531 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTracksUpdate_598533(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTracksUpdate_598532(path: JsonNode;
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
  var valid_598534 = path.getOrDefault("packageName")
  valid_598534 = validateParameter(valid_598534, JString, required = true,
                                 default = nil)
  if valid_598534 != nil:
    section.add "packageName", valid_598534
  var valid_598535 = path.getOrDefault("editId")
  valid_598535 = validateParameter(valid_598535, JString, required = true,
                                 default = nil)
  if valid_598535 != nil:
    section.add "editId", valid_598535
  var valid_598536 = path.getOrDefault("track")
  valid_598536 = validateParameter(valid_598536, JString, required = true,
                                 default = nil)
  if valid_598536 != nil:
    section.add "track", valid_598536
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
  var valid_598537 = query.getOrDefault("fields")
  valid_598537 = validateParameter(valid_598537, JString, required = false,
                                 default = nil)
  if valid_598537 != nil:
    section.add "fields", valid_598537
  var valid_598538 = query.getOrDefault("quotaUser")
  valid_598538 = validateParameter(valid_598538, JString, required = false,
                                 default = nil)
  if valid_598538 != nil:
    section.add "quotaUser", valid_598538
  var valid_598539 = query.getOrDefault("alt")
  valid_598539 = validateParameter(valid_598539, JString, required = false,
                                 default = newJString("json"))
  if valid_598539 != nil:
    section.add "alt", valid_598539
  var valid_598540 = query.getOrDefault("oauth_token")
  valid_598540 = validateParameter(valid_598540, JString, required = false,
                                 default = nil)
  if valid_598540 != nil:
    section.add "oauth_token", valid_598540
  var valid_598541 = query.getOrDefault("userIp")
  valid_598541 = validateParameter(valid_598541, JString, required = false,
                                 default = nil)
  if valid_598541 != nil:
    section.add "userIp", valid_598541
  var valid_598542 = query.getOrDefault("key")
  valid_598542 = validateParameter(valid_598542, JString, required = false,
                                 default = nil)
  if valid_598542 != nil:
    section.add "key", valid_598542
  var valid_598543 = query.getOrDefault("prettyPrint")
  valid_598543 = validateParameter(valid_598543, JBool, required = false,
                                 default = newJBool(true))
  if valid_598543 != nil:
    section.add "prettyPrint", valid_598543
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

proc call*(call_598545: Call_AndroidpublisherEditsTracksUpdate_598531;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type.
  ## 
  let valid = call_598545.validator(path, query, header, formData, body)
  let scheme = call_598545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598545.url(scheme.get, call_598545.host, call_598545.base,
                         call_598545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598545, url, valid)

proc call*(call_598546: Call_AndroidpublisherEditsTracksUpdate_598531;
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
  var path_598547 = newJObject()
  var query_598548 = newJObject()
  var body_598549 = newJObject()
  add(query_598548, "fields", newJString(fields))
  add(path_598547, "packageName", newJString(packageName))
  add(query_598548, "quotaUser", newJString(quotaUser))
  add(query_598548, "alt", newJString(alt))
  add(path_598547, "editId", newJString(editId))
  add(query_598548, "oauth_token", newJString(oauthToken))
  add(query_598548, "userIp", newJString(userIp))
  add(query_598548, "key", newJString(key))
  if body != nil:
    body_598549 = body
  add(query_598548, "prettyPrint", newJBool(prettyPrint))
  add(path_598547, "track", newJString(track))
  result = call_598546.call(path_598547, query_598548, nil, nil, body_598549)

var androidpublisherEditsTracksUpdate* = Call_AndroidpublisherEditsTracksUpdate_598531(
    name: "androidpublisherEditsTracksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksUpdate_598532,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksUpdate_598533, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksGet_598514 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTracksGet_598516(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTracksGet_598515(path: JsonNode;
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
  var valid_598517 = path.getOrDefault("packageName")
  valid_598517 = validateParameter(valid_598517, JString, required = true,
                                 default = nil)
  if valid_598517 != nil:
    section.add "packageName", valid_598517
  var valid_598518 = path.getOrDefault("editId")
  valid_598518 = validateParameter(valid_598518, JString, required = true,
                                 default = nil)
  if valid_598518 != nil:
    section.add "editId", valid_598518
  var valid_598519 = path.getOrDefault("track")
  valid_598519 = validateParameter(valid_598519, JString, required = true,
                                 default = nil)
  if valid_598519 != nil:
    section.add "track", valid_598519
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
  var valid_598520 = query.getOrDefault("fields")
  valid_598520 = validateParameter(valid_598520, JString, required = false,
                                 default = nil)
  if valid_598520 != nil:
    section.add "fields", valid_598520
  var valid_598521 = query.getOrDefault("quotaUser")
  valid_598521 = validateParameter(valid_598521, JString, required = false,
                                 default = nil)
  if valid_598521 != nil:
    section.add "quotaUser", valid_598521
  var valid_598522 = query.getOrDefault("alt")
  valid_598522 = validateParameter(valid_598522, JString, required = false,
                                 default = newJString("json"))
  if valid_598522 != nil:
    section.add "alt", valid_598522
  var valid_598523 = query.getOrDefault("oauth_token")
  valid_598523 = validateParameter(valid_598523, JString, required = false,
                                 default = nil)
  if valid_598523 != nil:
    section.add "oauth_token", valid_598523
  var valid_598524 = query.getOrDefault("userIp")
  valid_598524 = validateParameter(valid_598524, JString, required = false,
                                 default = nil)
  if valid_598524 != nil:
    section.add "userIp", valid_598524
  var valid_598525 = query.getOrDefault("key")
  valid_598525 = validateParameter(valid_598525, JString, required = false,
                                 default = nil)
  if valid_598525 != nil:
    section.add "key", valid_598525
  var valid_598526 = query.getOrDefault("prettyPrint")
  valid_598526 = validateParameter(valid_598526, JBool, required = false,
                                 default = newJBool(true))
  if valid_598526 != nil:
    section.add "prettyPrint", valid_598526
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598527: Call_AndroidpublisherEditsTracksGet_598514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ## 
  let valid = call_598527.validator(path, query, header, formData, body)
  let scheme = call_598527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598527.url(scheme.get, call_598527.host, call_598527.base,
                         call_598527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598527, url, valid)

proc call*(call_598528: Call_AndroidpublisherEditsTracksGet_598514;
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
  var path_598529 = newJObject()
  var query_598530 = newJObject()
  add(query_598530, "fields", newJString(fields))
  add(path_598529, "packageName", newJString(packageName))
  add(query_598530, "quotaUser", newJString(quotaUser))
  add(query_598530, "alt", newJString(alt))
  add(path_598529, "editId", newJString(editId))
  add(query_598530, "oauth_token", newJString(oauthToken))
  add(query_598530, "userIp", newJString(userIp))
  add(query_598530, "key", newJString(key))
  add(query_598530, "prettyPrint", newJBool(prettyPrint))
  add(path_598529, "track", newJString(track))
  result = call_598528.call(path_598529, query_598530, nil, nil, nil)

var androidpublisherEditsTracksGet* = Call_AndroidpublisherEditsTracksGet_598514(
    name: "androidpublisherEditsTracksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksGet_598515,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksGet_598516, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksPatch_598550 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsTracksPatch_598552(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsTracksPatch_598551(path: JsonNode;
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
  var valid_598553 = path.getOrDefault("packageName")
  valid_598553 = validateParameter(valid_598553, JString, required = true,
                                 default = nil)
  if valid_598553 != nil:
    section.add "packageName", valid_598553
  var valid_598554 = path.getOrDefault("editId")
  valid_598554 = validateParameter(valid_598554, JString, required = true,
                                 default = nil)
  if valid_598554 != nil:
    section.add "editId", valid_598554
  var valid_598555 = path.getOrDefault("track")
  valid_598555 = validateParameter(valid_598555, JString, required = true,
                                 default = nil)
  if valid_598555 != nil:
    section.add "track", valid_598555
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
  var valid_598556 = query.getOrDefault("fields")
  valid_598556 = validateParameter(valid_598556, JString, required = false,
                                 default = nil)
  if valid_598556 != nil:
    section.add "fields", valid_598556
  var valid_598557 = query.getOrDefault("quotaUser")
  valid_598557 = validateParameter(valid_598557, JString, required = false,
                                 default = nil)
  if valid_598557 != nil:
    section.add "quotaUser", valid_598557
  var valid_598558 = query.getOrDefault("alt")
  valid_598558 = validateParameter(valid_598558, JString, required = false,
                                 default = newJString("json"))
  if valid_598558 != nil:
    section.add "alt", valid_598558
  var valid_598559 = query.getOrDefault("oauth_token")
  valid_598559 = validateParameter(valid_598559, JString, required = false,
                                 default = nil)
  if valid_598559 != nil:
    section.add "oauth_token", valid_598559
  var valid_598560 = query.getOrDefault("userIp")
  valid_598560 = validateParameter(valid_598560, JString, required = false,
                                 default = nil)
  if valid_598560 != nil:
    section.add "userIp", valid_598560
  var valid_598561 = query.getOrDefault("key")
  valid_598561 = validateParameter(valid_598561, JString, required = false,
                                 default = nil)
  if valid_598561 != nil:
    section.add "key", valid_598561
  var valid_598562 = query.getOrDefault("prettyPrint")
  valid_598562 = validateParameter(valid_598562, JBool, required = false,
                                 default = newJBool(true))
  if valid_598562 != nil:
    section.add "prettyPrint", valid_598562
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

proc call*(call_598564: Call_AndroidpublisherEditsTracksPatch_598550;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ## 
  let valid = call_598564.validator(path, query, header, formData, body)
  let scheme = call_598564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598564.url(scheme.get, call_598564.host, call_598564.base,
                         call_598564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598564, url, valid)

proc call*(call_598565: Call_AndroidpublisherEditsTracksPatch_598550;
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
  var path_598566 = newJObject()
  var query_598567 = newJObject()
  var body_598568 = newJObject()
  add(query_598567, "fields", newJString(fields))
  add(path_598566, "packageName", newJString(packageName))
  add(query_598567, "quotaUser", newJString(quotaUser))
  add(query_598567, "alt", newJString(alt))
  add(path_598566, "editId", newJString(editId))
  add(query_598567, "oauth_token", newJString(oauthToken))
  add(query_598567, "userIp", newJString(userIp))
  add(query_598567, "key", newJString(key))
  if body != nil:
    body_598568 = body
  add(query_598567, "prettyPrint", newJBool(prettyPrint))
  add(path_598566, "track", newJString(track))
  result = call_598565.call(path_598566, query_598567, nil, nil, body_598568)

var androidpublisherEditsTracksPatch* = Call_AndroidpublisherEditsTracksPatch_598550(
    name: "androidpublisherEditsTracksPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksPatch_598551,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsTracksPatch_598552, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsCommit_598569 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsCommit_598571(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsCommit_598570(path: JsonNode; query: JsonNode;
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
  var valid_598572 = path.getOrDefault("packageName")
  valid_598572 = validateParameter(valid_598572, JString, required = true,
                                 default = nil)
  if valid_598572 != nil:
    section.add "packageName", valid_598572
  var valid_598573 = path.getOrDefault("editId")
  valid_598573 = validateParameter(valid_598573, JString, required = true,
                                 default = nil)
  if valid_598573 != nil:
    section.add "editId", valid_598573
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
  var valid_598574 = query.getOrDefault("fields")
  valid_598574 = validateParameter(valid_598574, JString, required = false,
                                 default = nil)
  if valid_598574 != nil:
    section.add "fields", valid_598574
  var valid_598575 = query.getOrDefault("quotaUser")
  valid_598575 = validateParameter(valid_598575, JString, required = false,
                                 default = nil)
  if valid_598575 != nil:
    section.add "quotaUser", valid_598575
  var valid_598576 = query.getOrDefault("alt")
  valid_598576 = validateParameter(valid_598576, JString, required = false,
                                 default = newJString("json"))
  if valid_598576 != nil:
    section.add "alt", valid_598576
  var valid_598577 = query.getOrDefault("oauth_token")
  valid_598577 = validateParameter(valid_598577, JString, required = false,
                                 default = nil)
  if valid_598577 != nil:
    section.add "oauth_token", valid_598577
  var valid_598578 = query.getOrDefault("userIp")
  valid_598578 = validateParameter(valid_598578, JString, required = false,
                                 default = nil)
  if valid_598578 != nil:
    section.add "userIp", valid_598578
  var valid_598579 = query.getOrDefault("key")
  valid_598579 = validateParameter(valid_598579, JString, required = false,
                                 default = nil)
  if valid_598579 != nil:
    section.add "key", valid_598579
  var valid_598580 = query.getOrDefault("prettyPrint")
  valid_598580 = validateParameter(valid_598580, JBool, required = false,
                                 default = newJBool(true))
  if valid_598580 != nil:
    section.add "prettyPrint", valid_598580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598581: Call_AndroidpublisherEditsCommit_598569; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commits/applies the changes made in this edit back to the app.
  ## 
  let valid = call_598581.validator(path, query, header, formData, body)
  let scheme = call_598581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598581.url(scheme.get, call_598581.host, call_598581.base,
                         call_598581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598581, url, valid)

proc call*(call_598582: Call_AndroidpublisherEditsCommit_598569;
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
  var path_598583 = newJObject()
  var query_598584 = newJObject()
  add(query_598584, "fields", newJString(fields))
  add(path_598583, "packageName", newJString(packageName))
  add(query_598584, "quotaUser", newJString(quotaUser))
  add(query_598584, "alt", newJString(alt))
  add(path_598583, "editId", newJString(editId))
  add(query_598584, "oauth_token", newJString(oauthToken))
  add(query_598584, "userIp", newJString(userIp))
  add(query_598584, "key", newJString(key))
  add(query_598584, "prettyPrint", newJBool(prettyPrint))
  result = call_598582.call(path_598583, query_598584, nil, nil, nil)

var androidpublisherEditsCommit* = Call_AndroidpublisherEditsCommit_598569(
    name: "androidpublisherEditsCommit", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:commit",
    validator: validate_AndroidpublisherEditsCommit_598570,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsCommit_598571, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsValidate_598585 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherEditsValidate_598587(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherEditsValidate_598586(path: JsonNode; query: JsonNode;
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
  var valid_598588 = path.getOrDefault("packageName")
  valid_598588 = validateParameter(valid_598588, JString, required = true,
                                 default = nil)
  if valid_598588 != nil:
    section.add "packageName", valid_598588
  var valid_598589 = path.getOrDefault("editId")
  valid_598589 = validateParameter(valid_598589, JString, required = true,
                                 default = nil)
  if valid_598589 != nil:
    section.add "editId", valid_598589
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
  var valid_598590 = query.getOrDefault("fields")
  valid_598590 = validateParameter(valid_598590, JString, required = false,
                                 default = nil)
  if valid_598590 != nil:
    section.add "fields", valid_598590
  var valid_598591 = query.getOrDefault("quotaUser")
  valid_598591 = validateParameter(valid_598591, JString, required = false,
                                 default = nil)
  if valid_598591 != nil:
    section.add "quotaUser", valid_598591
  var valid_598592 = query.getOrDefault("alt")
  valid_598592 = validateParameter(valid_598592, JString, required = false,
                                 default = newJString("json"))
  if valid_598592 != nil:
    section.add "alt", valid_598592
  var valid_598593 = query.getOrDefault("oauth_token")
  valid_598593 = validateParameter(valid_598593, JString, required = false,
                                 default = nil)
  if valid_598593 != nil:
    section.add "oauth_token", valid_598593
  var valid_598594 = query.getOrDefault("userIp")
  valid_598594 = validateParameter(valid_598594, JString, required = false,
                                 default = nil)
  if valid_598594 != nil:
    section.add "userIp", valid_598594
  var valid_598595 = query.getOrDefault("key")
  valid_598595 = validateParameter(valid_598595, JString, required = false,
                                 default = nil)
  if valid_598595 != nil:
    section.add "key", valid_598595
  var valid_598596 = query.getOrDefault("prettyPrint")
  valid_598596 = validateParameter(valid_598596, JBool, required = false,
                                 default = newJBool(true))
  if valid_598596 != nil:
    section.add "prettyPrint", valid_598596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598597: Call_AndroidpublisherEditsValidate_598585; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ## 
  let valid = call_598597.validator(path, query, header, formData, body)
  let scheme = call_598597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598597.url(scheme.get, call_598597.host, call_598597.base,
                         call_598597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598597, url, valid)

proc call*(call_598598: Call_AndroidpublisherEditsValidate_598585;
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
  var path_598599 = newJObject()
  var query_598600 = newJObject()
  add(query_598600, "fields", newJString(fields))
  add(path_598599, "packageName", newJString(packageName))
  add(query_598600, "quotaUser", newJString(quotaUser))
  add(query_598600, "alt", newJString(alt))
  add(path_598599, "editId", newJString(editId))
  add(query_598600, "oauth_token", newJString(oauthToken))
  add(query_598600, "userIp", newJString(userIp))
  add(query_598600, "key", newJString(key))
  add(query_598600, "prettyPrint", newJBool(prettyPrint))
  result = call_598598.call(path_598599, query_598600, nil, nil, nil)

var androidpublisherEditsValidate* = Call_AndroidpublisherEditsValidate_598585(
    name: "androidpublisherEditsValidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:validate",
    validator: validate_AndroidpublisherEditsValidate_598586,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherEditsValidate_598587, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsInsert_598619 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsInsert_598621(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsInsert_598620(path: JsonNode;
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
  var valid_598622 = path.getOrDefault("packageName")
  valid_598622 = validateParameter(valid_598622, JString, required = true,
                                 default = nil)
  if valid_598622 != nil:
    section.add "packageName", valid_598622
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
  var valid_598623 = query.getOrDefault("fields")
  valid_598623 = validateParameter(valid_598623, JString, required = false,
                                 default = nil)
  if valid_598623 != nil:
    section.add "fields", valid_598623
  var valid_598624 = query.getOrDefault("quotaUser")
  valid_598624 = validateParameter(valid_598624, JString, required = false,
                                 default = nil)
  if valid_598624 != nil:
    section.add "quotaUser", valid_598624
  var valid_598625 = query.getOrDefault("alt")
  valid_598625 = validateParameter(valid_598625, JString, required = false,
                                 default = newJString("json"))
  if valid_598625 != nil:
    section.add "alt", valid_598625
  var valid_598626 = query.getOrDefault("oauth_token")
  valid_598626 = validateParameter(valid_598626, JString, required = false,
                                 default = nil)
  if valid_598626 != nil:
    section.add "oauth_token", valid_598626
  var valid_598627 = query.getOrDefault("userIp")
  valid_598627 = validateParameter(valid_598627, JString, required = false,
                                 default = nil)
  if valid_598627 != nil:
    section.add "userIp", valid_598627
  var valid_598628 = query.getOrDefault("key")
  valid_598628 = validateParameter(valid_598628, JString, required = false,
                                 default = nil)
  if valid_598628 != nil:
    section.add "key", valid_598628
  var valid_598629 = query.getOrDefault("autoConvertMissingPrices")
  valid_598629 = validateParameter(valid_598629, JBool, required = false, default = nil)
  if valid_598629 != nil:
    section.add "autoConvertMissingPrices", valid_598629
  var valid_598630 = query.getOrDefault("prettyPrint")
  valid_598630 = validateParameter(valid_598630, JBool, required = false,
                                 default = newJBool(true))
  if valid_598630 != nil:
    section.add "prettyPrint", valid_598630
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

proc call*(call_598632: Call_AndroidpublisherInappproductsInsert_598619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new in-app product for an app.
  ## 
  let valid = call_598632.validator(path, query, header, formData, body)
  let scheme = call_598632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598632.url(scheme.get, call_598632.host, call_598632.base,
                         call_598632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598632, url, valid)

proc call*(call_598633: Call_AndroidpublisherInappproductsInsert_598619;
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
  var path_598634 = newJObject()
  var query_598635 = newJObject()
  var body_598636 = newJObject()
  add(query_598635, "fields", newJString(fields))
  add(path_598634, "packageName", newJString(packageName))
  add(query_598635, "quotaUser", newJString(quotaUser))
  add(query_598635, "alt", newJString(alt))
  add(query_598635, "oauth_token", newJString(oauthToken))
  add(query_598635, "userIp", newJString(userIp))
  add(query_598635, "key", newJString(key))
  add(query_598635, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_598636 = body
  add(query_598635, "prettyPrint", newJBool(prettyPrint))
  result = call_598633.call(path_598634, query_598635, nil, nil, body_598636)

var androidpublisherInappproductsInsert* = Call_AndroidpublisherInappproductsInsert_598619(
    name: "androidpublisherInappproductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsInsert_598620,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsInsert_598621, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsList_598601 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsList_598603(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsList_598602(path: JsonNode;
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
  var valid_598604 = path.getOrDefault("packageName")
  valid_598604 = validateParameter(valid_598604, JString, required = true,
                                 default = nil)
  if valid_598604 != nil:
    section.add "packageName", valid_598604
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
  var valid_598605 = query.getOrDefault("token")
  valid_598605 = validateParameter(valid_598605, JString, required = false,
                                 default = nil)
  if valid_598605 != nil:
    section.add "token", valid_598605
  var valid_598606 = query.getOrDefault("fields")
  valid_598606 = validateParameter(valid_598606, JString, required = false,
                                 default = nil)
  if valid_598606 != nil:
    section.add "fields", valid_598606
  var valid_598607 = query.getOrDefault("quotaUser")
  valid_598607 = validateParameter(valid_598607, JString, required = false,
                                 default = nil)
  if valid_598607 != nil:
    section.add "quotaUser", valid_598607
  var valid_598608 = query.getOrDefault("alt")
  valid_598608 = validateParameter(valid_598608, JString, required = false,
                                 default = newJString("json"))
  if valid_598608 != nil:
    section.add "alt", valid_598608
  var valid_598609 = query.getOrDefault("oauth_token")
  valid_598609 = validateParameter(valid_598609, JString, required = false,
                                 default = nil)
  if valid_598609 != nil:
    section.add "oauth_token", valid_598609
  var valid_598610 = query.getOrDefault("userIp")
  valid_598610 = validateParameter(valid_598610, JString, required = false,
                                 default = nil)
  if valid_598610 != nil:
    section.add "userIp", valid_598610
  var valid_598611 = query.getOrDefault("maxResults")
  valid_598611 = validateParameter(valid_598611, JInt, required = false, default = nil)
  if valid_598611 != nil:
    section.add "maxResults", valid_598611
  var valid_598612 = query.getOrDefault("key")
  valid_598612 = validateParameter(valid_598612, JString, required = false,
                                 default = nil)
  if valid_598612 != nil:
    section.add "key", valid_598612
  var valid_598613 = query.getOrDefault("prettyPrint")
  valid_598613 = validateParameter(valid_598613, JBool, required = false,
                                 default = newJBool(true))
  if valid_598613 != nil:
    section.add "prettyPrint", valid_598613
  var valid_598614 = query.getOrDefault("startIndex")
  valid_598614 = validateParameter(valid_598614, JInt, required = false, default = nil)
  if valid_598614 != nil:
    section.add "startIndex", valid_598614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598615: Call_AndroidpublisherInappproductsList_598601;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ## 
  let valid = call_598615.validator(path, query, header, formData, body)
  let scheme = call_598615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598615.url(scheme.get, call_598615.host, call_598615.base,
                         call_598615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598615, url, valid)

proc call*(call_598616: Call_AndroidpublisherInappproductsList_598601;
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
  var path_598617 = newJObject()
  var query_598618 = newJObject()
  add(query_598618, "token", newJString(token))
  add(query_598618, "fields", newJString(fields))
  add(path_598617, "packageName", newJString(packageName))
  add(query_598618, "quotaUser", newJString(quotaUser))
  add(query_598618, "alt", newJString(alt))
  add(query_598618, "oauth_token", newJString(oauthToken))
  add(query_598618, "userIp", newJString(userIp))
  add(query_598618, "maxResults", newJInt(maxResults))
  add(query_598618, "key", newJString(key))
  add(query_598618, "prettyPrint", newJBool(prettyPrint))
  add(query_598618, "startIndex", newJInt(startIndex))
  result = call_598616.call(path_598617, query_598618, nil, nil, nil)

var androidpublisherInappproductsList* = Call_AndroidpublisherInappproductsList_598601(
    name: "androidpublisherInappproductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsList_598602,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsList_598603, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsUpdate_598653 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsUpdate_598655(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsUpdate_598654(path: JsonNode;
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
  var valid_598656 = path.getOrDefault("packageName")
  valid_598656 = validateParameter(valid_598656, JString, required = true,
                                 default = nil)
  if valid_598656 != nil:
    section.add "packageName", valid_598656
  var valid_598657 = path.getOrDefault("sku")
  valid_598657 = validateParameter(valid_598657, JString, required = true,
                                 default = nil)
  if valid_598657 != nil:
    section.add "sku", valid_598657
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
  var valid_598658 = query.getOrDefault("fields")
  valid_598658 = validateParameter(valid_598658, JString, required = false,
                                 default = nil)
  if valid_598658 != nil:
    section.add "fields", valid_598658
  var valid_598659 = query.getOrDefault("quotaUser")
  valid_598659 = validateParameter(valid_598659, JString, required = false,
                                 default = nil)
  if valid_598659 != nil:
    section.add "quotaUser", valid_598659
  var valid_598660 = query.getOrDefault("alt")
  valid_598660 = validateParameter(valid_598660, JString, required = false,
                                 default = newJString("json"))
  if valid_598660 != nil:
    section.add "alt", valid_598660
  var valid_598661 = query.getOrDefault("oauth_token")
  valid_598661 = validateParameter(valid_598661, JString, required = false,
                                 default = nil)
  if valid_598661 != nil:
    section.add "oauth_token", valid_598661
  var valid_598662 = query.getOrDefault("userIp")
  valid_598662 = validateParameter(valid_598662, JString, required = false,
                                 default = nil)
  if valid_598662 != nil:
    section.add "userIp", valid_598662
  var valid_598663 = query.getOrDefault("key")
  valid_598663 = validateParameter(valid_598663, JString, required = false,
                                 default = nil)
  if valid_598663 != nil:
    section.add "key", valid_598663
  var valid_598664 = query.getOrDefault("autoConvertMissingPrices")
  valid_598664 = validateParameter(valid_598664, JBool, required = false, default = nil)
  if valid_598664 != nil:
    section.add "autoConvertMissingPrices", valid_598664
  var valid_598665 = query.getOrDefault("prettyPrint")
  valid_598665 = validateParameter(valid_598665, JBool, required = false,
                                 default = newJBool(true))
  if valid_598665 != nil:
    section.add "prettyPrint", valid_598665
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

proc call*(call_598667: Call_AndroidpublisherInappproductsUpdate_598653;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product.
  ## 
  let valid = call_598667.validator(path, query, header, formData, body)
  let scheme = call_598667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598667.url(scheme.get, call_598667.host, call_598667.base,
                         call_598667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598667, url, valid)

proc call*(call_598668: Call_AndroidpublisherInappproductsUpdate_598653;
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
  var path_598669 = newJObject()
  var query_598670 = newJObject()
  var body_598671 = newJObject()
  add(query_598670, "fields", newJString(fields))
  add(path_598669, "packageName", newJString(packageName))
  add(query_598670, "quotaUser", newJString(quotaUser))
  add(query_598670, "alt", newJString(alt))
  add(query_598670, "oauth_token", newJString(oauthToken))
  add(query_598670, "userIp", newJString(userIp))
  add(path_598669, "sku", newJString(sku))
  add(query_598670, "key", newJString(key))
  add(query_598670, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_598671 = body
  add(query_598670, "prettyPrint", newJBool(prettyPrint))
  result = call_598668.call(path_598669, query_598670, nil, nil, body_598671)

var androidpublisherInappproductsUpdate* = Call_AndroidpublisherInappproductsUpdate_598653(
    name: "androidpublisherInappproductsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsUpdate_598654,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsUpdate_598655, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsGet_598637 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsGet_598639(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsGet_598638(path: JsonNode;
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
  var valid_598640 = path.getOrDefault("packageName")
  valid_598640 = validateParameter(valid_598640, JString, required = true,
                                 default = nil)
  if valid_598640 != nil:
    section.add "packageName", valid_598640
  var valid_598641 = path.getOrDefault("sku")
  valid_598641 = validateParameter(valid_598641, JString, required = true,
                                 default = nil)
  if valid_598641 != nil:
    section.add "sku", valid_598641
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
  var valid_598642 = query.getOrDefault("fields")
  valid_598642 = validateParameter(valid_598642, JString, required = false,
                                 default = nil)
  if valid_598642 != nil:
    section.add "fields", valid_598642
  var valid_598643 = query.getOrDefault("quotaUser")
  valid_598643 = validateParameter(valid_598643, JString, required = false,
                                 default = nil)
  if valid_598643 != nil:
    section.add "quotaUser", valid_598643
  var valid_598644 = query.getOrDefault("alt")
  valid_598644 = validateParameter(valid_598644, JString, required = false,
                                 default = newJString("json"))
  if valid_598644 != nil:
    section.add "alt", valid_598644
  var valid_598645 = query.getOrDefault("oauth_token")
  valid_598645 = validateParameter(valid_598645, JString, required = false,
                                 default = nil)
  if valid_598645 != nil:
    section.add "oauth_token", valid_598645
  var valid_598646 = query.getOrDefault("userIp")
  valid_598646 = validateParameter(valid_598646, JString, required = false,
                                 default = nil)
  if valid_598646 != nil:
    section.add "userIp", valid_598646
  var valid_598647 = query.getOrDefault("key")
  valid_598647 = validateParameter(valid_598647, JString, required = false,
                                 default = nil)
  if valid_598647 != nil:
    section.add "key", valid_598647
  var valid_598648 = query.getOrDefault("prettyPrint")
  valid_598648 = validateParameter(valid_598648, JBool, required = false,
                                 default = newJBool(true))
  if valid_598648 != nil:
    section.add "prettyPrint", valid_598648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598649: Call_AndroidpublisherInappproductsGet_598637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the in-app product specified.
  ## 
  let valid = call_598649.validator(path, query, header, formData, body)
  let scheme = call_598649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598649.url(scheme.get, call_598649.host, call_598649.base,
                         call_598649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598649, url, valid)

proc call*(call_598650: Call_AndroidpublisherInappproductsGet_598637;
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
  var path_598651 = newJObject()
  var query_598652 = newJObject()
  add(query_598652, "fields", newJString(fields))
  add(path_598651, "packageName", newJString(packageName))
  add(query_598652, "quotaUser", newJString(quotaUser))
  add(query_598652, "alt", newJString(alt))
  add(query_598652, "oauth_token", newJString(oauthToken))
  add(query_598652, "userIp", newJString(userIp))
  add(path_598651, "sku", newJString(sku))
  add(query_598652, "key", newJString(key))
  add(query_598652, "prettyPrint", newJBool(prettyPrint))
  result = call_598650.call(path_598651, query_598652, nil, nil, nil)

var androidpublisherInappproductsGet* = Call_AndroidpublisherInappproductsGet_598637(
    name: "androidpublisherInappproductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsGet_598638,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsGet_598639, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsPatch_598688 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsPatch_598690(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsPatch_598689(path: JsonNode;
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
  var valid_598691 = path.getOrDefault("packageName")
  valid_598691 = validateParameter(valid_598691, JString, required = true,
                                 default = nil)
  if valid_598691 != nil:
    section.add "packageName", valid_598691
  var valid_598692 = path.getOrDefault("sku")
  valid_598692 = validateParameter(valid_598692, JString, required = true,
                                 default = nil)
  if valid_598692 != nil:
    section.add "sku", valid_598692
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
  var valid_598693 = query.getOrDefault("fields")
  valid_598693 = validateParameter(valid_598693, JString, required = false,
                                 default = nil)
  if valid_598693 != nil:
    section.add "fields", valid_598693
  var valid_598694 = query.getOrDefault("quotaUser")
  valid_598694 = validateParameter(valid_598694, JString, required = false,
                                 default = nil)
  if valid_598694 != nil:
    section.add "quotaUser", valid_598694
  var valid_598695 = query.getOrDefault("alt")
  valid_598695 = validateParameter(valid_598695, JString, required = false,
                                 default = newJString("json"))
  if valid_598695 != nil:
    section.add "alt", valid_598695
  var valid_598696 = query.getOrDefault("oauth_token")
  valid_598696 = validateParameter(valid_598696, JString, required = false,
                                 default = nil)
  if valid_598696 != nil:
    section.add "oauth_token", valid_598696
  var valid_598697 = query.getOrDefault("userIp")
  valid_598697 = validateParameter(valid_598697, JString, required = false,
                                 default = nil)
  if valid_598697 != nil:
    section.add "userIp", valid_598697
  var valid_598698 = query.getOrDefault("key")
  valid_598698 = validateParameter(valid_598698, JString, required = false,
                                 default = nil)
  if valid_598698 != nil:
    section.add "key", valid_598698
  var valid_598699 = query.getOrDefault("autoConvertMissingPrices")
  valid_598699 = validateParameter(valid_598699, JBool, required = false, default = nil)
  if valid_598699 != nil:
    section.add "autoConvertMissingPrices", valid_598699
  var valid_598700 = query.getOrDefault("prettyPrint")
  valid_598700 = validateParameter(valid_598700, JBool, required = false,
                                 default = newJBool(true))
  if valid_598700 != nil:
    section.add "prettyPrint", valid_598700
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

proc call*(call_598702: Call_AndroidpublisherInappproductsPatch_598688;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product. This method supports patch semantics.
  ## 
  let valid = call_598702.validator(path, query, header, formData, body)
  let scheme = call_598702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598702.url(scheme.get, call_598702.host, call_598702.base,
                         call_598702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598702, url, valid)

proc call*(call_598703: Call_AndroidpublisherInappproductsPatch_598688;
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
  var path_598704 = newJObject()
  var query_598705 = newJObject()
  var body_598706 = newJObject()
  add(query_598705, "fields", newJString(fields))
  add(path_598704, "packageName", newJString(packageName))
  add(query_598705, "quotaUser", newJString(quotaUser))
  add(query_598705, "alt", newJString(alt))
  add(query_598705, "oauth_token", newJString(oauthToken))
  add(query_598705, "userIp", newJString(userIp))
  add(path_598704, "sku", newJString(sku))
  add(query_598705, "key", newJString(key))
  add(query_598705, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_598706 = body
  add(query_598705, "prettyPrint", newJBool(prettyPrint))
  result = call_598703.call(path_598704, query_598705, nil, nil, body_598706)

var androidpublisherInappproductsPatch* = Call_AndroidpublisherInappproductsPatch_598688(
    name: "androidpublisherInappproductsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsPatch_598689,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsPatch_598690, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsDelete_598672 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherInappproductsDelete_598674(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherInappproductsDelete_598673(path: JsonNode;
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
  var valid_598675 = path.getOrDefault("packageName")
  valid_598675 = validateParameter(valid_598675, JString, required = true,
                                 default = nil)
  if valid_598675 != nil:
    section.add "packageName", valid_598675
  var valid_598676 = path.getOrDefault("sku")
  valid_598676 = validateParameter(valid_598676, JString, required = true,
                                 default = nil)
  if valid_598676 != nil:
    section.add "sku", valid_598676
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
  var valid_598677 = query.getOrDefault("fields")
  valid_598677 = validateParameter(valid_598677, JString, required = false,
                                 default = nil)
  if valid_598677 != nil:
    section.add "fields", valid_598677
  var valid_598678 = query.getOrDefault("quotaUser")
  valid_598678 = validateParameter(valid_598678, JString, required = false,
                                 default = nil)
  if valid_598678 != nil:
    section.add "quotaUser", valid_598678
  var valid_598679 = query.getOrDefault("alt")
  valid_598679 = validateParameter(valid_598679, JString, required = false,
                                 default = newJString("json"))
  if valid_598679 != nil:
    section.add "alt", valid_598679
  var valid_598680 = query.getOrDefault("oauth_token")
  valid_598680 = validateParameter(valid_598680, JString, required = false,
                                 default = nil)
  if valid_598680 != nil:
    section.add "oauth_token", valid_598680
  var valid_598681 = query.getOrDefault("userIp")
  valid_598681 = validateParameter(valid_598681, JString, required = false,
                                 default = nil)
  if valid_598681 != nil:
    section.add "userIp", valid_598681
  var valid_598682 = query.getOrDefault("key")
  valid_598682 = validateParameter(valid_598682, JString, required = false,
                                 default = nil)
  if valid_598682 != nil:
    section.add "key", valid_598682
  var valid_598683 = query.getOrDefault("prettyPrint")
  valid_598683 = validateParameter(valid_598683, JBool, required = false,
                                 default = newJBool(true))
  if valid_598683 != nil:
    section.add "prettyPrint", valid_598683
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598684: Call_AndroidpublisherInappproductsDelete_598672;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an in-app product for an app.
  ## 
  let valid = call_598684.validator(path, query, header, formData, body)
  let scheme = call_598684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598684.url(scheme.get, call_598684.host, call_598684.base,
                         call_598684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598684, url, valid)

proc call*(call_598685: Call_AndroidpublisherInappproductsDelete_598672;
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
  var path_598686 = newJObject()
  var query_598687 = newJObject()
  add(query_598687, "fields", newJString(fields))
  add(path_598686, "packageName", newJString(packageName))
  add(query_598687, "quotaUser", newJString(quotaUser))
  add(query_598687, "alt", newJString(alt))
  add(query_598687, "oauth_token", newJString(oauthToken))
  add(query_598687, "userIp", newJString(userIp))
  add(path_598686, "sku", newJString(sku))
  add(query_598687, "key", newJString(key))
  add(query_598687, "prettyPrint", newJBool(prettyPrint))
  result = call_598685.call(path_598686, query_598687, nil, nil, nil)

var androidpublisherInappproductsDelete* = Call_AndroidpublisherInappproductsDelete_598672(
    name: "androidpublisherInappproductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsDelete_598673,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherInappproductsDelete_598674, schemes: {Scheme.Https})
type
  Call_AndroidpublisherOrdersRefund_598707 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherOrdersRefund_598709(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherOrdersRefund_598708(path: JsonNode; query: JsonNode;
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
  var valid_598710 = path.getOrDefault("packageName")
  valid_598710 = validateParameter(valid_598710, JString, required = true,
                                 default = nil)
  if valid_598710 != nil:
    section.add "packageName", valid_598710
  var valid_598711 = path.getOrDefault("orderId")
  valid_598711 = validateParameter(valid_598711, JString, required = true,
                                 default = nil)
  if valid_598711 != nil:
    section.add "orderId", valid_598711
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
  var valid_598712 = query.getOrDefault("fields")
  valid_598712 = validateParameter(valid_598712, JString, required = false,
                                 default = nil)
  if valid_598712 != nil:
    section.add "fields", valid_598712
  var valid_598713 = query.getOrDefault("quotaUser")
  valid_598713 = validateParameter(valid_598713, JString, required = false,
                                 default = nil)
  if valid_598713 != nil:
    section.add "quotaUser", valid_598713
  var valid_598714 = query.getOrDefault("alt")
  valid_598714 = validateParameter(valid_598714, JString, required = false,
                                 default = newJString("json"))
  if valid_598714 != nil:
    section.add "alt", valid_598714
  var valid_598715 = query.getOrDefault("oauth_token")
  valid_598715 = validateParameter(valid_598715, JString, required = false,
                                 default = nil)
  if valid_598715 != nil:
    section.add "oauth_token", valid_598715
  var valid_598716 = query.getOrDefault("userIp")
  valid_598716 = validateParameter(valid_598716, JString, required = false,
                                 default = nil)
  if valid_598716 != nil:
    section.add "userIp", valid_598716
  var valid_598717 = query.getOrDefault("key")
  valid_598717 = validateParameter(valid_598717, JString, required = false,
                                 default = nil)
  if valid_598717 != nil:
    section.add "key", valid_598717
  var valid_598718 = query.getOrDefault("revoke")
  valid_598718 = validateParameter(valid_598718, JBool, required = false, default = nil)
  if valid_598718 != nil:
    section.add "revoke", valid_598718
  var valid_598719 = query.getOrDefault("prettyPrint")
  valid_598719 = validateParameter(valid_598719, JBool, required = false,
                                 default = newJBool(true))
  if valid_598719 != nil:
    section.add "prettyPrint", valid_598719
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598720: Call_AndroidpublisherOrdersRefund_598707; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refund a user's subscription or in-app purchase order.
  ## 
  let valid = call_598720.validator(path, query, header, formData, body)
  let scheme = call_598720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598720.url(scheme.get, call_598720.host, call_598720.base,
                         call_598720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598720, url, valid)

proc call*(call_598721: Call_AndroidpublisherOrdersRefund_598707;
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
  var path_598722 = newJObject()
  var query_598723 = newJObject()
  add(query_598723, "fields", newJString(fields))
  add(path_598722, "packageName", newJString(packageName))
  add(query_598723, "quotaUser", newJString(quotaUser))
  add(query_598723, "alt", newJString(alt))
  add(query_598723, "oauth_token", newJString(oauthToken))
  add(query_598723, "userIp", newJString(userIp))
  add(path_598722, "orderId", newJString(orderId))
  add(query_598723, "key", newJString(key))
  add(query_598723, "revoke", newJBool(revoke))
  add(query_598723, "prettyPrint", newJBool(prettyPrint))
  result = call_598721.call(path_598722, query_598723, nil, nil, nil)

var androidpublisherOrdersRefund* = Call_AndroidpublisherOrdersRefund_598707(
    name: "androidpublisherOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/orders/{orderId}:refund",
    validator: validate_AndroidpublisherOrdersRefund_598708,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherOrdersRefund_598709, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsGet_598724 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesProductsGet_598726(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesProductsGet_598725(path: JsonNode;
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
  var valid_598727 = path.getOrDefault("packageName")
  valid_598727 = validateParameter(valid_598727, JString, required = true,
                                 default = nil)
  if valid_598727 != nil:
    section.add "packageName", valid_598727
  var valid_598728 = path.getOrDefault("token")
  valid_598728 = validateParameter(valid_598728, JString, required = true,
                                 default = nil)
  if valid_598728 != nil:
    section.add "token", valid_598728
  var valid_598729 = path.getOrDefault("productId")
  valid_598729 = validateParameter(valid_598729, JString, required = true,
                                 default = nil)
  if valid_598729 != nil:
    section.add "productId", valid_598729
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
  var valid_598730 = query.getOrDefault("fields")
  valid_598730 = validateParameter(valid_598730, JString, required = false,
                                 default = nil)
  if valid_598730 != nil:
    section.add "fields", valid_598730
  var valid_598731 = query.getOrDefault("quotaUser")
  valid_598731 = validateParameter(valid_598731, JString, required = false,
                                 default = nil)
  if valid_598731 != nil:
    section.add "quotaUser", valid_598731
  var valid_598732 = query.getOrDefault("alt")
  valid_598732 = validateParameter(valid_598732, JString, required = false,
                                 default = newJString("json"))
  if valid_598732 != nil:
    section.add "alt", valid_598732
  var valid_598733 = query.getOrDefault("oauth_token")
  valid_598733 = validateParameter(valid_598733, JString, required = false,
                                 default = nil)
  if valid_598733 != nil:
    section.add "oauth_token", valid_598733
  var valid_598734 = query.getOrDefault("userIp")
  valid_598734 = validateParameter(valid_598734, JString, required = false,
                                 default = nil)
  if valid_598734 != nil:
    section.add "userIp", valid_598734
  var valid_598735 = query.getOrDefault("key")
  valid_598735 = validateParameter(valid_598735, JString, required = false,
                                 default = nil)
  if valid_598735 != nil:
    section.add "key", valid_598735
  var valid_598736 = query.getOrDefault("prettyPrint")
  valid_598736 = validateParameter(valid_598736, JBool, required = false,
                                 default = newJBool(true))
  if valid_598736 != nil:
    section.add "prettyPrint", valid_598736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598737: Call_AndroidpublisherPurchasesProductsGet_598724;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  let valid = call_598737.validator(path, query, header, formData, body)
  let scheme = call_598737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598737.url(scheme.get, call_598737.host, call_598737.base,
                         call_598737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598737, url, valid)

proc call*(call_598738: Call_AndroidpublisherPurchasesProductsGet_598724;
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
  var path_598739 = newJObject()
  var query_598740 = newJObject()
  add(query_598740, "fields", newJString(fields))
  add(path_598739, "packageName", newJString(packageName))
  add(query_598740, "quotaUser", newJString(quotaUser))
  add(query_598740, "alt", newJString(alt))
  add(query_598740, "oauth_token", newJString(oauthToken))
  add(query_598740, "userIp", newJString(userIp))
  add(query_598740, "key", newJString(key))
  add(path_598739, "token", newJString(token))
  add(path_598739, "productId", newJString(productId))
  add(query_598740, "prettyPrint", newJBool(prettyPrint))
  result = call_598738.call(path_598739, query_598740, nil, nil, nil)

var androidpublisherPurchasesProductsGet* = Call_AndroidpublisherPurchasesProductsGet_598724(
    name: "androidpublisherPurchasesProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/purchases/products/{productId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesProductsGet_598725,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesProductsGet_598726, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsAcknowledge_598741 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesProductsAcknowledge_598743(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesProductsAcknowledge_598742(path: JsonNode;
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
  var valid_598744 = path.getOrDefault("packageName")
  valid_598744 = validateParameter(valid_598744, JString, required = true,
                                 default = nil)
  if valid_598744 != nil:
    section.add "packageName", valid_598744
  var valid_598745 = path.getOrDefault("token")
  valid_598745 = validateParameter(valid_598745, JString, required = true,
                                 default = nil)
  if valid_598745 != nil:
    section.add "token", valid_598745
  var valid_598746 = path.getOrDefault("productId")
  valid_598746 = validateParameter(valid_598746, JString, required = true,
                                 default = nil)
  if valid_598746 != nil:
    section.add "productId", valid_598746
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
  var valid_598747 = query.getOrDefault("fields")
  valid_598747 = validateParameter(valid_598747, JString, required = false,
                                 default = nil)
  if valid_598747 != nil:
    section.add "fields", valid_598747
  var valid_598748 = query.getOrDefault("quotaUser")
  valid_598748 = validateParameter(valid_598748, JString, required = false,
                                 default = nil)
  if valid_598748 != nil:
    section.add "quotaUser", valid_598748
  var valid_598749 = query.getOrDefault("alt")
  valid_598749 = validateParameter(valid_598749, JString, required = false,
                                 default = newJString("json"))
  if valid_598749 != nil:
    section.add "alt", valid_598749
  var valid_598750 = query.getOrDefault("oauth_token")
  valid_598750 = validateParameter(valid_598750, JString, required = false,
                                 default = nil)
  if valid_598750 != nil:
    section.add "oauth_token", valid_598750
  var valid_598751 = query.getOrDefault("userIp")
  valid_598751 = validateParameter(valid_598751, JString, required = false,
                                 default = nil)
  if valid_598751 != nil:
    section.add "userIp", valid_598751
  var valid_598752 = query.getOrDefault("key")
  valid_598752 = validateParameter(valid_598752, JString, required = false,
                                 default = nil)
  if valid_598752 != nil:
    section.add "key", valid_598752
  var valid_598753 = query.getOrDefault("prettyPrint")
  valid_598753 = validateParameter(valid_598753, JBool, required = false,
                                 default = newJBool(true))
  if valid_598753 != nil:
    section.add "prettyPrint", valid_598753
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

proc call*(call_598755: Call_AndroidpublisherPurchasesProductsAcknowledge_598741;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges a purchase of an inapp item.
  ## 
  let valid = call_598755.validator(path, query, header, formData, body)
  let scheme = call_598755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598755.url(scheme.get, call_598755.host, call_598755.base,
                         call_598755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598755, url, valid)

proc call*(call_598756: Call_AndroidpublisherPurchasesProductsAcknowledge_598741;
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
  var path_598757 = newJObject()
  var query_598758 = newJObject()
  var body_598759 = newJObject()
  add(query_598758, "fields", newJString(fields))
  add(path_598757, "packageName", newJString(packageName))
  add(query_598758, "quotaUser", newJString(quotaUser))
  add(query_598758, "alt", newJString(alt))
  add(query_598758, "oauth_token", newJString(oauthToken))
  add(query_598758, "userIp", newJString(userIp))
  add(query_598758, "key", newJString(key))
  add(path_598757, "token", newJString(token))
  if body != nil:
    body_598759 = body
  add(query_598758, "prettyPrint", newJBool(prettyPrint))
  add(path_598757, "productId", newJString(productId))
  result = call_598756.call(path_598757, query_598758, nil, nil, body_598759)

var androidpublisherPurchasesProductsAcknowledge* = Call_AndroidpublisherPurchasesProductsAcknowledge_598741(
    name: "androidpublisherPurchasesProductsAcknowledge",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/products/{productId}/tokens/{token}:acknowledge",
    validator: validate_AndroidpublisherPurchasesProductsAcknowledge_598742,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesProductsAcknowledge_598743,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsGet_598760 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesSubscriptionsGet_598762(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesSubscriptionsGet_598761(path: JsonNode;
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
  var valid_598763 = path.getOrDefault("packageName")
  valid_598763 = validateParameter(valid_598763, JString, required = true,
                                 default = nil)
  if valid_598763 != nil:
    section.add "packageName", valid_598763
  var valid_598764 = path.getOrDefault("subscriptionId")
  valid_598764 = validateParameter(valid_598764, JString, required = true,
                                 default = nil)
  if valid_598764 != nil:
    section.add "subscriptionId", valid_598764
  var valid_598765 = path.getOrDefault("token")
  valid_598765 = validateParameter(valid_598765, JString, required = true,
                                 default = nil)
  if valid_598765 != nil:
    section.add "token", valid_598765
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
  var valid_598766 = query.getOrDefault("fields")
  valid_598766 = validateParameter(valid_598766, JString, required = false,
                                 default = nil)
  if valid_598766 != nil:
    section.add "fields", valid_598766
  var valid_598767 = query.getOrDefault("quotaUser")
  valid_598767 = validateParameter(valid_598767, JString, required = false,
                                 default = nil)
  if valid_598767 != nil:
    section.add "quotaUser", valid_598767
  var valid_598768 = query.getOrDefault("alt")
  valid_598768 = validateParameter(valid_598768, JString, required = false,
                                 default = newJString("json"))
  if valid_598768 != nil:
    section.add "alt", valid_598768
  var valid_598769 = query.getOrDefault("oauth_token")
  valid_598769 = validateParameter(valid_598769, JString, required = false,
                                 default = nil)
  if valid_598769 != nil:
    section.add "oauth_token", valid_598769
  var valid_598770 = query.getOrDefault("userIp")
  valid_598770 = validateParameter(valid_598770, JString, required = false,
                                 default = nil)
  if valid_598770 != nil:
    section.add "userIp", valid_598770
  var valid_598771 = query.getOrDefault("key")
  valid_598771 = validateParameter(valid_598771, JString, required = false,
                                 default = nil)
  if valid_598771 != nil:
    section.add "key", valid_598771
  var valid_598772 = query.getOrDefault("prettyPrint")
  valid_598772 = validateParameter(valid_598772, JBool, required = false,
                                 default = newJBool(true))
  if valid_598772 != nil:
    section.add "prettyPrint", valid_598772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598773: Call_AndroidpublisherPurchasesSubscriptionsGet_598760;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_598773.validator(path, query, header, formData, body)
  let scheme = call_598773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598773.url(scheme.get, call_598773.host, call_598773.base,
                         call_598773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598773, url, valid)

proc call*(call_598774: Call_AndroidpublisherPurchasesSubscriptionsGet_598760;
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
  var path_598775 = newJObject()
  var query_598776 = newJObject()
  add(query_598776, "fields", newJString(fields))
  add(path_598775, "packageName", newJString(packageName))
  add(query_598776, "quotaUser", newJString(quotaUser))
  add(query_598776, "alt", newJString(alt))
  add(path_598775, "subscriptionId", newJString(subscriptionId))
  add(query_598776, "oauth_token", newJString(oauthToken))
  add(query_598776, "userIp", newJString(userIp))
  add(query_598776, "key", newJString(key))
  add(path_598775, "token", newJString(token))
  add(query_598776, "prettyPrint", newJBool(prettyPrint))
  result = call_598774.call(path_598775, query_598776, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsGet* = Call_AndroidpublisherPurchasesSubscriptionsGet_598760(
    name: "androidpublisherPurchasesSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesSubscriptionsGet_598761,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsGet_598762,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_598777 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesSubscriptionsAcknowledge_598779(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesSubscriptionsAcknowledge_598778(
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
  var valid_598780 = path.getOrDefault("packageName")
  valid_598780 = validateParameter(valid_598780, JString, required = true,
                                 default = nil)
  if valid_598780 != nil:
    section.add "packageName", valid_598780
  var valid_598781 = path.getOrDefault("subscriptionId")
  valid_598781 = validateParameter(valid_598781, JString, required = true,
                                 default = nil)
  if valid_598781 != nil:
    section.add "subscriptionId", valid_598781
  var valid_598782 = path.getOrDefault("token")
  valid_598782 = validateParameter(valid_598782, JString, required = true,
                                 default = nil)
  if valid_598782 != nil:
    section.add "token", valid_598782
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
  var valid_598783 = query.getOrDefault("fields")
  valid_598783 = validateParameter(valid_598783, JString, required = false,
                                 default = nil)
  if valid_598783 != nil:
    section.add "fields", valid_598783
  var valid_598784 = query.getOrDefault("quotaUser")
  valid_598784 = validateParameter(valid_598784, JString, required = false,
                                 default = nil)
  if valid_598784 != nil:
    section.add "quotaUser", valid_598784
  var valid_598785 = query.getOrDefault("alt")
  valid_598785 = validateParameter(valid_598785, JString, required = false,
                                 default = newJString("json"))
  if valid_598785 != nil:
    section.add "alt", valid_598785
  var valid_598786 = query.getOrDefault("oauth_token")
  valid_598786 = validateParameter(valid_598786, JString, required = false,
                                 default = nil)
  if valid_598786 != nil:
    section.add "oauth_token", valid_598786
  var valid_598787 = query.getOrDefault("userIp")
  valid_598787 = validateParameter(valid_598787, JString, required = false,
                                 default = nil)
  if valid_598787 != nil:
    section.add "userIp", valid_598787
  var valid_598788 = query.getOrDefault("key")
  valid_598788 = validateParameter(valid_598788, JString, required = false,
                                 default = nil)
  if valid_598788 != nil:
    section.add "key", valid_598788
  var valid_598789 = query.getOrDefault("prettyPrint")
  valid_598789 = validateParameter(valid_598789, JBool, required = false,
                                 default = newJBool(true))
  if valid_598789 != nil:
    section.add "prettyPrint", valid_598789
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

proc call*(call_598791: Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_598777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges a subscription purchase.
  ## 
  let valid = call_598791.validator(path, query, header, formData, body)
  let scheme = call_598791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598791.url(scheme.get, call_598791.host, call_598791.base,
                         call_598791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598791, url, valid)

proc call*(call_598792: Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_598777;
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
  var path_598793 = newJObject()
  var query_598794 = newJObject()
  var body_598795 = newJObject()
  add(query_598794, "fields", newJString(fields))
  add(path_598793, "packageName", newJString(packageName))
  add(query_598794, "quotaUser", newJString(quotaUser))
  add(query_598794, "alt", newJString(alt))
  add(path_598793, "subscriptionId", newJString(subscriptionId))
  add(query_598794, "oauth_token", newJString(oauthToken))
  add(query_598794, "userIp", newJString(userIp))
  add(query_598794, "key", newJString(key))
  add(path_598793, "token", newJString(token))
  if body != nil:
    body_598795 = body
  add(query_598794, "prettyPrint", newJBool(prettyPrint))
  result = call_598792.call(path_598793, query_598794, nil, nil, body_598795)

var androidpublisherPurchasesSubscriptionsAcknowledge* = Call_AndroidpublisherPurchasesSubscriptionsAcknowledge_598777(
    name: "androidpublisherPurchasesSubscriptionsAcknowledge",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:acknowledge",
    validator: validate_AndroidpublisherPurchasesSubscriptionsAcknowledge_598778,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsAcknowledge_598779,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsCancel_598796 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesSubscriptionsCancel_598798(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesSubscriptionsCancel_598797(path: JsonNode;
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
  var valid_598799 = path.getOrDefault("packageName")
  valid_598799 = validateParameter(valid_598799, JString, required = true,
                                 default = nil)
  if valid_598799 != nil:
    section.add "packageName", valid_598799
  var valid_598800 = path.getOrDefault("subscriptionId")
  valid_598800 = validateParameter(valid_598800, JString, required = true,
                                 default = nil)
  if valid_598800 != nil:
    section.add "subscriptionId", valid_598800
  var valid_598801 = path.getOrDefault("token")
  valid_598801 = validateParameter(valid_598801, JString, required = true,
                                 default = nil)
  if valid_598801 != nil:
    section.add "token", valid_598801
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
  var valid_598802 = query.getOrDefault("fields")
  valid_598802 = validateParameter(valid_598802, JString, required = false,
                                 default = nil)
  if valid_598802 != nil:
    section.add "fields", valid_598802
  var valid_598803 = query.getOrDefault("quotaUser")
  valid_598803 = validateParameter(valid_598803, JString, required = false,
                                 default = nil)
  if valid_598803 != nil:
    section.add "quotaUser", valid_598803
  var valid_598804 = query.getOrDefault("alt")
  valid_598804 = validateParameter(valid_598804, JString, required = false,
                                 default = newJString("json"))
  if valid_598804 != nil:
    section.add "alt", valid_598804
  var valid_598805 = query.getOrDefault("oauth_token")
  valid_598805 = validateParameter(valid_598805, JString, required = false,
                                 default = nil)
  if valid_598805 != nil:
    section.add "oauth_token", valid_598805
  var valid_598806 = query.getOrDefault("userIp")
  valid_598806 = validateParameter(valid_598806, JString, required = false,
                                 default = nil)
  if valid_598806 != nil:
    section.add "userIp", valid_598806
  var valid_598807 = query.getOrDefault("key")
  valid_598807 = validateParameter(valid_598807, JString, required = false,
                                 default = nil)
  if valid_598807 != nil:
    section.add "key", valid_598807
  var valid_598808 = query.getOrDefault("prettyPrint")
  valid_598808 = validateParameter(valid_598808, JBool, required = false,
                                 default = newJBool(true))
  if valid_598808 != nil:
    section.add "prettyPrint", valid_598808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598809: Call_AndroidpublisherPurchasesSubscriptionsCancel_598796;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_598809.validator(path, query, header, formData, body)
  let scheme = call_598809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598809.url(scheme.get, call_598809.host, call_598809.base,
                         call_598809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598809, url, valid)

proc call*(call_598810: Call_AndroidpublisherPurchasesSubscriptionsCancel_598796;
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
  var path_598811 = newJObject()
  var query_598812 = newJObject()
  add(query_598812, "fields", newJString(fields))
  add(path_598811, "packageName", newJString(packageName))
  add(query_598812, "quotaUser", newJString(quotaUser))
  add(query_598812, "alt", newJString(alt))
  add(path_598811, "subscriptionId", newJString(subscriptionId))
  add(query_598812, "oauth_token", newJString(oauthToken))
  add(query_598812, "userIp", newJString(userIp))
  add(query_598812, "key", newJString(key))
  add(path_598811, "token", newJString(token))
  add(query_598812, "prettyPrint", newJBool(prettyPrint))
  result = call_598810.call(path_598811, query_598812, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsCancel* = Call_AndroidpublisherPurchasesSubscriptionsCancel_598796(
    name: "androidpublisherPurchasesSubscriptionsCancel",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:cancel",
    validator: validate_AndroidpublisherPurchasesSubscriptionsCancel_598797,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsCancel_598798,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsDefer_598813 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesSubscriptionsDefer_598815(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesSubscriptionsDefer_598814(path: JsonNode;
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
  var valid_598816 = path.getOrDefault("packageName")
  valid_598816 = validateParameter(valid_598816, JString, required = true,
                                 default = nil)
  if valid_598816 != nil:
    section.add "packageName", valid_598816
  var valid_598817 = path.getOrDefault("subscriptionId")
  valid_598817 = validateParameter(valid_598817, JString, required = true,
                                 default = nil)
  if valid_598817 != nil:
    section.add "subscriptionId", valid_598817
  var valid_598818 = path.getOrDefault("token")
  valid_598818 = validateParameter(valid_598818, JString, required = true,
                                 default = nil)
  if valid_598818 != nil:
    section.add "token", valid_598818
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
  var valid_598819 = query.getOrDefault("fields")
  valid_598819 = validateParameter(valid_598819, JString, required = false,
                                 default = nil)
  if valid_598819 != nil:
    section.add "fields", valid_598819
  var valid_598820 = query.getOrDefault("quotaUser")
  valid_598820 = validateParameter(valid_598820, JString, required = false,
                                 default = nil)
  if valid_598820 != nil:
    section.add "quotaUser", valid_598820
  var valid_598821 = query.getOrDefault("alt")
  valid_598821 = validateParameter(valid_598821, JString, required = false,
                                 default = newJString("json"))
  if valid_598821 != nil:
    section.add "alt", valid_598821
  var valid_598822 = query.getOrDefault("oauth_token")
  valid_598822 = validateParameter(valid_598822, JString, required = false,
                                 default = nil)
  if valid_598822 != nil:
    section.add "oauth_token", valid_598822
  var valid_598823 = query.getOrDefault("userIp")
  valid_598823 = validateParameter(valid_598823, JString, required = false,
                                 default = nil)
  if valid_598823 != nil:
    section.add "userIp", valid_598823
  var valid_598824 = query.getOrDefault("key")
  valid_598824 = validateParameter(valid_598824, JString, required = false,
                                 default = nil)
  if valid_598824 != nil:
    section.add "key", valid_598824
  var valid_598825 = query.getOrDefault("prettyPrint")
  valid_598825 = validateParameter(valid_598825, JBool, required = false,
                                 default = newJBool(true))
  if valid_598825 != nil:
    section.add "prettyPrint", valid_598825
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

proc call*(call_598827: Call_AndroidpublisherPurchasesSubscriptionsDefer_598813;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Defers a user's subscription purchase until a specified future expiration time.
  ## 
  let valid = call_598827.validator(path, query, header, formData, body)
  let scheme = call_598827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598827.url(scheme.get, call_598827.host, call_598827.base,
                         call_598827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598827, url, valid)

proc call*(call_598828: Call_AndroidpublisherPurchasesSubscriptionsDefer_598813;
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
  var path_598829 = newJObject()
  var query_598830 = newJObject()
  var body_598831 = newJObject()
  add(query_598830, "fields", newJString(fields))
  add(path_598829, "packageName", newJString(packageName))
  add(query_598830, "quotaUser", newJString(quotaUser))
  add(query_598830, "alt", newJString(alt))
  add(path_598829, "subscriptionId", newJString(subscriptionId))
  add(query_598830, "oauth_token", newJString(oauthToken))
  add(query_598830, "userIp", newJString(userIp))
  add(query_598830, "key", newJString(key))
  add(path_598829, "token", newJString(token))
  if body != nil:
    body_598831 = body
  add(query_598830, "prettyPrint", newJBool(prettyPrint))
  result = call_598828.call(path_598829, query_598830, nil, nil, body_598831)

var androidpublisherPurchasesSubscriptionsDefer* = Call_AndroidpublisherPurchasesSubscriptionsDefer_598813(
    name: "androidpublisherPurchasesSubscriptionsDefer",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:defer",
    validator: validate_AndroidpublisherPurchasesSubscriptionsDefer_598814,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsDefer_598815,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRefund_598832 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesSubscriptionsRefund_598834(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesSubscriptionsRefund_598833(path: JsonNode;
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
  var valid_598835 = path.getOrDefault("packageName")
  valid_598835 = validateParameter(valid_598835, JString, required = true,
                                 default = nil)
  if valid_598835 != nil:
    section.add "packageName", valid_598835
  var valid_598836 = path.getOrDefault("subscriptionId")
  valid_598836 = validateParameter(valid_598836, JString, required = true,
                                 default = nil)
  if valid_598836 != nil:
    section.add "subscriptionId", valid_598836
  var valid_598837 = path.getOrDefault("token")
  valid_598837 = validateParameter(valid_598837, JString, required = true,
                                 default = nil)
  if valid_598837 != nil:
    section.add "token", valid_598837
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
  var valid_598838 = query.getOrDefault("fields")
  valid_598838 = validateParameter(valid_598838, JString, required = false,
                                 default = nil)
  if valid_598838 != nil:
    section.add "fields", valid_598838
  var valid_598839 = query.getOrDefault("quotaUser")
  valid_598839 = validateParameter(valid_598839, JString, required = false,
                                 default = nil)
  if valid_598839 != nil:
    section.add "quotaUser", valid_598839
  var valid_598840 = query.getOrDefault("alt")
  valid_598840 = validateParameter(valid_598840, JString, required = false,
                                 default = newJString("json"))
  if valid_598840 != nil:
    section.add "alt", valid_598840
  var valid_598841 = query.getOrDefault("oauth_token")
  valid_598841 = validateParameter(valid_598841, JString, required = false,
                                 default = nil)
  if valid_598841 != nil:
    section.add "oauth_token", valid_598841
  var valid_598842 = query.getOrDefault("userIp")
  valid_598842 = validateParameter(valid_598842, JString, required = false,
                                 default = nil)
  if valid_598842 != nil:
    section.add "userIp", valid_598842
  var valid_598843 = query.getOrDefault("key")
  valid_598843 = validateParameter(valid_598843, JString, required = false,
                                 default = nil)
  if valid_598843 != nil:
    section.add "key", valid_598843
  var valid_598844 = query.getOrDefault("prettyPrint")
  valid_598844 = validateParameter(valid_598844, JBool, required = false,
                                 default = newJBool(true))
  if valid_598844 != nil:
    section.add "prettyPrint", valid_598844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598845: Call_AndroidpublisherPurchasesSubscriptionsRefund_598832;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ## 
  let valid = call_598845.validator(path, query, header, formData, body)
  let scheme = call_598845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598845.url(scheme.get, call_598845.host, call_598845.base,
                         call_598845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598845, url, valid)

proc call*(call_598846: Call_AndroidpublisherPurchasesSubscriptionsRefund_598832;
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
  var path_598847 = newJObject()
  var query_598848 = newJObject()
  add(query_598848, "fields", newJString(fields))
  add(path_598847, "packageName", newJString(packageName))
  add(query_598848, "quotaUser", newJString(quotaUser))
  add(query_598848, "alt", newJString(alt))
  add(path_598847, "subscriptionId", newJString(subscriptionId))
  add(query_598848, "oauth_token", newJString(oauthToken))
  add(query_598848, "userIp", newJString(userIp))
  add(query_598848, "key", newJString(key))
  add(path_598847, "token", newJString(token))
  add(query_598848, "prettyPrint", newJBool(prettyPrint))
  result = call_598846.call(path_598847, query_598848, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRefund* = Call_AndroidpublisherPurchasesSubscriptionsRefund_598832(
    name: "androidpublisherPurchasesSubscriptionsRefund",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:refund",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRefund_598833,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRefund_598834,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRevoke_598849 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesSubscriptionsRevoke_598851(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesSubscriptionsRevoke_598850(path: JsonNode;
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
  var valid_598852 = path.getOrDefault("packageName")
  valid_598852 = validateParameter(valid_598852, JString, required = true,
                                 default = nil)
  if valid_598852 != nil:
    section.add "packageName", valid_598852
  var valid_598853 = path.getOrDefault("subscriptionId")
  valid_598853 = validateParameter(valid_598853, JString, required = true,
                                 default = nil)
  if valid_598853 != nil:
    section.add "subscriptionId", valid_598853
  var valid_598854 = path.getOrDefault("token")
  valid_598854 = validateParameter(valid_598854, JString, required = true,
                                 default = nil)
  if valid_598854 != nil:
    section.add "token", valid_598854
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
  var valid_598855 = query.getOrDefault("fields")
  valid_598855 = validateParameter(valid_598855, JString, required = false,
                                 default = nil)
  if valid_598855 != nil:
    section.add "fields", valid_598855
  var valid_598856 = query.getOrDefault("quotaUser")
  valid_598856 = validateParameter(valid_598856, JString, required = false,
                                 default = nil)
  if valid_598856 != nil:
    section.add "quotaUser", valid_598856
  var valid_598857 = query.getOrDefault("alt")
  valid_598857 = validateParameter(valid_598857, JString, required = false,
                                 default = newJString("json"))
  if valid_598857 != nil:
    section.add "alt", valid_598857
  var valid_598858 = query.getOrDefault("oauth_token")
  valid_598858 = validateParameter(valid_598858, JString, required = false,
                                 default = nil)
  if valid_598858 != nil:
    section.add "oauth_token", valid_598858
  var valid_598859 = query.getOrDefault("userIp")
  valid_598859 = validateParameter(valid_598859, JString, required = false,
                                 default = nil)
  if valid_598859 != nil:
    section.add "userIp", valid_598859
  var valid_598860 = query.getOrDefault("key")
  valid_598860 = validateParameter(valid_598860, JString, required = false,
                                 default = nil)
  if valid_598860 != nil:
    section.add "key", valid_598860
  var valid_598861 = query.getOrDefault("prettyPrint")
  valid_598861 = validateParameter(valid_598861, JBool, required = false,
                                 default = newJBool(true))
  if valid_598861 != nil:
    section.add "prettyPrint", valid_598861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598862: Call_AndroidpublisherPurchasesSubscriptionsRevoke_598849;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ## 
  let valid = call_598862.validator(path, query, header, formData, body)
  let scheme = call_598862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598862.url(scheme.get, call_598862.host, call_598862.base,
                         call_598862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598862, url, valid)

proc call*(call_598863: Call_AndroidpublisherPurchasesSubscriptionsRevoke_598849;
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
  var path_598864 = newJObject()
  var query_598865 = newJObject()
  add(query_598865, "fields", newJString(fields))
  add(path_598864, "packageName", newJString(packageName))
  add(query_598865, "quotaUser", newJString(quotaUser))
  add(query_598865, "alt", newJString(alt))
  add(path_598864, "subscriptionId", newJString(subscriptionId))
  add(query_598865, "oauth_token", newJString(oauthToken))
  add(query_598865, "userIp", newJString(userIp))
  add(query_598865, "key", newJString(key))
  add(path_598864, "token", newJString(token))
  add(query_598865, "prettyPrint", newJBool(prettyPrint))
  result = call_598863.call(path_598864, query_598865, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRevoke* = Call_AndroidpublisherPurchasesSubscriptionsRevoke_598849(
    name: "androidpublisherPurchasesSubscriptionsRevoke",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:revoke",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRevoke_598850,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRevoke_598851,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesVoidedpurchasesList_598866 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherPurchasesVoidedpurchasesList_598868(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherPurchasesVoidedpurchasesList_598867(path: JsonNode;
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
  var valid_598869 = path.getOrDefault("packageName")
  valid_598869 = validateParameter(valid_598869, JString, required = true,
                                 default = nil)
  if valid_598869 != nil:
    section.add "packageName", valid_598869
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
  var valid_598870 = query.getOrDefault("token")
  valid_598870 = validateParameter(valid_598870, JString, required = false,
                                 default = nil)
  if valid_598870 != nil:
    section.add "token", valid_598870
  var valid_598871 = query.getOrDefault("fields")
  valid_598871 = validateParameter(valid_598871, JString, required = false,
                                 default = nil)
  if valid_598871 != nil:
    section.add "fields", valid_598871
  var valid_598872 = query.getOrDefault("quotaUser")
  valid_598872 = validateParameter(valid_598872, JString, required = false,
                                 default = nil)
  if valid_598872 != nil:
    section.add "quotaUser", valid_598872
  var valid_598873 = query.getOrDefault("alt")
  valid_598873 = validateParameter(valid_598873, JString, required = false,
                                 default = newJString("json"))
  if valid_598873 != nil:
    section.add "alt", valid_598873
  var valid_598874 = query.getOrDefault("type")
  valid_598874 = validateParameter(valid_598874, JInt, required = false, default = nil)
  if valid_598874 != nil:
    section.add "type", valid_598874
  var valid_598875 = query.getOrDefault("oauth_token")
  valid_598875 = validateParameter(valid_598875, JString, required = false,
                                 default = nil)
  if valid_598875 != nil:
    section.add "oauth_token", valid_598875
  var valid_598876 = query.getOrDefault("endTime")
  valid_598876 = validateParameter(valid_598876, JString, required = false,
                                 default = nil)
  if valid_598876 != nil:
    section.add "endTime", valid_598876
  var valid_598877 = query.getOrDefault("userIp")
  valid_598877 = validateParameter(valid_598877, JString, required = false,
                                 default = nil)
  if valid_598877 != nil:
    section.add "userIp", valid_598877
  var valid_598878 = query.getOrDefault("maxResults")
  valid_598878 = validateParameter(valid_598878, JInt, required = false, default = nil)
  if valid_598878 != nil:
    section.add "maxResults", valid_598878
  var valid_598879 = query.getOrDefault("key")
  valid_598879 = validateParameter(valid_598879, JString, required = false,
                                 default = nil)
  if valid_598879 != nil:
    section.add "key", valid_598879
  var valid_598880 = query.getOrDefault("prettyPrint")
  valid_598880 = validateParameter(valid_598880, JBool, required = false,
                                 default = newJBool(true))
  if valid_598880 != nil:
    section.add "prettyPrint", valid_598880
  var valid_598881 = query.getOrDefault("startTime")
  valid_598881 = validateParameter(valid_598881, JString, required = false,
                                 default = nil)
  if valid_598881 != nil:
    section.add "startTime", valid_598881
  var valid_598882 = query.getOrDefault("startIndex")
  valid_598882 = validateParameter(valid_598882, JInt, required = false, default = nil)
  if valid_598882 != nil:
    section.add "startIndex", valid_598882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598883: Call_AndroidpublisherPurchasesVoidedpurchasesList_598866;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the purchases that were canceled, refunded or charged-back.
  ## 
  let valid = call_598883.validator(path, query, header, formData, body)
  let scheme = call_598883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598883.url(scheme.get, call_598883.host, call_598883.base,
                         call_598883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598883, url, valid)

proc call*(call_598884: Call_AndroidpublisherPurchasesVoidedpurchasesList_598866;
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
  var path_598885 = newJObject()
  var query_598886 = newJObject()
  add(query_598886, "token", newJString(token))
  add(query_598886, "fields", newJString(fields))
  add(path_598885, "packageName", newJString(packageName))
  add(query_598886, "quotaUser", newJString(quotaUser))
  add(query_598886, "alt", newJString(alt))
  add(query_598886, "type", newJInt(`type`))
  add(query_598886, "oauth_token", newJString(oauthToken))
  add(query_598886, "endTime", newJString(endTime))
  add(query_598886, "userIp", newJString(userIp))
  add(query_598886, "maxResults", newJInt(maxResults))
  add(query_598886, "key", newJString(key))
  add(query_598886, "prettyPrint", newJBool(prettyPrint))
  add(query_598886, "startTime", newJString(startTime))
  add(query_598886, "startIndex", newJInt(startIndex))
  result = call_598884.call(path_598885, query_598886, nil, nil, nil)

var androidpublisherPurchasesVoidedpurchasesList* = Call_AndroidpublisherPurchasesVoidedpurchasesList_598866(
    name: "androidpublisherPurchasesVoidedpurchasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{packageName}/purchases/voidedpurchases",
    validator: validate_AndroidpublisherPurchasesVoidedpurchasesList_598867,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherPurchasesVoidedpurchasesList_598868,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsList_598887 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherReviewsList_598889(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherReviewsList_598888(path: JsonNode; query: JsonNode;
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
  var valid_598890 = path.getOrDefault("packageName")
  valid_598890 = validateParameter(valid_598890, JString, required = true,
                                 default = nil)
  if valid_598890 != nil:
    section.add "packageName", valid_598890
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
  var valid_598891 = query.getOrDefault("translationLanguage")
  valid_598891 = validateParameter(valid_598891, JString, required = false,
                                 default = nil)
  if valid_598891 != nil:
    section.add "translationLanguage", valid_598891
  var valid_598892 = query.getOrDefault("token")
  valid_598892 = validateParameter(valid_598892, JString, required = false,
                                 default = nil)
  if valid_598892 != nil:
    section.add "token", valid_598892
  var valid_598893 = query.getOrDefault("fields")
  valid_598893 = validateParameter(valid_598893, JString, required = false,
                                 default = nil)
  if valid_598893 != nil:
    section.add "fields", valid_598893
  var valid_598894 = query.getOrDefault("quotaUser")
  valid_598894 = validateParameter(valid_598894, JString, required = false,
                                 default = nil)
  if valid_598894 != nil:
    section.add "quotaUser", valid_598894
  var valid_598895 = query.getOrDefault("alt")
  valid_598895 = validateParameter(valid_598895, JString, required = false,
                                 default = newJString("json"))
  if valid_598895 != nil:
    section.add "alt", valid_598895
  var valid_598896 = query.getOrDefault("oauth_token")
  valid_598896 = validateParameter(valid_598896, JString, required = false,
                                 default = nil)
  if valid_598896 != nil:
    section.add "oauth_token", valid_598896
  var valid_598897 = query.getOrDefault("userIp")
  valid_598897 = validateParameter(valid_598897, JString, required = false,
                                 default = nil)
  if valid_598897 != nil:
    section.add "userIp", valid_598897
  var valid_598898 = query.getOrDefault("maxResults")
  valid_598898 = validateParameter(valid_598898, JInt, required = false, default = nil)
  if valid_598898 != nil:
    section.add "maxResults", valid_598898
  var valid_598899 = query.getOrDefault("key")
  valid_598899 = validateParameter(valid_598899, JString, required = false,
                                 default = nil)
  if valid_598899 != nil:
    section.add "key", valid_598899
  var valid_598900 = query.getOrDefault("prettyPrint")
  valid_598900 = validateParameter(valid_598900, JBool, required = false,
                                 default = newJBool(true))
  if valid_598900 != nil:
    section.add "prettyPrint", valid_598900
  var valid_598901 = query.getOrDefault("startIndex")
  valid_598901 = validateParameter(valid_598901, JInt, required = false, default = nil)
  if valid_598901 != nil:
    section.add "startIndex", valid_598901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598902: Call_AndroidpublisherReviewsList_598887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ## 
  let valid = call_598902.validator(path, query, header, formData, body)
  let scheme = call_598902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598902.url(scheme.get, call_598902.host, call_598902.base,
                         call_598902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598902, url, valid)

proc call*(call_598903: Call_AndroidpublisherReviewsList_598887;
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
  var path_598904 = newJObject()
  var query_598905 = newJObject()
  add(query_598905, "translationLanguage", newJString(translationLanguage))
  add(query_598905, "token", newJString(token))
  add(query_598905, "fields", newJString(fields))
  add(path_598904, "packageName", newJString(packageName))
  add(query_598905, "quotaUser", newJString(quotaUser))
  add(query_598905, "alt", newJString(alt))
  add(query_598905, "oauth_token", newJString(oauthToken))
  add(query_598905, "userIp", newJString(userIp))
  add(query_598905, "maxResults", newJInt(maxResults))
  add(query_598905, "key", newJString(key))
  add(query_598905, "prettyPrint", newJBool(prettyPrint))
  add(query_598905, "startIndex", newJInt(startIndex))
  result = call_598903.call(path_598904, query_598905, nil, nil, nil)

var androidpublisherReviewsList* = Call_AndroidpublisherReviewsList_598887(
    name: "androidpublisherReviewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews",
    validator: validate_AndroidpublisherReviewsList_598888,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsList_598889, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsGet_598906 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherReviewsGet_598908(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherReviewsGet_598907(path: JsonNode; query: JsonNode;
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
  var valid_598909 = path.getOrDefault("packageName")
  valid_598909 = validateParameter(valid_598909, JString, required = true,
                                 default = nil)
  if valid_598909 != nil:
    section.add "packageName", valid_598909
  var valid_598910 = path.getOrDefault("reviewId")
  valid_598910 = validateParameter(valid_598910, JString, required = true,
                                 default = nil)
  if valid_598910 != nil:
    section.add "reviewId", valid_598910
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
  var valid_598911 = query.getOrDefault("translationLanguage")
  valid_598911 = validateParameter(valid_598911, JString, required = false,
                                 default = nil)
  if valid_598911 != nil:
    section.add "translationLanguage", valid_598911
  var valid_598912 = query.getOrDefault("fields")
  valid_598912 = validateParameter(valid_598912, JString, required = false,
                                 default = nil)
  if valid_598912 != nil:
    section.add "fields", valid_598912
  var valid_598913 = query.getOrDefault("quotaUser")
  valid_598913 = validateParameter(valid_598913, JString, required = false,
                                 default = nil)
  if valid_598913 != nil:
    section.add "quotaUser", valid_598913
  var valid_598914 = query.getOrDefault("alt")
  valid_598914 = validateParameter(valid_598914, JString, required = false,
                                 default = newJString("json"))
  if valid_598914 != nil:
    section.add "alt", valid_598914
  var valid_598915 = query.getOrDefault("oauth_token")
  valid_598915 = validateParameter(valid_598915, JString, required = false,
                                 default = nil)
  if valid_598915 != nil:
    section.add "oauth_token", valid_598915
  var valid_598916 = query.getOrDefault("userIp")
  valid_598916 = validateParameter(valid_598916, JString, required = false,
                                 default = nil)
  if valid_598916 != nil:
    section.add "userIp", valid_598916
  var valid_598917 = query.getOrDefault("key")
  valid_598917 = validateParameter(valid_598917, JString, required = false,
                                 default = nil)
  if valid_598917 != nil:
    section.add "key", valid_598917
  var valid_598918 = query.getOrDefault("prettyPrint")
  valid_598918 = validateParameter(valid_598918, JBool, required = false,
                                 default = newJBool(true))
  if valid_598918 != nil:
    section.add "prettyPrint", valid_598918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598919: Call_AndroidpublisherReviewsGet_598906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single review.
  ## 
  let valid = call_598919.validator(path, query, header, formData, body)
  let scheme = call_598919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598919.url(scheme.get, call_598919.host, call_598919.base,
                         call_598919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598919, url, valid)

proc call*(call_598920: Call_AndroidpublisherReviewsGet_598906;
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
  var path_598921 = newJObject()
  var query_598922 = newJObject()
  add(query_598922, "translationLanguage", newJString(translationLanguage))
  add(query_598922, "fields", newJString(fields))
  add(path_598921, "packageName", newJString(packageName))
  add(query_598922, "quotaUser", newJString(quotaUser))
  add(query_598922, "alt", newJString(alt))
  add(query_598922, "oauth_token", newJString(oauthToken))
  add(path_598921, "reviewId", newJString(reviewId))
  add(query_598922, "userIp", newJString(userIp))
  add(query_598922, "key", newJString(key))
  add(query_598922, "prettyPrint", newJBool(prettyPrint))
  result = call_598920.call(path_598921, query_598922, nil, nil, nil)

var androidpublisherReviewsGet* = Call_AndroidpublisherReviewsGet_598906(
    name: "androidpublisherReviewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}",
    validator: validate_AndroidpublisherReviewsGet_598907,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsGet_598908, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsReply_598923 = ref object of OpenApiRestCall_597421
proc url_AndroidpublisherReviewsReply_598925(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidpublisherReviewsReply_598924(path: JsonNode; query: JsonNode;
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
  var valid_598926 = path.getOrDefault("packageName")
  valid_598926 = validateParameter(valid_598926, JString, required = true,
                                 default = nil)
  if valid_598926 != nil:
    section.add "packageName", valid_598926
  var valid_598927 = path.getOrDefault("reviewId")
  valid_598927 = validateParameter(valid_598927, JString, required = true,
                                 default = nil)
  if valid_598927 != nil:
    section.add "reviewId", valid_598927
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
  var valid_598928 = query.getOrDefault("fields")
  valid_598928 = validateParameter(valid_598928, JString, required = false,
                                 default = nil)
  if valid_598928 != nil:
    section.add "fields", valid_598928
  var valid_598929 = query.getOrDefault("quotaUser")
  valid_598929 = validateParameter(valid_598929, JString, required = false,
                                 default = nil)
  if valid_598929 != nil:
    section.add "quotaUser", valid_598929
  var valid_598930 = query.getOrDefault("alt")
  valid_598930 = validateParameter(valid_598930, JString, required = false,
                                 default = newJString("json"))
  if valid_598930 != nil:
    section.add "alt", valid_598930
  var valid_598931 = query.getOrDefault("oauth_token")
  valid_598931 = validateParameter(valid_598931, JString, required = false,
                                 default = nil)
  if valid_598931 != nil:
    section.add "oauth_token", valid_598931
  var valid_598932 = query.getOrDefault("userIp")
  valid_598932 = validateParameter(valid_598932, JString, required = false,
                                 default = nil)
  if valid_598932 != nil:
    section.add "userIp", valid_598932
  var valid_598933 = query.getOrDefault("key")
  valid_598933 = validateParameter(valid_598933, JString, required = false,
                                 default = nil)
  if valid_598933 != nil:
    section.add "key", valid_598933
  var valid_598934 = query.getOrDefault("prettyPrint")
  valid_598934 = validateParameter(valid_598934, JBool, required = false,
                                 default = newJBool(true))
  if valid_598934 != nil:
    section.add "prettyPrint", valid_598934
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

proc call*(call_598936: Call_AndroidpublisherReviewsReply_598923; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reply to a single review, or update an existing reply.
  ## 
  let valid = call_598936.validator(path, query, header, formData, body)
  let scheme = call_598936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598936.url(scheme.get, call_598936.host, call_598936.base,
                         call_598936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598936, url, valid)

proc call*(call_598937: Call_AndroidpublisherReviewsReply_598923;
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
  var path_598938 = newJObject()
  var query_598939 = newJObject()
  var body_598940 = newJObject()
  add(query_598939, "fields", newJString(fields))
  add(path_598938, "packageName", newJString(packageName))
  add(query_598939, "quotaUser", newJString(quotaUser))
  add(query_598939, "alt", newJString(alt))
  add(query_598939, "oauth_token", newJString(oauthToken))
  add(path_598938, "reviewId", newJString(reviewId))
  add(query_598939, "userIp", newJString(userIp))
  add(query_598939, "key", newJString(key))
  if body != nil:
    body_598940 = body
  add(query_598939, "prettyPrint", newJBool(prettyPrint))
  result = call_598937.call(path_598938, query_598939, nil, nil, body_598940)

var androidpublisherReviewsReply* = Call_AndroidpublisherReviewsReply_598923(
    name: "androidpublisherReviewsReply", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}:reply",
    validator: validate_AndroidpublisherReviewsReply_598924,
    base: "/androidpublisher/v3/applications",
    url: url_AndroidpublisherReviewsReply_598925, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
