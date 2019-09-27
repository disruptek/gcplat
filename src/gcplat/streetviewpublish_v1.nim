
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  gcpServiceName = "streetviewpublish"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StreetviewpublishPhotoCreate_593677 = ref object of OpenApiRestCall_593408
proc url_StreetviewpublishPhotoCreate_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotoCreate_593678(path: JsonNode; query: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593791 = query.getOrDefault("upload_protocol")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "upload_protocol", valid_593791
  var valid_593792 = query.getOrDefault("fields")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "fields", valid_593792
  var valid_593793 = query.getOrDefault("quotaUser")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "quotaUser", valid_593793
  var valid_593807 = query.getOrDefault("alt")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = newJString("json"))
  if valid_593807 != nil:
    section.add "alt", valid_593807
  var valid_593808 = query.getOrDefault("oauth_token")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "oauth_token", valid_593808
  var valid_593809 = query.getOrDefault("callback")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "callback", valid_593809
  var valid_593810 = query.getOrDefault("access_token")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "access_token", valid_593810
  var valid_593811 = query.getOrDefault("uploadType")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "uploadType", valid_593811
  var valid_593812 = query.getOrDefault("key")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "key", valid_593812
  var valid_593813 = query.getOrDefault("$.xgafv")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = newJString("1"))
  if valid_593813 != nil:
    section.add "$.xgafv", valid_593813
  var valid_593814 = query.getOrDefault("prettyPrint")
  valid_593814 = validateParameter(valid_593814, JBool, required = false,
                                 default = newJBool(true))
  if valid_593814 != nil:
    section.add "prettyPrint", valid_593814
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

proc call*(call_593838: Call_StreetviewpublishPhotoCreate_593677; path: JsonNode;
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
  let valid = call_593838.validator(path, query, header, formData, body)
  let scheme = call_593838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593838.url(scheme.get, call_593838.host, call_593838.base,
                         call_593838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593838, url, valid)

proc call*(call_593909: Call_StreetviewpublishPhotoCreate_593677;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593910 = newJObject()
  var body_593912 = newJObject()
  add(query_593910, "upload_protocol", newJString(uploadProtocol))
  add(query_593910, "fields", newJString(fields))
  add(query_593910, "quotaUser", newJString(quotaUser))
  add(query_593910, "alt", newJString(alt))
  add(query_593910, "oauth_token", newJString(oauthToken))
  add(query_593910, "callback", newJString(callback))
  add(query_593910, "access_token", newJString(accessToken))
  add(query_593910, "uploadType", newJString(uploadType))
  add(query_593910, "key", newJString(key))
  add(query_593910, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593912 = body
  add(query_593910, "prettyPrint", newJBool(prettyPrint))
  result = call_593909.call(nil, query_593910, nil, nil, body_593912)

var streetviewpublishPhotoCreate* = Call_StreetviewpublishPhotoCreate_593677(
    name: "streetviewpublishPhotoCreate", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo",
    validator: validate_StreetviewpublishPhotoCreate_593678, base: "/",
    url: url_StreetviewpublishPhotoCreate_593679, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoUpdate_593951 = ref object of OpenApiRestCall_593408
proc url_StreetviewpublishPhotoUpdate_593953(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/photo/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreetviewpublishPhotoUpdate_593952(path: JsonNode; query: JsonNode;
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
  var valid_593968 = path.getOrDefault("id")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "id", valid_593968
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  section = newJObject()
  var valid_593969 = query.getOrDefault("upload_protocol")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "upload_protocol", valid_593969
  var valid_593970 = query.getOrDefault("fields")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "fields", valid_593970
  var valid_593971 = query.getOrDefault("quotaUser")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "quotaUser", valid_593971
  var valid_593972 = query.getOrDefault("alt")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = newJString("json"))
  if valid_593972 != nil:
    section.add "alt", valid_593972
  var valid_593973 = query.getOrDefault("oauth_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "oauth_token", valid_593973
  var valid_593974 = query.getOrDefault("callback")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "callback", valid_593974
  var valid_593975 = query.getOrDefault("access_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "access_token", valid_593975
  var valid_593976 = query.getOrDefault("uploadType")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "uploadType", valid_593976
  var valid_593977 = query.getOrDefault("key")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "key", valid_593977
  var valid_593978 = query.getOrDefault("$.xgafv")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("1"))
  if valid_593978 != nil:
    section.add "$.xgafv", valid_593978
  var valid_593979 = query.getOrDefault("prettyPrint")
  valid_593979 = validateParameter(valid_593979, JBool, required = false,
                                 default = newJBool(true))
  if valid_593979 != nil:
    section.add "prettyPrint", valid_593979
  var valid_593980 = query.getOrDefault("updateMask")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "updateMask", valid_593980
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

proc call*(call_593982: Call_StreetviewpublishPhotoUpdate_593951; path: JsonNode;
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
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_StreetviewpublishPhotoUpdate_593951; id: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   id: string (required)
  ##     : Required. A unique identifier for a photo.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  var body_593986 = newJObject()
  add(query_593985, "upload_protocol", newJString(uploadProtocol))
  add(query_593985, "fields", newJString(fields))
  add(query_593985, "quotaUser", newJString(quotaUser))
  add(query_593985, "alt", newJString(alt))
  add(query_593985, "oauth_token", newJString(oauthToken))
  add(query_593985, "callback", newJString(callback))
  add(query_593985, "access_token", newJString(accessToken))
  add(query_593985, "uploadType", newJString(uploadType))
  add(path_593984, "id", newJString(id))
  add(query_593985, "key", newJString(key))
  add(query_593985, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593986 = body
  add(query_593985, "prettyPrint", newJBool(prettyPrint))
  add(query_593985, "updateMask", newJString(updateMask))
  result = call_593983.call(path_593984, query_593985, nil, nil, body_593986)

var streetviewpublishPhotoUpdate* = Call_StreetviewpublishPhotoUpdate_593951(
    name: "streetviewpublishPhotoUpdate", meth: HttpMethod.HttpPut,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{id}",
    validator: validate_StreetviewpublishPhotoUpdate_593952, base: "/",
    url: url_StreetviewpublishPhotoUpdate_593953, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoGet_593987 = ref object of OpenApiRestCall_593408
proc url_StreetviewpublishPhotoGet_593989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "photoId" in path, "`photoId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/photo/"),
               (kind: VariableSegment, value: "photoId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreetviewpublishPhotoGet_593988(path: JsonNode; query: JsonNode;
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
  var valid_593990 = path.getOrDefault("photoId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "photoId", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   languageCode: JString
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593991 = query.getOrDefault("upload_protocol")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "upload_protocol", valid_593991
  var valid_593992 = query.getOrDefault("fields")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "fields", valid_593992
  var valid_593993 = query.getOrDefault("view")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_593993 != nil:
    section.add "view", valid_593993
  var valid_593994 = query.getOrDefault("quotaUser")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "quotaUser", valid_593994
  var valid_593995 = query.getOrDefault("alt")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = newJString("json"))
  if valid_593995 != nil:
    section.add "alt", valid_593995
  var valid_593996 = query.getOrDefault("oauth_token")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "oauth_token", valid_593996
  var valid_593997 = query.getOrDefault("callback")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "callback", valid_593997
  var valid_593998 = query.getOrDefault("access_token")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "access_token", valid_593998
  var valid_593999 = query.getOrDefault("uploadType")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "uploadType", valid_593999
  var valid_594000 = query.getOrDefault("key")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "key", valid_594000
  var valid_594001 = query.getOrDefault("$.xgafv")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = newJString("1"))
  if valid_594001 != nil:
    section.add "$.xgafv", valid_594001
  var valid_594002 = query.getOrDefault("languageCode")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "languageCode", valid_594002
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

proc call*(call_594004: Call_StreetviewpublishPhotoGet_593987; path: JsonNode;
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
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_StreetviewpublishPhotoGet_593987; photoId: string;
          uploadProtocol: string = ""; fields: string = ""; view: string = "BASIC";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; languageCode: string = "";
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   photoId: string (required)
  ##          : Required. ID of the Photo.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(query_594007, "upload_protocol", newJString(uploadProtocol))
  add(path_594006, "photoId", newJString(photoId))
  add(query_594007, "fields", newJString(fields))
  add(query_594007, "view", newJString(view))
  add(query_594007, "quotaUser", newJString(quotaUser))
  add(query_594007, "alt", newJString(alt))
  add(query_594007, "oauth_token", newJString(oauthToken))
  add(query_594007, "callback", newJString(callback))
  add(query_594007, "access_token", newJString(accessToken))
  add(query_594007, "uploadType", newJString(uploadType))
  add(query_594007, "key", newJString(key))
  add(query_594007, "$.xgafv", newJString(Xgafv))
  add(query_594007, "languageCode", newJString(languageCode))
  add(query_594007, "prettyPrint", newJBool(prettyPrint))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var streetviewpublishPhotoGet* = Call_StreetviewpublishPhotoGet_593987(
    name: "streetviewpublishPhotoGet", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{photoId}",
    validator: validate_StreetviewpublishPhotoGet_593988, base: "/",
    url: url_StreetviewpublishPhotoGet_593989, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoDelete_594008 = ref object of OpenApiRestCall_593408
proc url_StreetviewpublishPhotoDelete_594010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "photoId" in path, "`photoId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/photo/"),
               (kind: VariableSegment, value: "photoId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreetviewpublishPhotoDelete_594009(path: JsonNode; query: JsonNode;
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
  var valid_594011 = path.getOrDefault("photoId")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "photoId", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594012 = query.getOrDefault("upload_protocol")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "upload_protocol", valid_594012
  var valid_594013 = query.getOrDefault("fields")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "fields", valid_594013
  var valid_594014 = query.getOrDefault("quotaUser")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "quotaUser", valid_594014
  var valid_594015 = query.getOrDefault("alt")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("json"))
  if valid_594015 != nil:
    section.add "alt", valid_594015
  var valid_594016 = query.getOrDefault("oauth_token")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "oauth_token", valid_594016
  var valid_594017 = query.getOrDefault("callback")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "callback", valid_594017
  var valid_594018 = query.getOrDefault("access_token")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "access_token", valid_594018
  var valid_594019 = query.getOrDefault("uploadType")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "uploadType", valid_594019
  var valid_594020 = query.getOrDefault("key")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "key", valid_594020
  var valid_594021 = query.getOrDefault("$.xgafv")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = newJString("1"))
  if valid_594021 != nil:
    section.add "$.xgafv", valid_594021
  var valid_594022 = query.getOrDefault("prettyPrint")
  valid_594022 = validateParameter(valid_594022, JBool, required = false,
                                 default = newJBool(true))
  if valid_594022 != nil:
    section.add "prettyPrint", valid_594022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_StreetviewpublishPhotoDelete_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Photo and its metadata.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.NOT_FOUND if the photo ID does not exist.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_StreetviewpublishPhotoDelete_594008; photoId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## streetviewpublishPhotoDelete
  ## Deletes a Photo and its metadata.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.NOT_FOUND if the photo ID does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   photoId: string (required)
  ##          : Required. ID of the Photo.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  add(query_594026, "upload_protocol", newJString(uploadProtocol))
  add(path_594025, "photoId", newJString(photoId))
  add(query_594026, "fields", newJString(fields))
  add(query_594026, "quotaUser", newJString(quotaUser))
  add(query_594026, "alt", newJString(alt))
  add(query_594026, "oauth_token", newJString(oauthToken))
  add(query_594026, "callback", newJString(callback))
  add(query_594026, "access_token", newJString(accessToken))
  add(query_594026, "uploadType", newJString(uploadType))
  add(query_594026, "key", newJString(key))
  add(query_594026, "$.xgafv", newJString(Xgafv))
  add(query_594026, "prettyPrint", newJBool(prettyPrint))
  result = call_594024.call(path_594025, query_594026, nil, nil, nil)

var streetviewpublishPhotoDelete* = Call_StreetviewpublishPhotoDelete_594008(
    name: "streetviewpublishPhotoDelete", meth: HttpMethod.HttpDelete,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{photoId}",
    validator: validate_StreetviewpublishPhotoDelete_594009, base: "/",
    url: url_StreetviewpublishPhotoDelete_594010, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoStartUpload_594027 = ref object of OpenApiRestCall_593408
proc url_StreetviewpublishPhotoStartUpload_594029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotoStartUpload_594028(path: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594030 = query.getOrDefault("upload_protocol")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "upload_protocol", valid_594030
  var valid_594031 = query.getOrDefault("fields")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "fields", valid_594031
  var valid_594032 = query.getOrDefault("quotaUser")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "quotaUser", valid_594032
  var valid_594033 = query.getOrDefault("alt")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = newJString("json"))
  if valid_594033 != nil:
    section.add "alt", valid_594033
  var valid_594034 = query.getOrDefault("oauth_token")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "oauth_token", valid_594034
  var valid_594035 = query.getOrDefault("callback")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "callback", valid_594035
  var valid_594036 = query.getOrDefault("access_token")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "access_token", valid_594036
  var valid_594037 = query.getOrDefault("uploadType")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "uploadType", valid_594037
  var valid_594038 = query.getOrDefault("key")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "key", valid_594038
  var valid_594039 = query.getOrDefault("$.xgafv")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("1"))
  if valid_594039 != nil:
    section.add "$.xgafv", valid_594039
  var valid_594040 = query.getOrDefault("prettyPrint")
  valid_594040 = validateParameter(valid_594040, JBool, required = false,
                                 default = newJBool(true))
  if valid_594040 != nil:
    section.add "prettyPrint", valid_594040
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

proc call*(call_594042: Call_StreetviewpublishPhotoStartUpload_594027;
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
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_StreetviewpublishPhotoStartUpload_594027;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594044 = newJObject()
  var body_594045 = newJObject()
  add(query_594044, "upload_protocol", newJString(uploadProtocol))
  add(query_594044, "fields", newJString(fields))
  add(query_594044, "quotaUser", newJString(quotaUser))
  add(query_594044, "alt", newJString(alt))
  add(query_594044, "oauth_token", newJString(oauthToken))
  add(query_594044, "callback", newJString(callback))
  add(query_594044, "access_token", newJString(accessToken))
  add(query_594044, "uploadType", newJString(uploadType))
  add(query_594044, "key", newJString(key))
  add(query_594044, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594045 = body
  add(query_594044, "prettyPrint", newJBool(prettyPrint))
  result = call_594043.call(nil, query_594044, nil, nil, body_594045)

var streetviewpublishPhotoStartUpload* = Call_StreetviewpublishPhotoStartUpload_594027(
    name: "streetviewpublishPhotoStartUpload", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo:startUpload",
    validator: validate_StreetviewpublishPhotoStartUpload_594028, base: "/",
    url: url_StreetviewpublishPhotoStartUpload_594029, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosList_594046 = ref object of OpenApiRestCall_593408
proc url_StreetviewpublishPhotosList_594048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosList_594047(path: JsonNode; query: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The
  ## nextPageToken
  ## value returned from a previous
  ## ListPhotos
  ## request, if any.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Required. Specifies if a download URL for the photos bytes should be returned in the
  ## Photos response.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   languageCode: JString
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   pageSize: JInt
  ##           : The maximum number of photos to return.
  ## `pageSize` must be non-negative. If `pageSize` is zero or is not provided,
  ## the default page size of 100 is used.
  ## The number of photos returned in the response may be less than `pageSize`
  ## if the number of photos that belong to the user is less than `pageSize`.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Required. The filter expression. For example: `placeId=ChIJj61dQgK6j4AR4GeTYWZsKWw`.
  ## 
  ## The only filter supported at the moment is `placeId`.
  section = newJObject()
  var valid_594049 = query.getOrDefault("upload_protocol")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "upload_protocol", valid_594049
  var valid_594050 = query.getOrDefault("fields")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "fields", valid_594050
  var valid_594051 = query.getOrDefault("pageToken")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "pageToken", valid_594051
  var valid_594052 = query.getOrDefault("quotaUser")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "quotaUser", valid_594052
  var valid_594053 = query.getOrDefault("view")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_594053 != nil:
    section.add "view", valid_594053
  var valid_594054 = query.getOrDefault("alt")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = newJString("json"))
  if valid_594054 != nil:
    section.add "alt", valid_594054
  var valid_594055 = query.getOrDefault("oauth_token")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "oauth_token", valid_594055
  var valid_594056 = query.getOrDefault("callback")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "callback", valid_594056
  var valid_594057 = query.getOrDefault("access_token")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "access_token", valid_594057
  var valid_594058 = query.getOrDefault("uploadType")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "uploadType", valid_594058
  var valid_594059 = query.getOrDefault("key")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "key", valid_594059
  var valid_594060 = query.getOrDefault("$.xgafv")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = newJString("1"))
  if valid_594060 != nil:
    section.add "$.xgafv", valid_594060
  var valid_594061 = query.getOrDefault("languageCode")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "languageCode", valid_594061
  var valid_594062 = query.getOrDefault("pageSize")
  valid_594062 = validateParameter(valid_594062, JInt, required = false, default = nil)
  if valid_594062 != nil:
    section.add "pageSize", valid_594062
  var valid_594063 = query.getOrDefault("prettyPrint")
  valid_594063 = validateParameter(valid_594063, JBool, required = false,
                                 default = newJBool(true))
  if valid_594063 != nil:
    section.add "prettyPrint", valid_594063
  var valid_594064 = query.getOrDefault("filter")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "filter", valid_594064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_StreetviewpublishPhotosList_594046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Photos that belong to
  ## the user.
  ## 
  ## <aside class="note"><b>Note:</b> Recently created photos that are still
  ## being indexed are not returned in the response.</aside>
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_StreetviewpublishPhotosList_594046;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "BASIC"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          languageCode: string = ""; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## streetviewpublishPhotosList
  ## Lists all the Photos that belong to
  ## the user.
  ## 
  ## <aside class="note"><b>Note:</b> Recently created photos that are still
  ## being indexed are not returned in the response.</aside>
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The
  ## nextPageToken
  ## value returned from a previous
  ## ListPhotos
  ## request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Required. Specifies if a download URL for the photos bytes should be returned in the
  ## Photos response.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   pageSize: int
  ##           : The maximum number of photos to return.
  ## `pageSize` must be non-negative. If `pageSize` is zero or is not provided,
  ## the default page size of 100 is used.
  ## The number of photos returned in the response may be less than `pageSize`
  ## if the number of photos that belong to the user is less than `pageSize`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Required. The filter expression. For example: `placeId=ChIJj61dQgK6j4AR4GeTYWZsKWw`.
  ## 
  ## The only filter supported at the moment is `placeId`.
  var query_594067 = newJObject()
  add(query_594067, "upload_protocol", newJString(uploadProtocol))
  add(query_594067, "fields", newJString(fields))
  add(query_594067, "pageToken", newJString(pageToken))
  add(query_594067, "quotaUser", newJString(quotaUser))
  add(query_594067, "view", newJString(view))
  add(query_594067, "alt", newJString(alt))
  add(query_594067, "oauth_token", newJString(oauthToken))
  add(query_594067, "callback", newJString(callback))
  add(query_594067, "access_token", newJString(accessToken))
  add(query_594067, "uploadType", newJString(uploadType))
  add(query_594067, "key", newJString(key))
  add(query_594067, "$.xgafv", newJString(Xgafv))
  add(query_594067, "languageCode", newJString(languageCode))
  add(query_594067, "pageSize", newJInt(pageSize))
  add(query_594067, "prettyPrint", newJBool(prettyPrint))
  add(query_594067, "filter", newJString(filter))
  result = call_594066.call(nil, query_594067, nil, nil, nil)

var streetviewpublishPhotosList* = Call_StreetviewpublishPhotosList_594046(
    name: "streetviewpublishPhotosList", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos",
    validator: validate_StreetviewpublishPhotosList_594047, base: "/",
    url: url_StreetviewpublishPhotosList_594048, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchDelete_594068 = ref object of OpenApiRestCall_593408
proc url_StreetviewpublishPhotosBatchDelete_594070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchDelete_594069(path: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594071 = query.getOrDefault("upload_protocol")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "upload_protocol", valid_594071
  var valid_594072 = query.getOrDefault("fields")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "fields", valid_594072
  var valid_594073 = query.getOrDefault("quotaUser")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "quotaUser", valid_594073
  var valid_594074 = query.getOrDefault("alt")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = newJString("json"))
  if valid_594074 != nil:
    section.add "alt", valid_594074
  var valid_594075 = query.getOrDefault("oauth_token")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "oauth_token", valid_594075
  var valid_594076 = query.getOrDefault("callback")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "callback", valid_594076
  var valid_594077 = query.getOrDefault("access_token")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "access_token", valid_594077
  var valid_594078 = query.getOrDefault("uploadType")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "uploadType", valid_594078
  var valid_594079 = query.getOrDefault("key")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "key", valid_594079
  var valid_594080 = query.getOrDefault("$.xgafv")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = newJString("1"))
  if valid_594080 != nil:
    section.add "$.xgafv", valid_594080
  var valid_594081 = query.getOrDefault("prettyPrint")
  valid_594081 = validateParameter(valid_594081, JBool, required = false,
                                 default = newJBool(true))
  if valid_594081 != nil:
    section.add "prettyPrint", valid_594081
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

proc call*(call_594083: Call_StreetviewpublishPhotosBatchDelete_594068;
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
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_StreetviewpublishPhotosBatchDelete_594068;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594085 = newJObject()
  var body_594086 = newJObject()
  add(query_594085, "upload_protocol", newJString(uploadProtocol))
  add(query_594085, "fields", newJString(fields))
  add(query_594085, "quotaUser", newJString(quotaUser))
  add(query_594085, "alt", newJString(alt))
  add(query_594085, "oauth_token", newJString(oauthToken))
  add(query_594085, "callback", newJString(callback))
  add(query_594085, "access_token", newJString(accessToken))
  add(query_594085, "uploadType", newJString(uploadType))
  add(query_594085, "key", newJString(key))
  add(query_594085, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594086 = body
  add(query_594085, "prettyPrint", newJBool(prettyPrint))
  result = call_594084.call(nil, query_594085, nil, nil, body_594086)

var streetviewpublishPhotosBatchDelete* = Call_StreetviewpublishPhotosBatchDelete_594068(
    name: "streetviewpublishPhotosBatchDelete", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchDelete",
    validator: validate_StreetviewpublishPhotosBatchDelete_594069, base: "/",
    url: url_StreetviewpublishPhotosBatchDelete_594070, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchGet_594087 = ref object of OpenApiRestCall_593408
proc url_StreetviewpublishPhotosBatchGet_594089(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchGet_594088(path: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   languageCode: JString
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   photoIds: JArray
  ##           : Required. IDs of the Photos. For HTTP
  ## GET requests, the URL query parameter should be
  ## `photoIds=<id1>&photoIds=<id2>&...`.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594090 = query.getOrDefault("upload_protocol")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "upload_protocol", valid_594090
  var valid_594091 = query.getOrDefault("fields")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "fields", valid_594091
  var valid_594092 = query.getOrDefault("view")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_594092 != nil:
    section.add "view", valid_594092
  var valid_594093 = query.getOrDefault("quotaUser")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "quotaUser", valid_594093
  var valid_594094 = query.getOrDefault("alt")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("json"))
  if valid_594094 != nil:
    section.add "alt", valid_594094
  var valid_594095 = query.getOrDefault("oauth_token")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "oauth_token", valid_594095
  var valid_594096 = query.getOrDefault("callback")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "callback", valid_594096
  var valid_594097 = query.getOrDefault("access_token")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "access_token", valid_594097
  var valid_594098 = query.getOrDefault("uploadType")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "uploadType", valid_594098
  var valid_594099 = query.getOrDefault("key")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "key", valid_594099
  var valid_594100 = query.getOrDefault("$.xgafv")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = newJString("1"))
  if valid_594100 != nil:
    section.add "$.xgafv", valid_594100
  var valid_594101 = query.getOrDefault("languageCode")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "languageCode", valid_594101
  var valid_594102 = query.getOrDefault("photoIds")
  valid_594102 = validateParameter(valid_594102, JArray, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "photoIds", valid_594102
  var valid_594103 = query.getOrDefault("prettyPrint")
  valid_594103 = validateParameter(valid_594103, JBool, required = false,
                                 default = newJBool(true))
  if valid_594103 != nil:
    section.add "prettyPrint", valid_594103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594104: Call_StreetviewpublishPhotosBatchGet_594087;
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
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_StreetviewpublishPhotosBatchGet_594087;
          uploadProtocol: string = ""; fields: string = ""; view: string = "BASIC";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; languageCode: string = "";
          photoIds: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   photoIds: JArray
  ##           : Required. IDs of the Photos. For HTTP
  ## GET requests, the URL query parameter should be
  ## `photoIds=<id1>&photoIds=<id2>&...`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594106 = newJObject()
  add(query_594106, "upload_protocol", newJString(uploadProtocol))
  add(query_594106, "fields", newJString(fields))
  add(query_594106, "view", newJString(view))
  add(query_594106, "quotaUser", newJString(quotaUser))
  add(query_594106, "alt", newJString(alt))
  add(query_594106, "oauth_token", newJString(oauthToken))
  add(query_594106, "callback", newJString(callback))
  add(query_594106, "access_token", newJString(accessToken))
  add(query_594106, "uploadType", newJString(uploadType))
  add(query_594106, "key", newJString(key))
  add(query_594106, "$.xgafv", newJString(Xgafv))
  add(query_594106, "languageCode", newJString(languageCode))
  if photoIds != nil:
    query_594106.add "photoIds", photoIds
  add(query_594106, "prettyPrint", newJBool(prettyPrint))
  result = call_594105.call(nil, query_594106, nil, nil, nil)

var streetviewpublishPhotosBatchGet* = Call_StreetviewpublishPhotosBatchGet_594087(
    name: "streetviewpublishPhotosBatchGet", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchGet",
    validator: validate_StreetviewpublishPhotosBatchGet_594088, base: "/",
    url: url_StreetviewpublishPhotosBatchGet_594089, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchUpdate_594107 = ref object of OpenApiRestCall_593408
proc url_StreetviewpublishPhotosBatchUpdate_594109(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchUpdate_594108(path: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594110 = query.getOrDefault("upload_protocol")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "upload_protocol", valid_594110
  var valid_594111 = query.getOrDefault("fields")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "fields", valid_594111
  var valid_594112 = query.getOrDefault("quotaUser")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "quotaUser", valid_594112
  var valid_594113 = query.getOrDefault("alt")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = newJString("json"))
  if valid_594113 != nil:
    section.add "alt", valid_594113
  var valid_594114 = query.getOrDefault("oauth_token")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "oauth_token", valid_594114
  var valid_594115 = query.getOrDefault("callback")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "callback", valid_594115
  var valid_594116 = query.getOrDefault("access_token")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "access_token", valid_594116
  var valid_594117 = query.getOrDefault("uploadType")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "uploadType", valid_594117
  var valid_594118 = query.getOrDefault("key")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "key", valid_594118
  var valid_594119 = query.getOrDefault("$.xgafv")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = newJString("1"))
  if valid_594119 != nil:
    section.add "$.xgafv", valid_594119
  var valid_594120 = query.getOrDefault("prettyPrint")
  valid_594120 = validateParameter(valid_594120, JBool, required = false,
                                 default = newJBool(true))
  if valid_594120 != nil:
    section.add "prettyPrint", valid_594120
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

proc call*(call_594122: Call_StreetviewpublishPhotosBatchUpdate_594107;
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
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_StreetviewpublishPhotosBatchUpdate_594107;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594124 = newJObject()
  var body_594125 = newJObject()
  add(query_594124, "upload_protocol", newJString(uploadProtocol))
  add(query_594124, "fields", newJString(fields))
  add(query_594124, "quotaUser", newJString(quotaUser))
  add(query_594124, "alt", newJString(alt))
  add(query_594124, "oauth_token", newJString(oauthToken))
  add(query_594124, "callback", newJString(callback))
  add(query_594124, "access_token", newJString(accessToken))
  add(query_594124, "uploadType", newJString(uploadType))
  add(query_594124, "key", newJString(key))
  add(query_594124, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594125 = body
  add(query_594124, "prettyPrint", newJBool(prettyPrint))
  result = call_594123.call(nil, query_594124, nil, nil, body_594125)

var streetviewpublishPhotosBatchUpdate* = Call_StreetviewpublishPhotosBatchUpdate_594107(
    name: "streetviewpublishPhotosBatchUpdate", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchUpdate",
    validator: validate_StreetviewpublishPhotosBatchUpdate_594108, base: "/",
    url: url_StreetviewpublishPhotosBatchUpdate_594109, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
