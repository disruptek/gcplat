
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play Developer
## version: v2
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
  Call_AndroidpublisherEditsInsert_578618 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsInsert_578620(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsInsert_578619(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578790: Call_AndroidpublisherEditsInsert_578618; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new edit for an app, populated with the app's current state.
  ## 
  let valid = call_578790.validator(path, query, header, formData, body)
  let scheme = call_578790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578790.url(scheme.get, call_578790.host, call_578790.base,
                         call_578790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578790, url, valid)

proc call*(call_578861: Call_AndroidpublisherEditsInsert_578618;
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
  var path_578862 = newJObject()
  var query_578864 = newJObject()
  var body_578865 = newJObject()
  add(query_578864, "key", newJString(key))
  add(query_578864, "prettyPrint", newJBool(prettyPrint))
  add(query_578864, "oauth_token", newJString(oauthToken))
  add(path_578862, "packageName", newJString(packageName))
  add(query_578864, "alt", newJString(alt))
  add(query_578864, "userIp", newJString(userIp))
  add(query_578864, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578865 = body
  add(query_578864, "fields", newJString(fields))
  result = call_578861.call(path_578862, query_578864, nil, nil, body_578865)

var androidpublisherEditsInsert* = Call_AndroidpublisherEditsInsert_578618(
    name: "androidpublisherEditsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits",
    validator: validate_AndroidpublisherEditsInsert_578619,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsInsert_578620, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsGet_578904 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsGet_578906(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsGet_578905(path: JsonNode; query: JsonNode;
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
  var valid_578907 = path.getOrDefault("packageName")
  valid_578907 = validateParameter(valid_578907, JString, required = true,
                                 default = nil)
  if valid_578907 != nil:
    section.add "packageName", valid_578907
  var valid_578908 = path.getOrDefault("editId")
  valid_578908 = validateParameter(valid_578908, JString, required = true,
                                 default = nil)
  if valid_578908 != nil:
    section.add "editId", valid_578908
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
  var valid_578909 = query.getOrDefault("key")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "key", valid_578909
  var valid_578910 = query.getOrDefault("prettyPrint")
  valid_578910 = validateParameter(valid_578910, JBool, required = false,
                                 default = newJBool(true))
  if valid_578910 != nil:
    section.add "prettyPrint", valid_578910
  var valid_578911 = query.getOrDefault("oauth_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "oauth_token", valid_578911
  var valid_578912 = query.getOrDefault("alt")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = newJString("json"))
  if valid_578912 != nil:
    section.add "alt", valid_578912
  var valid_578913 = query.getOrDefault("userIp")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "userIp", valid_578913
  var valid_578914 = query.getOrDefault("quotaUser")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "quotaUser", valid_578914
  var valid_578915 = query.getOrDefault("fields")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "fields", valid_578915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578916: Call_AndroidpublisherEditsGet_578904; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the edit specified. Calls will fail if the edit is no long active (e.g. has been deleted, superseded or expired).
  ## 
  let valid = call_578916.validator(path, query, header, formData, body)
  let scheme = call_578916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578916.url(scheme.get, call_578916.host, call_578916.base,
                         call_578916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578916, url, valid)

proc call*(call_578917: Call_AndroidpublisherEditsGet_578904; packageName: string;
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
  var path_578918 = newJObject()
  var query_578919 = newJObject()
  add(query_578919, "key", newJString(key))
  add(query_578919, "prettyPrint", newJBool(prettyPrint))
  add(query_578919, "oauth_token", newJString(oauthToken))
  add(path_578918, "packageName", newJString(packageName))
  add(path_578918, "editId", newJString(editId))
  add(query_578919, "alt", newJString(alt))
  add(query_578919, "userIp", newJString(userIp))
  add(query_578919, "quotaUser", newJString(quotaUser))
  add(query_578919, "fields", newJString(fields))
  result = call_578917.call(path_578918, query_578919, nil, nil, nil)

var androidpublisherEditsGet* = Call_AndroidpublisherEditsGet_578904(
    name: "androidpublisherEditsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsGet_578905,
    base: "/androidpublisher/v2/applications", url: url_AndroidpublisherEditsGet_578906,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDelete_578920 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsDelete_578922(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDelete_578921(path: JsonNode; query: JsonNode;
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
  var valid_578923 = path.getOrDefault("packageName")
  valid_578923 = validateParameter(valid_578923, JString, required = true,
                                 default = nil)
  if valid_578923 != nil:
    section.add "packageName", valid_578923
  var valid_578924 = path.getOrDefault("editId")
  valid_578924 = validateParameter(valid_578924, JString, required = true,
                                 default = nil)
  if valid_578924 != nil:
    section.add "editId", valid_578924
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
  var valid_578925 = query.getOrDefault("key")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "key", valid_578925
  var valid_578926 = query.getOrDefault("prettyPrint")
  valid_578926 = validateParameter(valid_578926, JBool, required = false,
                                 default = newJBool(true))
  if valid_578926 != nil:
    section.add "prettyPrint", valid_578926
  var valid_578927 = query.getOrDefault("oauth_token")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "oauth_token", valid_578927
  var valid_578928 = query.getOrDefault("alt")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("json"))
  if valid_578928 != nil:
    section.add "alt", valid_578928
  var valid_578929 = query.getOrDefault("userIp")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "userIp", valid_578929
  var valid_578930 = query.getOrDefault("quotaUser")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "quotaUser", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578932: Call_AndroidpublisherEditsDelete_578920; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an edit for an app. Creating a new edit will automatically delete any of your previous edits so this method need only be called if you want to preemptively abandon an edit.
  ## 
  let valid = call_578932.validator(path, query, header, formData, body)
  let scheme = call_578932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578932.url(scheme.get, call_578932.host, call_578932.base,
                         call_578932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578932, url, valid)

proc call*(call_578933: Call_AndroidpublisherEditsDelete_578920;
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
  var path_578934 = newJObject()
  var query_578935 = newJObject()
  add(query_578935, "key", newJString(key))
  add(query_578935, "prettyPrint", newJBool(prettyPrint))
  add(query_578935, "oauth_token", newJString(oauthToken))
  add(path_578934, "packageName", newJString(packageName))
  add(path_578934, "editId", newJString(editId))
  add(query_578935, "alt", newJString(alt))
  add(query_578935, "userIp", newJString(userIp))
  add(query_578935, "quotaUser", newJString(quotaUser))
  add(query_578935, "fields", newJString(fields))
  result = call_578933.call(path_578934, query_578935, nil, nil, nil)

var androidpublisherEditsDelete* = Call_AndroidpublisherEditsDelete_578920(
    name: "androidpublisherEditsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}",
    validator: validate_AndroidpublisherEditsDelete_578921,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDelete_578922, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksUpload_578952 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApksUpload_578954(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsApksUpload_578953(path: JsonNode;
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
  var valid_578955 = path.getOrDefault("packageName")
  valid_578955 = validateParameter(valid_578955, JString, required = true,
                                 default = nil)
  if valid_578955 != nil:
    section.add "packageName", valid_578955
  var valid_578956 = path.getOrDefault("editId")
  valid_578956 = validateParameter(valid_578956, JString, required = true,
                                 default = nil)
  if valid_578956 != nil:
    section.add "editId", valid_578956
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
  var valid_578957 = query.getOrDefault("key")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "key", valid_578957
  var valid_578958 = query.getOrDefault("prettyPrint")
  valid_578958 = validateParameter(valid_578958, JBool, required = false,
                                 default = newJBool(true))
  if valid_578958 != nil:
    section.add "prettyPrint", valid_578958
  var valid_578959 = query.getOrDefault("oauth_token")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "oauth_token", valid_578959
  var valid_578960 = query.getOrDefault("alt")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = newJString("json"))
  if valid_578960 != nil:
    section.add "alt", valid_578960
  var valid_578961 = query.getOrDefault("userIp")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "userIp", valid_578961
  var valid_578962 = query.getOrDefault("quotaUser")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "quotaUser", valid_578962
  var valid_578963 = query.getOrDefault("fields")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "fields", valid_578963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578964: Call_AndroidpublisherEditsApksUpload_578952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_578964.validator(path, query, header, formData, body)
  let scheme = call_578964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578964.url(scheme.get, call_578964.host, call_578964.base,
                         call_578964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578964, url, valid)

proc call*(call_578965: Call_AndroidpublisherEditsApksUpload_578952;
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
  var path_578966 = newJObject()
  var query_578967 = newJObject()
  add(query_578967, "key", newJString(key))
  add(query_578967, "prettyPrint", newJBool(prettyPrint))
  add(query_578967, "oauth_token", newJString(oauthToken))
  add(path_578966, "packageName", newJString(packageName))
  add(path_578966, "editId", newJString(editId))
  add(query_578967, "alt", newJString(alt))
  add(query_578967, "userIp", newJString(userIp))
  add(query_578967, "quotaUser", newJString(quotaUser))
  add(query_578967, "fields", newJString(fields))
  result = call_578965.call(path_578966, query_578967, nil, nil, nil)

var androidpublisherEditsApksUpload* = Call_AndroidpublisherEditsApksUpload_578952(
    name: "androidpublisherEditsApksUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksUpload_578953,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksUpload_578954, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksList_578936 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApksList_578938(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsApksList_578937(path: JsonNode; query: JsonNode;
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
  var valid_578939 = path.getOrDefault("packageName")
  valid_578939 = validateParameter(valid_578939, JString, required = true,
                                 default = nil)
  if valid_578939 != nil:
    section.add "packageName", valid_578939
  var valid_578940 = path.getOrDefault("editId")
  valid_578940 = validateParameter(valid_578940, JString, required = true,
                                 default = nil)
  if valid_578940 != nil:
    section.add "editId", valid_578940
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
  var valid_578941 = query.getOrDefault("key")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "key", valid_578941
  var valid_578942 = query.getOrDefault("prettyPrint")
  valid_578942 = validateParameter(valid_578942, JBool, required = false,
                                 default = newJBool(true))
  if valid_578942 != nil:
    section.add "prettyPrint", valid_578942
  var valid_578943 = query.getOrDefault("oauth_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "oauth_token", valid_578943
  var valid_578944 = query.getOrDefault("alt")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = newJString("json"))
  if valid_578944 != nil:
    section.add "alt", valid_578944
  var valid_578945 = query.getOrDefault("userIp")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "userIp", valid_578945
  var valid_578946 = query.getOrDefault("quotaUser")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "quotaUser", valid_578946
  var valid_578947 = query.getOrDefault("fields")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "fields", valid_578947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578948: Call_AndroidpublisherEditsApksList_578936; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_578948.validator(path, query, header, formData, body)
  let scheme = call_578948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578948.url(scheme.get, call_578948.host, call_578948.base,
                         call_578948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578948, url, valid)

proc call*(call_578949: Call_AndroidpublisherEditsApksList_578936;
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
  var path_578950 = newJObject()
  var query_578951 = newJObject()
  add(query_578951, "key", newJString(key))
  add(query_578951, "prettyPrint", newJBool(prettyPrint))
  add(query_578951, "oauth_token", newJString(oauthToken))
  add(path_578950, "packageName", newJString(packageName))
  add(path_578950, "editId", newJString(editId))
  add(query_578951, "alt", newJString(alt))
  add(query_578951, "userIp", newJString(userIp))
  add(query_578951, "quotaUser", newJString(quotaUser))
  add(query_578951, "fields", newJString(fields))
  result = call_578949.call(path_578950, query_578951, nil, nil, nil)

var androidpublisherEditsApksList* = Call_AndroidpublisherEditsApksList_578936(
    name: "androidpublisherEditsApksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks",
    validator: validate_AndroidpublisherEditsApksList_578937,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksList_578938, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApksAddexternallyhosted_578968 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApksAddexternallyhosted_578970(protocol: Scheme;
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

proc validate_AndroidpublisherEditsApksAddexternallyhosted_578969(path: JsonNode;
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
  var valid_578971 = path.getOrDefault("packageName")
  valid_578971 = validateParameter(valid_578971, JString, required = true,
                                 default = nil)
  if valid_578971 != nil:
    section.add "packageName", valid_578971
  var valid_578972 = path.getOrDefault("editId")
  valid_578972 = validateParameter(valid_578972, JString, required = true,
                                 default = nil)
  if valid_578972 != nil:
    section.add "editId", valid_578972
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
  var valid_578973 = query.getOrDefault("key")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "key", valid_578973
  var valid_578974 = query.getOrDefault("prettyPrint")
  valid_578974 = validateParameter(valid_578974, JBool, required = false,
                                 default = newJBool(true))
  if valid_578974 != nil:
    section.add "prettyPrint", valid_578974
  var valid_578975 = query.getOrDefault("oauth_token")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "oauth_token", valid_578975
  var valid_578976 = query.getOrDefault("alt")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = newJString("json"))
  if valid_578976 != nil:
    section.add "alt", valid_578976
  var valid_578977 = query.getOrDefault("userIp")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "userIp", valid_578977
  var valid_578978 = query.getOrDefault("quotaUser")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "quotaUser", valid_578978
  var valid_578979 = query.getOrDefault("fields")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "fields", valid_578979
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

proc call*(call_578981: Call_AndroidpublisherEditsApksAddexternallyhosted_578968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to enterprises using Google Play for Work whose application is configured to restrict distribution to the enterprise domain.
  ## 
  let valid = call_578981.validator(path, query, header, formData, body)
  let scheme = call_578981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578981.url(scheme.get, call_578981.host, call_578981.base,
                         call_578981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578981, url, valid)

proc call*(call_578982: Call_AndroidpublisherEditsApksAddexternallyhosted_578968;
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
  var path_578983 = newJObject()
  var query_578984 = newJObject()
  var body_578985 = newJObject()
  add(query_578984, "key", newJString(key))
  add(query_578984, "prettyPrint", newJBool(prettyPrint))
  add(query_578984, "oauth_token", newJString(oauthToken))
  add(path_578983, "packageName", newJString(packageName))
  add(path_578983, "editId", newJString(editId))
  add(query_578984, "alt", newJString(alt))
  add(query_578984, "userIp", newJString(userIp))
  add(query_578984, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578985 = body
  add(query_578984, "fields", newJString(fields))
  result = call_578982.call(path_578983, query_578984, nil, nil, body_578985)

var androidpublisherEditsApksAddexternallyhosted* = Call_AndroidpublisherEditsApksAddexternallyhosted_578968(
    name: "androidpublisherEditsApksAddexternallyhosted",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/externallyHosted",
    validator: validate_AndroidpublisherEditsApksAddexternallyhosted_578969,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApksAddexternallyhosted_578970,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDeobfuscationfilesUpload_578986 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsDeobfuscationfilesUpload_578988(protocol: Scheme;
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

proc validate_AndroidpublisherEditsDeobfuscationfilesUpload_578987(
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
  var valid_578989 = path.getOrDefault("packageName")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "packageName", valid_578989
  var valid_578990 = path.getOrDefault("editId")
  valid_578990 = validateParameter(valid_578990, JString, required = true,
                                 default = nil)
  if valid_578990 != nil:
    section.add "editId", valid_578990
  var valid_578991 = path.getOrDefault("deobfuscationFileType")
  valid_578991 = validateParameter(valid_578991, JString, required = true,
                                 default = newJString("proguard"))
  if valid_578991 != nil:
    section.add "deobfuscationFileType", valid_578991
  var valid_578992 = path.getOrDefault("apkVersionCode")
  valid_578992 = validateParameter(valid_578992, JInt, required = true, default = nil)
  if valid_578992 != nil:
    section.add "apkVersionCode", valid_578992
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
  var valid_578993 = query.getOrDefault("key")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "key", valid_578993
  var valid_578994 = query.getOrDefault("prettyPrint")
  valid_578994 = validateParameter(valid_578994, JBool, required = false,
                                 default = newJBool(true))
  if valid_578994 != nil:
    section.add "prettyPrint", valid_578994
  var valid_578995 = query.getOrDefault("oauth_token")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "oauth_token", valid_578995
  var valid_578996 = query.getOrDefault("alt")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = newJString("json"))
  if valid_578996 != nil:
    section.add "alt", valid_578996
  var valid_578997 = query.getOrDefault("userIp")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "userIp", valid_578997
  var valid_578998 = query.getOrDefault("quotaUser")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "quotaUser", valid_578998
  var valid_578999 = query.getOrDefault("fields")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "fields", valid_578999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579000: Call_AndroidpublisherEditsDeobfuscationfilesUpload_578986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the deobfuscation file of the specified APK. If a deobfuscation file already exists, it will be replaced.
  ## 
  let valid = call_579000.validator(path, query, header, formData, body)
  let scheme = call_579000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579000.url(scheme.get, call_579000.host, call_579000.base,
                         call_579000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579000, url, valid)

proc call*(call_579001: Call_AndroidpublisherEditsDeobfuscationfilesUpload_578986;
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
  var path_579002 = newJObject()
  var query_579003 = newJObject()
  add(query_579003, "key", newJString(key))
  add(query_579003, "prettyPrint", newJBool(prettyPrint))
  add(query_579003, "oauth_token", newJString(oauthToken))
  add(path_579002, "packageName", newJString(packageName))
  add(path_579002, "editId", newJString(editId))
  add(query_579003, "alt", newJString(alt))
  add(query_579003, "userIp", newJString(userIp))
  add(query_579003, "quotaUser", newJString(quotaUser))
  add(path_579002, "deobfuscationFileType", newJString(deobfuscationFileType))
  add(path_579002, "apkVersionCode", newJInt(apkVersionCode))
  add(query_579003, "fields", newJString(fields))
  result = call_579001.call(path_579002, query_579003, nil, nil, nil)

var androidpublisherEditsDeobfuscationfilesUpload* = Call_AndroidpublisherEditsDeobfuscationfilesUpload_578986(
    name: "androidpublisherEditsDeobfuscationfilesUpload",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType}",
    validator: validate_AndroidpublisherEditsDeobfuscationfilesUpload_578987,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDeobfuscationfilesUpload_578988,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpdate_579022 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsExpansionfilesUpdate_579024(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesUpdate_579023(path: JsonNode;
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
  var valid_579025 = path.getOrDefault("packageName")
  valid_579025 = validateParameter(valid_579025, JString, required = true,
                                 default = nil)
  if valid_579025 != nil:
    section.add "packageName", valid_579025
  var valid_579026 = path.getOrDefault("editId")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "editId", valid_579026
  var valid_579027 = path.getOrDefault("apkVersionCode")
  valid_579027 = validateParameter(valid_579027, JInt, required = true, default = nil)
  if valid_579027 != nil:
    section.add "apkVersionCode", valid_579027
  var valid_579028 = path.getOrDefault("expansionFileType")
  valid_579028 = validateParameter(valid_579028, JString, required = true,
                                 default = newJString("main"))
  if valid_579028 != nil:
    section.add "expansionFileType", valid_579028
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
  var valid_579029 = query.getOrDefault("key")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "key", valid_579029
  var valid_579030 = query.getOrDefault("prettyPrint")
  valid_579030 = validateParameter(valid_579030, JBool, required = false,
                                 default = newJBool(true))
  if valid_579030 != nil:
    section.add "prettyPrint", valid_579030
  var valid_579031 = query.getOrDefault("oauth_token")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "oauth_token", valid_579031
  var valid_579032 = query.getOrDefault("alt")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = newJString("json"))
  if valid_579032 != nil:
    section.add "alt", valid_579032
  var valid_579033 = query.getOrDefault("userIp")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "userIp", valid_579033
  var valid_579034 = query.getOrDefault("quotaUser")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "quotaUser", valid_579034
  var valid_579035 = query.getOrDefault("fields")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "fields", valid_579035
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

proc call*(call_579037: Call_AndroidpublisherEditsExpansionfilesUpdate_579022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method.
  ## 
  let valid = call_579037.validator(path, query, header, formData, body)
  let scheme = call_579037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579037.url(scheme.get, call_579037.host, call_579037.base,
                         call_579037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579037, url, valid)

proc call*(call_579038: Call_AndroidpublisherEditsExpansionfilesUpdate_579022;
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
  var path_579039 = newJObject()
  var query_579040 = newJObject()
  var body_579041 = newJObject()
  add(query_579040, "key", newJString(key))
  add(query_579040, "prettyPrint", newJBool(prettyPrint))
  add(query_579040, "oauth_token", newJString(oauthToken))
  add(path_579039, "packageName", newJString(packageName))
  add(path_579039, "editId", newJString(editId))
  add(query_579040, "alt", newJString(alt))
  add(query_579040, "userIp", newJString(userIp))
  add(query_579040, "quotaUser", newJString(quotaUser))
  add(path_579039, "apkVersionCode", newJInt(apkVersionCode))
  if body != nil:
    body_579041 = body
  add(path_579039, "expansionFileType", newJString(expansionFileType))
  add(query_579040, "fields", newJString(fields))
  result = call_579038.call(path_579039, query_579040, nil, nil, body_579041)

var androidpublisherEditsExpansionfilesUpdate* = Call_AndroidpublisherEditsExpansionfilesUpdate_579022(
    name: "androidpublisherEditsExpansionfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpdate_579023,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpdate_579024,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesUpload_579042 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsExpansionfilesUpload_579044(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesUpload_579043(path: JsonNode;
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
  var valid_579045 = path.getOrDefault("packageName")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "packageName", valid_579045
  var valid_579046 = path.getOrDefault("editId")
  valid_579046 = validateParameter(valid_579046, JString, required = true,
                                 default = nil)
  if valid_579046 != nil:
    section.add "editId", valid_579046
  var valid_579047 = path.getOrDefault("apkVersionCode")
  valid_579047 = validateParameter(valid_579047, JInt, required = true, default = nil)
  if valid_579047 != nil:
    section.add "apkVersionCode", valid_579047
  var valid_579048 = path.getOrDefault("expansionFileType")
  valid_579048 = validateParameter(valid_579048, JString, required = true,
                                 default = newJString("main"))
  if valid_579048 != nil:
    section.add "expansionFileType", valid_579048
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
  var valid_579049 = query.getOrDefault("key")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "key", valid_579049
  var valid_579050 = query.getOrDefault("prettyPrint")
  valid_579050 = validateParameter(valid_579050, JBool, required = false,
                                 default = newJBool(true))
  if valid_579050 != nil:
    section.add "prettyPrint", valid_579050
  var valid_579051 = query.getOrDefault("oauth_token")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "oauth_token", valid_579051
  var valid_579052 = query.getOrDefault("alt")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = newJString("json"))
  if valid_579052 != nil:
    section.add "alt", valid_579052
  var valid_579053 = query.getOrDefault("userIp")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "userIp", valid_579053
  var valid_579054 = query.getOrDefault("quotaUser")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "quotaUser", valid_579054
  var valid_579055 = query.getOrDefault("fields")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "fields", valid_579055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579056: Call_AndroidpublisherEditsExpansionfilesUpload_579042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads and attaches a new Expansion File to the APK specified.
  ## 
  let valid = call_579056.validator(path, query, header, formData, body)
  let scheme = call_579056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579056.url(scheme.get, call_579056.host, call_579056.base,
                         call_579056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579056, url, valid)

proc call*(call_579057: Call_AndroidpublisherEditsExpansionfilesUpload_579042;
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
  var path_579058 = newJObject()
  var query_579059 = newJObject()
  add(query_579059, "key", newJString(key))
  add(query_579059, "prettyPrint", newJBool(prettyPrint))
  add(query_579059, "oauth_token", newJString(oauthToken))
  add(path_579058, "packageName", newJString(packageName))
  add(path_579058, "editId", newJString(editId))
  add(query_579059, "alt", newJString(alt))
  add(query_579059, "userIp", newJString(userIp))
  add(query_579059, "quotaUser", newJString(quotaUser))
  add(path_579058, "apkVersionCode", newJInt(apkVersionCode))
  add(path_579058, "expansionFileType", newJString(expansionFileType))
  add(query_579059, "fields", newJString(fields))
  result = call_579057.call(path_579058, query_579059, nil, nil, nil)

var androidpublisherEditsExpansionfilesUpload* = Call_AndroidpublisherEditsExpansionfilesUpload_579042(
    name: "androidpublisherEditsExpansionfilesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesUpload_579043,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesUpload_579044,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesGet_579004 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsExpansionfilesGet_579006(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesGet_579005(path: JsonNode;
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
  var valid_579007 = path.getOrDefault("packageName")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "packageName", valid_579007
  var valid_579008 = path.getOrDefault("editId")
  valid_579008 = validateParameter(valid_579008, JString, required = true,
                                 default = nil)
  if valid_579008 != nil:
    section.add "editId", valid_579008
  var valid_579009 = path.getOrDefault("apkVersionCode")
  valid_579009 = validateParameter(valid_579009, JInt, required = true, default = nil)
  if valid_579009 != nil:
    section.add "apkVersionCode", valid_579009
  var valid_579010 = path.getOrDefault("expansionFileType")
  valid_579010 = validateParameter(valid_579010, JString, required = true,
                                 default = newJString("main"))
  if valid_579010 != nil:
    section.add "expansionFileType", valid_579010
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
  var valid_579011 = query.getOrDefault("key")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "key", valid_579011
  var valid_579012 = query.getOrDefault("prettyPrint")
  valid_579012 = validateParameter(valid_579012, JBool, required = false,
                                 default = newJBool(true))
  if valid_579012 != nil:
    section.add "prettyPrint", valid_579012
  var valid_579013 = query.getOrDefault("oauth_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "oauth_token", valid_579013
  var valid_579014 = query.getOrDefault("alt")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = newJString("json"))
  if valid_579014 != nil:
    section.add "alt", valid_579014
  var valid_579015 = query.getOrDefault("userIp")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "userIp", valid_579015
  var valid_579016 = query.getOrDefault("quotaUser")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "quotaUser", valid_579016
  var valid_579017 = query.getOrDefault("fields")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "fields", valid_579017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579018: Call_AndroidpublisherEditsExpansionfilesGet_579004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the Expansion File configuration for the APK specified.
  ## 
  let valid = call_579018.validator(path, query, header, formData, body)
  let scheme = call_579018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579018.url(scheme.get, call_579018.host, call_579018.base,
                         call_579018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579018, url, valid)

proc call*(call_579019: Call_AndroidpublisherEditsExpansionfilesGet_579004;
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
  var path_579020 = newJObject()
  var query_579021 = newJObject()
  add(query_579021, "key", newJString(key))
  add(query_579021, "prettyPrint", newJBool(prettyPrint))
  add(query_579021, "oauth_token", newJString(oauthToken))
  add(path_579020, "packageName", newJString(packageName))
  add(path_579020, "editId", newJString(editId))
  add(query_579021, "alt", newJString(alt))
  add(query_579021, "userIp", newJString(userIp))
  add(query_579021, "quotaUser", newJString(quotaUser))
  add(path_579020, "apkVersionCode", newJInt(apkVersionCode))
  add(path_579020, "expansionFileType", newJString(expansionFileType))
  add(query_579021, "fields", newJString(fields))
  result = call_579019.call(path_579020, query_579021, nil, nil, nil)

var androidpublisherEditsExpansionfilesGet* = Call_AndroidpublisherEditsExpansionfilesGet_579004(
    name: "androidpublisherEditsExpansionfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesGet_579005,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesGet_579006,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsExpansionfilesPatch_579060 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsExpansionfilesPatch_579062(protocol: Scheme;
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

proc validate_AndroidpublisherEditsExpansionfilesPatch_579061(path: JsonNode;
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
  var valid_579063 = path.getOrDefault("packageName")
  valid_579063 = validateParameter(valid_579063, JString, required = true,
                                 default = nil)
  if valid_579063 != nil:
    section.add "packageName", valid_579063
  var valid_579064 = path.getOrDefault("editId")
  valid_579064 = validateParameter(valid_579064, JString, required = true,
                                 default = nil)
  if valid_579064 != nil:
    section.add "editId", valid_579064
  var valid_579065 = path.getOrDefault("apkVersionCode")
  valid_579065 = validateParameter(valid_579065, JInt, required = true, default = nil)
  if valid_579065 != nil:
    section.add "apkVersionCode", valid_579065
  var valid_579066 = path.getOrDefault("expansionFileType")
  valid_579066 = validateParameter(valid_579066, JString, required = true,
                                 default = newJString("main"))
  if valid_579066 != nil:
    section.add "expansionFileType", valid_579066
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
  var valid_579073 = query.getOrDefault("fields")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "fields", valid_579073
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

proc call*(call_579075: Call_AndroidpublisherEditsExpansionfilesPatch_579060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the APK's Expansion File configuration to reference another APK's Expansion Files. To add a new Expansion File use the Upload method. This method supports patch semantics.
  ## 
  let valid = call_579075.validator(path, query, header, formData, body)
  let scheme = call_579075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579075.url(scheme.get, call_579075.host, call_579075.base,
                         call_579075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579075, url, valid)

proc call*(call_579076: Call_AndroidpublisherEditsExpansionfilesPatch_579060;
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
  var path_579077 = newJObject()
  var query_579078 = newJObject()
  var body_579079 = newJObject()
  add(query_579078, "key", newJString(key))
  add(query_579078, "prettyPrint", newJBool(prettyPrint))
  add(query_579078, "oauth_token", newJString(oauthToken))
  add(path_579077, "packageName", newJString(packageName))
  add(path_579077, "editId", newJString(editId))
  add(query_579078, "alt", newJString(alt))
  add(query_579078, "userIp", newJString(userIp))
  add(query_579078, "quotaUser", newJString(quotaUser))
  add(path_579077, "apkVersionCode", newJInt(apkVersionCode))
  if body != nil:
    body_579079 = body
  add(path_579077, "expansionFileType", newJString(expansionFileType))
  add(query_579078, "fields", newJString(fields))
  result = call_579076.call(path_579077, query_579078, nil, nil, body_579079)

var androidpublisherEditsExpansionfilesPatch* = Call_AndroidpublisherEditsExpansionfilesPatch_579060(
    name: "androidpublisherEditsExpansionfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}",
    validator: validate_AndroidpublisherEditsExpansionfilesPatch_579061,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsExpansionfilesPatch_579062,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsList_579080 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApklistingsList_579082(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsList_579081(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the APK-specific localized listings for a specified APK.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579083 = path.getOrDefault("packageName")
  valid_579083 = validateParameter(valid_579083, JString, required = true,
                                 default = nil)
  if valid_579083 != nil:
    section.add "packageName", valid_579083
  var valid_579084 = path.getOrDefault("editId")
  valid_579084 = validateParameter(valid_579084, JString, required = true,
                                 default = nil)
  if valid_579084 != nil:
    section.add "editId", valid_579084
  var valid_579085 = path.getOrDefault("apkVersionCode")
  valid_579085 = validateParameter(valid_579085, JInt, required = true, default = nil)
  if valid_579085 != nil:
    section.add "apkVersionCode", valid_579085
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
  var valid_579086 = query.getOrDefault("key")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "key", valid_579086
  var valid_579087 = query.getOrDefault("prettyPrint")
  valid_579087 = validateParameter(valid_579087, JBool, required = false,
                                 default = newJBool(true))
  if valid_579087 != nil:
    section.add "prettyPrint", valid_579087
  var valid_579088 = query.getOrDefault("oauth_token")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "oauth_token", valid_579088
  var valid_579089 = query.getOrDefault("alt")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = newJString("json"))
  if valid_579089 != nil:
    section.add "alt", valid_579089
  var valid_579090 = query.getOrDefault("userIp")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "userIp", valid_579090
  var valid_579091 = query.getOrDefault("quotaUser")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "quotaUser", valid_579091
  var valid_579092 = query.getOrDefault("fields")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "fields", valid_579092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579093: Call_AndroidpublisherEditsApklistingsList_579080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the APK-specific localized listings for a specified APK.
  ## 
  let valid = call_579093.validator(path, query, header, formData, body)
  let scheme = call_579093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579093.url(scheme.get, call_579093.host, call_579093.base,
                         call_579093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579093, url, valid)

proc call*(call_579094: Call_AndroidpublisherEditsApklistingsList_579080;
          packageName: string; editId: string; apkVersionCode: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsApklistingsList
  ## Lists all the APK-specific localized listings for a specified APK.
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
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579095 = newJObject()
  var query_579096 = newJObject()
  add(query_579096, "key", newJString(key))
  add(query_579096, "prettyPrint", newJBool(prettyPrint))
  add(query_579096, "oauth_token", newJString(oauthToken))
  add(path_579095, "packageName", newJString(packageName))
  add(path_579095, "editId", newJString(editId))
  add(query_579096, "alt", newJString(alt))
  add(query_579096, "userIp", newJString(userIp))
  add(query_579096, "quotaUser", newJString(quotaUser))
  add(path_579095, "apkVersionCode", newJInt(apkVersionCode))
  add(query_579096, "fields", newJString(fields))
  result = call_579094.call(path_579095, query_579096, nil, nil, nil)

var androidpublisherEditsApklistingsList* = Call_AndroidpublisherEditsApklistingsList_579080(
    name: "androidpublisherEditsApklistingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings",
    validator: validate_AndroidpublisherEditsApklistingsList_579081,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsList_579082, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsDeleteall_579097 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApklistingsDeleteall_579099(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsDeleteall_579098(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all the APK-specific localized listings for a specified APK.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579100 = path.getOrDefault("packageName")
  valid_579100 = validateParameter(valid_579100, JString, required = true,
                                 default = nil)
  if valid_579100 != nil:
    section.add "packageName", valid_579100
  var valid_579101 = path.getOrDefault("editId")
  valid_579101 = validateParameter(valid_579101, JString, required = true,
                                 default = nil)
  if valid_579101 != nil:
    section.add "editId", valid_579101
  var valid_579102 = path.getOrDefault("apkVersionCode")
  valid_579102 = validateParameter(valid_579102, JInt, required = true, default = nil)
  if valid_579102 != nil:
    section.add "apkVersionCode", valid_579102
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
  var valid_579103 = query.getOrDefault("key")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "key", valid_579103
  var valid_579104 = query.getOrDefault("prettyPrint")
  valid_579104 = validateParameter(valid_579104, JBool, required = false,
                                 default = newJBool(true))
  if valid_579104 != nil:
    section.add "prettyPrint", valid_579104
  var valid_579105 = query.getOrDefault("oauth_token")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "oauth_token", valid_579105
  var valid_579106 = query.getOrDefault("alt")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("json"))
  if valid_579106 != nil:
    section.add "alt", valid_579106
  var valid_579107 = query.getOrDefault("userIp")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "userIp", valid_579107
  var valid_579108 = query.getOrDefault("quotaUser")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "quotaUser", valid_579108
  var valid_579109 = query.getOrDefault("fields")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "fields", valid_579109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579110: Call_AndroidpublisherEditsApklistingsDeleteall_579097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all the APK-specific localized listings for a specified APK.
  ## 
  let valid = call_579110.validator(path, query, header, formData, body)
  let scheme = call_579110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579110.url(scheme.get, call_579110.host, call_579110.base,
                         call_579110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579110, url, valid)

proc call*(call_579111: Call_AndroidpublisherEditsApklistingsDeleteall_579097;
          packageName: string; editId: string; apkVersionCode: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidpublisherEditsApklistingsDeleteall
  ## Deletes all the APK-specific localized listings for a specified APK.
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
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579112 = newJObject()
  var query_579113 = newJObject()
  add(query_579113, "key", newJString(key))
  add(query_579113, "prettyPrint", newJBool(prettyPrint))
  add(query_579113, "oauth_token", newJString(oauthToken))
  add(path_579112, "packageName", newJString(packageName))
  add(path_579112, "editId", newJString(editId))
  add(query_579113, "alt", newJString(alt))
  add(query_579113, "userIp", newJString(userIp))
  add(query_579113, "quotaUser", newJString(quotaUser))
  add(path_579112, "apkVersionCode", newJInt(apkVersionCode))
  add(query_579113, "fields", newJString(fields))
  result = call_579111.call(path_579112, query_579113, nil, nil, nil)

var androidpublisherEditsApklistingsDeleteall* = Call_AndroidpublisherEditsApklistingsDeleteall_579097(
    name: "androidpublisherEditsApklistingsDeleteall",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings",
    validator: validate_AndroidpublisherEditsApklistingsDeleteall_579098,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsDeleteall_579099,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsUpdate_579132 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApklistingsUpdate_579134(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsUpdate_579133(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579135 = path.getOrDefault("packageName")
  valid_579135 = validateParameter(valid_579135, JString, required = true,
                                 default = nil)
  if valid_579135 != nil:
    section.add "packageName", valid_579135
  var valid_579136 = path.getOrDefault("editId")
  valid_579136 = validateParameter(valid_579136, JString, required = true,
                                 default = nil)
  if valid_579136 != nil:
    section.add "editId", valid_579136
  var valid_579137 = path.getOrDefault("language")
  valid_579137 = validateParameter(valid_579137, JString, required = true,
                                 default = nil)
  if valid_579137 != nil:
    section.add "language", valid_579137
  var valid_579138 = path.getOrDefault("apkVersionCode")
  valid_579138 = validateParameter(valid_579138, JInt, required = true, default = nil)
  if valid_579138 != nil:
    section.add "apkVersionCode", valid_579138
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
  var valid_579139 = query.getOrDefault("key")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "key", valid_579139
  var valid_579140 = query.getOrDefault("prettyPrint")
  valid_579140 = validateParameter(valid_579140, JBool, required = false,
                                 default = newJBool(true))
  if valid_579140 != nil:
    section.add "prettyPrint", valid_579140
  var valid_579141 = query.getOrDefault("oauth_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "oauth_token", valid_579141
  var valid_579142 = query.getOrDefault("alt")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = newJString("json"))
  if valid_579142 != nil:
    section.add "alt", valid_579142
  var valid_579143 = query.getOrDefault("userIp")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "userIp", valid_579143
  var valid_579144 = query.getOrDefault("quotaUser")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "quotaUser", valid_579144
  var valid_579145 = query.getOrDefault("fields")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "fields", valid_579145
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

proc call*(call_579147: Call_AndroidpublisherEditsApklistingsUpdate_579132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_579147.validator(path, query, header, formData, body)
  let scheme = call_579147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579147.url(scheme.get, call_579147.host, call_579147.base,
                         call_579147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579147, url, valid)

proc call*(call_579148: Call_AndroidpublisherEditsApklistingsUpdate_579132;
          packageName: string; editId: string; language: string; apkVersionCode: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidpublisherEditsApklistingsUpdate
  ## Updates or creates the APK-specific localized listing for a specified APK and language code.
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
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   apkVersionCode: int (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579149 = newJObject()
  var query_579150 = newJObject()
  var body_579151 = newJObject()
  add(query_579150, "key", newJString(key))
  add(query_579150, "prettyPrint", newJBool(prettyPrint))
  add(query_579150, "oauth_token", newJString(oauthToken))
  add(path_579149, "packageName", newJString(packageName))
  add(path_579149, "editId", newJString(editId))
  add(path_579149, "language", newJString(language))
  add(query_579150, "alt", newJString(alt))
  add(query_579150, "userIp", newJString(userIp))
  add(query_579150, "quotaUser", newJString(quotaUser))
  add(path_579149, "apkVersionCode", newJInt(apkVersionCode))
  if body != nil:
    body_579151 = body
  add(query_579150, "fields", newJString(fields))
  result = call_579148.call(path_579149, query_579150, nil, nil, body_579151)

var androidpublisherEditsApklistingsUpdate* = Call_AndroidpublisherEditsApklistingsUpdate_579132(
    name: "androidpublisherEditsApklistingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsUpdate_579133,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsUpdate_579134,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsGet_579114 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApklistingsGet_579116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsGet_579115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the APK-specific localized listing for a specified APK and language code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579117 = path.getOrDefault("packageName")
  valid_579117 = validateParameter(valid_579117, JString, required = true,
                                 default = nil)
  if valid_579117 != nil:
    section.add "packageName", valid_579117
  var valid_579118 = path.getOrDefault("editId")
  valid_579118 = validateParameter(valid_579118, JString, required = true,
                                 default = nil)
  if valid_579118 != nil:
    section.add "editId", valid_579118
  var valid_579119 = path.getOrDefault("language")
  valid_579119 = validateParameter(valid_579119, JString, required = true,
                                 default = nil)
  if valid_579119 != nil:
    section.add "language", valid_579119
  var valid_579120 = path.getOrDefault("apkVersionCode")
  valid_579120 = validateParameter(valid_579120, JInt, required = true, default = nil)
  if valid_579120 != nil:
    section.add "apkVersionCode", valid_579120
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
  var valid_579121 = query.getOrDefault("key")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "key", valid_579121
  var valid_579122 = query.getOrDefault("prettyPrint")
  valid_579122 = validateParameter(valid_579122, JBool, required = false,
                                 default = newJBool(true))
  if valid_579122 != nil:
    section.add "prettyPrint", valid_579122
  var valid_579123 = query.getOrDefault("oauth_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "oauth_token", valid_579123
  var valid_579124 = query.getOrDefault("alt")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = newJString("json"))
  if valid_579124 != nil:
    section.add "alt", valid_579124
  var valid_579125 = query.getOrDefault("userIp")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "userIp", valid_579125
  var valid_579126 = query.getOrDefault("quotaUser")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "quotaUser", valid_579126
  var valid_579127 = query.getOrDefault("fields")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "fields", valid_579127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579128: Call_AndroidpublisherEditsApklistingsGet_579114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_579128.validator(path, query, header, formData, body)
  let scheme = call_579128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579128.url(scheme.get, call_579128.host, call_579128.base,
                         call_579128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579128, url, valid)

proc call*(call_579129: Call_AndroidpublisherEditsApklistingsGet_579114;
          packageName: string; editId: string; language: string; apkVersionCode: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidpublisherEditsApklistingsGet
  ## Fetches the APK-specific localized listing for a specified APK and language code.
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
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   apkVersionCode: int (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579130 = newJObject()
  var query_579131 = newJObject()
  add(query_579131, "key", newJString(key))
  add(query_579131, "prettyPrint", newJBool(prettyPrint))
  add(query_579131, "oauth_token", newJString(oauthToken))
  add(path_579130, "packageName", newJString(packageName))
  add(path_579130, "editId", newJString(editId))
  add(path_579130, "language", newJString(language))
  add(query_579131, "alt", newJString(alt))
  add(query_579131, "userIp", newJString(userIp))
  add(query_579131, "quotaUser", newJString(quotaUser))
  add(path_579130, "apkVersionCode", newJInt(apkVersionCode))
  add(query_579131, "fields", newJString(fields))
  result = call_579129.call(path_579130, query_579131, nil, nil, nil)

var androidpublisherEditsApklistingsGet* = Call_AndroidpublisherEditsApklistingsGet_579114(
    name: "androidpublisherEditsApklistingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsGet_579115,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsGet_579116, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsPatch_579170 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApklistingsPatch_579172(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsPatch_579171(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579173 = path.getOrDefault("packageName")
  valid_579173 = validateParameter(valid_579173, JString, required = true,
                                 default = nil)
  if valid_579173 != nil:
    section.add "packageName", valid_579173
  var valid_579174 = path.getOrDefault("editId")
  valid_579174 = validateParameter(valid_579174, JString, required = true,
                                 default = nil)
  if valid_579174 != nil:
    section.add "editId", valid_579174
  var valid_579175 = path.getOrDefault("language")
  valid_579175 = validateParameter(valid_579175, JString, required = true,
                                 default = nil)
  if valid_579175 != nil:
    section.add "language", valid_579175
  var valid_579176 = path.getOrDefault("apkVersionCode")
  valid_579176 = validateParameter(valid_579176, JInt, required = true, default = nil)
  if valid_579176 != nil:
    section.add "apkVersionCode", valid_579176
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
  var valid_579177 = query.getOrDefault("key")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "key", valid_579177
  var valid_579178 = query.getOrDefault("prettyPrint")
  valid_579178 = validateParameter(valid_579178, JBool, required = false,
                                 default = newJBool(true))
  if valid_579178 != nil:
    section.add "prettyPrint", valid_579178
  var valid_579179 = query.getOrDefault("oauth_token")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "oauth_token", valid_579179
  var valid_579180 = query.getOrDefault("alt")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = newJString("json"))
  if valid_579180 != nil:
    section.add "alt", valid_579180
  var valid_579181 = query.getOrDefault("userIp")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "userIp", valid_579181
  var valid_579182 = query.getOrDefault("quotaUser")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "quotaUser", valid_579182
  var valid_579183 = query.getOrDefault("fields")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "fields", valid_579183
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

proc call*(call_579185: Call_AndroidpublisherEditsApklistingsPatch_579170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or creates the APK-specific localized listing for a specified APK and language code. This method supports patch semantics.
  ## 
  let valid = call_579185.validator(path, query, header, formData, body)
  let scheme = call_579185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579185.url(scheme.get, call_579185.host, call_579185.base,
                         call_579185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579185, url, valid)

proc call*(call_579186: Call_AndroidpublisherEditsApklistingsPatch_579170;
          packageName: string; editId: string; language: string; apkVersionCode: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidpublisherEditsApklistingsPatch
  ## Updates or creates the APK-specific localized listing for a specified APK and language code. This method supports patch semantics.
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
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   apkVersionCode: int (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579187 = newJObject()
  var query_579188 = newJObject()
  var body_579189 = newJObject()
  add(query_579188, "key", newJString(key))
  add(query_579188, "prettyPrint", newJBool(prettyPrint))
  add(query_579188, "oauth_token", newJString(oauthToken))
  add(path_579187, "packageName", newJString(packageName))
  add(path_579187, "editId", newJString(editId))
  add(path_579187, "language", newJString(language))
  add(query_579188, "alt", newJString(alt))
  add(query_579188, "userIp", newJString(userIp))
  add(query_579188, "quotaUser", newJString(quotaUser))
  add(path_579187, "apkVersionCode", newJInt(apkVersionCode))
  if body != nil:
    body_579189 = body
  add(query_579188, "fields", newJString(fields))
  result = call_579186.call(path_579187, query_579188, nil, nil, body_579189)

var androidpublisherEditsApklistingsPatch* = Call_AndroidpublisherEditsApklistingsPatch_579170(
    name: "androidpublisherEditsApklistingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsPatch_579171,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsPatch_579172, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsApklistingsDelete_579152 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsApklistingsDelete_579154(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "editId" in path, "`editId` is a required path parameter"
  assert "apkVersionCode" in path, "`apkVersionCode` is a required path parameter"
  assert "language" in path, "`language` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/edits/"),
               (kind: VariableSegment, value: "editId"),
               (kind: ConstantSegment, value: "/apks/"),
               (kind: VariableSegment, value: "apkVersionCode"),
               (kind: ConstantSegment, value: "/listings/"),
               (kind: VariableSegment, value: "language")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherEditsApklistingsDelete_579153(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the APK-specific localized listing for a specified APK and language code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : Unique identifier for the Android app that is being updated; for example, "com.spiffygame".
  ##   editId: JString (required)
  ##         : Unique identifier for this edit.
  ##   language: JString (required)
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   apkVersionCode: JInt (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_579155 = path.getOrDefault("packageName")
  valid_579155 = validateParameter(valid_579155, JString, required = true,
                                 default = nil)
  if valid_579155 != nil:
    section.add "packageName", valid_579155
  var valid_579156 = path.getOrDefault("editId")
  valid_579156 = validateParameter(valid_579156, JString, required = true,
                                 default = nil)
  if valid_579156 != nil:
    section.add "editId", valid_579156
  var valid_579157 = path.getOrDefault("language")
  valid_579157 = validateParameter(valid_579157, JString, required = true,
                                 default = nil)
  if valid_579157 != nil:
    section.add "language", valid_579157
  var valid_579158 = path.getOrDefault("apkVersionCode")
  valid_579158 = validateParameter(valid_579158, JInt, required = true, default = nil)
  if valid_579158 != nil:
    section.add "apkVersionCode", valid_579158
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
  var valid_579159 = query.getOrDefault("key")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "key", valid_579159
  var valid_579160 = query.getOrDefault("prettyPrint")
  valid_579160 = validateParameter(valid_579160, JBool, required = false,
                                 default = newJBool(true))
  if valid_579160 != nil:
    section.add "prettyPrint", valid_579160
  var valid_579161 = query.getOrDefault("oauth_token")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "oauth_token", valid_579161
  var valid_579162 = query.getOrDefault("alt")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = newJString("json"))
  if valid_579162 != nil:
    section.add "alt", valid_579162
  var valid_579163 = query.getOrDefault("userIp")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "userIp", valid_579163
  var valid_579164 = query.getOrDefault("quotaUser")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "quotaUser", valid_579164
  var valid_579165 = query.getOrDefault("fields")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "fields", valid_579165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579166: Call_AndroidpublisherEditsApklistingsDelete_579152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the APK-specific localized listing for a specified APK and language code.
  ## 
  let valid = call_579166.validator(path, query, header, formData, body)
  let scheme = call_579166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579166.url(scheme.get, call_579166.host, call_579166.base,
                         call_579166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579166, url, valid)

proc call*(call_579167: Call_AndroidpublisherEditsApklistingsDelete_579152;
          packageName: string; editId: string; language: string; apkVersionCode: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidpublisherEditsApklistingsDelete
  ## Deletes the APK-specific localized listing for a specified APK and language code.
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
  ##           : The language code (a BCP-47 language tag) of the APK-specific localized listing to read or modify. For example, to select Austrian German, pass "de-AT".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   apkVersionCode: int (required)
  ##                 : The APK version code whose APK-specific listings should be read or modified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579168 = newJObject()
  var query_579169 = newJObject()
  add(query_579169, "key", newJString(key))
  add(query_579169, "prettyPrint", newJBool(prettyPrint))
  add(query_579169, "oauth_token", newJString(oauthToken))
  add(path_579168, "packageName", newJString(packageName))
  add(path_579168, "editId", newJString(editId))
  add(path_579168, "language", newJString(language))
  add(query_579169, "alt", newJString(alt))
  add(query_579169, "userIp", newJString(userIp))
  add(query_579169, "quotaUser", newJString(quotaUser))
  add(path_579168, "apkVersionCode", newJInt(apkVersionCode))
  add(query_579169, "fields", newJString(fields))
  result = call_579167.call(path_579168, query_579169, nil, nil, nil)

var androidpublisherEditsApklistingsDelete* = Call_AndroidpublisherEditsApklistingsDelete_579152(
    name: "androidpublisherEditsApklistingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/apks/{apkVersionCode}/listings/{language}",
    validator: validate_AndroidpublisherEditsApklistingsDelete_579153,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsApklistingsDelete_579154,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesUpload_579206 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsBundlesUpload_579208(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsBundlesUpload_579207(path: JsonNode;
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
  var valid_579209 = path.getOrDefault("packageName")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "packageName", valid_579209
  var valid_579210 = path.getOrDefault("editId")
  valid_579210 = validateParameter(valid_579210, JString, required = true,
                                 default = nil)
  if valid_579210 != nil:
    section.add "editId", valid_579210
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
  var valid_579211 = query.getOrDefault("key")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "key", valid_579211
  var valid_579212 = query.getOrDefault("prettyPrint")
  valid_579212 = validateParameter(valid_579212, JBool, required = false,
                                 default = newJBool(true))
  if valid_579212 != nil:
    section.add "prettyPrint", valid_579212
  var valid_579213 = query.getOrDefault("oauth_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "oauth_token", valid_579213
  var valid_579214 = query.getOrDefault("ackBundleInstallationWarning")
  valid_579214 = validateParameter(valid_579214, JBool, required = false, default = nil)
  if valid_579214 != nil:
    section.add "ackBundleInstallationWarning", valid_579214
  var valid_579215 = query.getOrDefault("alt")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = newJString("json"))
  if valid_579215 != nil:
    section.add "alt", valid_579215
  var valid_579216 = query.getOrDefault("userIp")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "userIp", valid_579216
  var valid_579217 = query.getOrDefault("quotaUser")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "quotaUser", valid_579217
  var valid_579218 = query.getOrDefault("fields")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "fields", valid_579218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579219: Call_AndroidpublisherEditsBundlesUpload_579206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See: https://developers.google.com/api-client-library/java/google-api-java-client/errors for an example in java.
  ## 
  let valid = call_579219.validator(path, query, header, formData, body)
  let scheme = call_579219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579219.url(scheme.get, call_579219.host, call_579219.base,
                         call_579219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579219, url, valid)

proc call*(call_579220: Call_AndroidpublisherEditsBundlesUpload_579206;
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
  var path_579221 = newJObject()
  var query_579222 = newJObject()
  add(query_579222, "key", newJString(key))
  add(query_579222, "prettyPrint", newJBool(prettyPrint))
  add(query_579222, "oauth_token", newJString(oauthToken))
  add(path_579221, "packageName", newJString(packageName))
  add(query_579222, "ackBundleInstallationWarning",
      newJBool(ackBundleInstallationWarning))
  add(path_579221, "editId", newJString(editId))
  add(query_579222, "alt", newJString(alt))
  add(query_579222, "userIp", newJString(userIp))
  add(query_579222, "quotaUser", newJString(quotaUser))
  add(query_579222, "fields", newJString(fields))
  result = call_579220.call(path_579221, query_579222, nil, nil, nil)

var androidpublisherEditsBundlesUpload* = Call_AndroidpublisherEditsBundlesUpload_579206(
    name: "androidpublisherEditsBundlesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesUpload_579207,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsBundlesUpload_579208, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsBundlesList_579190 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsBundlesList_579192(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsBundlesList_579191(path: JsonNode;
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
  var valid_579193 = path.getOrDefault("packageName")
  valid_579193 = validateParameter(valid_579193, JString, required = true,
                                 default = nil)
  if valid_579193 != nil:
    section.add "packageName", valid_579193
  var valid_579194 = path.getOrDefault("editId")
  valid_579194 = validateParameter(valid_579194, JString, required = true,
                                 default = nil)
  if valid_579194 != nil:
    section.add "editId", valid_579194
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
  var valid_579195 = query.getOrDefault("key")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "key", valid_579195
  var valid_579196 = query.getOrDefault("prettyPrint")
  valid_579196 = validateParameter(valid_579196, JBool, required = false,
                                 default = newJBool(true))
  if valid_579196 != nil:
    section.add "prettyPrint", valid_579196
  var valid_579197 = query.getOrDefault("oauth_token")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "oauth_token", valid_579197
  var valid_579198 = query.getOrDefault("alt")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = newJString("json"))
  if valid_579198 != nil:
    section.add "alt", valid_579198
  var valid_579199 = query.getOrDefault("userIp")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "userIp", valid_579199
  var valid_579200 = query.getOrDefault("quotaUser")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "quotaUser", valid_579200
  var valid_579201 = query.getOrDefault("fields")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "fields", valid_579201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579202: Call_AndroidpublisherEditsBundlesList_579190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_579202.validator(path, query, header, formData, body)
  let scheme = call_579202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579202.url(scheme.get, call_579202.host, call_579202.base,
                         call_579202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579202, url, valid)

proc call*(call_579203: Call_AndroidpublisherEditsBundlesList_579190;
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
  var path_579204 = newJObject()
  var query_579205 = newJObject()
  add(query_579205, "key", newJString(key))
  add(query_579205, "prettyPrint", newJBool(prettyPrint))
  add(query_579205, "oauth_token", newJString(oauthToken))
  add(path_579204, "packageName", newJString(packageName))
  add(path_579204, "editId", newJString(editId))
  add(query_579205, "alt", newJString(alt))
  add(query_579205, "userIp", newJString(userIp))
  add(query_579205, "quotaUser", newJString(quotaUser))
  add(query_579205, "fields", newJString(fields))
  result = call_579203.call(path_579204, query_579205, nil, nil, nil)

var androidpublisherEditsBundlesList* = Call_AndroidpublisherEditsBundlesList_579190(
    name: "androidpublisherEditsBundlesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/bundles",
    validator: validate_AndroidpublisherEditsBundlesList_579191,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsBundlesList_579192, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsUpdate_579239 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsDetailsUpdate_579241(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsUpdate_579240(path: JsonNode;
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
  var valid_579242 = path.getOrDefault("packageName")
  valid_579242 = validateParameter(valid_579242, JString, required = true,
                                 default = nil)
  if valid_579242 != nil:
    section.add "packageName", valid_579242
  var valid_579243 = path.getOrDefault("editId")
  valid_579243 = validateParameter(valid_579243, JString, required = true,
                                 default = nil)
  if valid_579243 != nil:
    section.add "editId", valid_579243
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
  var valid_579244 = query.getOrDefault("key")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "key", valid_579244
  var valid_579245 = query.getOrDefault("prettyPrint")
  valid_579245 = validateParameter(valid_579245, JBool, required = false,
                                 default = newJBool(true))
  if valid_579245 != nil:
    section.add "prettyPrint", valid_579245
  var valid_579246 = query.getOrDefault("oauth_token")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "oauth_token", valid_579246
  var valid_579247 = query.getOrDefault("alt")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = newJString("json"))
  if valid_579247 != nil:
    section.add "alt", valid_579247
  var valid_579248 = query.getOrDefault("userIp")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "userIp", valid_579248
  var valid_579249 = query.getOrDefault("quotaUser")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "quotaUser", valid_579249
  var valid_579250 = query.getOrDefault("fields")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "fields", valid_579250
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

proc call*(call_579252: Call_AndroidpublisherEditsDetailsUpdate_579239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit.
  ## 
  let valid = call_579252.validator(path, query, header, formData, body)
  let scheme = call_579252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579252.url(scheme.get, call_579252.host, call_579252.base,
                         call_579252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579252, url, valid)

proc call*(call_579253: Call_AndroidpublisherEditsDetailsUpdate_579239;
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
  var path_579254 = newJObject()
  var query_579255 = newJObject()
  var body_579256 = newJObject()
  add(query_579255, "key", newJString(key))
  add(query_579255, "prettyPrint", newJBool(prettyPrint))
  add(query_579255, "oauth_token", newJString(oauthToken))
  add(path_579254, "packageName", newJString(packageName))
  add(path_579254, "editId", newJString(editId))
  add(query_579255, "alt", newJString(alt))
  add(query_579255, "userIp", newJString(userIp))
  add(query_579255, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579256 = body
  add(query_579255, "fields", newJString(fields))
  result = call_579253.call(path_579254, query_579255, nil, nil, body_579256)

var androidpublisherEditsDetailsUpdate* = Call_AndroidpublisherEditsDetailsUpdate_579239(
    name: "androidpublisherEditsDetailsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsUpdate_579240,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsUpdate_579241, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsGet_579223 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsDetailsGet_579225(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsGet_579224(path: JsonNode;
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
  var valid_579226 = path.getOrDefault("packageName")
  valid_579226 = validateParameter(valid_579226, JString, required = true,
                                 default = nil)
  if valid_579226 != nil:
    section.add "packageName", valid_579226
  var valid_579227 = path.getOrDefault("editId")
  valid_579227 = validateParameter(valid_579227, JString, required = true,
                                 default = nil)
  if valid_579227 != nil:
    section.add "editId", valid_579227
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
  var valid_579228 = query.getOrDefault("key")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "key", valid_579228
  var valid_579229 = query.getOrDefault("prettyPrint")
  valid_579229 = validateParameter(valid_579229, JBool, required = false,
                                 default = newJBool(true))
  if valid_579229 != nil:
    section.add "prettyPrint", valid_579229
  var valid_579230 = query.getOrDefault("oauth_token")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "oauth_token", valid_579230
  var valid_579231 = query.getOrDefault("alt")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = newJString("json"))
  if valid_579231 != nil:
    section.add "alt", valid_579231
  var valid_579232 = query.getOrDefault("userIp")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "userIp", valid_579232
  var valid_579233 = query.getOrDefault("quotaUser")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "quotaUser", valid_579233
  var valid_579234 = query.getOrDefault("fields")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "fields", valid_579234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579235: Call_AndroidpublisherEditsDetailsGet_579223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches app details for this edit. This includes the default language and developer support contact information.
  ## 
  let valid = call_579235.validator(path, query, header, formData, body)
  let scheme = call_579235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579235.url(scheme.get, call_579235.host, call_579235.base,
                         call_579235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579235, url, valid)

proc call*(call_579236: Call_AndroidpublisherEditsDetailsGet_579223;
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
  var path_579237 = newJObject()
  var query_579238 = newJObject()
  add(query_579238, "key", newJString(key))
  add(query_579238, "prettyPrint", newJBool(prettyPrint))
  add(query_579238, "oauth_token", newJString(oauthToken))
  add(path_579237, "packageName", newJString(packageName))
  add(path_579237, "editId", newJString(editId))
  add(query_579238, "alt", newJString(alt))
  add(query_579238, "userIp", newJString(userIp))
  add(query_579238, "quotaUser", newJString(quotaUser))
  add(query_579238, "fields", newJString(fields))
  result = call_579236.call(path_579237, query_579238, nil, nil, nil)

var androidpublisherEditsDetailsGet* = Call_AndroidpublisherEditsDetailsGet_579223(
    name: "androidpublisherEditsDetailsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsGet_579224,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsGet_579225, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsDetailsPatch_579257 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsDetailsPatch_579259(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsDetailsPatch_579258(path: JsonNode;
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
  var valid_579260 = path.getOrDefault("packageName")
  valid_579260 = validateParameter(valid_579260, JString, required = true,
                                 default = nil)
  if valid_579260 != nil:
    section.add "packageName", valid_579260
  var valid_579261 = path.getOrDefault("editId")
  valid_579261 = validateParameter(valid_579261, JString, required = true,
                                 default = nil)
  if valid_579261 != nil:
    section.add "editId", valid_579261
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
  var valid_579262 = query.getOrDefault("key")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "key", valid_579262
  var valid_579263 = query.getOrDefault("prettyPrint")
  valid_579263 = validateParameter(valid_579263, JBool, required = false,
                                 default = newJBool(true))
  if valid_579263 != nil:
    section.add "prettyPrint", valid_579263
  var valid_579264 = query.getOrDefault("oauth_token")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "oauth_token", valid_579264
  var valid_579265 = query.getOrDefault("alt")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = newJString("json"))
  if valid_579265 != nil:
    section.add "alt", valid_579265
  var valid_579266 = query.getOrDefault("userIp")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "userIp", valid_579266
  var valid_579267 = query.getOrDefault("quotaUser")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "quotaUser", valid_579267
  var valid_579268 = query.getOrDefault("fields")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "fields", valid_579268
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

proc call*(call_579270: Call_AndroidpublisherEditsDetailsPatch_579257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates app details for this edit. This method supports patch semantics.
  ## 
  let valid = call_579270.validator(path, query, header, formData, body)
  let scheme = call_579270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579270.url(scheme.get, call_579270.host, call_579270.base,
                         call_579270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579270, url, valid)

proc call*(call_579271: Call_AndroidpublisherEditsDetailsPatch_579257;
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
  var path_579272 = newJObject()
  var query_579273 = newJObject()
  var body_579274 = newJObject()
  add(query_579273, "key", newJString(key))
  add(query_579273, "prettyPrint", newJBool(prettyPrint))
  add(query_579273, "oauth_token", newJString(oauthToken))
  add(path_579272, "packageName", newJString(packageName))
  add(path_579272, "editId", newJString(editId))
  add(query_579273, "alt", newJString(alt))
  add(query_579273, "userIp", newJString(userIp))
  add(query_579273, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579274 = body
  add(query_579273, "fields", newJString(fields))
  result = call_579271.call(path_579272, query_579273, nil, nil, body_579274)

var androidpublisherEditsDetailsPatch* = Call_AndroidpublisherEditsDetailsPatch_579257(
    name: "androidpublisherEditsDetailsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/details",
    validator: validate_AndroidpublisherEditsDetailsPatch_579258,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsDetailsPatch_579259, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsList_579275 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsList_579277(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsList_579276(path: JsonNode;
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
  var valid_579278 = path.getOrDefault("packageName")
  valid_579278 = validateParameter(valid_579278, JString, required = true,
                                 default = nil)
  if valid_579278 != nil:
    section.add "packageName", valid_579278
  var valid_579279 = path.getOrDefault("editId")
  valid_579279 = validateParameter(valid_579279, JString, required = true,
                                 default = nil)
  if valid_579279 != nil:
    section.add "editId", valid_579279
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
  var valid_579280 = query.getOrDefault("key")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "key", valid_579280
  var valid_579281 = query.getOrDefault("prettyPrint")
  valid_579281 = validateParameter(valid_579281, JBool, required = false,
                                 default = newJBool(true))
  if valid_579281 != nil:
    section.add "prettyPrint", valid_579281
  var valid_579282 = query.getOrDefault("oauth_token")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "oauth_token", valid_579282
  var valid_579283 = query.getOrDefault("alt")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = newJString("json"))
  if valid_579283 != nil:
    section.add "alt", valid_579283
  var valid_579284 = query.getOrDefault("userIp")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "userIp", valid_579284
  var valid_579285 = query.getOrDefault("quotaUser")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "quotaUser", valid_579285
  var valid_579286 = query.getOrDefault("fields")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "fields", valid_579286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579287: Call_AndroidpublisherEditsListingsList_579275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all of the localized store listings attached to this edit.
  ## 
  let valid = call_579287.validator(path, query, header, formData, body)
  let scheme = call_579287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579287.url(scheme.get, call_579287.host, call_579287.base,
                         call_579287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579287, url, valid)

proc call*(call_579288: Call_AndroidpublisherEditsListingsList_579275;
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
  var path_579289 = newJObject()
  var query_579290 = newJObject()
  add(query_579290, "key", newJString(key))
  add(query_579290, "prettyPrint", newJBool(prettyPrint))
  add(query_579290, "oauth_token", newJString(oauthToken))
  add(path_579289, "packageName", newJString(packageName))
  add(path_579289, "editId", newJString(editId))
  add(query_579290, "alt", newJString(alt))
  add(query_579290, "userIp", newJString(userIp))
  add(query_579290, "quotaUser", newJString(quotaUser))
  add(query_579290, "fields", newJString(fields))
  result = call_579288.call(path_579289, query_579290, nil, nil, nil)

var androidpublisherEditsListingsList* = Call_AndroidpublisherEditsListingsList_579275(
    name: "androidpublisherEditsListingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsList_579276,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsList_579277, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDeleteall_579291 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsDeleteall_579293(protocol: Scheme;
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

proc validate_AndroidpublisherEditsListingsDeleteall_579292(path: JsonNode;
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
  var valid_579294 = path.getOrDefault("packageName")
  valid_579294 = validateParameter(valid_579294, JString, required = true,
                                 default = nil)
  if valid_579294 != nil:
    section.add "packageName", valid_579294
  var valid_579295 = path.getOrDefault("editId")
  valid_579295 = validateParameter(valid_579295, JString, required = true,
                                 default = nil)
  if valid_579295 != nil:
    section.add "editId", valid_579295
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
  var valid_579302 = query.getOrDefault("fields")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "fields", valid_579302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579303: Call_AndroidpublisherEditsListingsDeleteall_579291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all localized listings from an edit.
  ## 
  let valid = call_579303.validator(path, query, header, formData, body)
  let scheme = call_579303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579303.url(scheme.get, call_579303.host, call_579303.base,
                         call_579303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579303, url, valid)

proc call*(call_579304: Call_AndroidpublisherEditsListingsDeleteall_579291;
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
  var path_579305 = newJObject()
  var query_579306 = newJObject()
  add(query_579306, "key", newJString(key))
  add(query_579306, "prettyPrint", newJBool(prettyPrint))
  add(query_579306, "oauth_token", newJString(oauthToken))
  add(path_579305, "packageName", newJString(packageName))
  add(path_579305, "editId", newJString(editId))
  add(query_579306, "alt", newJString(alt))
  add(query_579306, "userIp", newJString(userIp))
  add(query_579306, "quotaUser", newJString(quotaUser))
  add(query_579306, "fields", newJString(fields))
  result = call_579304.call(path_579305, query_579306, nil, nil, nil)

var androidpublisherEditsListingsDeleteall* = Call_AndroidpublisherEditsListingsDeleteall_579291(
    name: "androidpublisherEditsListingsDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings",
    validator: validate_AndroidpublisherEditsListingsDeleteall_579292,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsDeleteall_579293,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsUpdate_579324 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsUpdate_579326(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsUpdate_579325(path: JsonNode;
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
  var valid_579327 = path.getOrDefault("packageName")
  valid_579327 = validateParameter(valid_579327, JString, required = true,
                                 default = nil)
  if valid_579327 != nil:
    section.add "packageName", valid_579327
  var valid_579328 = path.getOrDefault("editId")
  valid_579328 = validateParameter(valid_579328, JString, required = true,
                                 default = nil)
  if valid_579328 != nil:
    section.add "editId", valid_579328
  var valid_579329 = path.getOrDefault("language")
  valid_579329 = validateParameter(valid_579329, JString, required = true,
                                 default = nil)
  if valid_579329 != nil:
    section.add "language", valid_579329
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
  var valid_579330 = query.getOrDefault("key")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "key", valid_579330
  var valid_579331 = query.getOrDefault("prettyPrint")
  valid_579331 = validateParameter(valid_579331, JBool, required = false,
                                 default = newJBool(true))
  if valid_579331 != nil:
    section.add "prettyPrint", valid_579331
  var valid_579332 = query.getOrDefault("oauth_token")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "oauth_token", valid_579332
  var valid_579333 = query.getOrDefault("alt")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = newJString("json"))
  if valid_579333 != nil:
    section.add "alt", valid_579333
  var valid_579334 = query.getOrDefault("userIp")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "userIp", valid_579334
  var valid_579335 = query.getOrDefault("quotaUser")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "quotaUser", valid_579335
  var valid_579336 = query.getOrDefault("fields")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "fields", valid_579336
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

proc call*(call_579338: Call_AndroidpublisherEditsListingsUpdate_579324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing.
  ## 
  let valid = call_579338.validator(path, query, header, formData, body)
  let scheme = call_579338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579338.url(scheme.get, call_579338.host, call_579338.base,
                         call_579338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579338, url, valid)

proc call*(call_579339: Call_AndroidpublisherEditsListingsUpdate_579324;
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
  var path_579340 = newJObject()
  var query_579341 = newJObject()
  var body_579342 = newJObject()
  add(query_579341, "key", newJString(key))
  add(query_579341, "prettyPrint", newJBool(prettyPrint))
  add(query_579341, "oauth_token", newJString(oauthToken))
  add(path_579340, "packageName", newJString(packageName))
  add(path_579340, "editId", newJString(editId))
  add(path_579340, "language", newJString(language))
  add(query_579341, "alt", newJString(alt))
  add(query_579341, "userIp", newJString(userIp))
  add(query_579341, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579342 = body
  add(query_579341, "fields", newJString(fields))
  result = call_579339.call(path_579340, query_579341, nil, nil, body_579342)

var androidpublisherEditsListingsUpdate* = Call_AndroidpublisherEditsListingsUpdate_579324(
    name: "androidpublisherEditsListingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsUpdate_579325,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsUpdate_579326, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsGet_579307 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsGet_579309(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsGet_579308(path: JsonNode;
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
  var valid_579310 = path.getOrDefault("packageName")
  valid_579310 = validateParameter(valid_579310, JString, required = true,
                                 default = nil)
  if valid_579310 != nil:
    section.add "packageName", valid_579310
  var valid_579311 = path.getOrDefault("editId")
  valid_579311 = validateParameter(valid_579311, JString, required = true,
                                 default = nil)
  if valid_579311 != nil:
    section.add "editId", valid_579311
  var valid_579312 = path.getOrDefault("language")
  valid_579312 = validateParameter(valid_579312, JString, required = true,
                                 default = nil)
  if valid_579312 != nil:
    section.add "language", valid_579312
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
  var valid_579313 = query.getOrDefault("key")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "key", valid_579313
  var valid_579314 = query.getOrDefault("prettyPrint")
  valid_579314 = validateParameter(valid_579314, JBool, required = false,
                                 default = newJBool(true))
  if valid_579314 != nil:
    section.add "prettyPrint", valid_579314
  var valid_579315 = query.getOrDefault("oauth_token")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "oauth_token", valid_579315
  var valid_579316 = query.getOrDefault("alt")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = newJString("json"))
  if valid_579316 != nil:
    section.add "alt", valid_579316
  var valid_579317 = query.getOrDefault("userIp")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "userIp", valid_579317
  var valid_579318 = query.getOrDefault("quotaUser")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "quotaUser", valid_579318
  var valid_579319 = query.getOrDefault("fields")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "fields", valid_579319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579320: Call_AndroidpublisherEditsListingsGet_579307;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches information about a localized store listing.
  ## 
  let valid = call_579320.validator(path, query, header, formData, body)
  let scheme = call_579320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579320.url(scheme.get, call_579320.host, call_579320.base,
                         call_579320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579320, url, valid)

proc call*(call_579321: Call_AndroidpublisherEditsListingsGet_579307;
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
  var path_579322 = newJObject()
  var query_579323 = newJObject()
  add(query_579323, "key", newJString(key))
  add(query_579323, "prettyPrint", newJBool(prettyPrint))
  add(query_579323, "oauth_token", newJString(oauthToken))
  add(path_579322, "packageName", newJString(packageName))
  add(path_579322, "editId", newJString(editId))
  add(path_579322, "language", newJString(language))
  add(query_579323, "alt", newJString(alt))
  add(query_579323, "userIp", newJString(userIp))
  add(query_579323, "quotaUser", newJString(quotaUser))
  add(query_579323, "fields", newJString(fields))
  result = call_579321.call(path_579322, query_579323, nil, nil, nil)

var androidpublisherEditsListingsGet* = Call_AndroidpublisherEditsListingsGet_579307(
    name: "androidpublisherEditsListingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsGet_579308,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsGet_579309, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsPatch_579360 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsPatch_579362(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsPatch_579361(path: JsonNode;
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
  var valid_579363 = path.getOrDefault("packageName")
  valid_579363 = validateParameter(valid_579363, JString, required = true,
                                 default = nil)
  if valid_579363 != nil:
    section.add "packageName", valid_579363
  var valid_579364 = path.getOrDefault("editId")
  valid_579364 = validateParameter(valid_579364, JString, required = true,
                                 default = nil)
  if valid_579364 != nil:
    section.add "editId", valid_579364
  var valid_579365 = path.getOrDefault("language")
  valid_579365 = validateParameter(valid_579365, JString, required = true,
                                 default = nil)
  if valid_579365 != nil:
    section.add "language", valid_579365
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
  var valid_579366 = query.getOrDefault("key")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "key", valid_579366
  var valid_579367 = query.getOrDefault("prettyPrint")
  valid_579367 = validateParameter(valid_579367, JBool, required = false,
                                 default = newJBool(true))
  if valid_579367 != nil:
    section.add "prettyPrint", valid_579367
  var valid_579368 = query.getOrDefault("oauth_token")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "oauth_token", valid_579368
  var valid_579369 = query.getOrDefault("alt")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = newJString("json"))
  if valid_579369 != nil:
    section.add "alt", valid_579369
  var valid_579370 = query.getOrDefault("userIp")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "userIp", valid_579370
  var valid_579371 = query.getOrDefault("quotaUser")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "quotaUser", valid_579371
  var valid_579372 = query.getOrDefault("fields")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "fields", valid_579372
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

proc call*(call_579374: Call_AndroidpublisherEditsListingsPatch_579360;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a localized store listing. This method supports patch semantics.
  ## 
  let valid = call_579374.validator(path, query, header, formData, body)
  let scheme = call_579374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579374.url(scheme.get, call_579374.host, call_579374.base,
                         call_579374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579374, url, valid)

proc call*(call_579375: Call_AndroidpublisherEditsListingsPatch_579360;
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
  var path_579376 = newJObject()
  var query_579377 = newJObject()
  var body_579378 = newJObject()
  add(query_579377, "key", newJString(key))
  add(query_579377, "prettyPrint", newJBool(prettyPrint))
  add(query_579377, "oauth_token", newJString(oauthToken))
  add(path_579376, "packageName", newJString(packageName))
  add(path_579376, "editId", newJString(editId))
  add(path_579376, "language", newJString(language))
  add(query_579377, "alt", newJString(alt))
  add(query_579377, "userIp", newJString(userIp))
  add(query_579377, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579378 = body
  add(query_579377, "fields", newJString(fields))
  result = call_579375.call(path_579376, query_579377, nil, nil, body_579378)

var androidpublisherEditsListingsPatch* = Call_AndroidpublisherEditsListingsPatch_579360(
    name: "androidpublisherEditsListingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsPatch_579361,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsPatch_579362, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsListingsDelete_579343 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsListingsDelete_579345(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsListingsDelete_579344(path: JsonNode;
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
  var valid_579346 = path.getOrDefault("packageName")
  valid_579346 = validateParameter(valid_579346, JString, required = true,
                                 default = nil)
  if valid_579346 != nil:
    section.add "packageName", valid_579346
  var valid_579347 = path.getOrDefault("editId")
  valid_579347 = validateParameter(valid_579347, JString, required = true,
                                 default = nil)
  if valid_579347 != nil:
    section.add "editId", valid_579347
  var valid_579348 = path.getOrDefault("language")
  valid_579348 = validateParameter(valid_579348, JString, required = true,
                                 default = nil)
  if valid_579348 != nil:
    section.add "language", valid_579348
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
  var valid_579349 = query.getOrDefault("key")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "key", valid_579349
  var valid_579350 = query.getOrDefault("prettyPrint")
  valid_579350 = validateParameter(valid_579350, JBool, required = false,
                                 default = newJBool(true))
  if valid_579350 != nil:
    section.add "prettyPrint", valid_579350
  var valid_579351 = query.getOrDefault("oauth_token")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "oauth_token", valid_579351
  var valid_579352 = query.getOrDefault("alt")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = newJString("json"))
  if valid_579352 != nil:
    section.add "alt", valid_579352
  var valid_579353 = query.getOrDefault("userIp")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "userIp", valid_579353
  var valid_579354 = query.getOrDefault("quotaUser")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "quotaUser", valid_579354
  var valid_579355 = query.getOrDefault("fields")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "fields", valid_579355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579356: Call_AndroidpublisherEditsListingsDelete_579343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified localized store listing from an edit.
  ## 
  let valid = call_579356.validator(path, query, header, formData, body)
  let scheme = call_579356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579356.url(scheme.get, call_579356.host, call_579356.base,
                         call_579356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579356, url, valid)

proc call*(call_579357: Call_AndroidpublisherEditsListingsDelete_579343;
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
  var path_579358 = newJObject()
  var query_579359 = newJObject()
  add(query_579359, "key", newJString(key))
  add(query_579359, "prettyPrint", newJBool(prettyPrint))
  add(query_579359, "oauth_token", newJString(oauthToken))
  add(path_579358, "packageName", newJString(packageName))
  add(path_579358, "editId", newJString(editId))
  add(path_579358, "language", newJString(language))
  add(query_579359, "alt", newJString(alt))
  add(query_579359, "userIp", newJString(userIp))
  add(query_579359, "quotaUser", newJString(quotaUser))
  add(query_579359, "fields", newJString(fields))
  result = call_579357.call(path_579358, query_579359, nil, nil, nil)

var androidpublisherEditsListingsDelete* = Call_AndroidpublisherEditsListingsDelete_579343(
    name: "androidpublisherEditsListingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}",
    validator: validate_AndroidpublisherEditsListingsDelete_579344,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsListingsDelete_579345, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesUpload_579397 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsImagesUpload_579399(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesUpload_579398(path: JsonNode;
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
  var valid_579400 = path.getOrDefault("packageName")
  valid_579400 = validateParameter(valid_579400, JString, required = true,
                                 default = nil)
  if valid_579400 != nil:
    section.add "packageName", valid_579400
  var valid_579401 = path.getOrDefault("editId")
  valid_579401 = validateParameter(valid_579401, JString, required = true,
                                 default = nil)
  if valid_579401 != nil:
    section.add "editId", valid_579401
  var valid_579402 = path.getOrDefault("language")
  valid_579402 = validateParameter(valid_579402, JString, required = true,
                                 default = nil)
  if valid_579402 != nil:
    section.add "language", valid_579402
  var valid_579403 = path.getOrDefault("imageType")
  valid_579403 = validateParameter(valid_579403, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_579403 != nil:
    section.add "imageType", valid_579403
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
  var valid_579404 = query.getOrDefault("key")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "key", valid_579404
  var valid_579405 = query.getOrDefault("prettyPrint")
  valid_579405 = validateParameter(valid_579405, JBool, required = false,
                                 default = newJBool(true))
  if valid_579405 != nil:
    section.add "prettyPrint", valid_579405
  var valid_579406 = query.getOrDefault("oauth_token")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "oauth_token", valid_579406
  var valid_579407 = query.getOrDefault("alt")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = newJString("json"))
  if valid_579407 != nil:
    section.add "alt", valid_579407
  var valid_579408 = query.getOrDefault("userIp")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "userIp", valid_579408
  var valid_579409 = query.getOrDefault("quotaUser")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "quotaUser", valid_579409
  var valid_579410 = query.getOrDefault("fields")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "fields", valid_579410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579411: Call_AndroidpublisherEditsImagesUpload_579397;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a new image and adds it to the list of images for the specified language and image type.
  ## 
  let valid = call_579411.validator(path, query, header, formData, body)
  let scheme = call_579411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579411.url(scheme.get, call_579411.host, call_579411.base,
                         call_579411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579411, url, valid)

proc call*(call_579412: Call_AndroidpublisherEditsImagesUpload_579397;
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
  var path_579413 = newJObject()
  var query_579414 = newJObject()
  add(query_579414, "key", newJString(key))
  add(query_579414, "prettyPrint", newJBool(prettyPrint))
  add(query_579414, "oauth_token", newJString(oauthToken))
  add(path_579413, "packageName", newJString(packageName))
  add(path_579413, "editId", newJString(editId))
  add(path_579413, "language", newJString(language))
  add(query_579414, "alt", newJString(alt))
  add(query_579414, "userIp", newJString(userIp))
  add(query_579414, "quotaUser", newJString(quotaUser))
  add(path_579413, "imageType", newJString(imageType))
  add(query_579414, "fields", newJString(fields))
  result = call_579412.call(path_579413, query_579414, nil, nil, nil)

var androidpublisherEditsImagesUpload* = Call_AndroidpublisherEditsImagesUpload_579397(
    name: "androidpublisherEditsImagesUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesUpload_579398,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesUpload_579399, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesList_579379 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsImagesList_579381(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesList_579380(path: JsonNode;
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
  var valid_579382 = path.getOrDefault("packageName")
  valid_579382 = validateParameter(valid_579382, JString, required = true,
                                 default = nil)
  if valid_579382 != nil:
    section.add "packageName", valid_579382
  var valid_579383 = path.getOrDefault("editId")
  valid_579383 = validateParameter(valid_579383, JString, required = true,
                                 default = nil)
  if valid_579383 != nil:
    section.add "editId", valid_579383
  var valid_579384 = path.getOrDefault("language")
  valid_579384 = validateParameter(valid_579384, JString, required = true,
                                 default = nil)
  if valid_579384 != nil:
    section.add "language", valid_579384
  var valid_579385 = path.getOrDefault("imageType")
  valid_579385 = validateParameter(valid_579385, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_579385 != nil:
    section.add "imageType", valid_579385
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
  var valid_579386 = query.getOrDefault("key")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "key", valid_579386
  var valid_579387 = query.getOrDefault("prettyPrint")
  valid_579387 = validateParameter(valid_579387, JBool, required = false,
                                 default = newJBool(true))
  if valid_579387 != nil:
    section.add "prettyPrint", valid_579387
  var valid_579388 = query.getOrDefault("oauth_token")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "oauth_token", valid_579388
  var valid_579389 = query.getOrDefault("alt")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = newJString("json"))
  if valid_579389 != nil:
    section.add "alt", valid_579389
  var valid_579390 = query.getOrDefault("userIp")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "userIp", valid_579390
  var valid_579391 = query.getOrDefault("quotaUser")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = nil)
  if valid_579391 != nil:
    section.add "quotaUser", valid_579391
  var valid_579392 = query.getOrDefault("fields")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "fields", valid_579392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579393: Call_AndroidpublisherEditsImagesList_579379;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all images for the specified language and image type.
  ## 
  let valid = call_579393.validator(path, query, header, formData, body)
  let scheme = call_579393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579393.url(scheme.get, call_579393.host, call_579393.base,
                         call_579393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579393, url, valid)

proc call*(call_579394: Call_AndroidpublisherEditsImagesList_579379;
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
  var path_579395 = newJObject()
  var query_579396 = newJObject()
  add(query_579396, "key", newJString(key))
  add(query_579396, "prettyPrint", newJBool(prettyPrint))
  add(query_579396, "oauth_token", newJString(oauthToken))
  add(path_579395, "packageName", newJString(packageName))
  add(path_579395, "editId", newJString(editId))
  add(path_579395, "language", newJString(language))
  add(query_579396, "alt", newJString(alt))
  add(query_579396, "userIp", newJString(userIp))
  add(query_579396, "quotaUser", newJString(quotaUser))
  add(path_579395, "imageType", newJString(imageType))
  add(query_579396, "fields", newJString(fields))
  result = call_579394.call(path_579395, query_579396, nil, nil, nil)

var androidpublisherEditsImagesList* = Call_AndroidpublisherEditsImagesList_579379(
    name: "androidpublisherEditsImagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesList_579380,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesList_579381, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDeleteall_579415 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsImagesDeleteall_579417(protocol: Scheme;
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

proc validate_AndroidpublisherEditsImagesDeleteall_579416(path: JsonNode;
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
  var valid_579418 = path.getOrDefault("packageName")
  valid_579418 = validateParameter(valid_579418, JString, required = true,
                                 default = nil)
  if valid_579418 != nil:
    section.add "packageName", valid_579418
  var valid_579419 = path.getOrDefault("editId")
  valid_579419 = validateParameter(valid_579419, JString, required = true,
                                 default = nil)
  if valid_579419 != nil:
    section.add "editId", valid_579419
  var valid_579420 = path.getOrDefault("language")
  valid_579420 = validateParameter(valid_579420, JString, required = true,
                                 default = nil)
  if valid_579420 != nil:
    section.add "language", valid_579420
  var valid_579421 = path.getOrDefault("imageType")
  valid_579421 = validateParameter(valid_579421, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_579421 != nil:
    section.add "imageType", valid_579421
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
  var valid_579422 = query.getOrDefault("key")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "key", valid_579422
  var valid_579423 = query.getOrDefault("prettyPrint")
  valid_579423 = validateParameter(valid_579423, JBool, required = false,
                                 default = newJBool(true))
  if valid_579423 != nil:
    section.add "prettyPrint", valid_579423
  var valid_579424 = query.getOrDefault("oauth_token")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "oauth_token", valid_579424
  var valid_579425 = query.getOrDefault("alt")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = newJString("json"))
  if valid_579425 != nil:
    section.add "alt", valid_579425
  var valid_579426 = query.getOrDefault("userIp")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "userIp", valid_579426
  var valid_579427 = query.getOrDefault("quotaUser")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "quotaUser", valid_579427
  var valid_579428 = query.getOrDefault("fields")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "fields", valid_579428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579429: Call_AndroidpublisherEditsImagesDeleteall_579415;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all images for the specified language and image type.
  ## 
  let valid = call_579429.validator(path, query, header, formData, body)
  let scheme = call_579429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579429.url(scheme.get, call_579429.host, call_579429.base,
                         call_579429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579429, url, valid)

proc call*(call_579430: Call_AndroidpublisherEditsImagesDeleteall_579415;
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
  var path_579431 = newJObject()
  var query_579432 = newJObject()
  add(query_579432, "key", newJString(key))
  add(query_579432, "prettyPrint", newJBool(prettyPrint))
  add(query_579432, "oauth_token", newJString(oauthToken))
  add(path_579431, "packageName", newJString(packageName))
  add(path_579431, "editId", newJString(editId))
  add(path_579431, "language", newJString(language))
  add(query_579432, "alt", newJString(alt))
  add(query_579432, "userIp", newJString(userIp))
  add(query_579432, "quotaUser", newJString(quotaUser))
  add(path_579431, "imageType", newJString(imageType))
  add(query_579432, "fields", newJString(fields))
  result = call_579430.call(path_579431, query_579432, nil, nil, nil)

var androidpublisherEditsImagesDeleteall* = Call_AndroidpublisherEditsImagesDeleteall_579415(
    name: "androidpublisherEditsImagesDeleteall", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}",
    validator: validate_AndroidpublisherEditsImagesDeleteall_579416,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesDeleteall_579417, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsImagesDelete_579433 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsImagesDelete_579435(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsImagesDelete_579434(path: JsonNode;
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
  var valid_579436 = path.getOrDefault("imageId")
  valid_579436 = validateParameter(valid_579436, JString, required = true,
                                 default = nil)
  if valid_579436 != nil:
    section.add "imageId", valid_579436
  var valid_579437 = path.getOrDefault("packageName")
  valid_579437 = validateParameter(valid_579437, JString, required = true,
                                 default = nil)
  if valid_579437 != nil:
    section.add "packageName", valid_579437
  var valid_579438 = path.getOrDefault("editId")
  valid_579438 = validateParameter(valid_579438, JString, required = true,
                                 default = nil)
  if valid_579438 != nil:
    section.add "editId", valid_579438
  var valid_579439 = path.getOrDefault("language")
  valid_579439 = validateParameter(valid_579439, JString, required = true,
                                 default = nil)
  if valid_579439 != nil:
    section.add "language", valid_579439
  var valid_579440 = path.getOrDefault("imageType")
  valid_579440 = validateParameter(valid_579440, JString, required = true,
                                 default = newJString("featureGraphic"))
  if valid_579440 != nil:
    section.add "imageType", valid_579440
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
  var valid_579441 = query.getOrDefault("key")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "key", valid_579441
  var valid_579442 = query.getOrDefault("prettyPrint")
  valid_579442 = validateParameter(valid_579442, JBool, required = false,
                                 default = newJBool(true))
  if valid_579442 != nil:
    section.add "prettyPrint", valid_579442
  var valid_579443 = query.getOrDefault("oauth_token")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "oauth_token", valid_579443
  var valid_579444 = query.getOrDefault("alt")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = newJString("json"))
  if valid_579444 != nil:
    section.add "alt", valid_579444
  var valid_579445 = query.getOrDefault("userIp")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "userIp", valid_579445
  var valid_579446 = query.getOrDefault("quotaUser")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "quotaUser", valid_579446
  var valid_579447 = query.getOrDefault("fields")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "fields", valid_579447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579448: Call_AndroidpublisherEditsImagesDelete_579433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the image (specified by id) from the edit.
  ## 
  let valid = call_579448.validator(path, query, header, formData, body)
  let scheme = call_579448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579448.url(scheme.get, call_579448.host, call_579448.base,
                         call_579448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579448, url, valid)

proc call*(call_579449: Call_AndroidpublisherEditsImagesDelete_579433;
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
  var path_579450 = newJObject()
  var query_579451 = newJObject()
  add(query_579451, "key", newJString(key))
  add(path_579450, "imageId", newJString(imageId))
  add(query_579451, "prettyPrint", newJBool(prettyPrint))
  add(query_579451, "oauth_token", newJString(oauthToken))
  add(path_579450, "packageName", newJString(packageName))
  add(path_579450, "editId", newJString(editId))
  add(path_579450, "language", newJString(language))
  add(query_579451, "alt", newJString(alt))
  add(query_579451, "userIp", newJString(userIp))
  add(query_579451, "quotaUser", newJString(quotaUser))
  add(path_579450, "imageType", newJString(imageType))
  add(query_579451, "fields", newJString(fields))
  result = call_579449.call(path_579450, query_579451, nil, nil, nil)

var androidpublisherEditsImagesDelete* = Call_AndroidpublisherEditsImagesDelete_579433(
    name: "androidpublisherEditsImagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/listings/{language}/{imageType}/{imageId}",
    validator: validate_AndroidpublisherEditsImagesDelete_579434,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsImagesDelete_579435, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersUpdate_579469 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTestersUpdate_579471(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersUpdate_579470(path: JsonNode;
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
  var valid_579472 = path.getOrDefault("packageName")
  valid_579472 = validateParameter(valid_579472, JString, required = true,
                                 default = nil)
  if valid_579472 != nil:
    section.add "packageName", valid_579472
  var valid_579473 = path.getOrDefault("editId")
  valid_579473 = validateParameter(valid_579473, JString, required = true,
                                 default = nil)
  if valid_579473 != nil:
    section.add "editId", valid_579473
  var valid_579474 = path.getOrDefault("track")
  valid_579474 = validateParameter(valid_579474, JString, required = true,
                                 default = nil)
  if valid_579474 != nil:
    section.add "track", valid_579474
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
  var valid_579475 = query.getOrDefault("key")
  valid_579475 = validateParameter(valid_579475, JString, required = false,
                                 default = nil)
  if valid_579475 != nil:
    section.add "key", valid_579475
  var valid_579476 = query.getOrDefault("prettyPrint")
  valid_579476 = validateParameter(valid_579476, JBool, required = false,
                                 default = newJBool(true))
  if valid_579476 != nil:
    section.add "prettyPrint", valid_579476
  var valid_579477 = query.getOrDefault("oauth_token")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "oauth_token", valid_579477
  var valid_579478 = query.getOrDefault("alt")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = newJString("json"))
  if valid_579478 != nil:
    section.add "alt", valid_579478
  var valid_579479 = query.getOrDefault("userIp")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "userIp", valid_579479
  var valid_579480 = query.getOrDefault("quotaUser")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = nil)
  if valid_579480 != nil:
    section.add "quotaUser", valid_579480
  var valid_579481 = query.getOrDefault("fields")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "fields", valid_579481
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

proc call*(call_579483: Call_AndroidpublisherEditsTestersUpdate_579469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_579483.validator(path, query, header, formData, body)
  let scheme = call_579483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579483.url(scheme.get, call_579483.host, call_579483.base,
                         call_579483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579483, url, valid)

proc call*(call_579484: Call_AndroidpublisherEditsTestersUpdate_579469;
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
  var path_579485 = newJObject()
  var query_579486 = newJObject()
  var body_579487 = newJObject()
  add(query_579486, "key", newJString(key))
  add(query_579486, "prettyPrint", newJBool(prettyPrint))
  add(query_579486, "oauth_token", newJString(oauthToken))
  add(path_579485, "packageName", newJString(packageName))
  add(path_579485, "editId", newJString(editId))
  add(path_579485, "track", newJString(track))
  add(query_579486, "alt", newJString(alt))
  add(query_579486, "userIp", newJString(userIp))
  add(query_579486, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579487 = body
  add(query_579486, "fields", newJString(fields))
  result = call_579484.call(path_579485, query_579486, nil, nil, body_579487)

var androidpublisherEditsTestersUpdate* = Call_AndroidpublisherEditsTestersUpdate_579469(
    name: "androidpublisherEditsTestersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersUpdate_579470,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersUpdate_579471, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersGet_579452 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTestersGet_579454(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersGet_579453(path: JsonNode;
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
  var valid_579455 = path.getOrDefault("packageName")
  valid_579455 = validateParameter(valid_579455, JString, required = true,
                                 default = nil)
  if valid_579455 != nil:
    section.add "packageName", valid_579455
  var valid_579456 = path.getOrDefault("editId")
  valid_579456 = validateParameter(valid_579456, JString, required = true,
                                 default = nil)
  if valid_579456 != nil:
    section.add "editId", valid_579456
  var valid_579457 = path.getOrDefault("track")
  valid_579457 = validateParameter(valid_579457, JString, required = true,
                                 default = nil)
  if valid_579457 != nil:
    section.add "track", valid_579457
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
  var valid_579458 = query.getOrDefault("key")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "key", valid_579458
  var valid_579459 = query.getOrDefault("prettyPrint")
  valid_579459 = validateParameter(valid_579459, JBool, required = false,
                                 default = newJBool(true))
  if valid_579459 != nil:
    section.add "prettyPrint", valid_579459
  var valid_579460 = query.getOrDefault("oauth_token")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "oauth_token", valid_579460
  var valid_579461 = query.getOrDefault("alt")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = newJString("json"))
  if valid_579461 != nil:
    section.add "alt", valid_579461
  var valid_579462 = query.getOrDefault("userIp")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "userIp", valid_579462
  var valid_579463 = query.getOrDefault("quotaUser")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "quotaUser", valid_579463
  var valid_579464 = query.getOrDefault("fields")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "fields", valid_579464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579465: Call_AndroidpublisherEditsTestersGet_579452;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_579465.validator(path, query, header, formData, body)
  let scheme = call_579465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579465.url(scheme.get, call_579465.host, call_579465.base,
                         call_579465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579465, url, valid)

proc call*(call_579466: Call_AndroidpublisherEditsTestersGet_579452;
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
  var path_579467 = newJObject()
  var query_579468 = newJObject()
  add(query_579468, "key", newJString(key))
  add(query_579468, "prettyPrint", newJBool(prettyPrint))
  add(query_579468, "oauth_token", newJString(oauthToken))
  add(path_579467, "packageName", newJString(packageName))
  add(path_579467, "editId", newJString(editId))
  add(path_579467, "track", newJString(track))
  add(query_579468, "alt", newJString(alt))
  add(query_579468, "userIp", newJString(userIp))
  add(query_579468, "quotaUser", newJString(quotaUser))
  add(query_579468, "fields", newJString(fields))
  result = call_579466.call(path_579467, query_579468, nil, nil, nil)

var androidpublisherEditsTestersGet* = Call_AndroidpublisherEditsTestersGet_579452(
    name: "androidpublisherEditsTestersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersGet_579453,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersGet_579454, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTestersPatch_579488 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTestersPatch_579490(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTestersPatch_579489(path: JsonNode;
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
  var valid_579491 = path.getOrDefault("packageName")
  valid_579491 = validateParameter(valid_579491, JString, required = true,
                                 default = nil)
  if valid_579491 != nil:
    section.add "packageName", valid_579491
  var valid_579492 = path.getOrDefault("editId")
  valid_579492 = validateParameter(valid_579492, JString, required = true,
                                 default = nil)
  if valid_579492 != nil:
    section.add "editId", valid_579492
  var valid_579493 = path.getOrDefault("track")
  valid_579493 = validateParameter(valid_579493, JString, required = true,
                                 default = nil)
  if valid_579493 != nil:
    section.add "track", valid_579493
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
  var valid_579494 = query.getOrDefault("key")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "key", valid_579494
  var valid_579495 = query.getOrDefault("prettyPrint")
  valid_579495 = validateParameter(valid_579495, JBool, required = false,
                                 default = newJBool(true))
  if valid_579495 != nil:
    section.add "prettyPrint", valid_579495
  var valid_579496 = query.getOrDefault("oauth_token")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "oauth_token", valid_579496
  var valid_579497 = query.getOrDefault("alt")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = newJString("json"))
  if valid_579497 != nil:
    section.add "alt", valid_579497
  var valid_579498 = query.getOrDefault("userIp")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = nil)
  if valid_579498 != nil:
    section.add "userIp", valid_579498
  var valid_579499 = query.getOrDefault("quotaUser")
  valid_579499 = validateParameter(valid_579499, JString, required = false,
                                 default = nil)
  if valid_579499 != nil:
    section.add "quotaUser", valid_579499
  var valid_579500 = query.getOrDefault("fields")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "fields", valid_579500
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

proc call*(call_579502: Call_AndroidpublisherEditsTestersPatch_579488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_579502.validator(path, query, header, formData, body)
  let scheme = call_579502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579502.url(scheme.get, call_579502.host, call_579502.base,
                         call_579502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579502, url, valid)

proc call*(call_579503: Call_AndroidpublisherEditsTestersPatch_579488;
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
  var path_579504 = newJObject()
  var query_579505 = newJObject()
  var body_579506 = newJObject()
  add(query_579505, "key", newJString(key))
  add(query_579505, "prettyPrint", newJBool(prettyPrint))
  add(query_579505, "oauth_token", newJString(oauthToken))
  add(path_579504, "packageName", newJString(packageName))
  add(path_579504, "editId", newJString(editId))
  add(path_579504, "track", newJString(track))
  add(query_579505, "alt", newJString(alt))
  add(query_579505, "userIp", newJString(userIp))
  add(query_579505, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579506 = body
  add(query_579505, "fields", newJString(fields))
  result = call_579503.call(path_579504, query_579505, nil, nil, body_579506)

var androidpublisherEditsTestersPatch* = Call_AndroidpublisherEditsTestersPatch_579488(
    name: "androidpublisherEditsTestersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/testers/{track}",
    validator: validate_AndroidpublisherEditsTestersPatch_579489,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTestersPatch_579490, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksList_579507 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTracksList_579509(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksList_579508(path: JsonNode;
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
  var valid_579510 = path.getOrDefault("packageName")
  valid_579510 = validateParameter(valid_579510, JString, required = true,
                                 default = nil)
  if valid_579510 != nil:
    section.add "packageName", valid_579510
  var valid_579511 = path.getOrDefault("editId")
  valid_579511 = validateParameter(valid_579511, JString, required = true,
                                 default = nil)
  if valid_579511 != nil:
    section.add "editId", valid_579511
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
  var valid_579512 = query.getOrDefault("key")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "key", valid_579512
  var valid_579513 = query.getOrDefault("prettyPrint")
  valid_579513 = validateParameter(valid_579513, JBool, required = false,
                                 default = newJBool(true))
  if valid_579513 != nil:
    section.add "prettyPrint", valid_579513
  var valid_579514 = query.getOrDefault("oauth_token")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "oauth_token", valid_579514
  var valid_579515 = query.getOrDefault("alt")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = newJString("json"))
  if valid_579515 != nil:
    section.add "alt", valid_579515
  var valid_579516 = query.getOrDefault("userIp")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "userIp", valid_579516
  var valid_579517 = query.getOrDefault("quotaUser")
  valid_579517 = validateParameter(valid_579517, JString, required = false,
                                 default = nil)
  if valid_579517 != nil:
    section.add "quotaUser", valid_579517
  var valid_579518 = query.getOrDefault("fields")
  valid_579518 = validateParameter(valid_579518, JString, required = false,
                                 default = nil)
  if valid_579518 != nil:
    section.add "fields", valid_579518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579519: Call_AndroidpublisherEditsTracksList_579507;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the track configurations for this edit.
  ## 
  let valid = call_579519.validator(path, query, header, formData, body)
  let scheme = call_579519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579519.url(scheme.get, call_579519.host, call_579519.base,
                         call_579519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579519, url, valid)

proc call*(call_579520: Call_AndroidpublisherEditsTracksList_579507;
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
  var path_579521 = newJObject()
  var query_579522 = newJObject()
  add(query_579522, "key", newJString(key))
  add(query_579522, "prettyPrint", newJBool(prettyPrint))
  add(query_579522, "oauth_token", newJString(oauthToken))
  add(path_579521, "packageName", newJString(packageName))
  add(path_579521, "editId", newJString(editId))
  add(query_579522, "alt", newJString(alt))
  add(query_579522, "userIp", newJString(userIp))
  add(query_579522, "quotaUser", newJString(quotaUser))
  add(query_579522, "fields", newJString(fields))
  result = call_579520.call(path_579521, query_579522, nil, nil, nil)

var androidpublisherEditsTracksList* = Call_AndroidpublisherEditsTracksList_579507(
    name: "androidpublisherEditsTracksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}/tracks",
    validator: validate_AndroidpublisherEditsTracksList_579508,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksList_579509, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksUpdate_579540 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTracksUpdate_579542(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksUpdate_579541(path: JsonNode;
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
  var valid_579543 = path.getOrDefault("packageName")
  valid_579543 = validateParameter(valid_579543, JString, required = true,
                                 default = nil)
  if valid_579543 != nil:
    section.add "packageName", valid_579543
  var valid_579544 = path.getOrDefault("editId")
  valid_579544 = validateParameter(valid_579544, JString, required = true,
                                 default = nil)
  if valid_579544 != nil:
    section.add "editId", valid_579544
  var valid_579545 = path.getOrDefault("track")
  valid_579545 = validateParameter(valid_579545, JString, required = true,
                                 default = nil)
  if valid_579545 != nil:
    section.add "track", valid_579545
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
  var valid_579546 = query.getOrDefault("key")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "key", valid_579546
  var valid_579547 = query.getOrDefault("prettyPrint")
  valid_579547 = validateParameter(valid_579547, JBool, required = false,
                                 default = newJBool(true))
  if valid_579547 != nil:
    section.add "prettyPrint", valid_579547
  var valid_579548 = query.getOrDefault("oauth_token")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = nil)
  if valid_579548 != nil:
    section.add "oauth_token", valid_579548
  var valid_579549 = query.getOrDefault("alt")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = newJString("json"))
  if valid_579549 != nil:
    section.add "alt", valid_579549
  var valid_579550 = query.getOrDefault("userIp")
  valid_579550 = validateParameter(valid_579550, JString, required = false,
                                 default = nil)
  if valid_579550 != nil:
    section.add "userIp", valid_579550
  var valid_579551 = query.getOrDefault("quotaUser")
  valid_579551 = validateParameter(valid_579551, JString, required = false,
                                 default = nil)
  if valid_579551 != nil:
    section.add "quotaUser", valid_579551
  var valid_579552 = query.getOrDefault("fields")
  valid_579552 = validateParameter(valid_579552, JString, required = false,
                                 default = nil)
  if valid_579552 != nil:
    section.add "fields", valid_579552
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

proc call*(call_579554: Call_AndroidpublisherEditsTracksUpdate_579540;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type.
  ## 
  let valid = call_579554.validator(path, query, header, formData, body)
  let scheme = call_579554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579554.url(scheme.get, call_579554.host, call_579554.base,
                         call_579554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579554, url, valid)

proc call*(call_579555: Call_AndroidpublisherEditsTracksUpdate_579540;
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
  var path_579556 = newJObject()
  var query_579557 = newJObject()
  var body_579558 = newJObject()
  add(query_579557, "key", newJString(key))
  add(query_579557, "prettyPrint", newJBool(prettyPrint))
  add(query_579557, "oauth_token", newJString(oauthToken))
  add(path_579556, "packageName", newJString(packageName))
  add(path_579556, "editId", newJString(editId))
  add(path_579556, "track", newJString(track))
  add(query_579557, "alt", newJString(alt))
  add(query_579557, "userIp", newJString(userIp))
  add(query_579557, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579558 = body
  add(query_579557, "fields", newJString(fields))
  result = call_579555.call(path_579556, query_579557, nil, nil, body_579558)

var androidpublisherEditsTracksUpdate* = Call_AndroidpublisherEditsTracksUpdate_579540(
    name: "androidpublisherEditsTracksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksUpdate_579541,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksUpdate_579542, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksGet_579523 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTracksGet_579525(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksGet_579524(path: JsonNode;
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
  var valid_579526 = path.getOrDefault("packageName")
  valid_579526 = validateParameter(valid_579526, JString, required = true,
                                 default = nil)
  if valid_579526 != nil:
    section.add "packageName", valid_579526
  var valid_579527 = path.getOrDefault("editId")
  valid_579527 = validateParameter(valid_579527, JString, required = true,
                                 default = nil)
  if valid_579527 != nil:
    section.add "editId", valid_579527
  var valid_579528 = path.getOrDefault("track")
  valid_579528 = validateParameter(valid_579528, JString, required = true,
                                 default = nil)
  if valid_579528 != nil:
    section.add "track", valid_579528
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
  var valid_579529 = query.getOrDefault("key")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "key", valid_579529
  var valid_579530 = query.getOrDefault("prettyPrint")
  valid_579530 = validateParameter(valid_579530, JBool, required = false,
                                 default = newJBool(true))
  if valid_579530 != nil:
    section.add "prettyPrint", valid_579530
  var valid_579531 = query.getOrDefault("oauth_token")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "oauth_token", valid_579531
  var valid_579532 = query.getOrDefault("alt")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = newJString("json"))
  if valid_579532 != nil:
    section.add "alt", valid_579532
  var valid_579533 = query.getOrDefault("userIp")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "userIp", valid_579533
  var valid_579534 = query.getOrDefault("quotaUser")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "quotaUser", valid_579534
  var valid_579535 = query.getOrDefault("fields")
  valid_579535 = validateParameter(valid_579535, JString, required = false,
                                 default = nil)
  if valid_579535 != nil:
    section.add "fields", valid_579535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579536: Call_AndroidpublisherEditsTracksGet_579523; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the track configuration for the specified track type. Includes the APK version codes that are in this track.
  ## 
  let valid = call_579536.validator(path, query, header, formData, body)
  let scheme = call_579536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579536.url(scheme.get, call_579536.host, call_579536.base,
                         call_579536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579536, url, valid)

proc call*(call_579537: Call_AndroidpublisherEditsTracksGet_579523;
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
  var path_579538 = newJObject()
  var query_579539 = newJObject()
  add(query_579539, "key", newJString(key))
  add(query_579539, "prettyPrint", newJBool(prettyPrint))
  add(query_579539, "oauth_token", newJString(oauthToken))
  add(path_579538, "packageName", newJString(packageName))
  add(path_579538, "editId", newJString(editId))
  add(path_579538, "track", newJString(track))
  add(query_579539, "alt", newJString(alt))
  add(query_579539, "userIp", newJString(userIp))
  add(query_579539, "quotaUser", newJString(quotaUser))
  add(query_579539, "fields", newJString(fields))
  result = call_579537.call(path_579538, query_579539, nil, nil, nil)

var androidpublisherEditsTracksGet* = Call_AndroidpublisherEditsTracksGet_579523(
    name: "androidpublisherEditsTracksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksGet_579524,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksGet_579525, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsTracksPatch_579559 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsTracksPatch_579561(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsTracksPatch_579560(path: JsonNode;
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
  var valid_579562 = path.getOrDefault("packageName")
  valid_579562 = validateParameter(valid_579562, JString, required = true,
                                 default = nil)
  if valid_579562 != nil:
    section.add "packageName", valid_579562
  var valid_579563 = path.getOrDefault("editId")
  valid_579563 = validateParameter(valid_579563, JString, required = true,
                                 default = nil)
  if valid_579563 != nil:
    section.add "editId", valid_579563
  var valid_579564 = path.getOrDefault("track")
  valid_579564 = validateParameter(valid_579564, JString, required = true,
                                 default = nil)
  if valid_579564 != nil:
    section.add "track", valid_579564
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
  var valid_579565 = query.getOrDefault("key")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = nil)
  if valid_579565 != nil:
    section.add "key", valid_579565
  var valid_579566 = query.getOrDefault("prettyPrint")
  valid_579566 = validateParameter(valid_579566, JBool, required = false,
                                 default = newJBool(true))
  if valid_579566 != nil:
    section.add "prettyPrint", valid_579566
  var valid_579567 = query.getOrDefault("oauth_token")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = nil)
  if valid_579567 != nil:
    section.add "oauth_token", valid_579567
  var valid_579568 = query.getOrDefault("alt")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = newJString("json"))
  if valid_579568 != nil:
    section.add "alt", valid_579568
  var valid_579569 = query.getOrDefault("userIp")
  valid_579569 = validateParameter(valid_579569, JString, required = false,
                                 default = nil)
  if valid_579569 != nil:
    section.add "userIp", valid_579569
  var valid_579570 = query.getOrDefault("quotaUser")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "quotaUser", valid_579570
  var valid_579571 = query.getOrDefault("fields")
  valid_579571 = validateParameter(valid_579571, JString, required = false,
                                 default = nil)
  if valid_579571 != nil:
    section.add "fields", valid_579571
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

proc call*(call_579573: Call_AndroidpublisherEditsTracksPatch_579559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the track configuration for the specified track type. This method supports patch semantics.
  ## 
  let valid = call_579573.validator(path, query, header, formData, body)
  let scheme = call_579573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579573.url(scheme.get, call_579573.host, call_579573.base,
                         call_579573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579573, url, valid)

proc call*(call_579574: Call_AndroidpublisherEditsTracksPatch_579559;
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
  var path_579575 = newJObject()
  var query_579576 = newJObject()
  var body_579577 = newJObject()
  add(query_579576, "key", newJString(key))
  add(query_579576, "prettyPrint", newJBool(prettyPrint))
  add(query_579576, "oauth_token", newJString(oauthToken))
  add(path_579575, "packageName", newJString(packageName))
  add(path_579575, "editId", newJString(editId))
  add(path_579575, "track", newJString(track))
  add(query_579576, "alt", newJString(alt))
  add(query_579576, "userIp", newJString(userIp))
  add(query_579576, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579577 = body
  add(query_579576, "fields", newJString(fields))
  result = call_579574.call(path_579575, query_579576, nil, nil, body_579577)

var androidpublisherEditsTracksPatch* = Call_AndroidpublisherEditsTracksPatch_579559(
    name: "androidpublisherEditsTracksPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{packageName}/edits/{editId}/tracks/{track}",
    validator: validate_AndroidpublisherEditsTracksPatch_579560,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsTracksPatch_579561, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsCommit_579578 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsCommit_579580(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsCommit_579579(path: JsonNode; query: JsonNode;
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
  var valid_579581 = path.getOrDefault("packageName")
  valid_579581 = validateParameter(valid_579581, JString, required = true,
                                 default = nil)
  if valid_579581 != nil:
    section.add "packageName", valid_579581
  var valid_579582 = path.getOrDefault("editId")
  valid_579582 = validateParameter(valid_579582, JString, required = true,
                                 default = nil)
  if valid_579582 != nil:
    section.add "editId", valid_579582
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
  var valid_579583 = query.getOrDefault("key")
  valid_579583 = validateParameter(valid_579583, JString, required = false,
                                 default = nil)
  if valid_579583 != nil:
    section.add "key", valid_579583
  var valid_579584 = query.getOrDefault("prettyPrint")
  valid_579584 = validateParameter(valid_579584, JBool, required = false,
                                 default = newJBool(true))
  if valid_579584 != nil:
    section.add "prettyPrint", valid_579584
  var valid_579585 = query.getOrDefault("oauth_token")
  valid_579585 = validateParameter(valid_579585, JString, required = false,
                                 default = nil)
  if valid_579585 != nil:
    section.add "oauth_token", valid_579585
  var valid_579586 = query.getOrDefault("alt")
  valid_579586 = validateParameter(valid_579586, JString, required = false,
                                 default = newJString("json"))
  if valid_579586 != nil:
    section.add "alt", valid_579586
  var valid_579587 = query.getOrDefault("userIp")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = nil)
  if valid_579587 != nil:
    section.add "userIp", valid_579587
  var valid_579588 = query.getOrDefault("quotaUser")
  valid_579588 = validateParameter(valid_579588, JString, required = false,
                                 default = nil)
  if valid_579588 != nil:
    section.add "quotaUser", valid_579588
  var valid_579589 = query.getOrDefault("fields")
  valid_579589 = validateParameter(valid_579589, JString, required = false,
                                 default = nil)
  if valid_579589 != nil:
    section.add "fields", valid_579589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579590: Call_AndroidpublisherEditsCommit_579578; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commits/applies the changes made in this edit back to the app.
  ## 
  let valid = call_579590.validator(path, query, header, formData, body)
  let scheme = call_579590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579590.url(scheme.get, call_579590.host, call_579590.base,
                         call_579590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579590, url, valid)

proc call*(call_579591: Call_AndroidpublisherEditsCommit_579578;
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
  var path_579592 = newJObject()
  var query_579593 = newJObject()
  add(query_579593, "key", newJString(key))
  add(query_579593, "prettyPrint", newJBool(prettyPrint))
  add(query_579593, "oauth_token", newJString(oauthToken))
  add(path_579592, "packageName", newJString(packageName))
  add(path_579592, "editId", newJString(editId))
  add(query_579593, "alt", newJString(alt))
  add(query_579593, "userIp", newJString(userIp))
  add(query_579593, "quotaUser", newJString(quotaUser))
  add(query_579593, "fields", newJString(fields))
  result = call_579591.call(path_579592, query_579593, nil, nil, nil)

var androidpublisherEditsCommit* = Call_AndroidpublisherEditsCommit_579578(
    name: "androidpublisherEditsCommit", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:commit",
    validator: validate_AndroidpublisherEditsCommit_579579,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsCommit_579580, schemes: {Scheme.Https})
type
  Call_AndroidpublisherEditsValidate_579594 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherEditsValidate_579596(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherEditsValidate_579595(path: JsonNode; query: JsonNode;
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
  var valid_579597 = path.getOrDefault("packageName")
  valid_579597 = validateParameter(valid_579597, JString, required = true,
                                 default = nil)
  if valid_579597 != nil:
    section.add "packageName", valid_579597
  var valid_579598 = path.getOrDefault("editId")
  valid_579598 = validateParameter(valid_579598, JString, required = true,
                                 default = nil)
  if valid_579598 != nil:
    section.add "editId", valid_579598
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
  var valid_579599 = query.getOrDefault("key")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = nil)
  if valid_579599 != nil:
    section.add "key", valid_579599
  var valid_579600 = query.getOrDefault("prettyPrint")
  valid_579600 = validateParameter(valid_579600, JBool, required = false,
                                 default = newJBool(true))
  if valid_579600 != nil:
    section.add "prettyPrint", valid_579600
  var valid_579601 = query.getOrDefault("oauth_token")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "oauth_token", valid_579601
  var valid_579602 = query.getOrDefault("alt")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = newJString("json"))
  if valid_579602 != nil:
    section.add "alt", valid_579602
  var valid_579603 = query.getOrDefault("userIp")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = nil)
  if valid_579603 != nil:
    section.add "userIp", valid_579603
  var valid_579604 = query.getOrDefault("quotaUser")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = nil)
  if valid_579604 != nil:
    section.add "quotaUser", valid_579604
  var valid_579605 = query.getOrDefault("fields")
  valid_579605 = validateParameter(valid_579605, JString, required = false,
                                 default = nil)
  if valid_579605 != nil:
    section.add "fields", valid_579605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579606: Call_AndroidpublisherEditsValidate_579594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that the edit can be successfully committed. The edit's changes are not applied to the live app.
  ## 
  let valid = call_579606.validator(path, query, header, formData, body)
  let scheme = call_579606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579606.url(scheme.get, call_579606.host, call_579606.base,
                         call_579606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579606, url, valid)

proc call*(call_579607: Call_AndroidpublisherEditsValidate_579594;
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
  var path_579608 = newJObject()
  var query_579609 = newJObject()
  add(query_579609, "key", newJString(key))
  add(query_579609, "prettyPrint", newJBool(prettyPrint))
  add(query_579609, "oauth_token", newJString(oauthToken))
  add(path_579608, "packageName", newJString(packageName))
  add(path_579608, "editId", newJString(editId))
  add(query_579609, "alt", newJString(alt))
  add(query_579609, "userIp", newJString(userIp))
  add(query_579609, "quotaUser", newJString(quotaUser))
  add(query_579609, "fields", newJString(fields))
  result = call_579607.call(path_579608, query_579609, nil, nil, nil)

var androidpublisherEditsValidate* = Call_AndroidpublisherEditsValidate_579594(
    name: "androidpublisherEditsValidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/edits/{editId}:validate",
    validator: validate_AndroidpublisherEditsValidate_579595,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherEditsValidate_579596, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsInsert_579628 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsInsert_579630(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsInsert_579629(path: JsonNode;
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
  var valid_579631 = path.getOrDefault("packageName")
  valid_579631 = validateParameter(valid_579631, JString, required = true,
                                 default = nil)
  if valid_579631 != nil:
    section.add "packageName", valid_579631
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
  var valid_579632 = query.getOrDefault("key")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = nil)
  if valid_579632 != nil:
    section.add "key", valid_579632
  var valid_579633 = query.getOrDefault("prettyPrint")
  valid_579633 = validateParameter(valid_579633, JBool, required = false,
                                 default = newJBool(true))
  if valid_579633 != nil:
    section.add "prettyPrint", valid_579633
  var valid_579634 = query.getOrDefault("oauth_token")
  valid_579634 = validateParameter(valid_579634, JString, required = false,
                                 default = nil)
  if valid_579634 != nil:
    section.add "oauth_token", valid_579634
  var valid_579635 = query.getOrDefault("alt")
  valid_579635 = validateParameter(valid_579635, JString, required = false,
                                 default = newJString("json"))
  if valid_579635 != nil:
    section.add "alt", valid_579635
  var valid_579636 = query.getOrDefault("userIp")
  valid_579636 = validateParameter(valid_579636, JString, required = false,
                                 default = nil)
  if valid_579636 != nil:
    section.add "userIp", valid_579636
  var valid_579637 = query.getOrDefault("quotaUser")
  valid_579637 = validateParameter(valid_579637, JString, required = false,
                                 default = nil)
  if valid_579637 != nil:
    section.add "quotaUser", valid_579637
  var valid_579638 = query.getOrDefault("autoConvertMissingPrices")
  valid_579638 = validateParameter(valid_579638, JBool, required = false, default = nil)
  if valid_579638 != nil:
    section.add "autoConvertMissingPrices", valid_579638
  var valid_579639 = query.getOrDefault("fields")
  valid_579639 = validateParameter(valid_579639, JString, required = false,
                                 default = nil)
  if valid_579639 != nil:
    section.add "fields", valid_579639
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

proc call*(call_579641: Call_AndroidpublisherInappproductsInsert_579628;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new in-app product for an app.
  ## 
  let valid = call_579641.validator(path, query, header, formData, body)
  let scheme = call_579641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579641.url(scheme.get, call_579641.host, call_579641.base,
                         call_579641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579641, url, valid)

proc call*(call_579642: Call_AndroidpublisherInappproductsInsert_579628;
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
  var path_579643 = newJObject()
  var query_579644 = newJObject()
  var body_579645 = newJObject()
  add(query_579644, "key", newJString(key))
  add(query_579644, "prettyPrint", newJBool(prettyPrint))
  add(query_579644, "oauth_token", newJString(oauthToken))
  add(path_579643, "packageName", newJString(packageName))
  add(query_579644, "alt", newJString(alt))
  add(query_579644, "userIp", newJString(userIp))
  add(query_579644, "quotaUser", newJString(quotaUser))
  add(query_579644, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_579645 = body
  add(query_579644, "fields", newJString(fields))
  result = call_579642.call(path_579643, query_579644, nil, nil, body_579645)

var androidpublisherInappproductsInsert* = Call_AndroidpublisherInappproductsInsert_579628(
    name: "androidpublisherInappproductsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsInsert_579629,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsInsert_579630, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsList_579610 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsList_579612(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsList_579611(path: JsonNode;
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
  var valid_579613 = path.getOrDefault("packageName")
  valid_579613 = validateParameter(valid_579613, JString, required = true,
                                 default = nil)
  if valid_579613 != nil:
    section.add "packageName", valid_579613
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
  var valid_579614 = query.getOrDefault("key")
  valid_579614 = validateParameter(valid_579614, JString, required = false,
                                 default = nil)
  if valid_579614 != nil:
    section.add "key", valid_579614
  var valid_579615 = query.getOrDefault("prettyPrint")
  valid_579615 = validateParameter(valid_579615, JBool, required = false,
                                 default = newJBool(true))
  if valid_579615 != nil:
    section.add "prettyPrint", valid_579615
  var valid_579616 = query.getOrDefault("oauth_token")
  valid_579616 = validateParameter(valid_579616, JString, required = false,
                                 default = nil)
  if valid_579616 != nil:
    section.add "oauth_token", valid_579616
  var valid_579617 = query.getOrDefault("alt")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = newJString("json"))
  if valid_579617 != nil:
    section.add "alt", valid_579617
  var valid_579618 = query.getOrDefault("userIp")
  valid_579618 = validateParameter(valid_579618, JString, required = false,
                                 default = nil)
  if valid_579618 != nil:
    section.add "userIp", valid_579618
  var valid_579619 = query.getOrDefault("quotaUser")
  valid_579619 = validateParameter(valid_579619, JString, required = false,
                                 default = nil)
  if valid_579619 != nil:
    section.add "quotaUser", valid_579619
  var valid_579620 = query.getOrDefault("startIndex")
  valid_579620 = validateParameter(valid_579620, JInt, required = false, default = nil)
  if valid_579620 != nil:
    section.add "startIndex", valid_579620
  var valid_579621 = query.getOrDefault("token")
  valid_579621 = validateParameter(valid_579621, JString, required = false,
                                 default = nil)
  if valid_579621 != nil:
    section.add "token", valid_579621
  var valid_579622 = query.getOrDefault("fields")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "fields", valid_579622
  var valid_579623 = query.getOrDefault("maxResults")
  valid_579623 = validateParameter(valid_579623, JInt, required = false, default = nil)
  if valid_579623 != nil:
    section.add "maxResults", valid_579623
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579624: Call_AndroidpublisherInappproductsList_579610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the in-app products for an Android app, both subscriptions and managed in-app products..
  ## 
  let valid = call_579624.validator(path, query, header, formData, body)
  let scheme = call_579624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579624.url(scheme.get, call_579624.host, call_579624.base,
                         call_579624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579624, url, valid)

proc call*(call_579625: Call_AndroidpublisherInappproductsList_579610;
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
  var path_579626 = newJObject()
  var query_579627 = newJObject()
  add(query_579627, "key", newJString(key))
  add(query_579627, "prettyPrint", newJBool(prettyPrint))
  add(query_579627, "oauth_token", newJString(oauthToken))
  add(path_579626, "packageName", newJString(packageName))
  add(query_579627, "alt", newJString(alt))
  add(query_579627, "userIp", newJString(userIp))
  add(query_579627, "quotaUser", newJString(quotaUser))
  add(query_579627, "startIndex", newJInt(startIndex))
  add(query_579627, "token", newJString(token))
  add(query_579627, "fields", newJString(fields))
  add(query_579627, "maxResults", newJInt(maxResults))
  result = call_579625.call(path_579626, query_579627, nil, nil, nil)

var androidpublisherInappproductsList* = Call_AndroidpublisherInappproductsList_579610(
    name: "androidpublisherInappproductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts",
    validator: validate_AndroidpublisherInappproductsList_579611,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsList_579612, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsUpdate_579662 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsUpdate_579664(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsUpdate_579663(path: JsonNode;
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
  var valid_579665 = path.getOrDefault("packageName")
  valid_579665 = validateParameter(valid_579665, JString, required = true,
                                 default = nil)
  if valid_579665 != nil:
    section.add "packageName", valid_579665
  var valid_579666 = path.getOrDefault("sku")
  valid_579666 = validateParameter(valid_579666, JString, required = true,
                                 default = nil)
  if valid_579666 != nil:
    section.add "sku", valid_579666
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
  var valid_579667 = query.getOrDefault("key")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = nil)
  if valid_579667 != nil:
    section.add "key", valid_579667
  var valid_579668 = query.getOrDefault("prettyPrint")
  valid_579668 = validateParameter(valid_579668, JBool, required = false,
                                 default = newJBool(true))
  if valid_579668 != nil:
    section.add "prettyPrint", valid_579668
  var valid_579669 = query.getOrDefault("oauth_token")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = nil)
  if valid_579669 != nil:
    section.add "oauth_token", valid_579669
  var valid_579670 = query.getOrDefault("alt")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = newJString("json"))
  if valid_579670 != nil:
    section.add "alt", valid_579670
  var valid_579671 = query.getOrDefault("userIp")
  valid_579671 = validateParameter(valid_579671, JString, required = false,
                                 default = nil)
  if valid_579671 != nil:
    section.add "userIp", valid_579671
  var valid_579672 = query.getOrDefault("quotaUser")
  valid_579672 = validateParameter(valid_579672, JString, required = false,
                                 default = nil)
  if valid_579672 != nil:
    section.add "quotaUser", valid_579672
  var valid_579673 = query.getOrDefault("autoConvertMissingPrices")
  valid_579673 = validateParameter(valid_579673, JBool, required = false, default = nil)
  if valid_579673 != nil:
    section.add "autoConvertMissingPrices", valid_579673
  var valid_579674 = query.getOrDefault("fields")
  valid_579674 = validateParameter(valid_579674, JString, required = false,
                                 default = nil)
  if valid_579674 != nil:
    section.add "fields", valid_579674
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

proc call*(call_579676: Call_AndroidpublisherInappproductsUpdate_579662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product.
  ## 
  let valid = call_579676.validator(path, query, header, formData, body)
  let scheme = call_579676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579676.url(scheme.get, call_579676.host, call_579676.base,
                         call_579676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579676, url, valid)

proc call*(call_579677: Call_AndroidpublisherInappproductsUpdate_579662;
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
  var path_579678 = newJObject()
  var query_579679 = newJObject()
  var body_579680 = newJObject()
  add(query_579679, "key", newJString(key))
  add(query_579679, "prettyPrint", newJBool(prettyPrint))
  add(query_579679, "oauth_token", newJString(oauthToken))
  add(path_579678, "packageName", newJString(packageName))
  add(query_579679, "alt", newJString(alt))
  add(query_579679, "userIp", newJString(userIp))
  add(path_579678, "sku", newJString(sku))
  add(query_579679, "quotaUser", newJString(quotaUser))
  add(query_579679, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_579680 = body
  add(query_579679, "fields", newJString(fields))
  result = call_579677.call(path_579678, query_579679, nil, nil, body_579680)

var androidpublisherInappproductsUpdate* = Call_AndroidpublisherInappproductsUpdate_579662(
    name: "androidpublisherInappproductsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsUpdate_579663,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsUpdate_579664, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsGet_579646 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsGet_579648(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsGet_579647(path: JsonNode;
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
  var valid_579649 = path.getOrDefault("packageName")
  valid_579649 = validateParameter(valid_579649, JString, required = true,
                                 default = nil)
  if valid_579649 != nil:
    section.add "packageName", valid_579649
  var valid_579650 = path.getOrDefault("sku")
  valid_579650 = validateParameter(valid_579650, JString, required = true,
                                 default = nil)
  if valid_579650 != nil:
    section.add "sku", valid_579650
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
  var valid_579651 = query.getOrDefault("key")
  valid_579651 = validateParameter(valid_579651, JString, required = false,
                                 default = nil)
  if valid_579651 != nil:
    section.add "key", valid_579651
  var valid_579652 = query.getOrDefault("prettyPrint")
  valid_579652 = validateParameter(valid_579652, JBool, required = false,
                                 default = newJBool(true))
  if valid_579652 != nil:
    section.add "prettyPrint", valid_579652
  var valid_579653 = query.getOrDefault("oauth_token")
  valid_579653 = validateParameter(valid_579653, JString, required = false,
                                 default = nil)
  if valid_579653 != nil:
    section.add "oauth_token", valid_579653
  var valid_579654 = query.getOrDefault("alt")
  valid_579654 = validateParameter(valid_579654, JString, required = false,
                                 default = newJString("json"))
  if valid_579654 != nil:
    section.add "alt", valid_579654
  var valid_579655 = query.getOrDefault("userIp")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "userIp", valid_579655
  var valid_579656 = query.getOrDefault("quotaUser")
  valid_579656 = validateParameter(valid_579656, JString, required = false,
                                 default = nil)
  if valid_579656 != nil:
    section.add "quotaUser", valid_579656
  var valid_579657 = query.getOrDefault("fields")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "fields", valid_579657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579658: Call_AndroidpublisherInappproductsGet_579646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the in-app product specified.
  ## 
  let valid = call_579658.validator(path, query, header, formData, body)
  let scheme = call_579658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579658.url(scheme.get, call_579658.host, call_579658.base,
                         call_579658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579658, url, valid)

proc call*(call_579659: Call_AndroidpublisherInappproductsGet_579646;
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
  var path_579660 = newJObject()
  var query_579661 = newJObject()
  add(query_579661, "key", newJString(key))
  add(query_579661, "prettyPrint", newJBool(prettyPrint))
  add(query_579661, "oauth_token", newJString(oauthToken))
  add(path_579660, "packageName", newJString(packageName))
  add(query_579661, "alt", newJString(alt))
  add(query_579661, "userIp", newJString(userIp))
  add(path_579660, "sku", newJString(sku))
  add(query_579661, "quotaUser", newJString(quotaUser))
  add(query_579661, "fields", newJString(fields))
  result = call_579659.call(path_579660, query_579661, nil, nil, nil)

var androidpublisherInappproductsGet* = Call_AndroidpublisherInappproductsGet_579646(
    name: "androidpublisherInappproductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsGet_579647,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsGet_579648, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsPatch_579697 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsPatch_579699(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsPatch_579698(path: JsonNode;
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
  var valid_579700 = path.getOrDefault("packageName")
  valid_579700 = validateParameter(valid_579700, JString, required = true,
                                 default = nil)
  if valid_579700 != nil:
    section.add "packageName", valid_579700
  var valid_579701 = path.getOrDefault("sku")
  valid_579701 = validateParameter(valid_579701, JString, required = true,
                                 default = nil)
  if valid_579701 != nil:
    section.add "sku", valid_579701
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
  var valid_579702 = query.getOrDefault("key")
  valid_579702 = validateParameter(valid_579702, JString, required = false,
                                 default = nil)
  if valid_579702 != nil:
    section.add "key", valid_579702
  var valid_579703 = query.getOrDefault("prettyPrint")
  valid_579703 = validateParameter(valid_579703, JBool, required = false,
                                 default = newJBool(true))
  if valid_579703 != nil:
    section.add "prettyPrint", valid_579703
  var valid_579704 = query.getOrDefault("oauth_token")
  valid_579704 = validateParameter(valid_579704, JString, required = false,
                                 default = nil)
  if valid_579704 != nil:
    section.add "oauth_token", valid_579704
  var valid_579705 = query.getOrDefault("alt")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = newJString("json"))
  if valid_579705 != nil:
    section.add "alt", valid_579705
  var valid_579706 = query.getOrDefault("userIp")
  valid_579706 = validateParameter(valid_579706, JString, required = false,
                                 default = nil)
  if valid_579706 != nil:
    section.add "userIp", valid_579706
  var valid_579707 = query.getOrDefault("quotaUser")
  valid_579707 = validateParameter(valid_579707, JString, required = false,
                                 default = nil)
  if valid_579707 != nil:
    section.add "quotaUser", valid_579707
  var valid_579708 = query.getOrDefault("autoConvertMissingPrices")
  valid_579708 = validateParameter(valid_579708, JBool, required = false, default = nil)
  if valid_579708 != nil:
    section.add "autoConvertMissingPrices", valid_579708
  var valid_579709 = query.getOrDefault("fields")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = nil)
  if valid_579709 != nil:
    section.add "fields", valid_579709
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

proc call*(call_579711: Call_AndroidpublisherInappproductsPatch_579697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the details of an in-app product. This method supports patch semantics.
  ## 
  let valid = call_579711.validator(path, query, header, formData, body)
  let scheme = call_579711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579711.url(scheme.get, call_579711.host, call_579711.base,
                         call_579711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579711, url, valid)

proc call*(call_579712: Call_AndroidpublisherInappproductsPatch_579697;
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
  var path_579713 = newJObject()
  var query_579714 = newJObject()
  var body_579715 = newJObject()
  add(query_579714, "key", newJString(key))
  add(query_579714, "prettyPrint", newJBool(prettyPrint))
  add(query_579714, "oauth_token", newJString(oauthToken))
  add(path_579713, "packageName", newJString(packageName))
  add(query_579714, "alt", newJString(alt))
  add(query_579714, "userIp", newJString(userIp))
  add(path_579713, "sku", newJString(sku))
  add(query_579714, "quotaUser", newJString(quotaUser))
  add(query_579714, "autoConvertMissingPrices", newJBool(autoConvertMissingPrices))
  if body != nil:
    body_579715 = body
  add(query_579714, "fields", newJString(fields))
  result = call_579712.call(path_579713, query_579714, nil, nil, body_579715)

var androidpublisherInappproductsPatch* = Call_AndroidpublisherInappproductsPatch_579697(
    name: "androidpublisherInappproductsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsPatch_579698,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsPatch_579699, schemes: {Scheme.Https})
type
  Call_AndroidpublisherInappproductsDelete_579681 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherInappproductsDelete_579683(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherInappproductsDelete_579682(path: JsonNode;
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
  var valid_579684 = path.getOrDefault("packageName")
  valid_579684 = validateParameter(valid_579684, JString, required = true,
                                 default = nil)
  if valid_579684 != nil:
    section.add "packageName", valid_579684
  var valid_579685 = path.getOrDefault("sku")
  valid_579685 = validateParameter(valid_579685, JString, required = true,
                                 default = nil)
  if valid_579685 != nil:
    section.add "sku", valid_579685
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
  var valid_579686 = query.getOrDefault("key")
  valid_579686 = validateParameter(valid_579686, JString, required = false,
                                 default = nil)
  if valid_579686 != nil:
    section.add "key", valid_579686
  var valid_579687 = query.getOrDefault("prettyPrint")
  valid_579687 = validateParameter(valid_579687, JBool, required = false,
                                 default = newJBool(true))
  if valid_579687 != nil:
    section.add "prettyPrint", valid_579687
  var valid_579688 = query.getOrDefault("oauth_token")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = nil)
  if valid_579688 != nil:
    section.add "oauth_token", valid_579688
  var valid_579689 = query.getOrDefault("alt")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = newJString("json"))
  if valid_579689 != nil:
    section.add "alt", valid_579689
  var valid_579690 = query.getOrDefault("userIp")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "userIp", valid_579690
  var valid_579691 = query.getOrDefault("quotaUser")
  valid_579691 = validateParameter(valid_579691, JString, required = false,
                                 default = nil)
  if valid_579691 != nil:
    section.add "quotaUser", valid_579691
  var valid_579692 = query.getOrDefault("fields")
  valid_579692 = validateParameter(valid_579692, JString, required = false,
                                 default = nil)
  if valid_579692 != nil:
    section.add "fields", valid_579692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579693: Call_AndroidpublisherInappproductsDelete_579681;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an in-app product for an app.
  ## 
  let valid = call_579693.validator(path, query, header, formData, body)
  let scheme = call_579693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579693.url(scheme.get, call_579693.host, call_579693.base,
                         call_579693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579693, url, valid)

proc call*(call_579694: Call_AndroidpublisherInappproductsDelete_579681;
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
  var path_579695 = newJObject()
  var query_579696 = newJObject()
  add(query_579696, "key", newJString(key))
  add(query_579696, "prettyPrint", newJBool(prettyPrint))
  add(query_579696, "oauth_token", newJString(oauthToken))
  add(path_579695, "packageName", newJString(packageName))
  add(query_579696, "alt", newJString(alt))
  add(query_579696, "userIp", newJString(userIp))
  add(path_579695, "sku", newJString(sku))
  add(query_579696, "quotaUser", newJString(quotaUser))
  add(query_579696, "fields", newJString(fields))
  result = call_579694.call(path_579695, query_579696, nil, nil, nil)

var androidpublisherInappproductsDelete* = Call_AndroidpublisherInappproductsDelete_579681(
    name: "androidpublisherInappproductsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{packageName}/inappproducts/{sku}",
    validator: validate_AndroidpublisherInappproductsDelete_579682,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherInappproductsDelete_579683, schemes: {Scheme.Https})
type
  Call_AndroidpublisherOrdersRefund_579716 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherOrdersRefund_579718(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherOrdersRefund_579717(path: JsonNode; query: JsonNode;
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
  var valid_579719 = path.getOrDefault("packageName")
  valid_579719 = validateParameter(valid_579719, JString, required = true,
                                 default = nil)
  if valid_579719 != nil:
    section.add "packageName", valid_579719
  var valid_579720 = path.getOrDefault("orderId")
  valid_579720 = validateParameter(valid_579720, JString, required = true,
                                 default = nil)
  if valid_579720 != nil:
    section.add "orderId", valid_579720
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
  var valid_579721 = query.getOrDefault("key")
  valid_579721 = validateParameter(valid_579721, JString, required = false,
                                 default = nil)
  if valid_579721 != nil:
    section.add "key", valid_579721
  var valid_579722 = query.getOrDefault("prettyPrint")
  valid_579722 = validateParameter(valid_579722, JBool, required = false,
                                 default = newJBool(true))
  if valid_579722 != nil:
    section.add "prettyPrint", valid_579722
  var valid_579723 = query.getOrDefault("oauth_token")
  valid_579723 = validateParameter(valid_579723, JString, required = false,
                                 default = nil)
  if valid_579723 != nil:
    section.add "oauth_token", valid_579723
  var valid_579724 = query.getOrDefault("alt")
  valid_579724 = validateParameter(valid_579724, JString, required = false,
                                 default = newJString("json"))
  if valid_579724 != nil:
    section.add "alt", valid_579724
  var valid_579725 = query.getOrDefault("userIp")
  valid_579725 = validateParameter(valid_579725, JString, required = false,
                                 default = nil)
  if valid_579725 != nil:
    section.add "userIp", valid_579725
  var valid_579726 = query.getOrDefault("quotaUser")
  valid_579726 = validateParameter(valid_579726, JString, required = false,
                                 default = nil)
  if valid_579726 != nil:
    section.add "quotaUser", valid_579726
  var valid_579727 = query.getOrDefault("revoke")
  valid_579727 = validateParameter(valid_579727, JBool, required = false, default = nil)
  if valid_579727 != nil:
    section.add "revoke", valid_579727
  var valid_579728 = query.getOrDefault("fields")
  valid_579728 = validateParameter(valid_579728, JString, required = false,
                                 default = nil)
  if valid_579728 != nil:
    section.add "fields", valid_579728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579729: Call_AndroidpublisherOrdersRefund_579716; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refund a user's subscription or in-app purchase order.
  ## 
  let valid = call_579729.validator(path, query, header, formData, body)
  let scheme = call_579729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579729.url(scheme.get, call_579729.host, call_579729.base,
                         call_579729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579729, url, valid)

proc call*(call_579730: Call_AndroidpublisherOrdersRefund_579716;
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
  var path_579731 = newJObject()
  var query_579732 = newJObject()
  add(query_579732, "key", newJString(key))
  add(query_579732, "prettyPrint", newJBool(prettyPrint))
  add(query_579732, "oauth_token", newJString(oauthToken))
  add(path_579731, "packageName", newJString(packageName))
  add(query_579732, "alt", newJString(alt))
  add(query_579732, "userIp", newJString(userIp))
  add(query_579732, "quotaUser", newJString(quotaUser))
  add(query_579732, "revoke", newJBool(revoke))
  add(query_579732, "fields", newJString(fields))
  add(path_579731, "orderId", newJString(orderId))
  result = call_579730.call(path_579731, query_579732, nil, nil, nil)

var androidpublisherOrdersRefund* = Call_AndroidpublisherOrdersRefund_579716(
    name: "androidpublisherOrdersRefund", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/orders/{orderId}:refund",
    validator: validate_AndroidpublisherOrdersRefund_579717,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherOrdersRefund_579718, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesProductsGet_579733 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesProductsGet_579735(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesProductsGet_579734(path: JsonNode;
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
  var valid_579736 = path.getOrDefault("packageName")
  valid_579736 = validateParameter(valid_579736, JString, required = true,
                                 default = nil)
  if valid_579736 != nil:
    section.add "packageName", valid_579736
  var valid_579737 = path.getOrDefault("token")
  valid_579737 = validateParameter(valid_579737, JString, required = true,
                                 default = nil)
  if valid_579737 != nil:
    section.add "token", valid_579737
  var valid_579738 = path.getOrDefault("productId")
  valid_579738 = validateParameter(valid_579738, JString, required = true,
                                 default = nil)
  if valid_579738 != nil:
    section.add "productId", valid_579738
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
  var valid_579739 = query.getOrDefault("key")
  valid_579739 = validateParameter(valid_579739, JString, required = false,
                                 default = nil)
  if valid_579739 != nil:
    section.add "key", valid_579739
  var valid_579740 = query.getOrDefault("prettyPrint")
  valid_579740 = validateParameter(valid_579740, JBool, required = false,
                                 default = newJBool(true))
  if valid_579740 != nil:
    section.add "prettyPrint", valid_579740
  var valid_579741 = query.getOrDefault("oauth_token")
  valid_579741 = validateParameter(valid_579741, JString, required = false,
                                 default = nil)
  if valid_579741 != nil:
    section.add "oauth_token", valid_579741
  var valid_579742 = query.getOrDefault("alt")
  valid_579742 = validateParameter(valid_579742, JString, required = false,
                                 default = newJString("json"))
  if valid_579742 != nil:
    section.add "alt", valid_579742
  var valid_579743 = query.getOrDefault("userIp")
  valid_579743 = validateParameter(valid_579743, JString, required = false,
                                 default = nil)
  if valid_579743 != nil:
    section.add "userIp", valid_579743
  var valid_579744 = query.getOrDefault("quotaUser")
  valid_579744 = validateParameter(valid_579744, JString, required = false,
                                 default = nil)
  if valid_579744 != nil:
    section.add "quotaUser", valid_579744
  var valid_579745 = query.getOrDefault("fields")
  valid_579745 = validateParameter(valid_579745, JString, required = false,
                                 default = nil)
  if valid_579745 != nil:
    section.add "fields", valid_579745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579746: Call_AndroidpublisherPurchasesProductsGet_579733;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the purchase and consumption status of an inapp item.
  ## 
  let valid = call_579746.validator(path, query, header, formData, body)
  let scheme = call_579746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579746.url(scheme.get, call_579746.host, call_579746.base,
                         call_579746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579746, url, valid)

proc call*(call_579747: Call_AndroidpublisherPurchasesProductsGet_579733;
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
  var path_579748 = newJObject()
  var query_579749 = newJObject()
  add(query_579749, "key", newJString(key))
  add(query_579749, "prettyPrint", newJBool(prettyPrint))
  add(query_579749, "oauth_token", newJString(oauthToken))
  add(path_579748, "packageName", newJString(packageName))
  add(query_579749, "alt", newJString(alt))
  add(query_579749, "userIp", newJString(userIp))
  add(query_579749, "quotaUser", newJString(quotaUser))
  add(path_579748, "token", newJString(token))
  add(query_579749, "fields", newJString(fields))
  add(path_579748, "productId", newJString(productId))
  result = call_579747.call(path_579748, query_579749, nil, nil, nil)

var androidpublisherPurchasesProductsGet* = Call_AndroidpublisherPurchasesProductsGet_579733(
    name: "androidpublisherPurchasesProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/purchases/products/{productId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesProductsGet_579734,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesProductsGet_579735, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsGet_579750 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesSubscriptionsGet_579752(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsGet_579751(path: JsonNode;
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
  var valid_579753 = path.getOrDefault("packageName")
  valid_579753 = validateParameter(valid_579753, JString, required = true,
                                 default = nil)
  if valid_579753 != nil:
    section.add "packageName", valid_579753
  var valid_579754 = path.getOrDefault("subscriptionId")
  valid_579754 = validateParameter(valid_579754, JString, required = true,
                                 default = nil)
  if valid_579754 != nil:
    section.add "subscriptionId", valid_579754
  var valid_579755 = path.getOrDefault("token")
  valid_579755 = validateParameter(valid_579755, JString, required = true,
                                 default = nil)
  if valid_579755 != nil:
    section.add "token", valid_579755
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
  var valid_579756 = query.getOrDefault("key")
  valid_579756 = validateParameter(valid_579756, JString, required = false,
                                 default = nil)
  if valid_579756 != nil:
    section.add "key", valid_579756
  var valid_579757 = query.getOrDefault("prettyPrint")
  valid_579757 = validateParameter(valid_579757, JBool, required = false,
                                 default = newJBool(true))
  if valid_579757 != nil:
    section.add "prettyPrint", valid_579757
  var valid_579758 = query.getOrDefault("oauth_token")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "oauth_token", valid_579758
  var valid_579759 = query.getOrDefault("alt")
  valid_579759 = validateParameter(valid_579759, JString, required = false,
                                 default = newJString("json"))
  if valid_579759 != nil:
    section.add "alt", valid_579759
  var valid_579760 = query.getOrDefault("userIp")
  valid_579760 = validateParameter(valid_579760, JString, required = false,
                                 default = nil)
  if valid_579760 != nil:
    section.add "userIp", valid_579760
  var valid_579761 = query.getOrDefault("quotaUser")
  valid_579761 = validateParameter(valid_579761, JString, required = false,
                                 default = nil)
  if valid_579761 != nil:
    section.add "quotaUser", valid_579761
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

proc call*(call_579763: Call_AndroidpublisherPurchasesSubscriptionsGet_579750;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_579763.validator(path, query, header, formData, body)
  let scheme = call_579763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579763.url(scheme.get, call_579763.host, call_579763.base,
                         call_579763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579763, url, valid)

proc call*(call_579764: Call_AndroidpublisherPurchasesSubscriptionsGet_579750;
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
  var path_579765 = newJObject()
  var query_579766 = newJObject()
  add(query_579766, "key", newJString(key))
  add(query_579766, "prettyPrint", newJBool(prettyPrint))
  add(query_579766, "oauth_token", newJString(oauthToken))
  add(path_579765, "packageName", newJString(packageName))
  add(query_579766, "alt", newJString(alt))
  add(query_579766, "userIp", newJString(userIp))
  add(query_579766, "quotaUser", newJString(quotaUser))
  add(path_579765, "subscriptionId", newJString(subscriptionId))
  add(path_579765, "token", newJString(token))
  add(query_579766, "fields", newJString(fields))
  result = call_579764.call(path_579765, query_579766, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsGet* = Call_AndroidpublisherPurchasesSubscriptionsGet_579750(
    name: "androidpublisherPurchasesSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}",
    validator: validate_AndroidpublisherPurchasesSubscriptionsGet_579751,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsGet_579752,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsCancel_579767 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesSubscriptionsCancel_579769(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsCancel_579768(path: JsonNode;
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
  var valid_579770 = path.getOrDefault("packageName")
  valid_579770 = validateParameter(valid_579770, JString, required = true,
                                 default = nil)
  if valid_579770 != nil:
    section.add "packageName", valid_579770
  var valid_579771 = path.getOrDefault("subscriptionId")
  valid_579771 = validateParameter(valid_579771, JString, required = true,
                                 default = nil)
  if valid_579771 != nil:
    section.add "subscriptionId", valid_579771
  var valid_579772 = path.getOrDefault("token")
  valid_579772 = validateParameter(valid_579772, JString, required = true,
                                 default = nil)
  if valid_579772 != nil:
    section.add "token", valid_579772
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
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579774 = query.getOrDefault("prettyPrint")
  valid_579774 = validateParameter(valid_579774, JBool, required = false,
                                 default = newJBool(true))
  if valid_579774 != nil:
    section.add "prettyPrint", valid_579774
  var valid_579775 = query.getOrDefault("oauth_token")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "oauth_token", valid_579775
  var valid_579776 = query.getOrDefault("alt")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = newJString("json"))
  if valid_579776 != nil:
    section.add "alt", valid_579776
  var valid_579777 = query.getOrDefault("userIp")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "userIp", valid_579777
  var valid_579778 = query.getOrDefault("quotaUser")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "quotaUser", valid_579778
  var valid_579779 = query.getOrDefault("fields")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "fields", valid_579779
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579780: Call_AndroidpublisherPurchasesSubscriptionsCancel_579767;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_579780.validator(path, query, header, formData, body)
  let scheme = call_579780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579780.url(scheme.get, call_579780.host, call_579780.base,
                         call_579780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579780, url, valid)

proc call*(call_579781: Call_AndroidpublisherPurchasesSubscriptionsCancel_579767;
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
  var path_579782 = newJObject()
  var query_579783 = newJObject()
  add(query_579783, "key", newJString(key))
  add(query_579783, "prettyPrint", newJBool(prettyPrint))
  add(query_579783, "oauth_token", newJString(oauthToken))
  add(path_579782, "packageName", newJString(packageName))
  add(query_579783, "alt", newJString(alt))
  add(query_579783, "userIp", newJString(userIp))
  add(query_579783, "quotaUser", newJString(quotaUser))
  add(path_579782, "subscriptionId", newJString(subscriptionId))
  add(path_579782, "token", newJString(token))
  add(query_579783, "fields", newJString(fields))
  result = call_579781.call(path_579782, query_579783, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsCancel* = Call_AndroidpublisherPurchasesSubscriptionsCancel_579767(
    name: "androidpublisherPurchasesSubscriptionsCancel",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:cancel",
    validator: validate_AndroidpublisherPurchasesSubscriptionsCancel_579768,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsCancel_579769,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsDefer_579784 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesSubscriptionsDefer_579786(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsDefer_579785(path: JsonNode;
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
  var valid_579787 = path.getOrDefault("packageName")
  valid_579787 = validateParameter(valid_579787, JString, required = true,
                                 default = nil)
  if valid_579787 != nil:
    section.add "packageName", valid_579787
  var valid_579788 = path.getOrDefault("subscriptionId")
  valid_579788 = validateParameter(valid_579788, JString, required = true,
                                 default = nil)
  if valid_579788 != nil:
    section.add "subscriptionId", valid_579788
  var valid_579789 = path.getOrDefault("token")
  valid_579789 = validateParameter(valid_579789, JString, required = true,
                                 default = nil)
  if valid_579789 != nil:
    section.add "token", valid_579789
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
  var valid_579790 = query.getOrDefault("key")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "key", valid_579790
  var valid_579791 = query.getOrDefault("prettyPrint")
  valid_579791 = validateParameter(valid_579791, JBool, required = false,
                                 default = newJBool(true))
  if valid_579791 != nil:
    section.add "prettyPrint", valid_579791
  var valid_579792 = query.getOrDefault("oauth_token")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "oauth_token", valid_579792
  var valid_579793 = query.getOrDefault("alt")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = newJString("json"))
  if valid_579793 != nil:
    section.add "alt", valid_579793
  var valid_579794 = query.getOrDefault("userIp")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "userIp", valid_579794
  var valid_579795 = query.getOrDefault("quotaUser")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "quotaUser", valid_579795
  var valid_579796 = query.getOrDefault("fields")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "fields", valid_579796
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

proc call*(call_579798: Call_AndroidpublisherPurchasesSubscriptionsDefer_579784;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Defers a user's subscription purchase until a specified future expiration time.
  ## 
  let valid = call_579798.validator(path, query, header, formData, body)
  let scheme = call_579798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579798.url(scheme.get, call_579798.host, call_579798.base,
                         call_579798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579798, url, valid)

proc call*(call_579799: Call_AndroidpublisherPurchasesSubscriptionsDefer_579784;
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
  var path_579800 = newJObject()
  var query_579801 = newJObject()
  var body_579802 = newJObject()
  add(query_579801, "key", newJString(key))
  add(query_579801, "prettyPrint", newJBool(prettyPrint))
  add(query_579801, "oauth_token", newJString(oauthToken))
  add(path_579800, "packageName", newJString(packageName))
  add(query_579801, "alt", newJString(alt))
  add(query_579801, "userIp", newJString(userIp))
  add(query_579801, "quotaUser", newJString(quotaUser))
  add(path_579800, "subscriptionId", newJString(subscriptionId))
  add(path_579800, "token", newJString(token))
  if body != nil:
    body_579802 = body
  add(query_579801, "fields", newJString(fields))
  result = call_579799.call(path_579800, query_579801, nil, nil, body_579802)

var androidpublisherPurchasesSubscriptionsDefer* = Call_AndroidpublisherPurchasesSubscriptionsDefer_579784(
    name: "androidpublisherPurchasesSubscriptionsDefer",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:defer",
    validator: validate_AndroidpublisherPurchasesSubscriptionsDefer_579785,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsDefer_579786,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRefund_579803 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesSubscriptionsRefund_579805(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsRefund_579804(path: JsonNode;
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
  var valid_579806 = path.getOrDefault("packageName")
  valid_579806 = validateParameter(valid_579806, JString, required = true,
                                 default = nil)
  if valid_579806 != nil:
    section.add "packageName", valid_579806
  var valid_579807 = path.getOrDefault("subscriptionId")
  valid_579807 = validateParameter(valid_579807, JString, required = true,
                                 default = nil)
  if valid_579807 != nil:
    section.add "subscriptionId", valid_579807
  var valid_579808 = path.getOrDefault("token")
  valid_579808 = validateParameter(valid_579808, JString, required = true,
                                 default = nil)
  if valid_579808 != nil:
    section.add "token", valid_579808
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
  if body != nil:
    result.add "body", body

proc call*(call_579816: Call_AndroidpublisherPurchasesSubscriptionsRefund_579803;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds a user's subscription purchase, but the subscription remains valid until its expiration time and it will continue to recur.
  ## 
  let valid = call_579816.validator(path, query, header, formData, body)
  let scheme = call_579816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579816.url(scheme.get, call_579816.host, call_579816.base,
                         call_579816.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579816, url, valid)

proc call*(call_579817: Call_AndroidpublisherPurchasesSubscriptionsRefund_579803;
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
  var path_579818 = newJObject()
  var query_579819 = newJObject()
  add(query_579819, "key", newJString(key))
  add(query_579819, "prettyPrint", newJBool(prettyPrint))
  add(query_579819, "oauth_token", newJString(oauthToken))
  add(path_579818, "packageName", newJString(packageName))
  add(query_579819, "alt", newJString(alt))
  add(query_579819, "userIp", newJString(userIp))
  add(query_579819, "quotaUser", newJString(quotaUser))
  add(path_579818, "subscriptionId", newJString(subscriptionId))
  add(path_579818, "token", newJString(token))
  add(query_579819, "fields", newJString(fields))
  result = call_579817.call(path_579818, query_579819, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRefund* = Call_AndroidpublisherPurchasesSubscriptionsRefund_579803(
    name: "androidpublisherPurchasesSubscriptionsRefund",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:refund",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRefund_579804,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRefund_579805,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesSubscriptionsRevoke_579820 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesSubscriptionsRevoke_579822(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesSubscriptionsRevoke_579821(path: JsonNode;
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
  var valid_579823 = path.getOrDefault("packageName")
  valid_579823 = validateParameter(valid_579823, JString, required = true,
                                 default = nil)
  if valid_579823 != nil:
    section.add "packageName", valid_579823
  var valid_579824 = path.getOrDefault("subscriptionId")
  valid_579824 = validateParameter(valid_579824, JString, required = true,
                                 default = nil)
  if valid_579824 != nil:
    section.add "subscriptionId", valid_579824
  var valid_579825 = path.getOrDefault("token")
  valid_579825 = validateParameter(valid_579825, JString, required = true,
                                 default = nil)
  if valid_579825 != nil:
    section.add "token", valid_579825
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
  var valid_579828 = query.getOrDefault("oauth_token")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "oauth_token", valid_579828
  var valid_579829 = query.getOrDefault("alt")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = newJString("json"))
  if valid_579829 != nil:
    section.add "alt", valid_579829
  var valid_579830 = query.getOrDefault("userIp")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "userIp", valid_579830
  var valid_579831 = query.getOrDefault("quotaUser")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "quotaUser", valid_579831
  var valid_579832 = query.getOrDefault("fields")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "fields", valid_579832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579833: Call_AndroidpublisherPurchasesSubscriptionsRevoke_579820;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refunds and immediately revokes a user's subscription purchase. Access to the subscription will be terminated immediately and it will stop recurring.
  ## 
  let valid = call_579833.validator(path, query, header, formData, body)
  let scheme = call_579833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579833.url(scheme.get, call_579833.host, call_579833.base,
                         call_579833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579833, url, valid)

proc call*(call_579834: Call_AndroidpublisherPurchasesSubscriptionsRevoke_579820;
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
  var path_579835 = newJObject()
  var query_579836 = newJObject()
  add(query_579836, "key", newJString(key))
  add(query_579836, "prettyPrint", newJBool(prettyPrint))
  add(query_579836, "oauth_token", newJString(oauthToken))
  add(path_579835, "packageName", newJString(packageName))
  add(query_579836, "alt", newJString(alt))
  add(query_579836, "userIp", newJString(userIp))
  add(query_579836, "quotaUser", newJString(quotaUser))
  add(path_579835, "subscriptionId", newJString(subscriptionId))
  add(path_579835, "token", newJString(token))
  add(query_579836, "fields", newJString(fields))
  result = call_579834.call(path_579835, query_579836, nil, nil, nil)

var androidpublisherPurchasesSubscriptionsRevoke* = Call_AndroidpublisherPurchasesSubscriptionsRevoke_579820(
    name: "androidpublisherPurchasesSubscriptionsRevoke",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:revoke",
    validator: validate_AndroidpublisherPurchasesSubscriptionsRevoke_579821,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesSubscriptionsRevoke_579822,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesVoidedpurchasesList_579837 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherPurchasesVoidedpurchasesList_579839(protocol: Scheme;
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

proc validate_AndroidpublisherPurchasesVoidedpurchasesList_579838(path: JsonNode;
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
  var valid_579840 = path.getOrDefault("packageName")
  valid_579840 = validateParameter(valid_579840, JString, required = true,
                                 default = nil)
  if valid_579840 != nil:
    section.add "packageName", valid_579840
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
  ##   token: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##   endTime: JString
  ##          : The time, in milliseconds since the Epoch, of the newest voided purchase that you want to see in the response. The value of this parameter cannot be greater than the current time and is ignored if a pagination token is set. Default value is current time. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  section = newJObject()
  var valid_579841 = query.getOrDefault("key")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "key", valid_579841
  var valid_579842 = query.getOrDefault("prettyPrint")
  valid_579842 = validateParameter(valid_579842, JBool, required = false,
                                 default = newJBool(true))
  if valid_579842 != nil:
    section.add "prettyPrint", valid_579842
  var valid_579843 = query.getOrDefault("oauth_token")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "oauth_token", valid_579843
  var valid_579844 = query.getOrDefault("startTime")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "startTime", valid_579844
  var valid_579845 = query.getOrDefault("alt")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = newJString("json"))
  if valid_579845 != nil:
    section.add "alt", valid_579845
  var valid_579846 = query.getOrDefault("userIp")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "userIp", valid_579846
  var valid_579847 = query.getOrDefault("quotaUser")
  valid_579847 = validateParameter(valid_579847, JString, required = false,
                                 default = nil)
  if valid_579847 != nil:
    section.add "quotaUser", valid_579847
  var valid_579848 = query.getOrDefault("startIndex")
  valid_579848 = validateParameter(valid_579848, JInt, required = false, default = nil)
  if valid_579848 != nil:
    section.add "startIndex", valid_579848
  var valid_579849 = query.getOrDefault("token")
  valid_579849 = validateParameter(valid_579849, JString, required = false,
                                 default = nil)
  if valid_579849 != nil:
    section.add "token", valid_579849
  var valid_579850 = query.getOrDefault("fields")
  valid_579850 = validateParameter(valid_579850, JString, required = false,
                                 default = nil)
  if valid_579850 != nil:
    section.add "fields", valid_579850
  var valid_579851 = query.getOrDefault("maxResults")
  valid_579851 = validateParameter(valid_579851, JInt, required = false, default = nil)
  if valid_579851 != nil:
    section.add "maxResults", valid_579851
  var valid_579852 = query.getOrDefault("endTime")
  valid_579852 = validateParameter(valid_579852, JString, required = false,
                                 default = nil)
  if valid_579852 != nil:
    section.add "endTime", valid_579852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579853: Call_AndroidpublisherPurchasesVoidedpurchasesList_579837;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the purchases that were canceled, refunded or charged-back.
  ## 
  let valid = call_579853.validator(path, query, header, formData, body)
  let scheme = call_579853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579853.url(scheme.get, call_579853.host, call_579853.base,
                         call_579853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579853, url, valid)

proc call*(call_579854: Call_AndroidpublisherPurchasesVoidedpurchasesList_579837;
          packageName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; startTime: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
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
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##   endTime: string
  ##          : The time, in milliseconds since the Epoch, of the newest voided purchase that you want to see in the response. The value of this parameter cannot be greater than the current time and is ignored if a pagination token is set. Default value is current time. Note: This filter is applied on the time at which the record is seen as voided by our systems and not the actual voided time returned in the response.
  var path_579855 = newJObject()
  var query_579856 = newJObject()
  add(query_579856, "key", newJString(key))
  add(query_579856, "prettyPrint", newJBool(prettyPrint))
  add(query_579856, "oauth_token", newJString(oauthToken))
  add(path_579855, "packageName", newJString(packageName))
  add(query_579856, "startTime", newJString(startTime))
  add(query_579856, "alt", newJString(alt))
  add(query_579856, "userIp", newJString(userIp))
  add(query_579856, "quotaUser", newJString(quotaUser))
  add(query_579856, "startIndex", newJInt(startIndex))
  add(query_579856, "token", newJString(token))
  add(query_579856, "fields", newJString(fields))
  add(query_579856, "maxResults", newJInt(maxResults))
  add(query_579856, "endTime", newJString(endTime))
  result = call_579854.call(path_579855, query_579856, nil, nil, nil)

var androidpublisherPurchasesVoidedpurchasesList* = Call_AndroidpublisherPurchasesVoidedpurchasesList_579837(
    name: "androidpublisherPurchasesVoidedpurchasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{packageName}/purchases/voidedpurchases",
    validator: validate_AndroidpublisherPurchasesVoidedpurchasesList_579838,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherPurchasesVoidedpurchasesList_579839,
    schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsList_579857 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherReviewsList_579859(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsList_579858(path: JsonNode; query: JsonNode;
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
  var valid_579860 = path.getOrDefault("packageName")
  valid_579860 = validateParameter(valid_579860, JString, required = true,
                                 default = nil)
  if valid_579860 != nil:
    section.add "packageName", valid_579860
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
  var valid_579861 = query.getOrDefault("key")
  valid_579861 = validateParameter(valid_579861, JString, required = false,
                                 default = nil)
  if valid_579861 != nil:
    section.add "key", valid_579861
  var valid_579862 = query.getOrDefault("prettyPrint")
  valid_579862 = validateParameter(valid_579862, JBool, required = false,
                                 default = newJBool(true))
  if valid_579862 != nil:
    section.add "prettyPrint", valid_579862
  var valid_579863 = query.getOrDefault("oauth_token")
  valid_579863 = validateParameter(valid_579863, JString, required = false,
                                 default = nil)
  if valid_579863 != nil:
    section.add "oauth_token", valid_579863
  var valid_579864 = query.getOrDefault("alt")
  valid_579864 = validateParameter(valid_579864, JString, required = false,
                                 default = newJString("json"))
  if valid_579864 != nil:
    section.add "alt", valid_579864
  var valid_579865 = query.getOrDefault("userIp")
  valid_579865 = validateParameter(valid_579865, JString, required = false,
                                 default = nil)
  if valid_579865 != nil:
    section.add "userIp", valid_579865
  var valid_579866 = query.getOrDefault("quotaUser")
  valid_579866 = validateParameter(valid_579866, JString, required = false,
                                 default = nil)
  if valid_579866 != nil:
    section.add "quotaUser", valid_579866
  var valid_579867 = query.getOrDefault("startIndex")
  valid_579867 = validateParameter(valid_579867, JInt, required = false, default = nil)
  if valid_579867 != nil:
    section.add "startIndex", valid_579867
  var valid_579868 = query.getOrDefault("translationLanguage")
  valid_579868 = validateParameter(valid_579868, JString, required = false,
                                 default = nil)
  if valid_579868 != nil:
    section.add "translationLanguage", valid_579868
  var valid_579869 = query.getOrDefault("token")
  valid_579869 = validateParameter(valid_579869, JString, required = false,
                                 default = nil)
  if valid_579869 != nil:
    section.add "token", valid_579869
  var valid_579870 = query.getOrDefault("fields")
  valid_579870 = validateParameter(valid_579870, JString, required = false,
                                 default = nil)
  if valid_579870 != nil:
    section.add "fields", valid_579870
  var valid_579871 = query.getOrDefault("maxResults")
  valid_579871 = validateParameter(valid_579871, JInt, required = false, default = nil)
  if valid_579871 != nil:
    section.add "maxResults", valid_579871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579872: Call_AndroidpublisherReviewsList_579857; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of reviews. Only reviews from last week will be returned.
  ## 
  let valid = call_579872.validator(path, query, header, formData, body)
  let scheme = call_579872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579872.url(scheme.get, call_579872.host, call_579872.base,
                         call_579872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579872, url, valid)

proc call*(call_579873: Call_AndroidpublisherReviewsList_579857;
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
  var path_579874 = newJObject()
  var query_579875 = newJObject()
  add(query_579875, "key", newJString(key))
  add(query_579875, "prettyPrint", newJBool(prettyPrint))
  add(query_579875, "oauth_token", newJString(oauthToken))
  add(path_579874, "packageName", newJString(packageName))
  add(query_579875, "alt", newJString(alt))
  add(query_579875, "userIp", newJString(userIp))
  add(query_579875, "quotaUser", newJString(quotaUser))
  add(query_579875, "startIndex", newJInt(startIndex))
  add(query_579875, "translationLanguage", newJString(translationLanguage))
  add(query_579875, "token", newJString(token))
  add(query_579875, "fields", newJString(fields))
  add(query_579875, "maxResults", newJInt(maxResults))
  result = call_579873.call(path_579874, query_579875, nil, nil, nil)

var androidpublisherReviewsList* = Call_AndroidpublisherReviewsList_579857(
    name: "androidpublisherReviewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews",
    validator: validate_AndroidpublisherReviewsList_579858,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsList_579859, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsGet_579876 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherReviewsGet_579878(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsGet_579877(path: JsonNode; query: JsonNode;
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
  var valid_579879 = path.getOrDefault("packageName")
  valid_579879 = validateParameter(valid_579879, JString, required = true,
                                 default = nil)
  if valid_579879 != nil:
    section.add "packageName", valid_579879
  var valid_579880 = path.getOrDefault("reviewId")
  valid_579880 = validateParameter(valid_579880, JString, required = true,
                                 default = nil)
  if valid_579880 != nil:
    section.add "reviewId", valid_579880
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
  var valid_579881 = query.getOrDefault("key")
  valid_579881 = validateParameter(valid_579881, JString, required = false,
                                 default = nil)
  if valid_579881 != nil:
    section.add "key", valid_579881
  var valid_579882 = query.getOrDefault("prettyPrint")
  valid_579882 = validateParameter(valid_579882, JBool, required = false,
                                 default = newJBool(true))
  if valid_579882 != nil:
    section.add "prettyPrint", valid_579882
  var valid_579883 = query.getOrDefault("oauth_token")
  valid_579883 = validateParameter(valid_579883, JString, required = false,
                                 default = nil)
  if valid_579883 != nil:
    section.add "oauth_token", valid_579883
  var valid_579884 = query.getOrDefault("alt")
  valid_579884 = validateParameter(valid_579884, JString, required = false,
                                 default = newJString("json"))
  if valid_579884 != nil:
    section.add "alt", valid_579884
  var valid_579885 = query.getOrDefault("userIp")
  valid_579885 = validateParameter(valid_579885, JString, required = false,
                                 default = nil)
  if valid_579885 != nil:
    section.add "userIp", valid_579885
  var valid_579886 = query.getOrDefault("quotaUser")
  valid_579886 = validateParameter(valid_579886, JString, required = false,
                                 default = nil)
  if valid_579886 != nil:
    section.add "quotaUser", valid_579886
  var valid_579887 = query.getOrDefault("translationLanguage")
  valid_579887 = validateParameter(valid_579887, JString, required = false,
                                 default = nil)
  if valid_579887 != nil:
    section.add "translationLanguage", valid_579887
  var valid_579888 = query.getOrDefault("fields")
  valid_579888 = validateParameter(valid_579888, JString, required = false,
                                 default = nil)
  if valid_579888 != nil:
    section.add "fields", valid_579888
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579889: Call_AndroidpublisherReviewsGet_579876; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single review.
  ## 
  let valid = call_579889.validator(path, query, header, formData, body)
  let scheme = call_579889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579889.url(scheme.get, call_579889.host, call_579889.base,
                         call_579889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579889, url, valid)

proc call*(call_579890: Call_AndroidpublisherReviewsGet_579876;
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
  var path_579891 = newJObject()
  var query_579892 = newJObject()
  add(query_579892, "key", newJString(key))
  add(query_579892, "prettyPrint", newJBool(prettyPrint))
  add(query_579892, "oauth_token", newJString(oauthToken))
  add(path_579891, "packageName", newJString(packageName))
  add(path_579891, "reviewId", newJString(reviewId))
  add(query_579892, "alt", newJString(alt))
  add(query_579892, "userIp", newJString(userIp))
  add(query_579892, "quotaUser", newJString(quotaUser))
  add(query_579892, "translationLanguage", newJString(translationLanguage))
  add(query_579892, "fields", newJString(fields))
  result = call_579890.call(path_579891, query_579892, nil, nil, nil)

var androidpublisherReviewsGet* = Call_AndroidpublisherReviewsGet_579876(
    name: "androidpublisherReviewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}",
    validator: validate_AndroidpublisherReviewsGet_579877,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsGet_579878, schemes: {Scheme.Https})
type
  Call_AndroidpublisherReviewsReply_579893 = ref object of OpenApiRestCall_578348
proc url_AndroidpublisherReviewsReply_579895(protocol: Scheme; host: string;
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

proc validate_AndroidpublisherReviewsReply_579894(path: JsonNode; query: JsonNode;
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
  var valid_579896 = path.getOrDefault("packageName")
  valid_579896 = validateParameter(valid_579896, JString, required = true,
                                 default = nil)
  if valid_579896 != nil:
    section.add "packageName", valid_579896
  var valid_579897 = path.getOrDefault("reviewId")
  valid_579897 = validateParameter(valid_579897, JString, required = true,
                                 default = nil)
  if valid_579897 != nil:
    section.add "reviewId", valid_579897
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
  var valid_579904 = query.getOrDefault("fields")
  valid_579904 = validateParameter(valid_579904, JString, required = false,
                                 default = nil)
  if valid_579904 != nil:
    section.add "fields", valid_579904
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

proc call*(call_579906: Call_AndroidpublisherReviewsReply_579893; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reply to a single review, or update an existing reply.
  ## 
  let valid = call_579906.validator(path, query, header, formData, body)
  let scheme = call_579906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579906.url(scheme.get, call_579906.host, call_579906.base,
                         call_579906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579906, url, valid)

proc call*(call_579907: Call_AndroidpublisherReviewsReply_579893;
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
  var path_579908 = newJObject()
  var query_579909 = newJObject()
  var body_579910 = newJObject()
  add(query_579909, "key", newJString(key))
  add(query_579909, "prettyPrint", newJBool(prettyPrint))
  add(query_579909, "oauth_token", newJString(oauthToken))
  add(path_579908, "packageName", newJString(packageName))
  add(path_579908, "reviewId", newJString(reviewId))
  add(query_579909, "alt", newJString(alt))
  add(query_579909, "userIp", newJString(userIp))
  add(query_579909, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579910 = body
  add(query_579909, "fields", newJString(fields))
  result = call_579907.call(path_579908, query_579909, nil, nil, body_579910)

var androidpublisherReviewsReply* = Call_AndroidpublisherReviewsReply_579893(
    name: "androidpublisherReviewsReply", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/reviews/{reviewId}:reply",
    validator: validate_AndroidpublisherReviewsReply_579894,
    base: "/androidpublisher/v2/applications",
    url: url_AndroidpublisherReviewsReply_579895, schemes: {Scheme.Https})
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
