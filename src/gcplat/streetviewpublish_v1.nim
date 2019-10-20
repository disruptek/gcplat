
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Street View Publish
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Publishes 360 photos to Google Maps, along with position, orientation, and connectivity metadata. Apps can offer an interface for positioning, connecting, and uploading user-generated Street View images.
## 
## 
## https://developers.google.com/streetview/publish/
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "streetviewpublish"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StreetviewpublishPhotoCreate_578610 = ref object of OpenApiRestCall_578339
proc url_StreetviewpublishPhotoCreate_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotoCreate_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## After the client finishes uploading the photo with the returned
  ## UploadRef,
  ## CreatePhoto
  ## publishes the uploaded Photo to
  ## Street View on Google Maps.
  ## 
  ## Currently, the only way to set heading, pitch, and roll in CreatePhoto is
  ## through the [Photo Sphere XMP
  ## metadata](https://developers.google.com/streetview/spherical-metadata) in
  ## the photo bytes. CreatePhoto ignores the  `pose.heading`, `pose.pitch`,
  ## `pose.roll`, `pose.altitude`, and `pose.level` fields in Pose.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed or if
  ## the uploaded photo is not a 360 photo.
  ## * google.rpc.Code.NOT_FOUND if the upload reference does not exist.
  ## * google.rpc.Code.RESOURCE_EXHAUSTED if the account has reached the
  ## storage limit.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("$.xgafv")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("1"))
  if valid_578740 != nil:
    section.add "$.xgafv", valid_578740
  var valid_578741 = query.getOrDefault("alt")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = newJString("json"))
  if valid_578741 != nil:
    section.add "alt", valid_578741
  var valid_578742 = query.getOrDefault("uploadType")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "uploadType", valid_578742
  var valid_578743 = query.getOrDefault("quotaUser")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "quotaUser", valid_578743
  var valid_578744 = query.getOrDefault("callback")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "callback", valid_578744
  var valid_578745 = query.getOrDefault("fields")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "fields", valid_578745
  var valid_578746 = query.getOrDefault("access_token")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "access_token", valid_578746
  var valid_578747 = query.getOrDefault("upload_protocol")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "upload_protocol", valid_578747
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

proc call*(call_578771: Call_StreetviewpublishPhotoCreate_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## After the client finishes uploading the photo with the returned
  ## UploadRef,
  ## CreatePhoto
  ## publishes the uploaded Photo to
  ## Street View on Google Maps.
  ## 
  ## Currently, the only way to set heading, pitch, and roll in CreatePhoto is
  ## through the [Photo Sphere XMP
  ## metadata](https://developers.google.com/streetview/spherical-metadata) in
  ## the photo bytes. CreatePhoto ignores the  `pose.heading`, `pose.pitch`,
  ## `pose.roll`, `pose.altitude`, and `pose.level` fields in Pose.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed or if
  ## the uploaded photo is not a 360 photo.
  ## * google.rpc.Code.NOT_FOUND if the upload reference does not exist.
  ## * google.rpc.Code.RESOURCE_EXHAUSTED if the account has reached the
  ## storage limit.
  ## 
  let valid = call_578771.validator(path, query, header, formData, body)
  let scheme = call_578771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578771.url(scheme.get, call_578771.host, call_578771.base,
                         call_578771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578771, url, valid)

proc call*(call_578842: Call_StreetviewpublishPhotoCreate_578610; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## streetviewpublishPhotoCreate
  ## After the client finishes uploading the photo with the returned
  ## UploadRef,
  ## CreatePhoto
  ## publishes the uploaded Photo to
  ## Street View on Google Maps.
  ## 
  ## Currently, the only way to set heading, pitch, and roll in CreatePhoto is
  ## through the [Photo Sphere XMP
  ## metadata](https://developers.google.com/streetview/spherical-metadata) in
  ## the photo bytes. CreatePhoto ignores the  `pose.heading`, `pose.pitch`,
  ## `pose.roll`, `pose.altitude`, and `pose.level` fields in Pose.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed or if
  ## the uploaded photo is not a 360 photo.
  ## * google.rpc.Code.NOT_FOUND if the upload reference does not exist.
  ## * google.rpc.Code.RESOURCE_EXHAUSTED if the account has reached the
  ## storage limit.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578843 = newJObject()
  var body_578845 = newJObject()
  add(query_578843, "key", newJString(key))
  add(query_578843, "prettyPrint", newJBool(prettyPrint))
  add(query_578843, "oauth_token", newJString(oauthToken))
  add(query_578843, "$.xgafv", newJString(Xgafv))
  add(query_578843, "alt", newJString(alt))
  add(query_578843, "uploadType", newJString(uploadType))
  add(query_578843, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578845 = body
  add(query_578843, "callback", newJString(callback))
  add(query_578843, "fields", newJString(fields))
  add(query_578843, "access_token", newJString(accessToken))
  add(query_578843, "upload_protocol", newJString(uploadProtocol))
  result = call_578842.call(nil, query_578843, nil, nil, body_578845)

var streetviewpublishPhotoCreate* = Call_StreetviewpublishPhotoCreate_578610(
    name: "streetviewpublishPhotoCreate", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo",
    validator: validate_StreetviewpublishPhotoCreate_578611, base: "/",
    url: url_StreetviewpublishPhotoCreate_578612, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoUpdate_578884 = ref object of OpenApiRestCall_578339
proc url_StreetviewpublishPhotoUpdate_578886(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/photo/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreetviewpublishPhotoUpdate_578885(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the metadata of a Photo, such
  ## as pose, place association, connections, etc. Changing the pixels of a
  ## photo is not supported.
  ## 
  ## Only the fields specified in the
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed.
  ## * google.rpc.Code.NOT_FOUND if the requested photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Required. A unique identifier for a photo.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_578901 = path.getOrDefault("id")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "id", valid_578901
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Required. Mask that identifies fields on the photo metadata to update.
  ## If not present, the old Photo
  ## metadata is entirely replaced with the
  ## new Photo metadata in this request.
  ## The update fails if invalid fields are specified. Multiple fields can be
  ## specified in a comma-delimited list.
  ## 
  ## The following fields are valid:
  ## 
  ## * `pose.heading`
  ## * `pose.latLngPair`
  ## * `pose.pitch`
  ## * `pose.roll`
  ## * `pose.level`
  ## * `pose.altitude`
  ## * `connections`
  ## * `places`
  ## 
  ## 
  ## <aside class="note"><b>Note:</b> When
  ## updateMask
  ## contains repeated fields, the entire set of repeated values get replaced
  ## with the new contents. For example, if
  ## updateMask
  ## contains `connections` and `UpdatePhotoRequest.photo.connections` is empty,
  ## all connections are removed.</aside>
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578902 = query.getOrDefault("key")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "key", valid_578902
  var valid_578903 = query.getOrDefault("prettyPrint")
  valid_578903 = validateParameter(valid_578903, JBool, required = false,
                                 default = newJBool(true))
  if valid_578903 != nil:
    section.add "prettyPrint", valid_578903
  var valid_578904 = query.getOrDefault("oauth_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "oauth_token", valid_578904
  var valid_578905 = query.getOrDefault("$.xgafv")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("1"))
  if valid_578905 != nil:
    section.add "$.xgafv", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("updateMask")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "updateMask", valid_578909
  var valid_578910 = query.getOrDefault("callback")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "callback", valid_578910
  var valid_578911 = query.getOrDefault("fields")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "fields", valid_578911
  var valid_578912 = query.getOrDefault("access_token")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "access_token", valid_578912
  var valid_578913 = query.getOrDefault("upload_protocol")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "upload_protocol", valid_578913
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

proc call*(call_578915: Call_StreetviewpublishPhotoUpdate_578884; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadata of a Photo, such
  ## as pose, place association, connections, etc. Changing the pixels of a
  ## photo is not supported.
  ## 
  ## Only the fields specified in the
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed.
  ## * google.rpc.Code.NOT_FOUND if the requested photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
  ## 
  let valid = call_578915.validator(path, query, header, formData, body)
  let scheme = call_578915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578915.url(scheme.get, call_578915.host, call_578915.base,
                         call_578915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578915, url, valid)

proc call*(call_578916: Call_StreetviewpublishPhotoUpdate_578884; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## streetviewpublishPhotoUpdate
  ## Updates the metadata of a Photo, such
  ## as pose, place association, connections, etc. Changing the pixels of a
  ## photo is not supported.
  ## 
  ## Only the fields specified in the
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed.
  ## * google.rpc.Code.NOT_FOUND if the requested photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Required. A unique identifier for a photo.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Required. Mask that identifies fields on the photo metadata to update.
  ## If not present, the old Photo
  ## metadata is entirely replaced with the
  ## new Photo metadata in this request.
  ## The update fails if invalid fields are specified. Multiple fields can be
  ## specified in a comma-delimited list.
  ## 
  ## The following fields are valid:
  ## 
  ## * `pose.heading`
  ## * `pose.latLngPair`
  ## * `pose.pitch`
  ## * `pose.roll`
  ## * `pose.level`
  ## * `pose.altitude`
  ## * `connections`
  ## * `places`
  ## 
  ## 
  ## <aside class="note"><b>Note:</b> When
  ## updateMask
  ## contains repeated fields, the entire set of repeated values get replaced
  ## with the new contents. For example, if
  ## updateMask
  ## contains `connections` and `UpdatePhotoRequest.photo.connections` is empty,
  ## all connections are removed.</aside>
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578917 = newJObject()
  var query_578918 = newJObject()
  var body_578919 = newJObject()
  add(query_578918, "key", newJString(key))
  add(query_578918, "prettyPrint", newJBool(prettyPrint))
  add(query_578918, "oauth_token", newJString(oauthToken))
  add(query_578918, "$.xgafv", newJString(Xgafv))
  add(path_578917, "id", newJString(id))
  add(query_578918, "alt", newJString(alt))
  add(query_578918, "uploadType", newJString(uploadType))
  add(query_578918, "quotaUser", newJString(quotaUser))
  add(query_578918, "updateMask", newJString(updateMask))
  if body != nil:
    body_578919 = body
  add(query_578918, "callback", newJString(callback))
  add(query_578918, "fields", newJString(fields))
  add(query_578918, "access_token", newJString(accessToken))
  add(query_578918, "upload_protocol", newJString(uploadProtocol))
  result = call_578916.call(path_578917, query_578918, nil, nil, body_578919)

var streetviewpublishPhotoUpdate* = Call_StreetviewpublishPhotoUpdate_578884(
    name: "streetviewpublishPhotoUpdate", meth: HttpMethod.HttpPut,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{id}",
    validator: validate_StreetviewpublishPhotoUpdate_578885, base: "/",
    url: url_StreetviewpublishPhotoUpdate_578886, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoGet_578920 = ref object of OpenApiRestCall_578339
proc url_StreetviewpublishPhotoGet_578922(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "photoId" in path, "`photoId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/photo/"),
               (kind: VariableSegment, value: "photoId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreetviewpublishPhotoGet_578921(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metadata of the specified
  ## Photo.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested Photo.
  ## * google.rpc.Code.NOT_FOUND if the requested
  ## Photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   photoId: JString (required)
  ##          : Required. ID of the Photo.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `photoId` field"
  var valid_578923 = path.getOrDefault("photoId")
  valid_578923 = validateParameter(valid_578923, JString, required = true,
                                 default = nil)
  if valid_578923 != nil:
    section.add "photoId", valid_578923
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
  section = newJObject()
  var valid_578924 = query.getOrDefault("key")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "key", valid_578924
  var valid_578925 = query.getOrDefault("prettyPrint")
  valid_578925 = validateParameter(valid_578925, JBool, required = false,
                                 default = newJBool(true))
  if valid_578925 != nil:
    section.add "prettyPrint", valid_578925
  var valid_578926 = query.getOrDefault("oauth_token")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "oauth_token", valid_578926
  var valid_578927 = query.getOrDefault("$.xgafv")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = newJString("1"))
  if valid_578927 != nil:
    section.add "$.xgafv", valid_578927
  var valid_578928 = query.getOrDefault("alt")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("json"))
  if valid_578928 != nil:
    section.add "alt", valid_578928
  var valid_578929 = query.getOrDefault("uploadType")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "uploadType", valid_578929
  var valid_578930 = query.getOrDefault("quotaUser")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "quotaUser", valid_578930
  var valid_578931 = query.getOrDefault("callback")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "callback", valid_578931
  var valid_578932 = query.getOrDefault("languageCode")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "languageCode", valid_578932
  var valid_578933 = query.getOrDefault("fields")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "fields", valid_578933
  var valid_578934 = query.getOrDefault("access_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "access_token", valid_578934
  var valid_578935 = query.getOrDefault("upload_protocol")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "upload_protocol", valid_578935
  var valid_578936 = query.getOrDefault("view")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_578936 != nil:
    section.add "view", valid_578936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578937: Call_StreetviewpublishPhotoGet_578920; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metadata of the specified
  ## Photo.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested Photo.
  ## * google.rpc.Code.NOT_FOUND if the requested
  ## Photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
  ## 
  let valid = call_578937.validator(path, query, header, formData, body)
  let scheme = call_578937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578937.url(scheme.get, call_578937.host, call_578937.base,
                         call_578937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578937, url, valid)

proc call*(call_578938: Call_StreetviewpublishPhotoGet_578920; photoId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; languageCode: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          view: string = "BASIC"): Recallable =
  ## streetviewpublishPhotoGet
  ## Gets the metadata of the specified
  ## Photo.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested Photo.
  ## * google.rpc.Code.NOT_FOUND if the requested
  ## Photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   photoId: string (required)
  ##          : Required. ID of the Photo.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
  var path_578939 = newJObject()
  var query_578940 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(query_578940, "$.xgafv", newJString(Xgafv))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "uploadType", newJString(uploadType))
  add(path_578939, "photoId", newJString(photoId))
  add(query_578940, "quotaUser", newJString(quotaUser))
  add(query_578940, "callback", newJString(callback))
  add(query_578940, "languageCode", newJString(languageCode))
  add(query_578940, "fields", newJString(fields))
  add(query_578940, "access_token", newJString(accessToken))
  add(query_578940, "upload_protocol", newJString(uploadProtocol))
  add(query_578940, "view", newJString(view))
  result = call_578938.call(path_578939, query_578940, nil, nil, nil)

var streetviewpublishPhotoGet* = Call_StreetviewpublishPhotoGet_578920(
    name: "streetviewpublishPhotoGet", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{photoId}",
    validator: validate_StreetviewpublishPhotoGet_578921, base: "/",
    url: url_StreetviewpublishPhotoGet_578922, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoDelete_578941 = ref object of OpenApiRestCall_578339
proc url_StreetviewpublishPhotoDelete_578943(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "photoId" in path, "`photoId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/photo/"),
               (kind: VariableSegment, value: "photoId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreetviewpublishPhotoDelete_578942(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Photo and its metadata.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.NOT_FOUND if the photo ID does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   photoId: JString (required)
  ##          : Required. ID of the Photo.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `photoId` field"
  var valid_578944 = path.getOrDefault("photoId")
  valid_578944 = validateParameter(valid_578944, JString, required = true,
                                 default = nil)
  if valid_578944 != nil:
    section.add "photoId", valid_578944
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  var valid_578946 = query.getOrDefault("prettyPrint")
  valid_578946 = validateParameter(valid_578946, JBool, required = false,
                                 default = newJBool(true))
  if valid_578946 != nil:
    section.add "prettyPrint", valid_578946
  var valid_578947 = query.getOrDefault("oauth_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "oauth_token", valid_578947
  var valid_578948 = query.getOrDefault("$.xgafv")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("1"))
  if valid_578948 != nil:
    section.add "$.xgafv", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("uploadType")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "uploadType", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("callback")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "callback", valid_578952
  var valid_578953 = query.getOrDefault("fields")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "fields", valid_578953
  var valid_578954 = query.getOrDefault("access_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "access_token", valid_578954
  var valid_578955 = query.getOrDefault("upload_protocol")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "upload_protocol", valid_578955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578956: Call_StreetviewpublishPhotoDelete_578941; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Photo and its metadata.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.NOT_FOUND if the photo ID does not exist.
  ## 
  let valid = call_578956.validator(path, query, header, formData, body)
  let scheme = call_578956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578956.url(scheme.get, call_578956.host, call_578956.base,
                         call_578956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578956, url, valid)

proc call*(call_578957: Call_StreetviewpublishPhotoDelete_578941; photoId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## streetviewpublishPhotoDelete
  ## Deletes a Photo and its metadata.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.NOT_FOUND if the photo ID does not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   photoId: string (required)
  ##          : Required. ID of the Photo.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578958 = newJObject()
  var query_578959 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(query_578959, "$.xgafv", newJString(Xgafv))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "uploadType", newJString(uploadType))
  add(path_578958, "photoId", newJString(photoId))
  add(query_578959, "quotaUser", newJString(quotaUser))
  add(query_578959, "callback", newJString(callback))
  add(query_578959, "fields", newJString(fields))
  add(query_578959, "access_token", newJString(accessToken))
  add(query_578959, "upload_protocol", newJString(uploadProtocol))
  result = call_578957.call(path_578958, query_578959, nil, nil, nil)

var streetviewpublishPhotoDelete* = Call_StreetviewpublishPhotoDelete_578941(
    name: "streetviewpublishPhotoDelete", meth: HttpMethod.HttpDelete,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{photoId}",
    validator: validate_StreetviewpublishPhotoDelete_578942, base: "/",
    url: url_StreetviewpublishPhotoDelete_578943, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoStartUpload_578960 = ref object of OpenApiRestCall_578339
proc url_StreetviewpublishPhotoStartUpload_578962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotoStartUpload_578961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an upload session to start uploading photo bytes.  The method uses
  ## the upload URL of the returned
  ## UploadRef to upload the bytes for
  ## the Photo.
  ## 
  ## In addition to the photo requirements shown in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604,
  ## the photo must meet the following requirements:
  ## 
  ## * Photo Sphere XMP metadata must be included in the photo medadata. See
  ## https://developers.google.com/streetview/spherical-metadata for the
  ## required fields.
  ## * The pixel size of the photo must meet the size requirements listed in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604, and
  ## the photo must be a full 360 horizontally.
  ## 
  ## After the upload completes, the method uses
  ## UploadRef with
  ## CreatePhoto
  ## to create the Photo object entry.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578963 = query.getOrDefault("key")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "key", valid_578963
  var valid_578964 = query.getOrDefault("prettyPrint")
  valid_578964 = validateParameter(valid_578964, JBool, required = false,
                                 default = newJBool(true))
  if valid_578964 != nil:
    section.add "prettyPrint", valid_578964
  var valid_578965 = query.getOrDefault("oauth_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "oauth_token", valid_578965
  var valid_578966 = query.getOrDefault("$.xgafv")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = newJString("1"))
  if valid_578966 != nil:
    section.add "$.xgafv", valid_578966
  var valid_578967 = query.getOrDefault("alt")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("json"))
  if valid_578967 != nil:
    section.add "alt", valid_578967
  var valid_578968 = query.getOrDefault("uploadType")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "uploadType", valid_578968
  var valid_578969 = query.getOrDefault("quotaUser")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "quotaUser", valid_578969
  var valid_578970 = query.getOrDefault("callback")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "callback", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  var valid_578972 = query.getOrDefault("access_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "access_token", valid_578972
  var valid_578973 = query.getOrDefault("upload_protocol")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "upload_protocol", valid_578973
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

proc call*(call_578975: Call_StreetviewpublishPhotoStartUpload_578960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an upload session to start uploading photo bytes.  The method uses
  ## the upload URL of the returned
  ## UploadRef to upload the bytes for
  ## the Photo.
  ## 
  ## In addition to the photo requirements shown in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604,
  ## the photo must meet the following requirements:
  ## 
  ## * Photo Sphere XMP metadata must be included in the photo medadata. See
  ## https://developers.google.com/streetview/spherical-metadata for the
  ## required fields.
  ## * The pixel size of the photo must meet the size requirements listed in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604, and
  ## the photo must be a full 360 horizontally.
  ## 
  ## After the upload completes, the method uses
  ## UploadRef with
  ## CreatePhoto
  ## to create the Photo object entry.
  ## 
  let valid = call_578975.validator(path, query, header, formData, body)
  let scheme = call_578975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578975.url(scheme.get, call_578975.host, call_578975.base,
                         call_578975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578975, url, valid)

proc call*(call_578976: Call_StreetviewpublishPhotoStartUpload_578960;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## streetviewpublishPhotoStartUpload
  ## Creates an upload session to start uploading photo bytes.  The method uses
  ## the upload URL of the returned
  ## UploadRef to upload the bytes for
  ## the Photo.
  ## 
  ## In addition to the photo requirements shown in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604,
  ## the photo must meet the following requirements:
  ## 
  ## * Photo Sphere XMP metadata must be included in the photo medadata. See
  ## https://developers.google.com/streetview/spherical-metadata for the
  ## required fields.
  ## * The pixel size of the photo must meet the size requirements listed in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604, and
  ## the photo must be a full 360 horizontally.
  ## 
  ## After the upload completes, the method uses
  ## UploadRef with
  ## CreatePhoto
  ## to create the Photo object entry.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578977 = newJObject()
  var body_578978 = newJObject()
  add(query_578977, "key", newJString(key))
  add(query_578977, "prettyPrint", newJBool(prettyPrint))
  add(query_578977, "oauth_token", newJString(oauthToken))
  add(query_578977, "$.xgafv", newJString(Xgafv))
  add(query_578977, "alt", newJString(alt))
  add(query_578977, "uploadType", newJString(uploadType))
  add(query_578977, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578978 = body
  add(query_578977, "callback", newJString(callback))
  add(query_578977, "fields", newJString(fields))
  add(query_578977, "access_token", newJString(accessToken))
  add(query_578977, "upload_protocol", newJString(uploadProtocol))
  result = call_578976.call(nil, query_578977, nil, nil, body_578978)

var streetviewpublishPhotoStartUpload* = Call_StreetviewpublishPhotoStartUpload_578960(
    name: "streetviewpublishPhotoStartUpload", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo:startUpload",
    validator: validate_StreetviewpublishPhotoStartUpload_578961, base: "/",
    url: url_StreetviewpublishPhotoStartUpload_578962, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosList_578979 = ref object of OpenApiRestCall_578339
proc url_StreetviewpublishPhotosList_578981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosList_578980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Photos that belong to
  ## the user.
  ## 
  ## <aside class="note"><b>Note:</b> Recently created photos that are still
  ## being indexed are not returned in the response.</aside>
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of photos to return.
  ## `pageSize` must be non-negative. If `pageSize` is zero or is not provided,
  ## the default page size of 100 is used.
  ## The number of photos returned in the response may be less than `pageSize`
  ## if the number of photos that belong to the user is less than `pageSize`.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Required. The filter expression. For example: `placeId=ChIJj61dQgK6j4AR4GeTYWZsKWw`.
  ## 
  ## The only filter supported at the moment is `placeId`.
  ##   pageToken: JString
  ##            : The
  ## nextPageToken
  ## value returned from a previous
  ## ListPhotos
  ## request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Required. Specifies if a download URL for the photos bytes should be returned in the
  ## Photos response.
  section = newJObject()
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("prettyPrint")
  valid_578983 = validateParameter(valid_578983, JBool, required = false,
                                 default = newJBool(true))
  if valid_578983 != nil:
    section.add "prettyPrint", valid_578983
  var valid_578984 = query.getOrDefault("oauth_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "oauth_token", valid_578984
  var valid_578985 = query.getOrDefault("$.xgafv")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = newJString("1"))
  if valid_578985 != nil:
    section.add "$.xgafv", valid_578985
  var valid_578986 = query.getOrDefault("pageSize")
  valid_578986 = validateParameter(valid_578986, JInt, required = false, default = nil)
  if valid_578986 != nil:
    section.add "pageSize", valid_578986
  var valid_578987 = query.getOrDefault("alt")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("json"))
  if valid_578987 != nil:
    section.add "alt", valid_578987
  var valid_578988 = query.getOrDefault("uploadType")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "uploadType", valid_578988
  var valid_578989 = query.getOrDefault("quotaUser")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "quotaUser", valid_578989
  var valid_578990 = query.getOrDefault("filter")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "filter", valid_578990
  var valid_578991 = query.getOrDefault("pageToken")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "pageToken", valid_578991
  var valid_578992 = query.getOrDefault("callback")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "callback", valid_578992
  var valid_578993 = query.getOrDefault("languageCode")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "languageCode", valid_578993
  var valid_578994 = query.getOrDefault("fields")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "fields", valid_578994
  var valid_578995 = query.getOrDefault("access_token")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "access_token", valid_578995
  var valid_578996 = query.getOrDefault("upload_protocol")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "upload_protocol", valid_578996
  var valid_578997 = query.getOrDefault("view")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_578997 != nil:
    section.add "view", valid_578997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578998: Call_StreetviewpublishPhotosList_578979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Photos that belong to
  ## the user.
  ## 
  ## <aside class="note"><b>Note:</b> Recently created photos that are still
  ## being indexed are not returned in the response.</aside>
  ## 
  let valid = call_578998.validator(path, query, header, formData, body)
  let scheme = call_578998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578998.url(scheme.get, call_578998.host, call_578998.base,
                         call_578998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578998, url, valid)

proc call*(call_578999: Call_StreetviewpublishPhotosList_578979; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; languageCode: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; view: string = "BASIC"): Recallable =
  ## streetviewpublishPhotosList
  ## Lists all the Photos that belong to
  ## the user.
  ## 
  ## <aside class="note"><b>Note:</b> Recently created photos that are still
  ## being indexed are not returned in the response.</aside>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of photos to return.
  ## `pageSize` must be non-negative. If `pageSize` is zero or is not provided,
  ## the default page size of 100 is used.
  ## The number of photos returned in the response may be less than `pageSize`
  ## if the number of photos that belong to the user is less than `pageSize`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Required. The filter expression. For example: `placeId=ChIJj61dQgK6j4AR4GeTYWZsKWw`.
  ## 
  ## The only filter supported at the moment is `placeId`.
  ##   pageToken: string
  ##            : The
  ## nextPageToken
  ## value returned from a previous
  ## ListPhotos
  ## request, if any.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Required. Specifies if a download URL for the photos bytes should be returned in the
  ## Photos response.
  var query_579000 = newJObject()
  add(query_579000, "key", newJString(key))
  add(query_579000, "prettyPrint", newJBool(prettyPrint))
  add(query_579000, "oauth_token", newJString(oauthToken))
  add(query_579000, "$.xgafv", newJString(Xgafv))
  add(query_579000, "pageSize", newJInt(pageSize))
  add(query_579000, "alt", newJString(alt))
  add(query_579000, "uploadType", newJString(uploadType))
  add(query_579000, "quotaUser", newJString(quotaUser))
  add(query_579000, "filter", newJString(filter))
  add(query_579000, "pageToken", newJString(pageToken))
  add(query_579000, "callback", newJString(callback))
  add(query_579000, "languageCode", newJString(languageCode))
  add(query_579000, "fields", newJString(fields))
  add(query_579000, "access_token", newJString(accessToken))
  add(query_579000, "upload_protocol", newJString(uploadProtocol))
  add(query_579000, "view", newJString(view))
  result = call_578999.call(nil, query_579000, nil, nil, nil)

var streetviewpublishPhotosList* = Call_StreetviewpublishPhotosList_578979(
    name: "streetviewpublishPhotosList", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos",
    validator: validate_StreetviewpublishPhotosList_578980, base: "/",
    url: url_StreetviewpublishPhotosList_578981, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchDelete_579001 = ref object of OpenApiRestCall_578339
proc url_StreetviewpublishPhotosBatchDelete_579003(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchDelete_579002(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a list of Photos and their
  ## metadata.
  ## 
  ## Note that if
  ## BatchDeletePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchDeletePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchDeletePhotosResponse.results.
  ## See
  ## DeletePhoto
  ## for specific failures that can occur per photo.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579004 = query.getOrDefault("key")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "key", valid_579004
  var valid_579005 = query.getOrDefault("prettyPrint")
  valid_579005 = validateParameter(valid_579005, JBool, required = false,
                                 default = newJBool(true))
  if valid_579005 != nil:
    section.add "prettyPrint", valid_579005
  var valid_579006 = query.getOrDefault("oauth_token")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "oauth_token", valid_579006
  var valid_579007 = query.getOrDefault("$.xgafv")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = newJString("1"))
  if valid_579007 != nil:
    section.add "$.xgafv", valid_579007
  var valid_579008 = query.getOrDefault("alt")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("json"))
  if valid_579008 != nil:
    section.add "alt", valid_579008
  var valid_579009 = query.getOrDefault("uploadType")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "uploadType", valid_579009
  var valid_579010 = query.getOrDefault("quotaUser")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "quotaUser", valid_579010
  var valid_579011 = query.getOrDefault("callback")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "callback", valid_579011
  var valid_579012 = query.getOrDefault("fields")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "fields", valid_579012
  var valid_579013 = query.getOrDefault("access_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "access_token", valid_579013
  var valid_579014 = query.getOrDefault("upload_protocol")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "upload_protocol", valid_579014
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

proc call*(call_579016: Call_StreetviewpublishPhotosBatchDelete_579001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a list of Photos and their
  ## metadata.
  ## 
  ## Note that if
  ## BatchDeletePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchDeletePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchDeletePhotosResponse.results.
  ## See
  ## DeletePhoto
  ## for specific failures that can occur per photo.
  ## 
  let valid = call_579016.validator(path, query, header, formData, body)
  let scheme = call_579016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579016.url(scheme.get, call_579016.host, call_579016.base,
                         call_579016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579016, url, valid)

proc call*(call_579017: Call_StreetviewpublishPhotosBatchDelete_579001;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## streetviewpublishPhotosBatchDelete
  ## Deletes a list of Photos and their
  ## metadata.
  ## 
  ## Note that if
  ## BatchDeletePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchDeletePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchDeletePhotosResponse.results.
  ## See
  ## DeletePhoto
  ## for specific failures that can occur per photo.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579018 = newJObject()
  var body_579019 = newJObject()
  add(query_579018, "key", newJString(key))
  add(query_579018, "prettyPrint", newJBool(prettyPrint))
  add(query_579018, "oauth_token", newJString(oauthToken))
  add(query_579018, "$.xgafv", newJString(Xgafv))
  add(query_579018, "alt", newJString(alt))
  add(query_579018, "uploadType", newJString(uploadType))
  add(query_579018, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579019 = body
  add(query_579018, "callback", newJString(callback))
  add(query_579018, "fields", newJString(fields))
  add(query_579018, "access_token", newJString(accessToken))
  add(query_579018, "upload_protocol", newJString(uploadProtocol))
  result = call_579017.call(nil, query_579018, nil, nil, body_579019)

var streetviewpublishPhotosBatchDelete* = Call_StreetviewpublishPhotosBatchDelete_579001(
    name: "streetviewpublishPhotosBatchDelete", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchDelete",
    validator: validate_StreetviewpublishPhotosBatchDelete_579002, base: "/",
    url: url_StreetviewpublishPhotosBatchDelete_579003, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchGet_579020 = ref object of OpenApiRestCall_578339
proc url_StreetviewpublishPhotosBatchGet_579022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchGet_579021(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metadata of the specified
  ## Photo batch.
  ## 
  ## Note that if
  ## BatchGetPhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchGetPhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchGetPhotosResponse.results.
  ## See
  ## GetPhoto
  ## for specific failures that can occur per photo.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   photoIds: JArray
  ##           : Required. IDs of the Photos. For HTTP
  ## GET requests, the URL query parameter should be
  ## `photoIds=<id1>&photoIds=<id2>&...`.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
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
  var valid_579026 = query.getOrDefault("$.xgafv")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = newJString("1"))
  if valid_579026 != nil:
    section.add "$.xgafv", valid_579026
  var valid_579027 = query.getOrDefault("alt")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = newJString("json"))
  if valid_579027 != nil:
    section.add "alt", valid_579027
  var valid_579028 = query.getOrDefault("uploadType")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "uploadType", valid_579028
  var valid_579029 = query.getOrDefault("quotaUser")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "quotaUser", valid_579029
  var valid_579030 = query.getOrDefault("photoIds")
  valid_579030 = validateParameter(valid_579030, JArray, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "photoIds", valid_579030
  var valid_579031 = query.getOrDefault("callback")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "callback", valid_579031
  var valid_579032 = query.getOrDefault("languageCode")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "languageCode", valid_579032
  var valid_579033 = query.getOrDefault("fields")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "fields", valid_579033
  var valid_579034 = query.getOrDefault("access_token")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "access_token", valid_579034
  var valid_579035 = query.getOrDefault("upload_protocol")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "upload_protocol", valid_579035
  var valid_579036 = query.getOrDefault("view")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579036 != nil:
    section.add "view", valid_579036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579037: Call_StreetviewpublishPhotosBatchGet_579020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the metadata of the specified
  ## Photo batch.
  ## 
  ## Note that if
  ## BatchGetPhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchGetPhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchGetPhotosResponse.results.
  ## See
  ## GetPhoto
  ## for specific failures that can occur per photo.
  ## 
  let valid = call_579037.validator(path, query, header, formData, body)
  let scheme = call_579037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579037.url(scheme.get, call_579037.host, call_579037.base,
                         call_579037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579037, url, valid)

proc call*(call_579038: Call_StreetviewpublishPhotosBatchGet_579020;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; photoIds: JsonNode = nil; callback: string = "";
          languageCode: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; view: string = "BASIC"): Recallable =
  ## streetviewpublishPhotosBatchGet
  ## Gets the metadata of the specified
  ## Photo batch.
  ## 
  ## Note that if
  ## BatchGetPhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchGetPhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchGetPhotosResponse.results.
  ## See
  ## GetPhoto
  ## for specific failures that can occur per photo.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   photoIds: JArray
  ##           : Required. IDs of the Photos. For HTTP
  ## GET requests, the URL query parameter should be
  ## `photoIds=<id1>&photoIds=<id2>&...`.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
  var query_579039 = newJObject()
  add(query_579039, "key", newJString(key))
  add(query_579039, "prettyPrint", newJBool(prettyPrint))
  add(query_579039, "oauth_token", newJString(oauthToken))
  add(query_579039, "$.xgafv", newJString(Xgafv))
  add(query_579039, "alt", newJString(alt))
  add(query_579039, "uploadType", newJString(uploadType))
  add(query_579039, "quotaUser", newJString(quotaUser))
  if photoIds != nil:
    query_579039.add "photoIds", photoIds
  add(query_579039, "callback", newJString(callback))
  add(query_579039, "languageCode", newJString(languageCode))
  add(query_579039, "fields", newJString(fields))
  add(query_579039, "access_token", newJString(accessToken))
  add(query_579039, "upload_protocol", newJString(uploadProtocol))
  add(query_579039, "view", newJString(view))
  result = call_579038.call(nil, query_579039, nil, nil, nil)

var streetviewpublishPhotosBatchGet* = Call_StreetviewpublishPhotosBatchGet_579020(
    name: "streetviewpublishPhotosBatchGet", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchGet",
    validator: validate_StreetviewpublishPhotosBatchGet_579021, base: "/",
    url: url_StreetviewpublishPhotosBatchGet_579022, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchUpdate_579040 = ref object of OpenApiRestCall_578339
proc url_StreetviewpublishPhotosBatchUpdate_579042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchUpdate_579041(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the metadata of Photos, such
  ## as pose, place association, connections, etc. Changing the pixels of photos
  ## is not supported.
  ## 
  ## Note that if
  ## BatchUpdatePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchUpdatePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchUpdatePhotosResponse.results.
  ## See
  ## UpdatePhoto
  ## for specific failures that can occur per photo.
  ## 
  ## Only the fields specified in
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## The number of
  ## UpdatePhotoRequest
  ## messages in a
  ## BatchUpdatePhotosRequest
  ## must not exceed 20.
  ## 
  ## <aside class="note"><b>Note:</b> To update
  ## Pose.altitude,
  ## Pose.latLngPair has to be
  ## filled as well. Otherwise, the request will fail.</aside>
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579043 = query.getOrDefault("key")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "key", valid_579043
  var valid_579044 = query.getOrDefault("prettyPrint")
  valid_579044 = validateParameter(valid_579044, JBool, required = false,
                                 default = newJBool(true))
  if valid_579044 != nil:
    section.add "prettyPrint", valid_579044
  var valid_579045 = query.getOrDefault("oauth_token")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "oauth_token", valid_579045
  var valid_579046 = query.getOrDefault("$.xgafv")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("1"))
  if valid_579046 != nil:
    section.add "$.xgafv", valid_579046
  var valid_579047 = query.getOrDefault("alt")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = newJString("json"))
  if valid_579047 != nil:
    section.add "alt", valid_579047
  var valid_579048 = query.getOrDefault("uploadType")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "uploadType", valid_579048
  var valid_579049 = query.getOrDefault("quotaUser")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "quotaUser", valid_579049
  var valid_579050 = query.getOrDefault("callback")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "callback", valid_579050
  var valid_579051 = query.getOrDefault("fields")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "fields", valid_579051
  var valid_579052 = query.getOrDefault("access_token")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "access_token", valid_579052
  var valid_579053 = query.getOrDefault("upload_protocol")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "upload_protocol", valid_579053
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

proc call*(call_579055: Call_StreetviewpublishPhotosBatchUpdate_579040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the metadata of Photos, such
  ## as pose, place association, connections, etc. Changing the pixels of photos
  ## is not supported.
  ## 
  ## Note that if
  ## BatchUpdatePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchUpdatePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchUpdatePhotosResponse.results.
  ## See
  ## UpdatePhoto
  ## for specific failures that can occur per photo.
  ## 
  ## Only the fields specified in
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## The number of
  ## UpdatePhotoRequest
  ## messages in a
  ## BatchUpdatePhotosRequest
  ## must not exceed 20.
  ## 
  ## <aside class="note"><b>Note:</b> To update
  ## Pose.altitude,
  ## Pose.latLngPair has to be
  ## filled as well. Otherwise, the request will fail.</aside>
  ## 
  let valid = call_579055.validator(path, query, header, formData, body)
  let scheme = call_579055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579055.url(scheme.get, call_579055.host, call_579055.base,
                         call_579055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579055, url, valid)

proc call*(call_579056: Call_StreetviewpublishPhotosBatchUpdate_579040;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## streetviewpublishPhotosBatchUpdate
  ## Updates the metadata of Photos, such
  ## as pose, place association, connections, etc. Changing the pixels of photos
  ## is not supported.
  ## 
  ## Note that if
  ## BatchUpdatePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchUpdatePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchUpdatePhotosResponse.results.
  ## See
  ## UpdatePhoto
  ## for specific failures that can occur per photo.
  ## 
  ## Only the fields specified in
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## The number of
  ## UpdatePhotoRequest
  ## messages in a
  ## BatchUpdatePhotosRequest
  ## must not exceed 20.
  ## 
  ## <aside class="note"><b>Note:</b> To update
  ## Pose.altitude,
  ## Pose.latLngPair has to be
  ## filled as well. Otherwise, the request will fail.</aside>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579057 = newJObject()
  var body_579058 = newJObject()
  add(query_579057, "key", newJString(key))
  add(query_579057, "prettyPrint", newJBool(prettyPrint))
  add(query_579057, "oauth_token", newJString(oauthToken))
  add(query_579057, "$.xgafv", newJString(Xgafv))
  add(query_579057, "alt", newJString(alt))
  add(query_579057, "uploadType", newJString(uploadType))
  add(query_579057, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579058 = body
  add(query_579057, "callback", newJString(callback))
  add(query_579057, "fields", newJString(fields))
  add(query_579057, "access_token", newJString(accessToken))
  add(query_579057, "upload_protocol", newJString(uploadProtocol))
  result = call_579056.call(nil, query_579057, nil, nil, body_579058)

var streetviewpublishPhotosBatchUpdate* = Call_StreetviewpublishPhotosBatchUpdate_579040(
    name: "streetviewpublishPhotosBatchUpdate", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchUpdate",
    validator: validate_StreetviewpublishPhotosBatchUpdate_579041, base: "/",
    url: url_StreetviewpublishPhotosBatchUpdate_579042, schemes: {Scheme.Https})
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
