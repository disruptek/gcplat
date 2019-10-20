
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: YouTube Data
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Supports core YouTube features, such as uploading videos, creating and managing playlists, searching for content, and much more.
## 
## https://developers.google.com/youtube/v3
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

  OpenApiRestCall_578364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578364): Option[Scheme] {.used.} =
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
  gcpServiceName = "youtube"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubeActivitiesInsert_578912 = ref object of OpenApiRestCall_578364
proc url_YoutubeActivitiesInsert_578914(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeActivitiesInsert_578913(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578915 = query.getOrDefault("key")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "key", valid_578915
  var valid_578916 = query.getOrDefault("prettyPrint")
  valid_578916 = validateParameter(valid_578916, JBool, required = false,
                                 default = newJBool(true))
  if valid_578916 != nil:
    section.add "prettyPrint", valid_578916
  var valid_578917 = query.getOrDefault("oauth_token")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "oauth_token", valid_578917
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_578918 = query.getOrDefault("part")
  valid_578918 = validateParameter(valid_578918, JString, required = true,
                                 default = nil)
  if valid_578918 != nil:
    section.add "part", valid_578918
  var valid_578919 = query.getOrDefault("alt")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = newJString("json"))
  if valid_578919 != nil:
    section.add "alt", valid_578919
  var valid_578920 = query.getOrDefault("userIp")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "userIp", valid_578920
  var valid_578921 = query.getOrDefault("quotaUser")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "quotaUser", valid_578921
  var valid_578922 = query.getOrDefault("fields")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "fields", valid_578922
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

proc call*(call_578924: Call_YoutubeActivitiesInsert_578912; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
  ## 
  let valid = call_578924.validator(path, query, header, formData, body)
  let scheme = call_578924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578924.url(scheme.get, call_578924.host, call_578924.base,
                         call_578924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578924, url, valid)

proc call*(call_578925: Call_YoutubeActivitiesInsert_578912; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeActivitiesInsert
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578926 = newJObject()
  var body_578927 = newJObject()
  add(query_578926, "key", newJString(key))
  add(query_578926, "prettyPrint", newJBool(prettyPrint))
  add(query_578926, "oauth_token", newJString(oauthToken))
  add(query_578926, "part", newJString(part))
  add(query_578926, "alt", newJString(alt))
  add(query_578926, "userIp", newJString(userIp))
  add(query_578926, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578927 = body
  add(query_578926, "fields", newJString(fields))
  result = call_578925.call(nil, query_578926, nil, nil, body_578927)

var youtubeActivitiesInsert* = Call_YoutubeActivitiesInsert_578912(
    name: "youtubeActivitiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_YoutubeActivitiesInsert_578913, base: "/youtube/v3",
    url: url_YoutubeActivitiesInsert_578914, schemes: {Scheme.Https})
type
  Call_YoutubeActivitiesList_578634 = ref object of OpenApiRestCall_578364
proc url_YoutubeActivitiesList_578636(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeActivitiesList_578635(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
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
  ##   home: JBool
  ##       : Set this parameter's value to true to retrieve the activity feed that displays on the YouTube home page for the currently authenticated user.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more activity resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in an activity resource, the snippet property contains other properties that identify the type of activity, a display title for the activity, and so forth. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   channelId: JString
  ##            : The channelId parameter specifies a unique YouTube channel ID. The API will then return a list of that channel's activities.
  ##   publishedBefore: JString
  ##                  : The publishedBefore parameter specifies the date and time before which an activity must have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be excluded from the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code. YouTube uses this value when the authorized user's previous activity on YouTube does not provide enough information to generate the activity feed.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: JString
  ##                 : The publishedAfter parameter specifies the earliest date and time that an activity could have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be included in the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's activities.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  section = newJObject()
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("home")
  valid_578764 = validateParameter(valid_578764, JBool, required = false, default = nil)
  if valid_578764 != nil:
    section.add "home", valid_578764
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_578765 = query.getOrDefault("part")
  valid_578765 = validateParameter(valid_578765, JString, required = true,
                                 default = nil)
  if valid_578765 != nil:
    section.add "part", valid_578765
  var valid_578766 = query.getOrDefault("alt")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = newJString("json"))
  if valid_578766 != nil:
    section.add "alt", valid_578766
  var valid_578767 = query.getOrDefault("userIp")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "userIp", valid_578767
  var valid_578768 = query.getOrDefault("quotaUser")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "quotaUser", valid_578768
  var valid_578769 = query.getOrDefault("pageToken")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "pageToken", valid_578769
  var valid_578770 = query.getOrDefault("channelId")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "channelId", valid_578770
  var valid_578771 = query.getOrDefault("publishedBefore")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "publishedBefore", valid_578771
  var valid_578772 = query.getOrDefault("regionCode")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "regionCode", valid_578772
  var valid_578773 = query.getOrDefault("fields")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "fields", valid_578773
  var valid_578774 = query.getOrDefault("publishedAfter")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "publishedAfter", valid_578774
  var valid_578775 = query.getOrDefault("mine")
  valid_578775 = validateParameter(valid_578775, JBool, required = false, default = nil)
  if valid_578775 != nil:
    section.add "mine", valid_578775
  var valid_578777 = query.getOrDefault("maxResults")
  valid_578777 = validateParameter(valid_578777, JInt, required = false,
                                 default = newJInt(5))
  if valid_578777 != nil:
    section.add "maxResults", valid_578777
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578800: Call_YoutubeActivitiesList_578634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
  ## 
  let valid = call_578800.validator(path, query, header, formData, body)
  let scheme = call_578800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578800.url(scheme.get, call_578800.host, call_578800.base,
                         call_578800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578800, url, valid)

proc call*(call_578871: Call_YoutubeActivitiesList_578634; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          home: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; channelId: string = "";
          publishedBefore: string = ""; regionCode: string = ""; fields: string = "";
          publishedAfter: string = ""; mine: bool = false; maxResults: int = 5): Recallable =
  ## youtubeActivitiesList
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   home: bool
  ##       : Set this parameter's value to true to retrieve the activity feed that displays on the YouTube home page for the currently authenticated user.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more activity resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in an activity resource, the snippet property contains other properties that identify the type of activity, a display title for the activity, and so forth. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   channelId: string
  ##            : The channelId parameter specifies a unique YouTube channel ID. The API will then return a list of that channel's activities.
  ##   publishedBefore: string
  ##                  : The publishedBefore parameter specifies the date and time before which an activity must have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be excluded from the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code. YouTube uses this value when the authorized user's previous activity on YouTube does not provide enough information to generate the activity feed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: string
  ##                 : The publishedAfter parameter specifies the earliest date and time that an activity could have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be included in the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's activities.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_578872 = newJObject()
  add(query_578872, "key", newJString(key))
  add(query_578872, "prettyPrint", newJBool(prettyPrint))
  add(query_578872, "oauth_token", newJString(oauthToken))
  add(query_578872, "home", newJBool(home))
  add(query_578872, "part", newJString(part))
  add(query_578872, "alt", newJString(alt))
  add(query_578872, "userIp", newJString(userIp))
  add(query_578872, "quotaUser", newJString(quotaUser))
  add(query_578872, "pageToken", newJString(pageToken))
  add(query_578872, "channelId", newJString(channelId))
  add(query_578872, "publishedBefore", newJString(publishedBefore))
  add(query_578872, "regionCode", newJString(regionCode))
  add(query_578872, "fields", newJString(fields))
  add(query_578872, "publishedAfter", newJString(publishedAfter))
  add(query_578872, "mine", newJBool(mine))
  add(query_578872, "maxResults", newJInt(maxResults))
  result = call_578871.call(nil, query_578872, nil, nil, nil)

var youtubeActivitiesList* = Call_YoutubeActivitiesList_578634(
    name: "youtubeActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_YoutubeActivitiesList_578635, base: "/youtube/v3",
    url: url_YoutubeActivitiesList_578636, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsUpdate_578946 = ref object of OpenApiRestCall_578364
proc url_YoutubeCaptionsUpdate_578948(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsUpdate_578947(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the property value to snippet if you are updating the track's draft status. Otherwise, set the property value to id.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   sync: JBool
  ##       : Note: The API server only processes the parameter value if the request contains an updated caption file.
  ## 
  ## The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will automatically synchronize the caption track with the audio track.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578949 = query.getOrDefault("key")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "key", valid_578949
  var valid_578950 = query.getOrDefault("prettyPrint")
  valid_578950 = validateParameter(valid_578950, JBool, required = false,
                                 default = newJBool(true))
  if valid_578950 != nil:
    section.add "prettyPrint", valid_578950
  var valid_578951 = query.getOrDefault("oauth_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "oauth_token", valid_578951
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_578952 = query.getOrDefault("part")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "part", valid_578952
  var valid_578953 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "onBehalfOfContentOwner", valid_578953
  var valid_578954 = query.getOrDefault("alt")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = newJString("json"))
  if valid_578954 != nil:
    section.add "alt", valid_578954
  var valid_578955 = query.getOrDefault("userIp")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "userIp", valid_578955
  var valid_578956 = query.getOrDefault("sync")
  valid_578956 = validateParameter(valid_578956, JBool, required = false, default = nil)
  if valid_578956 != nil:
    section.add "sync", valid_578956
  var valid_578957 = query.getOrDefault("quotaUser")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "quotaUser", valid_578957
  var valid_578958 = query.getOrDefault("onBehalfOf")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "onBehalfOf", valid_578958
  var valid_578959 = query.getOrDefault("fields")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "fields", valid_578959
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

proc call*(call_578961: Call_YoutubeCaptionsUpdate_578946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
  ## 
  let valid = call_578961.validator(path, query, header, formData, body)
  let scheme = call_578961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578961.url(scheme.get, call_578961.host, call_578961.base,
                         call_578961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578961, url, valid)

proc call*(call_578962: Call_YoutubeCaptionsUpdate_578946; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; sync: bool = false; quotaUser: string = "";
          onBehalfOf: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeCaptionsUpdate
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the property value to snippet if you are updating the track's draft status. Otherwise, set the property value to id.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sync: bool
  ##       : Note: The API server only processes the parameter value if the request contains an updated caption file.
  ## 
  ## The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will automatically synchronize the caption track with the audio track.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578963 = newJObject()
  var body_578964 = newJObject()
  add(query_578963, "key", newJString(key))
  add(query_578963, "prettyPrint", newJBool(prettyPrint))
  add(query_578963, "oauth_token", newJString(oauthToken))
  add(query_578963, "part", newJString(part))
  add(query_578963, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578963, "alt", newJString(alt))
  add(query_578963, "userIp", newJString(userIp))
  add(query_578963, "sync", newJBool(sync))
  add(query_578963, "quotaUser", newJString(quotaUser))
  add(query_578963, "onBehalfOf", newJString(onBehalfOf))
  if body != nil:
    body_578964 = body
  add(query_578963, "fields", newJString(fields))
  result = call_578962.call(nil, query_578963, nil, nil, body_578964)

var youtubeCaptionsUpdate* = Call_YoutubeCaptionsUpdate_578946(
    name: "youtubeCaptionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsUpdate_578947, base: "/youtube/v3",
    url: url_YoutubeCaptionsUpdate_578948, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsInsert_578965 = ref object of OpenApiRestCall_578364
proc url_YoutubeCaptionsInsert_578967(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsInsert_578966(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a caption track.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the caption resource parts that the API response will include. Set the parameter value to snippet.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   sync: JBool
  ##       : The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will disregard any time codes that are in the uploaded caption file and generate new time codes for the captions.
  ## 
  ## You should set the sync parameter to true if you are uploading a transcript, which has no time codes, or if you suspect the time codes in your file are incorrect and want YouTube to try to fix them.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578968 = query.getOrDefault("key")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "key", valid_578968
  var valid_578969 = query.getOrDefault("prettyPrint")
  valid_578969 = validateParameter(valid_578969, JBool, required = false,
                                 default = newJBool(true))
  if valid_578969 != nil:
    section.add "prettyPrint", valid_578969
  var valid_578970 = query.getOrDefault("oauth_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "oauth_token", valid_578970
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_578971 = query.getOrDefault("part")
  valid_578971 = validateParameter(valid_578971, JString, required = true,
                                 default = nil)
  if valid_578971 != nil:
    section.add "part", valid_578971
  var valid_578972 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "onBehalfOfContentOwner", valid_578972
  var valid_578973 = query.getOrDefault("alt")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = newJString("json"))
  if valid_578973 != nil:
    section.add "alt", valid_578973
  var valid_578974 = query.getOrDefault("userIp")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "userIp", valid_578974
  var valid_578975 = query.getOrDefault("sync")
  valid_578975 = validateParameter(valid_578975, JBool, required = false, default = nil)
  if valid_578975 != nil:
    section.add "sync", valid_578975
  var valid_578976 = query.getOrDefault("quotaUser")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "quotaUser", valid_578976
  var valid_578977 = query.getOrDefault("onBehalfOf")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "onBehalfOf", valid_578977
  var valid_578978 = query.getOrDefault("fields")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "fields", valid_578978
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

proc call*(call_578980: Call_YoutubeCaptionsInsert_578965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a caption track.
  ## 
  let valid = call_578980.validator(path, query, header, formData, body)
  let scheme = call_578980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578980.url(scheme.get, call_578980.host, call_578980.base,
                         call_578980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578980, url, valid)

proc call*(call_578981: Call_YoutubeCaptionsInsert_578965; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; sync: bool = false; quotaUser: string = "";
          onBehalfOf: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeCaptionsInsert
  ## Uploads a caption track.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the caption resource parts that the API response will include. Set the parameter value to snippet.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sync: bool
  ##       : The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will disregard any time codes that are in the uploaded caption file and generate new time codes for the captions.
  ## 
  ## You should set the sync parameter to true if you are uploading a transcript, which has no time codes, or if you suspect the time codes in your file are incorrect and want YouTube to try to fix them.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578982 = newJObject()
  var body_578983 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(query_578982, "part", newJString(part))
  add(query_578982, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "userIp", newJString(userIp))
  add(query_578982, "sync", newJBool(sync))
  add(query_578982, "quotaUser", newJString(quotaUser))
  add(query_578982, "onBehalfOf", newJString(onBehalfOf))
  if body != nil:
    body_578983 = body
  add(query_578982, "fields", newJString(fields))
  result = call_578981.call(nil, query_578982, nil, nil, body_578983)

var youtubeCaptionsInsert* = Call_YoutubeCaptionsInsert_578965(
    name: "youtubeCaptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsInsert_578966, base: "/youtube/v3",
    url: url_YoutubeCaptionsInsert_578967, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsList_578928 = ref object of OpenApiRestCall_578364
proc url_YoutubeCaptionsList_578930(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsList_578929(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
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
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more caption resource parts that the API response will include. The part names that you can include in the parameter value are id and snippet.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of IDs that identify the caption resources that should be retrieved. Each ID must identify a caption track associated with the specified video.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is on behalf of.
  ##   videoId: JString (required)
  ##          : The videoId parameter specifies the YouTube video ID of the video for which the API should return caption tracks.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578931 = query.getOrDefault("key")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "key", valid_578931
  var valid_578932 = query.getOrDefault("prettyPrint")
  valid_578932 = validateParameter(valid_578932, JBool, required = false,
                                 default = newJBool(true))
  if valid_578932 != nil:
    section.add "prettyPrint", valid_578932
  var valid_578933 = query.getOrDefault("oauth_token")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "oauth_token", valid_578933
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_578934 = query.getOrDefault("part")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "part", valid_578934
  var valid_578935 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "onBehalfOfContentOwner", valid_578935
  var valid_578936 = query.getOrDefault("alt")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("json"))
  if valid_578936 != nil:
    section.add "alt", valid_578936
  var valid_578937 = query.getOrDefault("userIp")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "userIp", valid_578937
  var valid_578938 = query.getOrDefault("quotaUser")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "quotaUser", valid_578938
  var valid_578939 = query.getOrDefault("id")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "id", valid_578939
  var valid_578940 = query.getOrDefault("onBehalfOf")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "onBehalfOf", valid_578940
  var valid_578941 = query.getOrDefault("videoId")
  valid_578941 = validateParameter(valid_578941, JString, required = true,
                                 default = nil)
  if valid_578941 != nil:
    section.add "videoId", valid_578941
  var valid_578942 = query.getOrDefault("fields")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "fields", valid_578942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578943: Call_YoutubeCaptionsList_578928; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_YoutubeCaptionsList_578928; part: string;
          videoId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; onBehalfOfContentOwner: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          id: string = ""; onBehalfOf: string = ""; fields: string = ""): Recallable =
  ## youtubeCaptionsList
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more caption resource parts that the API response will include. The part names that you can include in the parameter value are id and snippet.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of IDs that identify the caption resources that should be retrieved. Each ID must identify a caption track associated with the specified video.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is on behalf of.
  ##   videoId: string (required)
  ##          : The videoId parameter specifies the YouTube video ID of the video for which the API should return caption tracks.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578945 = newJObject()
  add(query_578945, "key", newJString(key))
  add(query_578945, "prettyPrint", newJBool(prettyPrint))
  add(query_578945, "oauth_token", newJString(oauthToken))
  add(query_578945, "part", newJString(part))
  add(query_578945, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578945, "alt", newJString(alt))
  add(query_578945, "userIp", newJString(userIp))
  add(query_578945, "quotaUser", newJString(quotaUser))
  add(query_578945, "id", newJString(id))
  add(query_578945, "onBehalfOf", newJString(onBehalfOf))
  add(query_578945, "videoId", newJString(videoId))
  add(query_578945, "fields", newJString(fields))
  result = call_578944.call(nil, query_578945, nil, nil, nil)

var youtubeCaptionsList* = Call_YoutubeCaptionsList_578928(
    name: "youtubeCaptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsList_578929, base: "/youtube/v3",
    url: url_YoutubeCaptionsList_578930, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsDelete_578984 = ref object of OpenApiRestCall_578364
proc url_YoutubeCaptionsDelete_578986(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsDelete_578985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specified caption track.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter identifies the caption track that is being deleted. The value is a caption track ID as identified by the id property in a caption resource.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
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
  var valid_578990 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "onBehalfOfContentOwner", valid_578990
  var valid_578991 = query.getOrDefault("alt")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("json"))
  if valid_578991 != nil:
    section.add "alt", valid_578991
  var valid_578992 = query.getOrDefault("userIp")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "userIp", valid_578992
  var valid_578993 = query.getOrDefault("quotaUser")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "quotaUser", valid_578993
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_578994 = query.getOrDefault("id")
  valid_578994 = validateParameter(valid_578994, JString, required = true,
                                 default = nil)
  if valid_578994 != nil:
    section.add "id", valid_578994
  var valid_578995 = query.getOrDefault("onBehalfOf")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "onBehalfOf", valid_578995
  var valid_578996 = query.getOrDefault("fields")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "fields", valid_578996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578997: Call_YoutubeCaptionsDelete_578984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specified caption track.
  ## 
  let valid = call_578997.validator(path, query, header, formData, body)
  let scheme = call_578997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578997.url(scheme.get, call_578997.host, call_578997.base,
                         call_578997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578997, url, valid)

proc call*(call_578998: Call_YoutubeCaptionsDelete_578984; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; onBehalfOf: string = "";
          fields: string = ""): Recallable =
  ## youtubeCaptionsDelete
  ## Deletes a specified caption track.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter identifies the caption track that is being deleted. The value is a caption track ID as identified by the id property in a caption resource.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578999 = newJObject()
  add(query_578999, "key", newJString(key))
  add(query_578999, "prettyPrint", newJBool(prettyPrint))
  add(query_578999, "oauth_token", newJString(oauthToken))
  add(query_578999, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578999, "alt", newJString(alt))
  add(query_578999, "userIp", newJString(userIp))
  add(query_578999, "quotaUser", newJString(quotaUser))
  add(query_578999, "id", newJString(id))
  add(query_578999, "onBehalfOf", newJString(onBehalfOf))
  add(query_578999, "fields", newJString(fields))
  result = call_578998.call(nil, query_578999, nil, nil, nil)

var youtubeCaptionsDelete* = Call_YoutubeCaptionsDelete_578984(
    name: "youtubeCaptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsDelete_578985, base: "/youtube/v3",
    url: url_YoutubeCaptionsDelete_578986, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsDownload_579000 = ref object of OpenApiRestCall_578364
proc url_YoutubeCaptionsDownload_579002(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/captions/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubeCaptionsDownload_579001(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The id parameter identifies the caption track that is being retrieved. The value is a caption track ID as identified by the id property in a caption resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579017 = path.getOrDefault("id")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "id", valid_579017
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tlang: JString
  ##        : The tlang parameter specifies that the API response should return a translation of the specified caption track. The parameter value is an ISO 639-1 two-letter language code that identifies the desired caption language. The translation is generated by using machine translation, such as Google Translate.
  ##   tfmt: JString
  ##       : The tfmt parameter specifies that the caption track should be returned in a specific format. If the parameter is not included in the request, the track is returned in its original format.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579018 = query.getOrDefault("key")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "key", valid_579018
  var valid_579019 = query.getOrDefault("prettyPrint")
  valid_579019 = validateParameter(valid_579019, JBool, required = false,
                                 default = newJBool(true))
  if valid_579019 != nil:
    section.add "prettyPrint", valid_579019
  var valid_579020 = query.getOrDefault("oauth_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "oauth_token", valid_579020
  var valid_579021 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "onBehalfOfContentOwner", valid_579021
  var valid_579022 = query.getOrDefault("alt")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("json"))
  if valid_579022 != nil:
    section.add "alt", valid_579022
  var valid_579023 = query.getOrDefault("userIp")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "userIp", valid_579023
  var valid_579024 = query.getOrDefault("quotaUser")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "quotaUser", valid_579024
  var valid_579025 = query.getOrDefault("tlang")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "tlang", valid_579025
  var valid_579026 = query.getOrDefault("tfmt")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = newJString("sbv"))
  if valid_579026 != nil:
    section.add "tfmt", valid_579026
  var valid_579027 = query.getOrDefault("onBehalfOf")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "onBehalfOf", valid_579027
  var valid_579028 = query.getOrDefault("fields")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "fields", valid_579028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579029: Call_YoutubeCaptionsDownload_579000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ## 
  let valid = call_579029.validator(path, query, header, formData, body)
  let scheme = call_579029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579029.url(scheme.get, call_579029.host, call_579029.base,
                         call_579029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579029, url, valid)

proc call*(call_579030: Call_YoutubeCaptionsDownload_579000; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; tlang: string = "";
          tfmt: string = "sbv"; onBehalfOf: string = ""; fields: string = ""): Recallable =
  ## youtubeCaptionsDownload
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The id parameter identifies the caption track that is being retrieved. The value is a caption track ID as identified by the id property in a caption resource.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tlang: string
  ##        : The tlang parameter specifies that the API response should return a translation of the specified caption track. The parameter value is an ISO 639-1 two-letter language code that identifies the desired caption language. The translation is generated by using machine translation, such as Google Translate.
  ##   tfmt: string
  ##       : The tfmt parameter specifies that the caption track should be returned in a specific format. If the parameter is not included in the request, the track is returned in its original format.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579031 = newJObject()
  var query_579032 = newJObject()
  add(query_579032, "key", newJString(key))
  add(query_579032, "prettyPrint", newJBool(prettyPrint))
  add(query_579032, "oauth_token", newJString(oauthToken))
  add(path_579031, "id", newJString(id))
  add(query_579032, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579032, "alt", newJString(alt))
  add(query_579032, "userIp", newJString(userIp))
  add(query_579032, "quotaUser", newJString(quotaUser))
  add(query_579032, "tlang", newJString(tlang))
  add(query_579032, "tfmt", newJString(tfmt))
  add(query_579032, "onBehalfOf", newJString(onBehalfOf))
  add(query_579032, "fields", newJString(fields))
  result = call_579030.call(path_579031, query_579032, nil, nil, nil)

var youtubeCaptionsDownload* = Call_YoutubeCaptionsDownload_579000(
    name: "youtubeCaptionsDownload", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/captions/{id}",
    validator: validate_YoutubeCaptionsDownload_579001, base: "/youtube/v3",
    url: url_YoutubeCaptionsDownload_579002, schemes: {Scheme.Https})
type
  Call_YoutubeChannelBannersInsert_579033 = ref object of OpenApiRestCall_578364
proc url_YoutubeChannelBannersInsert_579035(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelBannersInsert_579034(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   channelId: JString
  ##            : The channelId parameter identifies the YouTube channel to which the banner is uploaded. The channelId parameter was introduced as a required parameter in May 2017. As this was a backward-incompatible change, channelBanners.insert requests that do not specify this parameter will not return an error until six months have passed from the time that the parameter was introduced. Please see the API Terms of Service for the official policy regarding backward incompatible changes and the API revision history for the exact date that the parameter was introduced.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579036 = query.getOrDefault("key")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "key", valid_579036
  var valid_579037 = query.getOrDefault("prettyPrint")
  valid_579037 = validateParameter(valid_579037, JBool, required = false,
                                 default = newJBool(true))
  if valid_579037 != nil:
    section.add "prettyPrint", valid_579037
  var valid_579038 = query.getOrDefault("oauth_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "oauth_token", valid_579038
  var valid_579039 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "onBehalfOfContentOwner", valid_579039
  var valid_579040 = query.getOrDefault("alt")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("json"))
  if valid_579040 != nil:
    section.add "alt", valid_579040
  var valid_579041 = query.getOrDefault("userIp")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "userIp", valid_579041
  var valid_579042 = query.getOrDefault("quotaUser")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "quotaUser", valid_579042
  var valid_579043 = query.getOrDefault("channelId")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "channelId", valid_579043
  var valid_579044 = query.getOrDefault("fields")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "fields", valid_579044
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

proc call*(call_579046: Call_YoutubeChannelBannersInsert_579033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
  ## 
  let valid = call_579046.validator(path, query, header, formData, body)
  let scheme = call_579046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579046.url(scheme.get, call_579046.host, call_579046.base,
                         call_579046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579046, url, valid)

proc call*(call_579047: Call_YoutubeChannelBannersInsert_579033; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; channelId: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeChannelBannersInsert
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   channelId: string
  ##            : The channelId parameter identifies the YouTube channel to which the banner is uploaded. The channelId parameter was introduced as a required parameter in May 2017. As this was a backward-incompatible change, channelBanners.insert requests that do not specify this parameter will not return an error until six months have passed from the time that the parameter was introduced. Please see the API Terms of Service for the official policy regarding backward incompatible changes and the API revision history for the exact date that the parameter was introduced.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579048 = newJObject()
  var body_579049 = newJObject()
  add(query_579048, "key", newJString(key))
  add(query_579048, "prettyPrint", newJBool(prettyPrint))
  add(query_579048, "oauth_token", newJString(oauthToken))
  add(query_579048, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579048, "alt", newJString(alt))
  add(query_579048, "userIp", newJString(userIp))
  add(query_579048, "quotaUser", newJString(quotaUser))
  add(query_579048, "channelId", newJString(channelId))
  if body != nil:
    body_579049 = body
  add(query_579048, "fields", newJString(fields))
  result = call_579047.call(nil, query_579048, nil, nil, body_579049)

var youtubeChannelBannersInsert* = Call_YoutubeChannelBannersInsert_579033(
    name: "youtubeChannelBannersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channelBanners/insert",
    validator: validate_YoutubeChannelBannersInsert_579034, base: "/youtube/v3",
    url: url_YoutubeChannelBannersInsert_579035, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsUpdate_579069 = ref object of OpenApiRestCall_578364
proc url_YoutubeChannelSectionsUpdate_579071(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsUpdate_579070(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a channelSection.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579072 = query.getOrDefault("key")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "key", valid_579072
  var valid_579073 = query.getOrDefault("prettyPrint")
  valid_579073 = validateParameter(valid_579073, JBool, required = false,
                                 default = newJBool(true))
  if valid_579073 != nil:
    section.add "prettyPrint", valid_579073
  var valid_579074 = query.getOrDefault("oauth_token")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "oauth_token", valid_579074
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579075 = query.getOrDefault("part")
  valid_579075 = validateParameter(valid_579075, JString, required = true,
                                 default = nil)
  if valid_579075 != nil:
    section.add "part", valid_579075
  var valid_579076 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "onBehalfOfContentOwner", valid_579076
  var valid_579077 = query.getOrDefault("alt")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = newJString("json"))
  if valid_579077 != nil:
    section.add "alt", valid_579077
  var valid_579078 = query.getOrDefault("userIp")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "userIp", valid_579078
  var valid_579079 = query.getOrDefault("quotaUser")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "quotaUser", valid_579079
  var valid_579080 = query.getOrDefault("fields")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "fields", valid_579080
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

proc call*(call_579082: Call_YoutubeChannelSectionsUpdate_579069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a channelSection.
  ## 
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_YoutubeChannelSectionsUpdate_579069; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubeChannelSectionsUpdate
  ## Update a channelSection.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579084 = newJObject()
  var body_579085 = newJObject()
  add(query_579084, "key", newJString(key))
  add(query_579084, "prettyPrint", newJBool(prettyPrint))
  add(query_579084, "oauth_token", newJString(oauthToken))
  add(query_579084, "part", newJString(part))
  add(query_579084, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579084, "alt", newJString(alt))
  add(query_579084, "userIp", newJString(userIp))
  add(query_579084, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579085 = body
  add(query_579084, "fields", newJString(fields))
  result = call_579083.call(nil, query_579084, nil, nil, body_579085)

var youtubeChannelSectionsUpdate* = Call_YoutubeChannelSectionsUpdate_579069(
    name: "youtubeChannelSectionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsUpdate_579070, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsUpdate_579071, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsInsert_579086 = ref object of OpenApiRestCall_578364
proc url_YoutubeChannelSectionsInsert_579088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsInsert_579087(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a channelSection for the authenticated user's channel.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579089 = query.getOrDefault("key")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "key", valid_579089
  var valid_579090 = query.getOrDefault("prettyPrint")
  valid_579090 = validateParameter(valid_579090, JBool, required = false,
                                 default = newJBool(true))
  if valid_579090 != nil:
    section.add "prettyPrint", valid_579090
  var valid_579091 = query.getOrDefault("oauth_token")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "oauth_token", valid_579091
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579092 = query.getOrDefault("part")
  valid_579092 = validateParameter(valid_579092, JString, required = true,
                                 default = nil)
  if valid_579092 != nil:
    section.add "part", valid_579092
  var valid_579093 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "onBehalfOfContentOwner", valid_579093
  var valid_579094 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579094
  var valid_579095 = query.getOrDefault("alt")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = newJString("json"))
  if valid_579095 != nil:
    section.add "alt", valid_579095
  var valid_579096 = query.getOrDefault("userIp")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "userIp", valid_579096
  var valid_579097 = query.getOrDefault("quotaUser")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "quotaUser", valid_579097
  var valid_579098 = query.getOrDefault("fields")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "fields", valid_579098
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

proc call*(call_579100: Call_YoutubeChannelSectionsInsert_579086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a channelSection for the authenticated user's channel.
  ## 
  let valid = call_579100.validator(path, query, header, formData, body)
  let scheme = call_579100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579100.url(scheme.get, call_579100.host, call_579100.base,
                         call_579100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579100, url, valid)

proc call*(call_579101: Call_YoutubeChannelSectionsInsert_579086; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubeChannelSectionsInsert
  ## Adds a channelSection for the authenticated user's channel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579102 = newJObject()
  var body_579103 = newJObject()
  add(query_579102, "key", newJString(key))
  add(query_579102, "prettyPrint", newJBool(prettyPrint))
  add(query_579102, "oauth_token", newJString(oauthToken))
  add(query_579102, "part", newJString(part))
  add(query_579102, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579102, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579102, "alt", newJString(alt))
  add(query_579102, "userIp", newJString(userIp))
  add(query_579102, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579103 = body
  add(query_579102, "fields", newJString(fields))
  result = call_579101.call(nil, query_579102, nil, nil, body_579103)

var youtubeChannelSectionsInsert* = Call_YoutubeChannelSectionsInsert_579086(
    name: "youtubeChannelSectionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsInsert_579087, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsInsert_579088, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsList_579050 = ref object of OpenApiRestCall_578364
proc url_YoutubeChannelSectionsList_579052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsList_579051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns channelSection resources that match the API request criteria.
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
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more channelSection resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, and contentDetails.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channelSection resource, the snippet property contains other properties, such as a display title for the channelSection. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   channelId: JString
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's channelSections.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channelSection ID(s) for the resource(s) that are being retrieved. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   hl: JString
  ##     : The hl parameter indicates that the snippet.localized property values in the returned channelSection resources should be in the specified language if localized values for that language are available. For example, if the API request specifies hl=de, the snippet.localized properties in the API response will contain German titles if German titles are available. Channel owners can provide localized channel section titles using either the channelSections.insert or channelSections.update method.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's channelSections.
  section = newJObject()
  var valid_579053 = query.getOrDefault("key")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "key", valid_579053
  var valid_579054 = query.getOrDefault("prettyPrint")
  valid_579054 = validateParameter(valid_579054, JBool, required = false,
                                 default = newJBool(true))
  if valid_579054 != nil:
    section.add "prettyPrint", valid_579054
  var valid_579055 = query.getOrDefault("oauth_token")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "oauth_token", valid_579055
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579056 = query.getOrDefault("part")
  valid_579056 = validateParameter(valid_579056, JString, required = true,
                                 default = nil)
  if valid_579056 != nil:
    section.add "part", valid_579056
  var valid_579057 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "onBehalfOfContentOwner", valid_579057
  var valid_579058 = query.getOrDefault("alt")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = newJString("json"))
  if valid_579058 != nil:
    section.add "alt", valid_579058
  var valid_579059 = query.getOrDefault("userIp")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "userIp", valid_579059
  var valid_579060 = query.getOrDefault("quotaUser")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "quotaUser", valid_579060
  var valid_579061 = query.getOrDefault("channelId")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "channelId", valid_579061
  var valid_579062 = query.getOrDefault("id")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "id", valid_579062
  var valid_579063 = query.getOrDefault("hl")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "hl", valid_579063
  var valid_579064 = query.getOrDefault("fields")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "fields", valid_579064
  var valid_579065 = query.getOrDefault("mine")
  valid_579065 = validateParameter(valid_579065, JBool, required = false, default = nil)
  if valid_579065 != nil:
    section.add "mine", valid_579065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579066: Call_YoutubeChannelSectionsList_579050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns channelSection resources that match the API request criteria.
  ## 
  let valid = call_579066.validator(path, query, header, formData, body)
  let scheme = call_579066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579066.url(scheme.get, call_579066.host, call_579066.base,
                         call_579066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579066, url, valid)

proc call*(call_579067: Call_YoutubeChannelSectionsList_579050; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; channelId: string = "";
          id: string = ""; hl: string = ""; fields: string = ""; mine: bool = false): Recallable =
  ## youtubeChannelSectionsList
  ## Returns channelSection resources that match the API request criteria.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more channelSection resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, and contentDetails.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channelSection resource, the snippet property contains other properties, such as a display title for the channelSection. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   channelId: string
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's channelSections.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channelSection ID(s) for the resource(s) that are being retrieved. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   hl: string
  ##     : The hl parameter indicates that the snippet.localized property values in the returned channelSection resources should be in the specified language if localized values for that language are available. For example, if the API request specifies hl=de, the snippet.localized properties in the API response will contain German titles if German titles are available. Channel owners can provide localized channel section titles using either the channelSections.insert or channelSections.update method.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's channelSections.
  var query_579068 = newJObject()
  add(query_579068, "key", newJString(key))
  add(query_579068, "prettyPrint", newJBool(prettyPrint))
  add(query_579068, "oauth_token", newJString(oauthToken))
  add(query_579068, "part", newJString(part))
  add(query_579068, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579068, "alt", newJString(alt))
  add(query_579068, "userIp", newJString(userIp))
  add(query_579068, "quotaUser", newJString(quotaUser))
  add(query_579068, "channelId", newJString(channelId))
  add(query_579068, "id", newJString(id))
  add(query_579068, "hl", newJString(hl))
  add(query_579068, "fields", newJString(fields))
  add(query_579068, "mine", newJBool(mine))
  result = call_579067.call(nil, query_579068, nil, nil, nil)

var youtubeChannelSectionsList* = Call_YoutubeChannelSectionsList_579050(
    name: "youtubeChannelSectionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsList_579051, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsList_579052, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsDelete_579104 = ref object of OpenApiRestCall_578364
proc url_YoutubeChannelSectionsDelete_579106(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsDelete_579105(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a channelSection.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube channelSection ID for the resource that is being deleted. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579107 = query.getOrDefault("key")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "key", valid_579107
  var valid_579108 = query.getOrDefault("prettyPrint")
  valid_579108 = validateParameter(valid_579108, JBool, required = false,
                                 default = newJBool(true))
  if valid_579108 != nil:
    section.add "prettyPrint", valid_579108
  var valid_579109 = query.getOrDefault("oauth_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "oauth_token", valid_579109
  var valid_579110 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "onBehalfOfContentOwner", valid_579110
  var valid_579111 = query.getOrDefault("alt")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = newJString("json"))
  if valid_579111 != nil:
    section.add "alt", valid_579111
  var valid_579112 = query.getOrDefault("userIp")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "userIp", valid_579112
  var valid_579113 = query.getOrDefault("quotaUser")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "quotaUser", valid_579113
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579114 = query.getOrDefault("id")
  valid_579114 = validateParameter(valid_579114, JString, required = true,
                                 default = nil)
  if valid_579114 != nil:
    section.add "id", valid_579114
  var valid_579115 = query.getOrDefault("fields")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "fields", valid_579115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579116: Call_YoutubeChannelSectionsDelete_579104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a channelSection.
  ## 
  let valid = call_579116.validator(path, query, header, formData, body)
  let scheme = call_579116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579116.url(scheme.get, call_579116.host, call_579116.base,
                         call_579116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579116, url, valid)

proc call*(call_579117: Call_YoutubeChannelSectionsDelete_579104; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## youtubeChannelSectionsDelete
  ## Deletes a channelSection.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube channelSection ID for the resource that is being deleted. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579118 = newJObject()
  add(query_579118, "key", newJString(key))
  add(query_579118, "prettyPrint", newJBool(prettyPrint))
  add(query_579118, "oauth_token", newJString(oauthToken))
  add(query_579118, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579118, "alt", newJString(alt))
  add(query_579118, "userIp", newJString(userIp))
  add(query_579118, "quotaUser", newJString(quotaUser))
  add(query_579118, "id", newJString(id))
  add(query_579118, "fields", newJString(fields))
  result = call_579117.call(nil, query_579118, nil, nil, nil)

var youtubeChannelSectionsDelete* = Call_YoutubeChannelSectionsDelete_579104(
    name: "youtubeChannelSectionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsDelete_579105, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsDelete_579106, schemes: {Scheme.Https})
type
  Call_YoutubeChannelsUpdate_579143 = ref object of OpenApiRestCall_578364
proc url_YoutubeChannelsUpdate_579145(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelsUpdate_579144(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The API currently only allows the parameter value to be set to either brandingSettings or invideoPromotion. (You cannot update both of those parts with a single request.)
  ## 
  ## Note that this method overrides the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies.
  ##   onBehalfOfContentOwner: JString
  ##                         : The onBehalfOfContentOwner parameter indicates that the authenticated user is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with needs to be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579146 = query.getOrDefault("key")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "key", valid_579146
  var valid_579147 = query.getOrDefault("prettyPrint")
  valid_579147 = validateParameter(valid_579147, JBool, required = false,
                                 default = newJBool(true))
  if valid_579147 != nil:
    section.add "prettyPrint", valid_579147
  var valid_579148 = query.getOrDefault("oauth_token")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "oauth_token", valid_579148
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579149 = query.getOrDefault("part")
  valid_579149 = validateParameter(valid_579149, JString, required = true,
                                 default = nil)
  if valid_579149 != nil:
    section.add "part", valid_579149
  var valid_579150 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "onBehalfOfContentOwner", valid_579150
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579156: Call_YoutubeChannelsUpdate_579143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
  ## 
  let valid = call_579156.validator(path, query, header, formData, body)
  let scheme = call_579156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579156.url(scheme.get, call_579156.host, call_579156.base,
                         call_579156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579156, url, valid)

proc call*(call_579157: Call_YoutubeChannelsUpdate_579143; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubeChannelsUpdate
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The API currently only allows the parameter value to be set to either brandingSettings or invideoPromotion. (You cannot update both of those parts with a single request.)
  ## 
  ## Note that this method overrides the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies.
  ##   onBehalfOfContentOwner: string
  ##                         : The onBehalfOfContentOwner parameter indicates that the authenticated user is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with needs to be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579158 = newJObject()
  var body_579159 = newJObject()
  add(query_579158, "key", newJString(key))
  add(query_579158, "prettyPrint", newJBool(prettyPrint))
  add(query_579158, "oauth_token", newJString(oauthToken))
  add(query_579158, "part", newJString(part))
  add(query_579158, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579158, "alt", newJString(alt))
  add(query_579158, "userIp", newJString(userIp))
  add(query_579158, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579159 = body
  add(query_579158, "fields", newJString(fields))
  result = call_579157.call(nil, query_579158, nil, nil, body_579159)

var youtubeChannelsUpdate* = Call_YoutubeChannelsUpdate_579143(
    name: "youtubeChannelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/channels",
    validator: validate_YoutubeChannelsUpdate_579144, base: "/youtube/v3",
    url: url_YoutubeChannelsUpdate_579145, schemes: {Scheme.Https})
type
  Call_YoutubeChannelsList_579119 = ref object of OpenApiRestCall_578364
proc url_YoutubeChannelsList_579121(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelsList_579120(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   forUsername: JString
  ##              : The forUsername parameter specifies a YouTube username, thereby requesting the channel associated with that username.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   mySubscribers: JBool
  ##                : Use the subscriptions.list method and its mySubscribers parameter to retrieve a list of subscribers to the authenticated user's channel.
  ##   managedByMe: JBool
  ##              : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## Set this parameter's value to true to instruct the API to only return channels managed by the content owner that the onBehalfOfContentOwner parameter specifies. The user must be authenticated as a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more channel resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channel resource, the contentDetails property contains other properties, such as the uploads properties. As such, if you set part=contentDetails, the API response will also contain all of those nested properties.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   categoryId: JString
  ##             : The categoryId parameter specifies a YouTube guide category, thereby requesting YouTube channels associated with that category.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channel ID(s) for the resource(s) that are being retrieved. In a channel resource, the id property specifies the channel's YouTube channel ID.
  ##   hl: JString
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the brandingSettings part.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: JBool
  ##       : Set this parameter's value to true to instruct the API to only return channels owned by the authenticated user.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  section = newJObject()
  var valid_579122 = query.getOrDefault("key")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "key", valid_579122
  var valid_579123 = query.getOrDefault("forUsername")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "forUsername", valid_579123
  var valid_579124 = query.getOrDefault("prettyPrint")
  valid_579124 = validateParameter(valid_579124, JBool, required = false,
                                 default = newJBool(true))
  if valid_579124 != nil:
    section.add "prettyPrint", valid_579124
  var valid_579125 = query.getOrDefault("oauth_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "oauth_token", valid_579125
  var valid_579126 = query.getOrDefault("mySubscribers")
  valid_579126 = validateParameter(valid_579126, JBool, required = false, default = nil)
  if valid_579126 != nil:
    section.add "mySubscribers", valid_579126
  var valid_579127 = query.getOrDefault("managedByMe")
  valid_579127 = validateParameter(valid_579127, JBool, required = false, default = nil)
  if valid_579127 != nil:
    section.add "managedByMe", valid_579127
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579128 = query.getOrDefault("part")
  valid_579128 = validateParameter(valid_579128, JString, required = true,
                                 default = nil)
  if valid_579128 != nil:
    section.add "part", valid_579128
  var valid_579129 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "onBehalfOfContentOwner", valid_579129
  var valid_579130 = query.getOrDefault("alt")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = newJString("json"))
  if valid_579130 != nil:
    section.add "alt", valid_579130
  var valid_579131 = query.getOrDefault("userIp")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "userIp", valid_579131
  var valid_579132 = query.getOrDefault("quotaUser")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "quotaUser", valid_579132
  var valid_579133 = query.getOrDefault("categoryId")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "categoryId", valid_579133
  var valid_579134 = query.getOrDefault("pageToken")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "pageToken", valid_579134
  var valid_579135 = query.getOrDefault("id")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "id", valid_579135
  var valid_579136 = query.getOrDefault("hl")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "hl", valid_579136
  var valid_579137 = query.getOrDefault("fields")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "fields", valid_579137
  var valid_579138 = query.getOrDefault("mine")
  valid_579138 = validateParameter(valid_579138, JBool, required = false, default = nil)
  if valid_579138 != nil:
    section.add "mine", valid_579138
  var valid_579139 = query.getOrDefault("maxResults")
  valid_579139 = validateParameter(valid_579139, JInt, required = false,
                                 default = newJInt(5))
  if valid_579139 != nil:
    section.add "maxResults", valid_579139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579140: Call_YoutubeChannelsList_579119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ## 
  let valid = call_579140.validator(path, query, header, formData, body)
  let scheme = call_579140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579140.url(scheme.get, call_579140.host, call_579140.base,
                         call_579140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579140, url, valid)

proc call*(call_579141: Call_YoutubeChannelsList_579119; part: string;
          key: string = ""; forUsername: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; mySubscribers: bool = false;
          managedByMe: bool = false; onBehalfOfContentOwner: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          categoryId: string = ""; pageToken: string = ""; id: string = ""; hl: string = "";
          fields: string = ""; mine: bool = false; maxResults: int = 5): Recallable =
  ## youtubeChannelsList
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   forUsername: string
  ##              : The forUsername parameter specifies a YouTube username, thereby requesting the channel associated with that username.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   mySubscribers: bool
  ##                : Use the subscriptions.list method and its mySubscribers parameter to retrieve a list of subscribers to the authenticated user's channel.
  ##   managedByMe: bool
  ##              : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## Set this parameter's value to true to instruct the API to only return channels managed by the content owner that the onBehalfOfContentOwner parameter specifies. The user must be authenticated as a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more channel resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channel resource, the contentDetails property contains other properties, such as the uploads properties. As such, if you set part=contentDetails, the API response will also contain all of those nested properties.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   categoryId: string
  ##             : The categoryId parameter specifies a YouTube guide category, thereby requesting YouTube channels associated with that category.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channel ID(s) for the resource(s) that are being retrieved. In a channel resource, the id property specifies the channel's YouTube channel ID.
  ##   hl: string
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the brandingSettings part.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: bool
  ##       : Set this parameter's value to true to instruct the API to only return channels owned by the authenticated user.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_579142 = newJObject()
  add(query_579142, "key", newJString(key))
  add(query_579142, "forUsername", newJString(forUsername))
  add(query_579142, "prettyPrint", newJBool(prettyPrint))
  add(query_579142, "oauth_token", newJString(oauthToken))
  add(query_579142, "mySubscribers", newJBool(mySubscribers))
  add(query_579142, "managedByMe", newJBool(managedByMe))
  add(query_579142, "part", newJString(part))
  add(query_579142, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579142, "alt", newJString(alt))
  add(query_579142, "userIp", newJString(userIp))
  add(query_579142, "quotaUser", newJString(quotaUser))
  add(query_579142, "categoryId", newJString(categoryId))
  add(query_579142, "pageToken", newJString(pageToken))
  add(query_579142, "id", newJString(id))
  add(query_579142, "hl", newJString(hl))
  add(query_579142, "fields", newJString(fields))
  add(query_579142, "mine", newJBool(mine))
  add(query_579142, "maxResults", newJInt(maxResults))
  result = call_579141.call(nil, query_579142, nil, nil, nil)

var youtubeChannelsList* = Call_YoutubeChannelsList_579119(
    name: "youtubeChannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/channels",
    validator: validate_YoutubeChannelsList_579120, base: "/youtube/v3",
    url: url_YoutubeChannelsList_579121, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsUpdate_579184 = ref object of OpenApiRestCall_578364
proc url_YoutubeCommentThreadsUpdate_579186(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsUpdate_579185(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the top-level comment in a comment thread.
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
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of commentThread resource properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579187 = query.getOrDefault("key")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "key", valid_579187
  var valid_579188 = query.getOrDefault("prettyPrint")
  valid_579188 = validateParameter(valid_579188, JBool, required = false,
                                 default = newJBool(true))
  if valid_579188 != nil:
    section.add "prettyPrint", valid_579188
  var valid_579189 = query.getOrDefault("oauth_token")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "oauth_token", valid_579189
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579190 = query.getOrDefault("part")
  valid_579190 = validateParameter(valid_579190, JString, required = true,
                                 default = nil)
  if valid_579190 != nil:
    section.add "part", valid_579190
  var valid_579191 = query.getOrDefault("alt")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = newJString("json"))
  if valid_579191 != nil:
    section.add "alt", valid_579191
  var valid_579192 = query.getOrDefault("userIp")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "userIp", valid_579192
  var valid_579193 = query.getOrDefault("quotaUser")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "quotaUser", valid_579193
  var valid_579194 = query.getOrDefault("fields")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "fields", valid_579194
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

proc call*(call_579196: Call_YoutubeCommentThreadsUpdate_579184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the top-level comment in a comment thread.
  ## 
  let valid = call_579196.validator(path, query, header, formData, body)
  let scheme = call_579196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579196.url(scheme.get, call_579196.host, call_579196.base,
                         call_579196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579196, url, valid)

proc call*(call_579197: Call_YoutubeCommentThreadsUpdate_579184; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeCommentThreadsUpdate
  ## Modifies the top-level comment in a comment thread.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of commentThread resource properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579198 = newJObject()
  var body_579199 = newJObject()
  add(query_579198, "key", newJString(key))
  add(query_579198, "prettyPrint", newJBool(prettyPrint))
  add(query_579198, "oauth_token", newJString(oauthToken))
  add(query_579198, "part", newJString(part))
  add(query_579198, "alt", newJString(alt))
  add(query_579198, "userIp", newJString(userIp))
  add(query_579198, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579199 = body
  add(query_579198, "fields", newJString(fields))
  result = call_579197.call(nil, query_579198, nil, nil, body_579199)

var youtubeCommentThreadsUpdate* = Call_YoutubeCommentThreadsUpdate_579184(
    name: "youtubeCommentThreadsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsUpdate_579185, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsUpdate_579186, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsInsert_579200 = ref object of OpenApiRestCall_578364
proc url_YoutubeCommentThreadsInsert_579202(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsInsert_579201(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
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
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579203 = query.getOrDefault("key")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "key", valid_579203
  var valid_579204 = query.getOrDefault("prettyPrint")
  valid_579204 = validateParameter(valid_579204, JBool, required = false,
                                 default = newJBool(true))
  if valid_579204 != nil:
    section.add "prettyPrint", valid_579204
  var valid_579205 = query.getOrDefault("oauth_token")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "oauth_token", valid_579205
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579206 = query.getOrDefault("part")
  valid_579206 = validateParameter(valid_579206, JString, required = true,
                                 default = nil)
  if valid_579206 != nil:
    section.add "part", valid_579206
  var valid_579207 = query.getOrDefault("alt")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = newJString("json"))
  if valid_579207 != nil:
    section.add "alt", valid_579207
  var valid_579208 = query.getOrDefault("userIp")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "userIp", valid_579208
  var valid_579209 = query.getOrDefault("quotaUser")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "quotaUser", valid_579209
  var valid_579210 = query.getOrDefault("fields")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "fields", valid_579210
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

proc call*(call_579212: Call_YoutubeCommentThreadsInsert_579200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
  ## 
  let valid = call_579212.validator(path, query, header, formData, body)
  let scheme = call_579212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579212.url(scheme.get, call_579212.host, call_579212.base,
                         call_579212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579212, url, valid)

proc call*(call_579213: Call_YoutubeCommentThreadsInsert_579200; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeCommentThreadsInsert
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579214 = newJObject()
  var body_579215 = newJObject()
  add(query_579214, "key", newJString(key))
  add(query_579214, "prettyPrint", newJBool(prettyPrint))
  add(query_579214, "oauth_token", newJString(oauthToken))
  add(query_579214, "part", newJString(part))
  add(query_579214, "alt", newJString(alt))
  add(query_579214, "userIp", newJString(userIp))
  add(query_579214, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579215 = body
  add(query_579214, "fields", newJString(fields))
  result = call_579213.call(nil, query_579214, nil, nil, body_579215)

var youtubeCommentThreadsInsert* = Call_YoutubeCommentThreadsInsert_579200(
    name: "youtubeCommentThreadsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsInsert_579201, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsInsert_579202, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsList_579160 = ref object of OpenApiRestCall_578364
proc url_YoutubeCommentThreadsList_579162(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsList_579161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of comment threads that match the API request parameters.
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
  ##   moderationStatus: JString
  ##                   : Set this parameter to limit the returned comment threads to a particular moderation state.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   order: JString
  ##        : The order parameter specifies the order in which the API response should list comment threads. Valid values are: 
  ## - time - Comment threads are ordered by time. This is the default behavior.
  ## - relevance - Comment threads are ordered by relevance.Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more commentThread resource properties that the API response will include.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   searchTerms: JString
  ##              : The searchTerms parameter instructs the API to limit the API response to only contain comments that contain the specified search terms.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   channelId: JString
  ##            : The channelId parameter instructs the API to return comment threads containing comments about the specified channel. (The response will not include comments left on videos that the channel uploaded.)
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of comment thread IDs for the resources that should be retrieved.
  ##   videoId: JString
  ##          : The videoId parameter instructs the API to return comment threads associated with the specified video ID.
  ##   textFormat: JString
  ##             : Set this parameter's value to html or plainText to instruct the API to return the comments left by users in html formatted or in plain text.
  ##   allThreadsRelatedToChannelId: JString
  ##                               : The allThreadsRelatedToChannelId parameter instructs the API to return all comment threads associated with the specified channel. The response can include comments about the channel or about the channel's videos.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  section = newJObject()
  var valid_579163 = query.getOrDefault("key")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "key", valid_579163
  var valid_579164 = query.getOrDefault("prettyPrint")
  valid_579164 = validateParameter(valid_579164, JBool, required = false,
                                 default = newJBool(true))
  if valid_579164 != nil:
    section.add "prettyPrint", valid_579164
  var valid_579165 = query.getOrDefault("oauth_token")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "oauth_token", valid_579165
  var valid_579166 = query.getOrDefault("moderationStatus")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = newJString("published"))
  if valid_579166 != nil:
    section.add "moderationStatus", valid_579166
  var valid_579167 = query.getOrDefault("order")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = newJString("relevance"))
  if valid_579167 != nil:
    section.add "order", valid_579167
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579168 = query.getOrDefault("part")
  valid_579168 = validateParameter(valid_579168, JString, required = true,
                                 default = nil)
  if valid_579168 != nil:
    section.add "part", valid_579168
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
  var valid_579172 = query.getOrDefault("pageToken")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "pageToken", valid_579172
  var valid_579173 = query.getOrDefault("searchTerms")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "searchTerms", valid_579173
  var valid_579174 = query.getOrDefault("channelId")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "channelId", valid_579174
  var valid_579175 = query.getOrDefault("id")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "id", valid_579175
  var valid_579176 = query.getOrDefault("videoId")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "videoId", valid_579176
  var valid_579177 = query.getOrDefault("textFormat")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = newJString("html"))
  if valid_579177 != nil:
    section.add "textFormat", valid_579177
  var valid_579178 = query.getOrDefault("allThreadsRelatedToChannelId")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "allThreadsRelatedToChannelId", valid_579178
  var valid_579179 = query.getOrDefault("fields")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "fields", valid_579179
  var valid_579180 = query.getOrDefault("maxResults")
  valid_579180 = validateParameter(valid_579180, JInt, required = false,
                                 default = newJInt(20))
  if valid_579180 != nil:
    section.add "maxResults", valid_579180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579181: Call_YoutubeCommentThreadsList_579160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of comment threads that match the API request parameters.
  ## 
  let valid = call_579181.validator(path, query, header, formData, body)
  let scheme = call_579181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579181.url(scheme.get, call_579181.host, call_579181.base,
                         call_579181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579181, url, valid)

proc call*(call_579182: Call_YoutubeCommentThreadsList_579160; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          moderationStatus: string = "published"; order: string = "relevance";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; searchTerms: string = ""; channelId: string = "";
          id: string = ""; videoId: string = ""; textFormat: string = "html";
          allThreadsRelatedToChannelId: string = ""; fields: string = "";
          maxResults: int = 20): Recallable =
  ## youtubeCommentThreadsList
  ## Returns a list of comment threads that match the API request parameters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   moderationStatus: string
  ##                   : Set this parameter to limit the returned comment threads to a particular moderation state.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   order: string
  ##        : The order parameter specifies the order in which the API response should list comment threads. Valid values are: 
  ## - time - Comment threads are ordered by time. This is the default behavior.
  ## - relevance - Comment threads are ordered by relevance.Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more commentThread resource properties that the API response will include.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   searchTerms: string
  ##              : The searchTerms parameter instructs the API to limit the API response to only contain comments that contain the specified search terms.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   channelId: string
  ##            : The channelId parameter instructs the API to return comment threads containing comments about the specified channel. (The response will not include comments left on videos that the channel uploaded.)
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of comment thread IDs for the resources that should be retrieved.
  ##   videoId: string
  ##          : The videoId parameter instructs the API to return comment threads associated with the specified video ID.
  ##   textFormat: string
  ##             : Set this parameter's value to html or plainText to instruct the API to return the comments left by users in html formatted or in plain text.
  ##   allThreadsRelatedToChannelId: string
  ##                               : The allThreadsRelatedToChannelId parameter instructs the API to return all comment threads associated with the specified channel. The response can include comments about the channel or about the channel's videos.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  var query_579183 = newJObject()
  add(query_579183, "key", newJString(key))
  add(query_579183, "prettyPrint", newJBool(prettyPrint))
  add(query_579183, "oauth_token", newJString(oauthToken))
  add(query_579183, "moderationStatus", newJString(moderationStatus))
  add(query_579183, "order", newJString(order))
  add(query_579183, "part", newJString(part))
  add(query_579183, "alt", newJString(alt))
  add(query_579183, "userIp", newJString(userIp))
  add(query_579183, "quotaUser", newJString(quotaUser))
  add(query_579183, "pageToken", newJString(pageToken))
  add(query_579183, "searchTerms", newJString(searchTerms))
  add(query_579183, "channelId", newJString(channelId))
  add(query_579183, "id", newJString(id))
  add(query_579183, "videoId", newJString(videoId))
  add(query_579183, "textFormat", newJString(textFormat))
  add(query_579183, "allThreadsRelatedToChannelId",
      newJString(allThreadsRelatedToChannelId))
  add(query_579183, "fields", newJString(fields))
  add(query_579183, "maxResults", newJInt(maxResults))
  result = call_579182.call(nil, query_579183, nil, nil, nil)

var youtubeCommentThreadsList* = Call_YoutubeCommentThreadsList_579160(
    name: "youtubeCommentThreadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsList_579161, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsList_579162, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsUpdate_579235 = ref object of OpenApiRestCall_578364
proc url_YoutubeCommentsUpdate_579237(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsUpdate_579236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a comment.
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
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579238 = query.getOrDefault("key")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "key", valid_579238
  var valid_579239 = query.getOrDefault("prettyPrint")
  valid_579239 = validateParameter(valid_579239, JBool, required = false,
                                 default = newJBool(true))
  if valid_579239 != nil:
    section.add "prettyPrint", valid_579239
  var valid_579240 = query.getOrDefault("oauth_token")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "oauth_token", valid_579240
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579241 = query.getOrDefault("part")
  valid_579241 = validateParameter(valid_579241, JString, required = true,
                                 default = nil)
  if valid_579241 != nil:
    section.add "part", valid_579241
  var valid_579242 = query.getOrDefault("alt")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = newJString("json"))
  if valid_579242 != nil:
    section.add "alt", valid_579242
  var valid_579243 = query.getOrDefault("userIp")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "userIp", valid_579243
  var valid_579244 = query.getOrDefault("quotaUser")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "quotaUser", valid_579244
  var valid_579245 = query.getOrDefault("fields")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "fields", valid_579245
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

proc call*(call_579247: Call_YoutubeCommentsUpdate_579235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a comment.
  ## 
  let valid = call_579247.validator(path, query, header, formData, body)
  let scheme = call_579247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579247.url(scheme.get, call_579247.host, call_579247.base,
                         call_579247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579247, url, valid)

proc call*(call_579248: Call_YoutubeCommentsUpdate_579235; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeCommentsUpdate
  ## Modifies a comment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579249 = newJObject()
  var body_579250 = newJObject()
  add(query_579249, "key", newJString(key))
  add(query_579249, "prettyPrint", newJBool(prettyPrint))
  add(query_579249, "oauth_token", newJString(oauthToken))
  add(query_579249, "part", newJString(part))
  add(query_579249, "alt", newJString(alt))
  add(query_579249, "userIp", newJString(userIp))
  add(query_579249, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579250 = body
  add(query_579249, "fields", newJString(fields))
  result = call_579248.call(nil, query_579249, nil, nil, body_579250)

var youtubeCommentsUpdate* = Call_YoutubeCommentsUpdate_579235(
    name: "youtubeCommentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsUpdate_579236, base: "/youtube/v3",
    url: url_YoutubeCommentsUpdate_579237, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsInsert_579251 = ref object of OpenApiRestCall_578364
proc url_YoutubeCommentsInsert_579253(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsInsert_579252(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
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
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579254 = query.getOrDefault("key")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "key", valid_579254
  var valid_579255 = query.getOrDefault("prettyPrint")
  valid_579255 = validateParameter(valid_579255, JBool, required = false,
                                 default = newJBool(true))
  if valid_579255 != nil:
    section.add "prettyPrint", valid_579255
  var valid_579256 = query.getOrDefault("oauth_token")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "oauth_token", valid_579256
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579257 = query.getOrDefault("part")
  valid_579257 = validateParameter(valid_579257, JString, required = true,
                                 default = nil)
  if valid_579257 != nil:
    section.add "part", valid_579257
  var valid_579258 = query.getOrDefault("alt")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = newJString("json"))
  if valid_579258 != nil:
    section.add "alt", valid_579258
  var valid_579259 = query.getOrDefault("userIp")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "userIp", valid_579259
  var valid_579260 = query.getOrDefault("quotaUser")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "quotaUser", valid_579260
  var valid_579261 = query.getOrDefault("fields")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "fields", valid_579261
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

proc call*(call_579263: Call_YoutubeCommentsInsert_579251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
  ## 
  let valid = call_579263.validator(path, query, header, formData, body)
  let scheme = call_579263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579263.url(scheme.get, call_579263.host, call_579263.base,
                         call_579263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579263, url, valid)

proc call*(call_579264: Call_YoutubeCommentsInsert_579251; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeCommentsInsert
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579265 = newJObject()
  var body_579266 = newJObject()
  add(query_579265, "key", newJString(key))
  add(query_579265, "prettyPrint", newJBool(prettyPrint))
  add(query_579265, "oauth_token", newJString(oauthToken))
  add(query_579265, "part", newJString(part))
  add(query_579265, "alt", newJString(alt))
  add(query_579265, "userIp", newJString(userIp))
  add(query_579265, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579266 = body
  add(query_579265, "fields", newJString(fields))
  result = call_579264.call(nil, query_579265, nil, nil, body_579266)

var youtubeCommentsInsert* = Call_YoutubeCommentsInsert_579251(
    name: "youtubeCommentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsInsert_579252, base: "/youtube/v3",
    url: url_YoutubeCommentsInsert_579253, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsList_579216 = ref object of OpenApiRestCall_578364
proc url_YoutubeCommentsList_579218(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsList_579217(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of comments that match the API request parameters.
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
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more comment resource properties that the API response will include.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of comment IDs for the resources that are being retrieved. In a comment resource, the id property specifies the comment's ID.
  ##   textFormat: JString
  ##             : This parameter indicates whether the API should return comments formatted as HTML or as plain text.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   parentId: JString
  ##           : The parentId parameter specifies the ID of the comment for which replies should be retrieved.
  ## 
  ## Note: YouTube currently supports replies only for top-level comments. However, replies to replies may be supported in the future.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  section = newJObject()
  var valid_579219 = query.getOrDefault("key")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "key", valid_579219
  var valid_579220 = query.getOrDefault("prettyPrint")
  valid_579220 = validateParameter(valid_579220, JBool, required = false,
                                 default = newJBool(true))
  if valid_579220 != nil:
    section.add "prettyPrint", valid_579220
  var valid_579221 = query.getOrDefault("oauth_token")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "oauth_token", valid_579221
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579222 = query.getOrDefault("part")
  valid_579222 = validateParameter(valid_579222, JString, required = true,
                                 default = nil)
  if valid_579222 != nil:
    section.add "part", valid_579222
  var valid_579223 = query.getOrDefault("alt")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = newJString("json"))
  if valid_579223 != nil:
    section.add "alt", valid_579223
  var valid_579224 = query.getOrDefault("userIp")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "userIp", valid_579224
  var valid_579225 = query.getOrDefault("quotaUser")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "quotaUser", valid_579225
  var valid_579226 = query.getOrDefault("pageToken")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "pageToken", valid_579226
  var valid_579227 = query.getOrDefault("id")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "id", valid_579227
  var valid_579228 = query.getOrDefault("textFormat")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = newJString("html"))
  if valid_579228 != nil:
    section.add "textFormat", valid_579228
  var valid_579229 = query.getOrDefault("fields")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "fields", valid_579229
  var valid_579230 = query.getOrDefault("parentId")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "parentId", valid_579230
  var valid_579231 = query.getOrDefault("maxResults")
  valid_579231 = validateParameter(valid_579231, JInt, required = false,
                                 default = newJInt(20))
  if valid_579231 != nil:
    section.add "maxResults", valid_579231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579232: Call_YoutubeCommentsList_579216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of comments that match the API request parameters.
  ## 
  let valid = call_579232.validator(path, query, header, formData, body)
  let scheme = call_579232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579232.url(scheme.get, call_579232.host, call_579232.base,
                         call_579232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579232, url, valid)

proc call*(call_579233: Call_YoutubeCommentsList_579216; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; id: string = ""; textFormat: string = "html";
          fields: string = ""; parentId: string = ""; maxResults: int = 20): Recallable =
  ## youtubeCommentsList
  ## Returns a list of comments that match the API request parameters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more comment resource properties that the API response will include.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of comment IDs for the resources that are being retrieved. In a comment resource, the id property specifies the comment's ID.
  ##   textFormat: string
  ##             : This parameter indicates whether the API should return comments formatted as HTML or as plain text.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   parentId: string
  ##           : The parentId parameter specifies the ID of the comment for which replies should be retrieved.
  ## 
  ## Note: YouTube currently supports replies only for top-level comments. However, replies to replies may be supported in the future.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  var query_579234 = newJObject()
  add(query_579234, "key", newJString(key))
  add(query_579234, "prettyPrint", newJBool(prettyPrint))
  add(query_579234, "oauth_token", newJString(oauthToken))
  add(query_579234, "part", newJString(part))
  add(query_579234, "alt", newJString(alt))
  add(query_579234, "userIp", newJString(userIp))
  add(query_579234, "quotaUser", newJString(quotaUser))
  add(query_579234, "pageToken", newJString(pageToken))
  add(query_579234, "id", newJString(id))
  add(query_579234, "textFormat", newJString(textFormat))
  add(query_579234, "fields", newJString(fields))
  add(query_579234, "parentId", newJString(parentId))
  add(query_579234, "maxResults", newJInt(maxResults))
  result = call_579233.call(nil, query_579234, nil, nil, nil)

var youtubeCommentsList* = Call_YoutubeCommentsList_579216(
    name: "youtubeCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsList_579217, base: "/youtube/v3",
    url: url_YoutubeCommentsList_579218, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsDelete_579267 = ref object of OpenApiRestCall_578364
proc url_YoutubeCommentsDelete_579269(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsDelete_579268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a comment.
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
  ##   id: JString (required)
  ##     : The id parameter specifies the comment ID for the resource that is being deleted.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579270 = query.getOrDefault("key")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "key", valid_579270
  var valid_579271 = query.getOrDefault("prettyPrint")
  valid_579271 = validateParameter(valid_579271, JBool, required = false,
                                 default = newJBool(true))
  if valid_579271 != nil:
    section.add "prettyPrint", valid_579271
  var valid_579272 = query.getOrDefault("oauth_token")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "oauth_token", valid_579272
  var valid_579273 = query.getOrDefault("alt")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = newJString("json"))
  if valid_579273 != nil:
    section.add "alt", valid_579273
  var valid_579274 = query.getOrDefault("userIp")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "userIp", valid_579274
  var valid_579275 = query.getOrDefault("quotaUser")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "quotaUser", valid_579275
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579276 = query.getOrDefault("id")
  valid_579276 = validateParameter(valid_579276, JString, required = true,
                                 default = nil)
  if valid_579276 != nil:
    section.add "id", valid_579276
  var valid_579277 = query.getOrDefault("fields")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "fields", valid_579277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579278: Call_YoutubeCommentsDelete_579267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_579278.validator(path, query, header, formData, body)
  let scheme = call_579278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579278.url(scheme.get, call_579278.host, call_579278.base,
                         call_579278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579278, url, valid)

proc call*(call_579279: Call_YoutubeCommentsDelete_579267; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## youtubeCommentsDelete
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
  ##   id: string (required)
  ##     : The id parameter specifies the comment ID for the resource that is being deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579280 = newJObject()
  add(query_579280, "key", newJString(key))
  add(query_579280, "prettyPrint", newJBool(prettyPrint))
  add(query_579280, "oauth_token", newJString(oauthToken))
  add(query_579280, "alt", newJString(alt))
  add(query_579280, "userIp", newJString(userIp))
  add(query_579280, "quotaUser", newJString(quotaUser))
  add(query_579280, "id", newJString(id))
  add(query_579280, "fields", newJString(fields))
  result = call_579279.call(nil, query_579280, nil, nil, nil)

var youtubeCommentsDelete* = Call_YoutubeCommentsDelete_579267(
    name: "youtubeCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsDelete_579268, base: "/youtube/v3",
    url: url_YoutubeCommentsDelete_579269, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsMarkAsSpam_579281 = ref object of OpenApiRestCall_578364
proc url_YoutubeCommentsMarkAsSpam_579283(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsMarkAsSpam_579282(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
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
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of IDs of comments that the caller believes should be classified as spam.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579284 = query.getOrDefault("key")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "key", valid_579284
  var valid_579285 = query.getOrDefault("prettyPrint")
  valid_579285 = validateParameter(valid_579285, JBool, required = false,
                                 default = newJBool(true))
  if valid_579285 != nil:
    section.add "prettyPrint", valid_579285
  var valid_579286 = query.getOrDefault("oauth_token")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "oauth_token", valid_579286
  var valid_579287 = query.getOrDefault("alt")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = newJString("json"))
  if valid_579287 != nil:
    section.add "alt", valid_579287
  var valid_579288 = query.getOrDefault("userIp")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "userIp", valid_579288
  var valid_579289 = query.getOrDefault("quotaUser")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "quotaUser", valid_579289
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579290 = query.getOrDefault("id")
  valid_579290 = validateParameter(valid_579290, JString, required = true,
                                 default = nil)
  if valid_579290 != nil:
    section.add "id", valid_579290
  var valid_579291 = query.getOrDefault("fields")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "fields", valid_579291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579292: Call_YoutubeCommentsMarkAsSpam_579281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
  ## 
  let valid = call_579292.validator(path, query, header, formData, body)
  let scheme = call_579292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579292.url(scheme.get, call_579292.host, call_579292.base,
                         call_579292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579292, url, valid)

proc call*(call_579293: Call_YoutubeCommentsMarkAsSpam_579281; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## youtubeCommentsMarkAsSpam
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
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
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of IDs of comments that the caller believes should be classified as spam.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579294 = newJObject()
  add(query_579294, "key", newJString(key))
  add(query_579294, "prettyPrint", newJBool(prettyPrint))
  add(query_579294, "oauth_token", newJString(oauthToken))
  add(query_579294, "alt", newJString(alt))
  add(query_579294, "userIp", newJString(userIp))
  add(query_579294, "quotaUser", newJString(quotaUser))
  add(query_579294, "id", newJString(id))
  add(query_579294, "fields", newJString(fields))
  result = call_579293.call(nil, query_579294, nil, nil, nil)

var youtubeCommentsMarkAsSpam* = Call_YoutubeCommentsMarkAsSpam_579281(
    name: "youtubeCommentsMarkAsSpam", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments/markAsSpam",
    validator: validate_YoutubeCommentsMarkAsSpam_579282, base: "/youtube/v3",
    url: url_YoutubeCommentsMarkAsSpam_579283, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsSetModerationStatus_579295 = ref object of OpenApiRestCall_578364
proc url_YoutubeCommentsSetModerationStatus_579297(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsSetModerationStatus_579296(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
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
  ##   moderationStatus: JString (required)
  ##                   : Identifies the new moderation status of the specified comments.
  ##   banAuthor: JBool
  ##            : The banAuthor parameter lets you indicate that you want to automatically reject any additional comments written by the comment's author. Set the parameter value to true to ban the author.
  ## 
  ## Note: This parameter is only valid if the moderationStatus parameter is also set to rejected.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of IDs that identify the comments for which you are updating the moderation status.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579298 = query.getOrDefault("key")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "key", valid_579298
  var valid_579299 = query.getOrDefault("prettyPrint")
  valid_579299 = validateParameter(valid_579299, JBool, required = false,
                                 default = newJBool(true))
  if valid_579299 != nil:
    section.add "prettyPrint", valid_579299
  var valid_579300 = query.getOrDefault("oauth_token")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "oauth_token", valid_579300
  assert query != nil,
        "query argument is necessary due to required `moderationStatus` field"
  var valid_579301 = query.getOrDefault("moderationStatus")
  valid_579301 = validateParameter(valid_579301, JString, required = true,
                                 default = newJString("heldForReview"))
  if valid_579301 != nil:
    section.add "moderationStatus", valid_579301
  var valid_579302 = query.getOrDefault("banAuthor")
  valid_579302 = validateParameter(valid_579302, JBool, required = false,
                                 default = newJBool(false))
  if valid_579302 != nil:
    section.add "banAuthor", valid_579302
  var valid_579303 = query.getOrDefault("alt")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = newJString("json"))
  if valid_579303 != nil:
    section.add "alt", valid_579303
  var valid_579304 = query.getOrDefault("userIp")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "userIp", valid_579304
  var valid_579305 = query.getOrDefault("quotaUser")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "quotaUser", valid_579305
  var valid_579306 = query.getOrDefault("id")
  valid_579306 = validateParameter(valid_579306, JString, required = true,
                                 default = nil)
  if valid_579306 != nil:
    section.add "id", valid_579306
  var valid_579307 = query.getOrDefault("fields")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "fields", valid_579307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579308: Call_YoutubeCommentsSetModerationStatus_579295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
  ## 
  let valid = call_579308.validator(path, query, header, formData, body)
  let scheme = call_579308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579308.url(scheme.get, call_579308.host, call_579308.base,
                         call_579308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579308, url, valid)

proc call*(call_579309: Call_YoutubeCommentsSetModerationStatus_579295; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          moderationStatus: string = "heldForReview"; banAuthor: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## youtubeCommentsSetModerationStatus
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   moderationStatus: string (required)
  ##                   : Identifies the new moderation status of the specified comments.
  ##   banAuthor: bool
  ##            : The banAuthor parameter lets you indicate that you want to automatically reject any additional comments written by the comment's author. Set the parameter value to true to ban the author.
  ## 
  ## Note: This parameter is only valid if the moderationStatus parameter is also set to rejected.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of IDs that identify the comments for which you are updating the moderation status.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579310 = newJObject()
  add(query_579310, "key", newJString(key))
  add(query_579310, "prettyPrint", newJBool(prettyPrint))
  add(query_579310, "oauth_token", newJString(oauthToken))
  add(query_579310, "moderationStatus", newJString(moderationStatus))
  add(query_579310, "banAuthor", newJBool(banAuthor))
  add(query_579310, "alt", newJString(alt))
  add(query_579310, "userIp", newJString(userIp))
  add(query_579310, "quotaUser", newJString(quotaUser))
  add(query_579310, "id", newJString(id))
  add(query_579310, "fields", newJString(fields))
  result = call_579309.call(nil, query_579310, nil, nil, nil)

var youtubeCommentsSetModerationStatus* = Call_YoutubeCommentsSetModerationStatus_579295(
    name: "youtubeCommentsSetModerationStatus", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments/setModerationStatus",
    validator: validate_YoutubeCommentsSetModerationStatus_579296,
    base: "/youtube/v3", url: url_YoutubeCommentsSetModerationStatus_579297,
    schemes: {Scheme.Https})
type
  Call_YoutubeGuideCategoriesList_579311 = ref object of OpenApiRestCall_578364
proc url_YoutubeGuideCategoriesList_579313(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeGuideCategoriesList_579312(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of categories that can be associated with YouTube channels.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the guideCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channel category ID(s) for the resource(s) that are being retrieved. In a guideCategory resource, the id property specifies the YouTube channel category ID.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return the list of guide categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   hl: JString
  ##     : The hl parameter specifies the language that will be used for text values in the API response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579314 = query.getOrDefault("key")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "key", valid_579314
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
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579317 = query.getOrDefault("part")
  valid_579317 = validateParameter(valid_579317, JString, required = true,
                                 default = nil)
  if valid_579317 != nil:
    section.add "part", valid_579317
  var valid_579318 = query.getOrDefault("alt")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = newJString("json"))
  if valid_579318 != nil:
    section.add "alt", valid_579318
  var valid_579319 = query.getOrDefault("userIp")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "userIp", valid_579319
  var valid_579320 = query.getOrDefault("quotaUser")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "quotaUser", valid_579320
  var valid_579321 = query.getOrDefault("id")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "id", valid_579321
  var valid_579322 = query.getOrDefault("regionCode")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "regionCode", valid_579322
  var valid_579323 = query.getOrDefault("hl")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = newJString("en-US"))
  if valid_579323 != nil:
    section.add "hl", valid_579323
  var valid_579324 = query.getOrDefault("fields")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "fields", valid_579324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579325: Call_YoutubeGuideCategoriesList_579311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of categories that can be associated with YouTube channels.
  ## 
  let valid = call_579325.validator(path, query, header, formData, body)
  let scheme = call_579325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579325.url(scheme.get, call_579325.host, call_579325.base,
                         call_579325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579325, url, valid)

proc call*(call_579326: Call_YoutubeGuideCategoriesList_579311; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          id: string = ""; regionCode: string = ""; hl: string = "en-US";
          fields: string = ""): Recallable =
  ## youtubeGuideCategoriesList
  ## Returns a list of categories that can be associated with YouTube channels.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the guideCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channel category ID(s) for the resource(s) that are being retrieved. In a guideCategory resource, the id property specifies the YouTube channel category ID.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return the list of guide categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   hl: string
  ##     : The hl parameter specifies the language that will be used for text values in the API response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579327 = newJObject()
  add(query_579327, "key", newJString(key))
  add(query_579327, "prettyPrint", newJBool(prettyPrint))
  add(query_579327, "oauth_token", newJString(oauthToken))
  add(query_579327, "part", newJString(part))
  add(query_579327, "alt", newJString(alt))
  add(query_579327, "userIp", newJString(userIp))
  add(query_579327, "quotaUser", newJString(quotaUser))
  add(query_579327, "id", newJString(id))
  add(query_579327, "regionCode", newJString(regionCode))
  add(query_579327, "hl", newJString(hl))
  add(query_579327, "fields", newJString(fields))
  result = call_579326.call(nil, query_579327, nil, nil, nil)

var youtubeGuideCategoriesList* = Call_YoutubeGuideCategoriesList_579311(
    name: "youtubeGuideCategoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/guideCategories",
    validator: validate_YoutubeGuideCategoriesList_579312, base: "/youtube/v3",
    url: url_YoutubeGuideCategoriesList_579313, schemes: {Scheme.Https})
type
  Call_YoutubeI18nLanguagesList_579328 = ref object of OpenApiRestCall_578364
proc url_YoutubeI18nLanguagesList_579330(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeI18nLanguagesList_579329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of application languages that the YouTube website supports.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the i18nLanguage resource properties that the API response will include. Set the parameter value to snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579331 = query.getOrDefault("key")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "key", valid_579331
  var valid_579332 = query.getOrDefault("prettyPrint")
  valid_579332 = validateParameter(valid_579332, JBool, required = false,
                                 default = newJBool(true))
  if valid_579332 != nil:
    section.add "prettyPrint", valid_579332
  var valid_579333 = query.getOrDefault("oauth_token")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "oauth_token", valid_579333
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579334 = query.getOrDefault("part")
  valid_579334 = validateParameter(valid_579334, JString, required = true,
                                 default = nil)
  if valid_579334 != nil:
    section.add "part", valid_579334
  var valid_579335 = query.getOrDefault("alt")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = newJString("json"))
  if valid_579335 != nil:
    section.add "alt", valid_579335
  var valid_579336 = query.getOrDefault("userIp")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "userIp", valid_579336
  var valid_579337 = query.getOrDefault("quotaUser")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "quotaUser", valid_579337
  var valid_579338 = query.getOrDefault("hl")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = newJString("en_US"))
  if valid_579338 != nil:
    section.add "hl", valid_579338
  var valid_579339 = query.getOrDefault("fields")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "fields", valid_579339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579340: Call_YoutubeI18nLanguagesList_579328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of application languages that the YouTube website supports.
  ## 
  let valid = call_579340.validator(path, query, header, formData, body)
  let scheme = call_579340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579340.url(scheme.get, call_579340.host, call_579340.base,
                         call_579340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579340, url, valid)

proc call*(call_579341: Call_YoutubeI18nLanguagesList_579328; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          hl: string = "en_US"; fields: string = ""): Recallable =
  ## youtubeI18nLanguagesList
  ## Returns a list of application languages that the YouTube website supports.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the i18nLanguage resource properties that the API response will include. Set the parameter value to snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579342 = newJObject()
  add(query_579342, "key", newJString(key))
  add(query_579342, "prettyPrint", newJBool(prettyPrint))
  add(query_579342, "oauth_token", newJString(oauthToken))
  add(query_579342, "part", newJString(part))
  add(query_579342, "alt", newJString(alt))
  add(query_579342, "userIp", newJString(userIp))
  add(query_579342, "quotaUser", newJString(quotaUser))
  add(query_579342, "hl", newJString(hl))
  add(query_579342, "fields", newJString(fields))
  result = call_579341.call(nil, query_579342, nil, nil, nil)

var youtubeI18nLanguagesList* = Call_YoutubeI18nLanguagesList_579328(
    name: "youtubeI18nLanguagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/i18nLanguages",
    validator: validate_YoutubeI18nLanguagesList_579329, base: "/youtube/v3",
    url: url_YoutubeI18nLanguagesList_579330, schemes: {Scheme.Https})
type
  Call_YoutubeI18nRegionsList_579343 = ref object of OpenApiRestCall_578364
proc url_YoutubeI18nRegionsList_579345(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeI18nRegionsList_579344(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of content regions that the YouTube website supports.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the i18nRegion resource properties that the API response will include. Set the parameter value to snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579346 = query.getOrDefault("key")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "key", valid_579346
  var valid_579347 = query.getOrDefault("prettyPrint")
  valid_579347 = validateParameter(valid_579347, JBool, required = false,
                                 default = newJBool(true))
  if valid_579347 != nil:
    section.add "prettyPrint", valid_579347
  var valid_579348 = query.getOrDefault("oauth_token")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "oauth_token", valid_579348
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579349 = query.getOrDefault("part")
  valid_579349 = validateParameter(valid_579349, JString, required = true,
                                 default = nil)
  if valid_579349 != nil:
    section.add "part", valid_579349
  var valid_579350 = query.getOrDefault("alt")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = newJString("json"))
  if valid_579350 != nil:
    section.add "alt", valid_579350
  var valid_579351 = query.getOrDefault("userIp")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "userIp", valid_579351
  var valid_579352 = query.getOrDefault("quotaUser")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "quotaUser", valid_579352
  var valid_579353 = query.getOrDefault("hl")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = newJString("en_US"))
  if valid_579353 != nil:
    section.add "hl", valid_579353
  var valid_579354 = query.getOrDefault("fields")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "fields", valid_579354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579355: Call_YoutubeI18nRegionsList_579343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of content regions that the YouTube website supports.
  ## 
  let valid = call_579355.validator(path, query, header, formData, body)
  let scheme = call_579355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579355.url(scheme.get, call_579355.host, call_579355.base,
                         call_579355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579355, url, valid)

proc call*(call_579356: Call_YoutubeI18nRegionsList_579343; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          hl: string = "en_US"; fields: string = ""): Recallable =
  ## youtubeI18nRegionsList
  ## Returns a list of content regions that the YouTube website supports.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the i18nRegion resource properties that the API response will include. Set the parameter value to snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579357 = newJObject()
  add(query_579357, "key", newJString(key))
  add(query_579357, "prettyPrint", newJBool(prettyPrint))
  add(query_579357, "oauth_token", newJString(oauthToken))
  add(query_579357, "part", newJString(part))
  add(query_579357, "alt", newJString(alt))
  add(query_579357, "userIp", newJString(userIp))
  add(query_579357, "quotaUser", newJString(quotaUser))
  add(query_579357, "hl", newJString(hl))
  add(query_579357, "fields", newJString(fields))
  result = call_579356.call(nil, query_579357, nil, nil, nil)

var youtubeI18nRegionsList* = Call_YoutubeI18nRegionsList_579343(
    name: "youtubeI18nRegionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/i18nRegions",
    validator: validate_YoutubeI18nRegionsList_579344, base: "/youtube/v3",
    url: url_YoutubeI18nRegionsList_579345, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsUpdate_579380 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveBroadcastsUpdate_579382(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsUpdate_579381(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a broadcast's privacy status is defined in the status part. As such, if your request is updating a private or unlisted broadcast, and the request's part parameter value includes the status part, the broadcast's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the broadcast will revert to the default privacy setting.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579383 = query.getOrDefault("key")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "key", valid_579383
  var valid_579384 = query.getOrDefault("prettyPrint")
  valid_579384 = validateParameter(valid_579384, JBool, required = false,
                                 default = newJBool(true))
  if valid_579384 != nil:
    section.add "prettyPrint", valid_579384
  var valid_579385 = query.getOrDefault("oauth_token")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "oauth_token", valid_579385
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579386 = query.getOrDefault("part")
  valid_579386 = validateParameter(valid_579386, JString, required = true,
                                 default = nil)
  if valid_579386 != nil:
    section.add "part", valid_579386
  var valid_579387 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "onBehalfOfContentOwner", valid_579387
  var valid_579388 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579388
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579394: Call_YoutubeLiveBroadcastsUpdate_579380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
  ## 
  let valid = call_579394.validator(path, query, header, formData, body)
  let scheme = call_579394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579394.url(scheme.get, call_579394.host, call_579394.base,
                         call_579394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579394, url, valid)

proc call*(call_579395: Call_YoutubeLiveBroadcastsUpdate_579380; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubeLiveBroadcastsUpdate
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a broadcast's privacy status is defined in the status part. As such, if your request is updating a private or unlisted broadcast, and the request's part parameter value includes the status part, the broadcast's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the broadcast will revert to the default privacy setting.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579396 = newJObject()
  var body_579397 = newJObject()
  add(query_579396, "key", newJString(key))
  add(query_579396, "prettyPrint", newJBool(prettyPrint))
  add(query_579396, "oauth_token", newJString(oauthToken))
  add(query_579396, "part", newJString(part))
  add(query_579396, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579396, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579396, "alt", newJString(alt))
  add(query_579396, "userIp", newJString(userIp))
  add(query_579396, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579397 = body
  add(query_579396, "fields", newJString(fields))
  result = call_579395.call(nil, query_579396, nil, nil, body_579397)

var youtubeLiveBroadcastsUpdate* = Call_YoutubeLiveBroadcastsUpdate_579380(
    name: "youtubeLiveBroadcastsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsUpdate_579381, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsUpdate_579382, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsInsert_579398 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveBroadcastsInsert_579400(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsInsert_579399(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a broadcast.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579401 = query.getOrDefault("key")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "key", valid_579401
  var valid_579402 = query.getOrDefault("prettyPrint")
  valid_579402 = validateParameter(valid_579402, JBool, required = false,
                                 default = newJBool(true))
  if valid_579402 != nil:
    section.add "prettyPrint", valid_579402
  var valid_579403 = query.getOrDefault("oauth_token")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "oauth_token", valid_579403
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579404 = query.getOrDefault("part")
  valid_579404 = validateParameter(valid_579404, JString, required = true,
                                 default = nil)
  if valid_579404 != nil:
    section.add "part", valid_579404
  var valid_579405 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "onBehalfOfContentOwner", valid_579405
  var valid_579406 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579406
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579412: Call_YoutubeLiveBroadcastsInsert_579398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a broadcast.
  ## 
  let valid = call_579412.validator(path, query, header, formData, body)
  let scheme = call_579412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579412.url(scheme.get, call_579412.host, call_579412.base,
                         call_579412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579412, url, valid)

proc call*(call_579413: Call_YoutubeLiveBroadcastsInsert_579398; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubeLiveBroadcastsInsert
  ## Creates a broadcast.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579414 = newJObject()
  var body_579415 = newJObject()
  add(query_579414, "key", newJString(key))
  add(query_579414, "prettyPrint", newJBool(prettyPrint))
  add(query_579414, "oauth_token", newJString(oauthToken))
  add(query_579414, "part", newJString(part))
  add(query_579414, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579414, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579414, "alt", newJString(alt))
  add(query_579414, "userIp", newJString(userIp))
  add(query_579414, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579415 = body
  add(query_579414, "fields", newJString(fields))
  result = call_579413.call(nil, query_579414, nil, nil, body_579415)

var youtubeLiveBroadcastsInsert* = Call_YoutubeLiveBroadcastsInsert_579398(
    name: "youtubeLiveBroadcastsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsInsert_579399, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsInsert_579400, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsList_579358 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveBroadcastsList_579360(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsList_579359(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of YouTube broadcasts that match the API request parameters.
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
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   broadcastType: JString
  ##                : The broadcastType parameter filters the API response to only include broadcasts with the specified type. This is only compatible with the mine filter for now.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   broadcastStatus: JString
  ##                  : The broadcastStatus parameter filters the API response to only include broadcasts with the specified status.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of YouTube broadcast IDs that identify the broadcasts being retrieved. In a liveBroadcast resource, the id property specifies the broadcast's ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: JBool
  ##       : The mine parameter can be used to instruct the API to only return broadcasts owned by the authenticated user. Set the parameter value to true to only retrieve your own broadcasts.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
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
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579364 = query.getOrDefault("part")
  valid_579364 = validateParameter(valid_579364, JString, required = true,
                                 default = nil)
  if valid_579364 != nil:
    section.add "part", valid_579364
  var valid_579365 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "onBehalfOfContentOwner", valid_579365
  var valid_579366 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579366
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
  var valid_579369 = query.getOrDefault("broadcastType")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = newJString("event"))
  if valid_579369 != nil:
    section.add "broadcastType", valid_579369
  var valid_579370 = query.getOrDefault("quotaUser")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "quotaUser", valid_579370
  var valid_579371 = query.getOrDefault("pageToken")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "pageToken", valid_579371
  var valid_579372 = query.getOrDefault("broadcastStatus")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = newJString("active"))
  if valid_579372 != nil:
    section.add "broadcastStatus", valid_579372
  var valid_579373 = query.getOrDefault("id")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "id", valid_579373
  var valid_579374 = query.getOrDefault("fields")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "fields", valid_579374
  var valid_579375 = query.getOrDefault("mine")
  valid_579375 = validateParameter(valid_579375, JBool, required = false, default = nil)
  if valid_579375 != nil:
    section.add "mine", valid_579375
  var valid_579376 = query.getOrDefault("maxResults")
  valid_579376 = validateParameter(valid_579376, JInt, required = false,
                                 default = newJInt(5))
  if valid_579376 != nil:
    section.add "maxResults", valid_579376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579377: Call_YoutubeLiveBroadcastsList_579358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of YouTube broadcasts that match the API request parameters.
  ## 
  let valid = call_579377.validator(path, query, header, formData, body)
  let scheme = call_579377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579377.url(scheme.get, call_579377.host, call_579377.base,
                         call_579377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579377, url, valid)

proc call*(call_579378: Call_YoutubeLiveBroadcastsList_579358; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; broadcastType: string = "event"; quotaUser: string = "";
          pageToken: string = ""; broadcastStatus: string = "active"; id: string = "";
          fields: string = ""; mine: bool = false; maxResults: int = 5): Recallable =
  ## youtubeLiveBroadcastsList
  ## Returns a list of YouTube broadcasts that match the API request parameters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   broadcastType: string
  ##                : The broadcastType parameter filters the API response to only include broadcasts with the specified type. This is only compatible with the mine filter for now.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   broadcastStatus: string
  ##                  : The broadcastStatus parameter filters the API response to only include broadcasts with the specified status.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of YouTube broadcast IDs that identify the broadcasts being retrieved. In a liveBroadcast resource, the id property specifies the broadcast's ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: bool
  ##       : The mine parameter can be used to instruct the API to only return broadcasts owned by the authenticated user. Set the parameter value to true to only retrieve your own broadcasts.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_579379 = newJObject()
  add(query_579379, "key", newJString(key))
  add(query_579379, "prettyPrint", newJBool(prettyPrint))
  add(query_579379, "oauth_token", newJString(oauthToken))
  add(query_579379, "part", newJString(part))
  add(query_579379, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579379, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579379, "alt", newJString(alt))
  add(query_579379, "userIp", newJString(userIp))
  add(query_579379, "broadcastType", newJString(broadcastType))
  add(query_579379, "quotaUser", newJString(quotaUser))
  add(query_579379, "pageToken", newJString(pageToken))
  add(query_579379, "broadcastStatus", newJString(broadcastStatus))
  add(query_579379, "id", newJString(id))
  add(query_579379, "fields", newJString(fields))
  add(query_579379, "mine", newJBool(mine))
  add(query_579379, "maxResults", newJInt(maxResults))
  result = call_579378.call(nil, query_579379, nil, nil, nil)

var youtubeLiveBroadcastsList* = Call_YoutubeLiveBroadcastsList_579358(
    name: "youtubeLiveBroadcastsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsList_579359, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsList_579360, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsDelete_579416 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveBroadcastsDelete_579418(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsDelete_579417(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a broadcast.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live broadcast ID for the resource that is being deleted.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579419 = query.getOrDefault("key")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "key", valid_579419
  var valid_579420 = query.getOrDefault("prettyPrint")
  valid_579420 = validateParameter(valid_579420, JBool, required = false,
                                 default = newJBool(true))
  if valid_579420 != nil:
    section.add "prettyPrint", valid_579420
  var valid_579421 = query.getOrDefault("oauth_token")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "oauth_token", valid_579421
  var valid_579422 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "onBehalfOfContentOwner", valid_579422
  var valid_579423 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579423
  var valid_579424 = query.getOrDefault("alt")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = newJString("json"))
  if valid_579424 != nil:
    section.add "alt", valid_579424
  var valid_579425 = query.getOrDefault("userIp")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "userIp", valid_579425
  var valid_579426 = query.getOrDefault("quotaUser")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "quotaUser", valid_579426
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579427 = query.getOrDefault("id")
  valid_579427 = validateParameter(valid_579427, JString, required = true,
                                 default = nil)
  if valid_579427 != nil:
    section.add "id", valid_579427
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

proc call*(call_579429: Call_YoutubeLiveBroadcastsDelete_579416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a broadcast.
  ## 
  let valid = call_579429.validator(path, query, header, formData, body)
  let scheme = call_579429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579429.url(scheme.get, call_579429.host, call_579429.base,
                         call_579429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579429, url, valid)

proc call*(call_579430: Call_YoutubeLiveBroadcastsDelete_579416; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## youtubeLiveBroadcastsDelete
  ## Deletes a broadcast.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live broadcast ID for the resource that is being deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579431 = newJObject()
  add(query_579431, "key", newJString(key))
  add(query_579431, "prettyPrint", newJBool(prettyPrint))
  add(query_579431, "oauth_token", newJString(oauthToken))
  add(query_579431, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579431, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579431, "alt", newJString(alt))
  add(query_579431, "userIp", newJString(userIp))
  add(query_579431, "quotaUser", newJString(quotaUser))
  add(query_579431, "id", newJString(id))
  add(query_579431, "fields", newJString(fields))
  result = call_579430.call(nil, query_579431, nil, nil, nil)

var youtubeLiveBroadcastsDelete* = Call_YoutubeLiveBroadcastsDelete_579416(
    name: "youtubeLiveBroadcastsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsDelete_579417, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsDelete_579418, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsBind_579432 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveBroadcastsBind_579434(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsBind_579433(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
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
  ##   streamId: JString
  ##           : The streamId parameter specifies the unique ID of the video stream that is being bound to a broadcast. If this parameter is omitted, the API will remove any existing binding between the broadcast and a video stream.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is being bound to a video stream.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579435 = query.getOrDefault("key")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "key", valid_579435
  var valid_579436 = query.getOrDefault("prettyPrint")
  valid_579436 = validateParameter(valid_579436, JBool, required = false,
                                 default = newJBool(true))
  if valid_579436 != nil:
    section.add "prettyPrint", valid_579436
  var valid_579437 = query.getOrDefault("oauth_token")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "oauth_token", valid_579437
  var valid_579438 = query.getOrDefault("streamId")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "streamId", valid_579438
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579439 = query.getOrDefault("part")
  valid_579439 = validateParameter(valid_579439, JString, required = true,
                                 default = nil)
  if valid_579439 != nil:
    section.add "part", valid_579439
  var valid_579440 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "onBehalfOfContentOwner", valid_579440
  var valid_579441 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579441
  var valid_579442 = query.getOrDefault("alt")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = newJString("json"))
  if valid_579442 != nil:
    section.add "alt", valid_579442
  var valid_579443 = query.getOrDefault("userIp")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "userIp", valid_579443
  var valid_579444 = query.getOrDefault("quotaUser")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "quotaUser", valid_579444
  var valid_579445 = query.getOrDefault("id")
  valid_579445 = validateParameter(valid_579445, JString, required = true,
                                 default = nil)
  if valid_579445 != nil:
    section.add "id", valid_579445
  var valid_579446 = query.getOrDefault("fields")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "fields", valid_579446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579447: Call_YoutubeLiveBroadcastsBind_579432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
  ## 
  let valid = call_579447.validator(path, query, header, formData, body)
  let scheme = call_579447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579447.url(scheme.get, call_579447.host, call_579447.base,
                         call_579447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579447, url, valid)

proc call*(call_579448: Call_YoutubeLiveBroadcastsBind_579432; part: string;
          id: string; key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          streamId: string = ""; onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## youtubeLiveBroadcastsBind
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   streamId: string
  ##           : The streamId parameter specifies the unique ID of the video stream that is being bound to a broadcast. If this parameter is omitted, the API will remove any existing binding between the broadcast and a video stream.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is being bound to a video stream.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579449 = newJObject()
  add(query_579449, "key", newJString(key))
  add(query_579449, "prettyPrint", newJBool(prettyPrint))
  add(query_579449, "oauth_token", newJString(oauthToken))
  add(query_579449, "streamId", newJString(streamId))
  add(query_579449, "part", newJString(part))
  add(query_579449, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579449, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579449, "alt", newJString(alt))
  add(query_579449, "userIp", newJString(userIp))
  add(query_579449, "quotaUser", newJString(quotaUser))
  add(query_579449, "id", newJString(id))
  add(query_579449, "fields", newJString(fields))
  result = call_579448.call(nil, query_579449, nil, nil, nil)

var youtubeLiveBroadcastsBind* = Call_YoutubeLiveBroadcastsBind_579432(
    name: "youtubeLiveBroadcastsBind", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/bind",
    validator: validate_YoutubeLiveBroadcastsBind_579433, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsBind_579434, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsControl_579450 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveBroadcastsControl_579452(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsControl_579451(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
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
  ##   walltime: JString
  ##           : The walltime parameter specifies the wall clock time at which the specified slate change will occur. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sssZ) format.
  ##   offsetTimeMs: JString
  ##               : The offsetTimeMs parameter specifies a positive time offset when the specified slate change will occur. The value is measured in milliseconds from the beginning of the broadcast's monitor stream, which is the time that the testing phase for the broadcast began. Even though it is specified in milliseconds, the value is actually an approximation, and YouTube completes the requested action as closely as possible to that time.
  ## 
  ## If you do not specify a value for this parameter, then YouTube performs the action as soon as possible. See the Getting started guide for more details.
  ## 
  ## Important: You should only specify a value for this parameter if your broadcast stream is delayed.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   displaySlate: JBool
  ##               : The displaySlate parameter specifies whether the slate is being enabled or disabled.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live broadcast ID that uniquely identifies the broadcast in which the slate is being updated.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579453 = query.getOrDefault("key")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "key", valid_579453
  var valid_579454 = query.getOrDefault("prettyPrint")
  valid_579454 = validateParameter(valid_579454, JBool, required = false,
                                 default = newJBool(true))
  if valid_579454 != nil:
    section.add "prettyPrint", valid_579454
  var valid_579455 = query.getOrDefault("oauth_token")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = nil)
  if valid_579455 != nil:
    section.add "oauth_token", valid_579455
  var valid_579456 = query.getOrDefault("walltime")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = nil)
  if valid_579456 != nil:
    section.add "walltime", valid_579456
  var valid_579457 = query.getOrDefault("offsetTimeMs")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "offsetTimeMs", valid_579457
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579458 = query.getOrDefault("part")
  valid_579458 = validateParameter(valid_579458, JString, required = true,
                                 default = nil)
  if valid_579458 != nil:
    section.add "part", valid_579458
  var valid_579459 = query.getOrDefault("displaySlate")
  valid_579459 = validateParameter(valid_579459, JBool, required = false, default = nil)
  if valid_579459 != nil:
    section.add "displaySlate", valid_579459
  var valid_579460 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "onBehalfOfContentOwner", valid_579460
  var valid_579461 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579461
  var valid_579462 = query.getOrDefault("alt")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = newJString("json"))
  if valid_579462 != nil:
    section.add "alt", valid_579462
  var valid_579463 = query.getOrDefault("userIp")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "userIp", valid_579463
  var valid_579464 = query.getOrDefault("quotaUser")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "quotaUser", valid_579464
  var valid_579465 = query.getOrDefault("id")
  valid_579465 = validateParameter(valid_579465, JString, required = true,
                                 default = nil)
  if valid_579465 != nil:
    section.add "id", valid_579465
  var valid_579466 = query.getOrDefault("fields")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "fields", valid_579466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579467: Call_YoutubeLiveBroadcastsControl_579450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
  ## 
  let valid = call_579467.validator(path, query, header, formData, body)
  let scheme = call_579467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579467.url(scheme.get, call_579467.host, call_579467.base,
                         call_579467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579467, url, valid)

proc call*(call_579468: Call_YoutubeLiveBroadcastsControl_579450; part: string;
          id: string; key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          walltime: string = ""; offsetTimeMs: string = ""; displaySlate: bool = false;
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## youtubeLiveBroadcastsControl
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   walltime: string
  ##           : The walltime parameter specifies the wall clock time at which the specified slate change will occur. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sssZ) format.
  ##   offsetTimeMs: string
  ##               : The offsetTimeMs parameter specifies a positive time offset when the specified slate change will occur. The value is measured in milliseconds from the beginning of the broadcast's monitor stream, which is the time that the testing phase for the broadcast began. Even though it is specified in milliseconds, the value is actually an approximation, and YouTube completes the requested action as closely as possible to that time.
  ## 
  ## If you do not specify a value for this parameter, then YouTube performs the action as soon as possible. See the Getting started guide for more details.
  ## 
  ## Important: You should only specify a value for this parameter if your broadcast stream is delayed.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   displaySlate: bool
  ##               : The displaySlate parameter specifies whether the slate is being enabled or disabled.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live broadcast ID that uniquely identifies the broadcast in which the slate is being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579469 = newJObject()
  add(query_579469, "key", newJString(key))
  add(query_579469, "prettyPrint", newJBool(prettyPrint))
  add(query_579469, "oauth_token", newJString(oauthToken))
  add(query_579469, "walltime", newJString(walltime))
  add(query_579469, "offsetTimeMs", newJString(offsetTimeMs))
  add(query_579469, "part", newJString(part))
  add(query_579469, "displaySlate", newJBool(displaySlate))
  add(query_579469, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579469, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579469, "alt", newJString(alt))
  add(query_579469, "userIp", newJString(userIp))
  add(query_579469, "quotaUser", newJString(quotaUser))
  add(query_579469, "id", newJString(id))
  add(query_579469, "fields", newJString(fields))
  result = call_579468.call(nil, query_579469, nil, nil, nil)

var youtubeLiveBroadcastsControl* = Call_YoutubeLiveBroadcastsControl_579450(
    name: "youtubeLiveBroadcastsControl", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/control",
    validator: validate_YoutubeLiveBroadcastsControl_579451, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsControl_579452, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsTransition_579470 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveBroadcastsTransition_579472(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsTransition_579471(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
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
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   broadcastStatus: JString (required)
  ##                  : The broadcastStatus parameter identifies the state to which the broadcast is changing. Note that to transition a broadcast to either the testing or live state, the status.streamStatus must be active for the stream that the broadcast is bound to.
  ##   id: JString (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is transitioning to another status.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579473 = query.getOrDefault("key")
  valid_579473 = validateParameter(valid_579473, JString, required = false,
                                 default = nil)
  if valid_579473 != nil:
    section.add "key", valid_579473
  var valid_579474 = query.getOrDefault("prettyPrint")
  valid_579474 = validateParameter(valid_579474, JBool, required = false,
                                 default = newJBool(true))
  if valid_579474 != nil:
    section.add "prettyPrint", valid_579474
  var valid_579475 = query.getOrDefault("oauth_token")
  valid_579475 = validateParameter(valid_579475, JString, required = false,
                                 default = nil)
  if valid_579475 != nil:
    section.add "oauth_token", valid_579475
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579476 = query.getOrDefault("part")
  valid_579476 = validateParameter(valid_579476, JString, required = true,
                                 default = nil)
  if valid_579476 != nil:
    section.add "part", valid_579476
  var valid_579477 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "onBehalfOfContentOwner", valid_579477
  var valid_579478 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = nil)
  if valid_579478 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579478
  var valid_579479 = query.getOrDefault("alt")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = newJString("json"))
  if valid_579479 != nil:
    section.add "alt", valid_579479
  var valid_579480 = query.getOrDefault("userIp")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = nil)
  if valid_579480 != nil:
    section.add "userIp", valid_579480
  var valid_579481 = query.getOrDefault("quotaUser")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "quotaUser", valid_579481
  var valid_579482 = query.getOrDefault("broadcastStatus")
  valid_579482 = validateParameter(valid_579482, JString, required = true,
                                 default = newJString("complete"))
  if valid_579482 != nil:
    section.add "broadcastStatus", valid_579482
  var valid_579483 = query.getOrDefault("id")
  valid_579483 = validateParameter(valid_579483, JString, required = true,
                                 default = nil)
  if valid_579483 != nil:
    section.add "id", valid_579483
  var valid_579484 = query.getOrDefault("fields")
  valid_579484 = validateParameter(valid_579484, JString, required = false,
                                 default = nil)
  if valid_579484 != nil:
    section.add "fields", valid_579484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579485: Call_YoutubeLiveBroadcastsTransition_579470;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
  ## 
  let valid = call_579485.validator(path, query, header, formData, body)
  let scheme = call_579485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579485.url(scheme.get, call_579485.host, call_579485.base,
                         call_579485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579485, url, valid)

proc call*(call_579486: Call_YoutubeLiveBroadcastsTransition_579470; part: string;
          id: string; key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          broadcastStatus: string = "complete"; fields: string = ""): Recallable =
  ## youtubeLiveBroadcastsTransition
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   broadcastStatus: string (required)
  ##                  : The broadcastStatus parameter identifies the state to which the broadcast is changing. Note that to transition a broadcast to either the testing or live state, the status.streamStatus must be active for the stream that the broadcast is bound to.
  ##   id: string (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is transitioning to another status.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579487 = newJObject()
  add(query_579487, "key", newJString(key))
  add(query_579487, "prettyPrint", newJBool(prettyPrint))
  add(query_579487, "oauth_token", newJString(oauthToken))
  add(query_579487, "part", newJString(part))
  add(query_579487, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579487, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579487, "alt", newJString(alt))
  add(query_579487, "userIp", newJString(userIp))
  add(query_579487, "quotaUser", newJString(quotaUser))
  add(query_579487, "broadcastStatus", newJString(broadcastStatus))
  add(query_579487, "id", newJString(id))
  add(query_579487, "fields", newJString(fields))
  result = call_579486.call(nil, query_579487, nil, nil, nil)

var youtubeLiveBroadcastsTransition* = Call_YoutubeLiveBroadcastsTransition_579470(
    name: "youtubeLiveBroadcastsTransition", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/transition",
    validator: validate_YoutubeLiveBroadcastsTransition_579471,
    base: "/youtube/v3", url: url_YoutubeLiveBroadcastsTransition_579472,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatBansInsert_579488 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveChatBansInsert_579490(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatBansInsert_579489(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new ban to the chat.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579491 = query.getOrDefault("key")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = nil)
  if valid_579491 != nil:
    section.add "key", valid_579491
  var valid_579492 = query.getOrDefault("prettyPrint")
  valid_579492 = validateParameter(valid_579492, JBool, required = false,
                                 default = newJBool(true))
  if valid_579492 != nil:
    section.add "prettyPrint", valid_579492
  var valid_579493 = query.getOrDefault("oauth_token")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "oauth_token", valid_579493
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579494 = query.getOrDefault("part")
  valid_579494 = validateParameter(valid_579494, JString, required = true,
                                 default = nil)
  if valid_579494 != nil:
    section.add "part", valid_579494
  var valid_579495 = query.getOrDefault("alt")
  valid_579495 = validateParameter(valid_579495, JString, required = false,
                                 default = newJString("json"))
  if valid_579495 != nil:
    section.add "alt", valid_579495
  var valid_579496 = query.getOrDefault("userIp")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "userIp", valid_579496
  var valid_579497 = query.getOrDefault("quotaUser")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = nil)
  if valid_579497 != nil:
    section.add "quotaUser", valid_579497
  var valid_579498 = query.getOrDefault("fields")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = nil)
  if valid_579498 != nil:
    section.add "fields", valid_579498
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

proc call*(call_579500: Call_YoutubeLiveChatBansInsert_579488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new ban to the chat.
  ## 
  let valid = call_579500.validator(path, query, header, formData, body)
  let scheme = call_579500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579500.url(scheme.get, call_579500.host, call_579500.base,
                         call_579500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579500, url, valid)

proc call*(call_579501: Call_YoutubeLiveChatBansInsert_579488; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeLiveChatBansInsert
  ## Adds a new ban to the chat.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579502 = newJObject()
  var body_579503 = newJObject()
  add(query_579502, "key", newJString(key))
  add(query_579502, "prettyPrint", newJBool(prettyPrint))
  add(query_579502, "oauth_token", newJString(oauthToken))
  add(query_579502, "part", newJString(part))
  add(query_579502, "alt", newJString(alt))
  add(query_579502, "userIp", newJString(userIp))
  add(query_579502, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579503 = body
  add(query_579502, "fields", newJString(fields))
  result = call_579501.call(nil, query_579502, nil, nil, body_579503)

var youtubeLiveChatBansInsert* = Call_YoutubeLiveChatBansInsert_579488(
    name: "youtubeLiveChatBansInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/bans",
    validator: validate_YoutubeLiveChatBansInsert_579489, base: "/youtube/v3",
    url: url_YoutubeLiveChatBansInsert_579490, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatBansDelete_579504 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveChatBansDelete_579506(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatBansDelete_579505(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a chat ban.
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
  ##   id: JString (required)
  ##     : The id parameter identifies the chat ban to remove. The value uniquely identifies both the ban and the chat.
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
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579513 = query.getOrDefault("id")
  valid_579513 = validateParameter(valid_579513, JString, required = true,
                                 default = nil)
  if valid_579513 != nil:
    section.add "id", valid_579513
  var valid_579514 = query.getOrDefault("fields")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "fields", valid_579514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579515: Call_YoutubeLiveChatBansDelete_579504; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a chat ban.
  ## 
  let valid = call_579515.validator(path, query, header, formData, body)
  let scheme = call_579515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579515.url(scheme.get, call_579515.host, call_579515.base,
                         call_579515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579515, url, valid)

proc call*(call_579516: Call_YoutubeLiveChatBansDelete_579504; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## youtubeLiveChatBansDelete
  ## Removes a chat ban.
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
  ##   id: string (required)
  ##     : The id parameter identifies the chat ban to remove. The value uniquely identifies both the ban and the chat.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579517 = newJObject()
  add(query_579517, "key", newJString(key))
  add(query_579517, "prettyPrint", newJBool(prettyPrint))
  add(query_579517, "oauth_token", newJString(oauthToken))
  add(query_579517, "alt", newJString(alt))
  add(query_579517, "userIp", newJString(userIp))
  add(query_579517, "quotaUser", newJString(quotaUser))
  add(query_579517, "id", newJString(id))
  add(query_579517, "fields", newJString(fields))
  result = call_579516.call(nil, query_579517, nil, nil, nil)

var youtubeLiveChatBansDelete* = Call_YoutubeLiveChatBansDelete_579504(
    name: "youtubeLiveChatBansDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/bans",
    validator: validate_YoutubeLiveChatBansDelete_579505, base: "/youtube/v3",
    url: url_YoutubeLiveChatBansDelete_579506, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesInsert_579537 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveChatMessagesInsert_579539(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesInsert_579538(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a message to a live chat.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the parameter value to snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579540 = query.getOrDefault("key")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = nil)
  if valid_579540 != nil:
    section.add "key", valid_579540
  var valid_579541 = query.getOrDefault("prettyPrint")
  valid_579541 = validateParameter(valid_579541, JBool, required = false,
                                 default = newJBool(true))
  if valid_579541 != nil:
    section.add "prettyPrint", valid_579541
  var valid_579542 = query.getOrDefault("oauth_token")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = nil)
  if valid_579542 != nil:
    section.add "oauth_token", valid_579542
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579543 = query.getOrDefault("part")
  valid_579543 = validateParameter(valid_579543, JString, required = true,
                                 default = nil)
  if valid_579543 != nil:
    section.add "part", valid_579543
  var valid_579544 = query.getOrDefault("alt")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = newJString("json"))
  if valid_579544 != nil:
    section.add "alt", valid_579544
  var valid_579545 = query.getOrDefault("userIp")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "userIp", valid_579545
  var valid_579546 = query.getOrDefault("quotaUser")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "quotaUser", valid_579546
  var valid_579547 = query.getOrDefault("fields")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "fields", valid_579547
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

proc call*(call_579549: Call_YoutubeLiveChatMessagesInsert_579537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a message to a live chat.
  ## 
  let valid = call_579549.validator(path, query, header, formData, body)
  let scheme = call_579549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579549.url(scheme.get, call_579549.host, call_579549.base,
                         call_579549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579549, url, valid)

proc call*(call_579550: Call_YoutubeLiveChatMessagesInsert_579537; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeLiveChatMessagesInsert
  ## Adds a message to a live chat.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the parameter value to snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579551 = newJObject()
  var body_579552 = newJObject()
  add(query_579551, "key", newJString(key))
  add(query_579551, "prettyPrint", newJBool(prettyPrint))
  add(query_579551, "oauth_token", newJString(oauthToken))
  add(query_579551, "part", newJString(part))
  add(query_579551, "alt", newJString(alt))
  add(query_579551, "userIp", newJString(userIp))
  add(query_579551, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579552 = body
  add(query_579551, "fields", newJString(fields))
  result = call_579550.call(nil, query_579551, nil, nil, body_579552)

var youtubeLiveChatMessagesInsert* = Call_YoutubeLiveChatMessagesInsert_579537(
    name: "youtubeLiveChatMessagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesInsert_579538, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesInsert_579539, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesList_579518 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveChatMessagesList_579520(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesList_579519(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists live chat messages for a specific chat.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the liveChatComment resource parts that the API response will include. Supported values are id and snippet.
  ##   profileImageSize: JInt
  ##                   : The profileImageSize parameter specifies the size of the user profile pictures that should be returned in the result set. Default: 88.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   liveChatId: JString (required)
  ##             : The liveChatId parameter specifies the ID of the chat whose messages will be returned.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identify other pages that could be retrieved.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of messages that should be returned in the result set.
  section = newJObject()
  var valid_579521 = query.getOrDefault("key")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "key", valid_579521
  var valid_579522 = query.getOrDefault("prettyPrint")
  valid_579522 = validateParameter(valid_579522, JBool, required = false,
                                 default = newJBool(true))
  if valid_579522 != nil:
    section.add "prettyPrint", valid_579522
  var valid_579523 = query.getOrDefault("oauth_token")
  valid_579523 = validateParameter(valid_579523, JString, required = false,
                                 default = nil)
  if valid_579523 != nil:
    section.add "oauth_token", valid_579523
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579524 = query.getOrDefault("part")
  valid_579524 = validateParameter(valid_579524, JString, required = true,
                                 default = nil)
  if valid_579524 != nil:
    section.add "part", valid_579524
  var valid_579525 = query.getOrDefault("profileImageSize")
  valid_579525 = validateParameter(valid_579525, JInt, required = false, default = nil)
  if valid_579525 != nil:
    section.add "profileImageSize", valid_579525
  var valid_579526 = query.getOrDefault("alt")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = newJString("json"))
  if valid_579526 != nil:
    section.add "alt", valid_579526
  var valid_579527 = query.getOrDefault("userIp")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "userIp", valid_579527
  var valid_579528 = query.getOrDefault("liveChatId")
  valid_579528 = validateParameter(valid_579528, JString, required = true,
                                 default = nil)
  if valid_579528 != nil:
    section.add "liveChatId", valid_579528
  var valid_579529 = query.getOrDefault("quotaUser")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "quotaUser", valid_579529
  var valid_579530 = query.getOrDefault("pageToken")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "pageToken", valid_579530
  var valid_579531 = query.getOrDefault("hl")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "hl", valid_579531
  var valid_579532 = query.getOrDefault("fields")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "fields", valid_579532
  var valid_579533 = query.getOrDefault("maxResults")
  valid_579533 = validateParameter(valid_579533, JInt, required = false,
                                 default = newJInt(500))
  if valid_579533 != nil:
    section.add "maxResults", valid_579533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579534: Call_YoutubeLiveChatMessagesList_579518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists live chat messages for a specific chat.
  ## 
  let valid = call_579534.validator(path, query, header, formData, body)
  let scheme = call_579534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579534.url(scheme.get, call_579534.host, call_579534.base,
                         call_579534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579534, url, valid)

proc call*(call_579535: Call_YoutubeLiveChatMessagesList_579518; part: string;
          liveChatId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; profileImageSize: int = 0; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          hl: string = ""; fields: string = ""; maxResults: int = 500): Recallable =
  ## youtubeLiveChatMessagesList
  ## Lists live chat messages for a specific chat.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the liveChatComment resource parts that the API response will include. Supported values are id and snippet.
  ##   profileImageSize: int
  ##                   : The profileImageSize parameter specifies the size of the user profile pictures that should be returned in the result set. Default: 88.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   liveChatId: string (required)
  ##             : The liveChatId parameter specifies the ID of the chat whose messages will be returned.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identify other pages that could be retrieved.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of messages that should be returned in the result set.
  var query_579536 = newJObject()
  add(query_579536, "key", newJString(key))
  add(query_579536, "prettyPrint", newJBool(prettyPrint))
  add(query_579536, "oauth_token", newJString(oauthToken))
  add(query_579536, "part", newJString(part))
  add(query_579536, "profileImageSize", newJInt(profileImageSize))
  add(query_579536, "alt", newJString(alt))
  add(query_579536, "userIp", newJString(userIp))
  add(query_579536, "liveChatId", newJString(liveChatId))
  add(query_579536, "quotaUser", newJString(quotaUser))
  add(query_579536, "pageToken", newJString(pageToken))
  add(query_579536, "hl", newJString(hl))
  add(query_579536, "fields", newJString(fields))
  add(query_579536, "maxResults", newJInt(maxResults))
  result = call_579535.call(nil, query_579536, nil, nil, nil)

var youtubeLiveChatMessagesList* = Call_YoutubeLiveChatMessagesList_579518(
    name: "youtubeLiveChatMessagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesList_579519, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesList_579520, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesDelete_579553 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveChatMessagesDelete_579555(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesDelete_579554(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a chat message.
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
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube chat message ID of the resource that is being deleted.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579556 = query.getOrDefault("key")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = nil)
  if valid_579556 != nil:
    section.add "key", valid_579556
  var valid_579557 = query.getOrDefault("prettyPrint")
  valid_579557 = validateParameter(valid_579557, JBool, required = false,
                                 default = newJBool(true))
  if valid_579557 != nil:
    section.add "prettyPrint", valid_579557
  var valid_579558 = query.getOrDefault("oauth_token")
  valid_579558 = validateParameter(valid_579558, JString, required = false,
                                 default = nil)
  if valid_579558 != nil:
    section.add "oauth_token", valid_579558
  var valid_579559 = query.getOrDefault("alt")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = newJString("json"))
  if valid_579559 != nil:
    section.add "alt", valid_579559
  var valid_579560 = query.getOrDefault("userIp")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = nil)
  if valid_579560 != nil:
    section.add "userIp", valid_579560
  var valid_579561 = query.getOrDefault("quotaUser")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "quotaUser", valid_579561
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579562 = query.getOrDefault("id")
  valid_579562 = validateParameter(valid_579562, JString, required = true,
                                 default = nil)
  if valid_579562 != nil:
    section.add "id", valid_579562
  var valid_579563 = query.getOrDefault("fields")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "fields", valid_579563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579564: Call_YoutubeLiveChatMessagesDelete_579553; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a chat message.
  ## 
  let valid = call_579564.validator(path, query, header, formData, body)
  let scheme = call_579564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579564.url(scheme.get, call_579564.host, call_579564.base,
                         call_579564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579564, url, valid)

proc call*(call_579565: Call_YoutubeLiveChatMessagesDelete_579553; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## youtubeLiveChatMessagesDelete
  ## Deletes a chat message.
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
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube chat message ID of the resource that is being deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579566 = newJObject()
  add(query_579566, "key", newJString(key))
  add(query_579566, "prettyPrint", newJBool(prettyPrint))
  add(query_579566, "oauth_token", newJString(oauthToken))
  add(query_579566, "alt", newJString(alt))
  add(query_579566, "userIp", newJString(userIp))
  add(query_579566, "quotaUser", newJString(quotaUser))
  add(query_579566, "id", newJString(id))
  add(query_579566, "fields", newJString(fields))
  result = call_579565.call(nil, query_579566, nil, nil, nil)

var youtubeLiveChatMessagesDelete* = Call_YoutubeLiveChatMessagesDelete_579553(
    name: "youtubeLiveChatMessagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesDelete_579554, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesDelete_579555, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsInsert_579584 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveChatModeratorsInsert_579586(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsInsert_579585(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new moderator for the chat.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579590 = query.getOrDefault("part")
  valid_579590 = validateParameter(valid_579590, JString, required = true,
                                 default = nil)
  if valid_579590 != nil:
    section.add "part", valid_579590
  var valid_579591 = query.getOrDefault("alt")
  valid_579591 = validateParameter(valid_579591, JString, required = false,
                                 default = newJString("json"))
  if valid_579591 != nil:
    section.add "alt", valid_579591
  var valid_579592 = query.getOrDefault("userIp")
  valid_579592 = validateParameter(valid_579592, JString, required = false,
                                 default = nil)
  if valid_579592 != nil:
    section.add "userIp", valid_579592
  var valid_579593 = query.getOrDefault("quotaUser")
  valid_579593 = validateParameter(valid_579593, JString, required = false,
                                 default = nil)
  if valid_579593 != nil:
    section.add "quotaUser", valid_579593
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

proc call*(call_579596: Call_YoutubeLiveChatModeratorsInsert_579584;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new moderator for the chat.
  ## 
  let valid = call_579596.validator(path, query, header, formData, body)
  let scheme = call_579596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579596.url(scheme.get, call_579596.host, call_579596.base,
                         call_579596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579596, url, valid)

proc call*(call_579597: Call_YoutubeLiveChatModeratorsInsert_579584; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeLiveChatModeratorsInsert
  ## Adds a new moderator for the chat.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579598 = newJObject()
  var body_579599 = newJObject()
  add(query_579598, "key", newJString(key))
  add(query_579598, "prettyPrint", newJBool(prettyPrint))
  add(query_579598, "oauth_token", newJString(oauthToken))
  add(query_579598, "part", newJString(part))
  add(query_579598, "alt", newJString(alt))
  add(query_579598, "userIp", newJString(userIp))
  add(query_579598, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579599 = body
  add(query_579598, "fields", newJString(fields))
  result = call_579597.call(nil, query_579598, nil, nil, body_579599)

var youtubeLiveChatModeratorsInsert* = Call_YoutubeLiveChatModeratorsInsert_579584(
    name: "youtubeLiveChatModeratorsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsInsert_579585,
    base: "/youtube/v3", url: url_YoutubeLiveChatModeratorsInsert_579586,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsList_579567 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveChatModeratorsList_579569(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsList_579568(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists moderators for a live chat.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the liveChatModerator resource parts that the API response will include. Supported values are id and snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   liveChatId: JString (required)
  ##             : The liveChatId parameter specifies the YouTube live chat for which the API should return moderators.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  section = newJObject()
  var valid_579570 = query.getOrDefault("key")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "key", valid_579570
  var valid_579571 = query.getOrDefault("prettyPrint")
  valid_579571 = validateParameter(valid_579571, JBool, required = false,
                                 default = newJBool(true))
  if valid_579571 != nil:
    section.add "prettyPrint", valid_579571
  var valid_579572 = query.getOrDefault("oauth_token")
  valid_579572 = validateParameter(valid_579572, JString, required = false,
                                 default = nil)
  if valid_579572 != nil:
    section.add "oauth_token", valid_579572
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579573 = query.getOrDefault("part")
  valid_579573 = validateParameter(valid_579573, JString, required = true,
                                 default = nil)
  if valid_579573 != nil:
    section.add "part", valid_579573
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
  var valid_579576 = query.getOrDefault("liveChatId")
  valid_579576 = validateParameter(valid_579576, JString, required = true,
                                 default = nil)
  if valid_579576 != nil:
    section.add "liveChatId", valid_579576
  var valid_579577 = query.getOrDefault("quotaUser")
  valid_579577 = validateParameter(valid_579577, JString, required = false,
                                 default = nil)
  if valid_579577 != nil:
    section.add "quotaUser", valid_579577
  var valid_579578 = query.getOrDefault("pageToken")
  valid_579578 = validateParameter(valid_579578, JString, required = false,
                                 default = nil)
  if valid_579578 != nil:
    section.add "pageToken", valid_579578
  var valid_579579 = query.getOrDefault("fields")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = nil)
  if valid_579579 != nil:
    section.add "fields", valid_579579
  var valid_579580 = query.getOrDefault("maxResults")
  valid_579580 = validateParameter(valid_579580, JInt, required = false,
                                 default = newJInt(5))
  if valid_579580 != nil:
    section.add "maxResults", valid_579580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579581: Call_YoutubeLiveChatModeratorsList_579567; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists moderators for a live chat.
  ## 
  let valid = call_579581.validator(path, query, header, formData, body)
  let scheme = call_579581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579581.url(scheme.get, call_579581.host, call_579581.base,
                         call_579581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579581, url, valid)

proc call*(call_579582: Call_YoutubeLiveChatModeratorsList_579567; part: string;
          liveChatId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 5): Recallable =
  ## youtubeLiveChatModeratorsList
  ## Lists moderators for a live chat.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the liveChatModerator resource parts that the API response will include. Supported values are id and snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   liveChatId: string (required)
  ##             : The liveChatId parameter specifies the YouTube live chat for which the API should return moderators.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_579583 = newJObject()
  add(query_579583, "key", newJString(key))
  add(query_579583, "prettyPrint", newJBool(prettyPrint))
  add(query_579583, "oauth_token", newJString(oauthToken))
  add(query_579583, "part", newJString(part))
  add(query_579583, "alt", newJString(alt))
  add(query_579583, "userIp", newJString(userIp))
  add(query_579583, "liveChatId", newJString(liveChatId))
  add(query_579583, "quotaUser", newJString(quotaUser))
  add(query_579583, "pageToken", newJString(pageToken))
  add(query_579583, "fields", newJString(fields))
  add(query_579583, "maxResults", newJInt(maxResults))
  result = call_579582.call(nil, query_579583, nil, nil, nil)

var youtubeLiveChatModeratorsList* = Call_YoutubeLiveChatModeratorsList_579567(
    name: "youtubeLiveChatModeratorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsList_579568, base: "/youtube/v3",
    url: url_YoutubeLiveChatModeratorsList_579569, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsDelete_579600 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveChatModeratorsDelete_579602(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsDelete_579601(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a chat moderator.
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
  ##   id: JString (required)
  ##     : The id parameter identifies the chat moderator to remove. The value uniquely identifies both the moderator and the chat.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579603 = query.getOrDefault("key")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = nil)
  if valid_579603 != nil:
    section.add "key", valid_579603
  var valid_579604 = query.getOrDefault("prettyPrint")
  valid_579604 = validateParameter(valid_579604, JBool, required = false,
                                 default = newJBool(true))
  if valid_579604 != nil:
    section.add "prettyPrint", valid_579604
  var valid_579605 = query.getOrDefault("oauth_token")
  valid_579605 = validateParameter(valid_579605, JString, required = false,
                                 default = nil)
  if valid_579605 != nil:
    section.add "oauth_token", valid_579605
  var valid_579606 = query.getOrDefault("alt")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = newJString("json"))
  if valid_579606 != nil:
    section.add "alt", valid_579606
  var valid_579607 = query.getOrDefault("userIp")
  valid_579607 = validateParameter(valid_579607, JString, required = false,
                                 default = nil)
  if valid_579607 != nil:
    section.add "userIp", valid_579607
  var valid_579608 = query.getOrDefault("quotaUser")
  valid_579608 = validateParameter(valid_579608, JString, required = false,
                                 default = nil)
  if valid_579608 != nil:
    section.add "quotaUser", valid_579608
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579609 = query.getOrDefault("id")
  valid_579609 = validateParameter(valid_579609, JString, required = true,
                                 default = nil)
  if valid_579609 != nil:
    section.add "id", valid_579609
  var valid_579610 = query.getOrDefault("fields")
  valid_579610 = validateParameter(valid_579610, JString, required = false,
                                 default = nil)
  if valid_579610 != nil:
    section.add "fields", valid_579610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579611: Call_YoutubeLiveChatModeratorsDelete_579600;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a chat moderator.
  ## 
  let valid = call_579611.validator(path, query, header, formData, body)
  let scheme = call_579611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579611.url(scheme.get, call_579611.host, call_579611.base,
                         call_579611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579611, url, valid)

proc call*(call_579612: Call_YoutubeLiveChatModeratorsDelete_579600; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## youtubeLiveChatModeratorsDelete
  ## Removes a chat moderator.
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
  ##   id: string (required)
  ##     : The id parameter identifies the chat moderator to remove. The value uniquely identifies both the moderator and the chat.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579613 = newJObject()
  add(query_579613, "key", newJString(key))
  add(query_579613, "prettyPrint", newJBool(prettyPrint))
  add(query_579613, "oauth_token", newJString(oauthToken))
  add(query_579613, "alt", newJString(alt))
  add(query_579613, "userIp", newJString(userIp))
  add(query_579613, "quotaUser", newJString(quotaUser))
  add(query_579613, "id", newJString(id))
  add(query_579613, "fields", newJString(fields))
  result = call_579612.call(nil, query_579613, nil, nil, nil)

var youtubeLiveChatModeratorsDelete* = Call_YoutubeLiveChatModeratorsDelete_579600(
    name: "youtubeLiveChatModeratorsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsDelete_579601,
    base: "/youtube/v3", url: url_YoutubeLiveChatModeratorsDelete_579602,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsUpdate_579634 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveStreamsUpdate_579636(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsUpdate_579635(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. If the request body does not specify a value for a mutable property, the existing value for that property will be removed.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
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
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579640 = query.getOrDefault("part")
  valid_579640 = validateParameter(valid_579640, JString, required = true,
                                 default = nil)
  if valid_579640 != nil:
    section.add "part", valid_579640
  var valid_579641 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = nil)
  if valid_579641 != nil:
    section.add "onBehalfOfContentOwner", valid_579641
  var valid_579642 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579642
  var valid_579643 = query.getOrDefault("alt")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = newJString("json"))
  if valid_579643 != nil:
    section.add "alt", valid_579643
  var valid_579644 = query.getOrDefault("userIp")
  valid_579644 = validateParameter(valid_579644, JString, required = false,
                                 default = nil)
  if valid_579644 != nil:
    section.add "userIp", valid_579644
  var valid_579645 = query.getOrDefault("quotaUser")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = nil)
  if valid_579645 != nil:
    section.add "quotaUser", valid_579645
  var valid_579646 = query.getOrDefault("fields")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = nil)
  if valid_579646 != nil:
    section.add "fields", valid_579646
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

proc call*(call_579648: Call_YoutubeLiveStreamsUpdate_579634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
  ## 
  let valid = call_579648.validator(path, query, header, formData, body)
  let scheme = call_579648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579648.url(scheme.get, call_579648.host, call_579648.base,
                         call_579648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579648, url, valid)

proc call*(call_579649: Call_YoutubeLiveStreamsUpdate_579634; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubeLiveStreamsUpdate
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. If the request body does not specify a value for a mutable property, the existing value for that property will be removed.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579650 = newJObject()
  var body_579651 = newJObject()
  add(query_579650, "key", newJString(key))
  add(query_579650, "prettyPrint", newJBool(prettyPrint))
  add(query_579650, "oauth_token", newJString(oauthToken))
  add(query_579650, "part", newJString(part))
  add(query_579650, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579650, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579650, "alt", newJString(alt))
  add(query_579650, "userIp", newJString(userIp))
  add(query_579650, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579651 = body
  add(query_579650, "fields", newJString(fields))
  result = call_579649.call(nil, query_579650, nil, nil, body_579651)

var youtubeLiveStreamsUpdate* = Call_YoutubeLiveStreamsUpdate_579634(
    name: "youtubeLiveStreamsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsUpdate_579635, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsUpdate_579636, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsInsert_579652 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveStreamsInsert_579654(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsInsert_579653(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579655 = query.getOrDefault("key")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "key", valid_579655
  var valid_579656 = query.getOrDefault("prettyPrint")
  valid_579656 = validateParameter(valid_579656, JBool, required = false,
                                 default = newJBool(true))
  if valid_579656 != nil:
    section.add "prettyPrint", valid_579656
  var valid_579657 = query.getOrDefault("oauth_token")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "oauth_token", valid_579657
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579658 = query.getOrDefault("part")
  valid_579658 = validateParameter(valid_579658, JString, required = true,
                                 default = nil)
  if valid_579658 != nil:
    section.add "part", valid_579658
  var valid_579659 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579659 = validateParameter(valid_579659, JString, required = false,
                                 default = nil)
  if valid_579659 != nil:
    section.add "onBehalfOfContentOwner", valid_579659
  var valid_579660 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579660 = validateParameter(valid_579660, JString, required = false,
                                 default = nil)
  if valid_579660 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579660
  var valid_579661 = query.getOrDefault("alt")
  valid_579661 = validateParameter(valid_579661, JString, required = false,
                                 default = newJString("json"))
  if valid_579661 != nil:
    section.add "alt", valid_579661
  var valid_579662 = query.getOrDefault("userIp")
  valid_579662 = validateParameter(valid_579662, JString, required = false,
                                 default = nil)
  if valid_579662 != nil:
    section.add "userIp", valid_579662
  var valid_579663 = query.getOrDefault("quotaUser")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "quotaUser", valid_579663
  var valid_579664 = query.getOrDefault("fields")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = nil)
  if valid_579664 != nil:
    section.add "fields", valid_579664
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

proc call*(call_579666: Call_YoutubeLiveStreamsInsert_579652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
  ## 
  let valid = call_579666.validator(path, query, header, formData, body)
  let scheme = call_579666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579666.url(scheme.get, call_579666.host, call_579666.base,
                         call_579666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579666, url, valid)

proc call*(call_579667: Call_YoutubeLiveStreamsInsert_579652; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubeLiveStreamsInsert
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579668 = newJObject()
  var body_579669 = newJObject()
  add(query_579668, "key", newJString(key))
  add(query_579668, "prettyPrint", newJBool(prettyPrint))
  add(query_579668, "oauth_token", newJString(oauthToken))
  add(query_579668, "part", newJString(part))
  add(query_579668, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579668, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579668, "alt", newJString(alt))
  add(query_579668, "userIp", newJString(userIp))
  add(query_579668, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579669 = body
  add(query_579668, "fields", newJString(fields))
  result = call_579667.call(nil, query_579668, nil, nil, body_579669)

var youtubeLiveStreamsInsert* = Call_YoutubeLiveStreamsInsert_579652(
    name: "youtubeLiveStreamsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsInsert_579653, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsInsert_579654, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsList_579614 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveStreamsList_579616(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsList_579615(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of video streams that match the API request parameters.
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
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveStream resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, cdn, and status.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of YouTube stream IDs that identify the streams being retrieved. In a liveStream resource, the id property specifies the stream's ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: JBool
  ##       : The mine parameter can be used to instruct the API to only return streams owned by the authenticated user. Set the parameter value to true to only retrieve your own streams.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
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
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579620 = query.getOrDefault("part")
  valid_579620 = validateParameter(valid_579620, JString, required = true,
                                 default = nil)
  if valid_579620 != nil:
    section.add "part", valid_579620
  var valid_579621 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579621 = validateParameter(valid_579621, JString, required = false,
                                 default = nil)
  if valid_579621 != nil:
    section.add "onBehalfOfContentOwner", valid_579621
  var valid_579622 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579622
  var valid_579623 = query.getOrDefault("alt")
  valid_579623 = validateParameter(valid_579623, JString, required = false,
                                 default = newJString("json"))
  if valid_579623 != nil:
    section.add "alt", valid_579623
  var valid_579624 = query.getOrDefault("userIp")
  valid_579624 = validateParameter(valid_579624, JString, required = false,
                                 default = nil)
  if valid_579624 != nil:
    section.add "userIp", valid_579624
  var valid_579625 = query.getOrDefault("quotaUser")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = nil)
  if valid_579625 != nil:
    section.add "quotaUser", valid_579625
  var valid_579626 = query.getOrDefault("pageToken")
  valid_579626 = validateParameter(valid_579626, JString, required = false,
                                 default = nil)
  if valid_579626 != nil:
    section.add "pageToken", valid_579626
  var valid_579627 = query.getOrDefault("id")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = nil)
  if valid_579627 != nil:
    section.add "id", valid_579627
  var valid_579628 = query.getOrDefault("fields")
  valid_579628 = validateParameter(valid_579628, JString, required = false,
                                 default = nil)
  if valid_579628 != nil:
    section.add "fields", valid_579628
  var valid_579629 = query.getOrDefault("mine")
  valid_579629 = validateParameter(valid_579629, JBool, required = false, default = nil)
  if valid_579629 != nil:
    section.add "mine", valid_579629
  var valid_579630 = query.getOrDefault("maxResults")
  valid_579630 = validateParameter(valid_579630, JInt, required = false,
                                 default = newJInt(5))
  if valid_579630 != nil:
    section.add "maxResults", valid_579630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579631: Call_YoutubeLiveStreamsList_579614; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of video streams that match the API request parameters.
  ## 
  let valid = call_579631.validator(path, query, header, formData, body)
  let scheme = call_579631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579631.url(scheme.get, call_579631.host, call_579631.base,
                         call_579631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579631, url, valid)

proc call*(call_579632: Call_YoutubeLiveStreamsList_579614; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          id: string = ""; fields: string = ""; mine: bool = false; maxResults: int = 5): Recallable =
  ## youtubeLiveStreamsList
  ## Returns a list of video streams that match the API request parameters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveStream resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, cdn, and status.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of YouTube stream IDs that identify the streams being retrieved. In a liveStream resource, the id property specifies the stream's ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: bool
  ##       : The mine parameter can be used to instruct the API to only return streams owned by the authenticated user. Set the parameter value to true to only retrieve your own streams.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_579633 = newJObject()
  add(query_579633, "key", newJString(key))
  add(query_579633, "prettyPrint", newJBool(prettyPrint))
  add(query_579633, "oauth_token", newJString(oauthToken))
  add(query_579633, "part", newJString(part))
  add(query_579633, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579633, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579633, "alt", newJString(alt))
  add(query_579633, "userIp", newJString(userIp))
  add(query_579633, "quotaUser", newJString(quotaUser))
  add(query_579633, "pageToken", newJString(pageToken))
  add(query_579633, "id", newJString(id))
  add(query_579633, "fields", newJString(fields))
  add(query_579633, "mine", newJBool(mine))
  add(query_579633, "maxResults", newJInt(maxResults))
  result = call_579632.call(nil, query_579633, nil, nil, nil)

var youtubeLiveStreamsList* = Call_YoutubeLiveStreamsList_579614(
    name: "youtubeLiveStreamsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsList_579615, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsList_579616, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsDelete_579670 = ref object of OpenApiRestCall_578364
proc url_YoutubeLiveStreamsDelete_579672(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsDelete_579671(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a video stream.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live stream ID for the resource that is being deleted.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579673 = query.getOrDefault("key")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = nil)
  if valid_579673 != nil:
    section.add "key", valid_579673
  var valid_579674 = query.getOrDefault("prettyPrint")
  valid_579674 = validateParameter(valid_579674, JBool, required = false,
                                 default = newJBool(true))
  if valid_579674 != nil:
    section.add "prettyPrint", valid_579674
  var valid_579675 = query.getOrDefault("oauth_token")
  valid_579675 = validateParameter(valid_579675, JString, required = false,
                                 default = nil)
  if valid_579675 != nil:
    section.add "oauth_token", valid_579675
  var valid_579676 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579676 = validateParameter(valid_579676, JString, required = false,
                                 default = nil)
  if valid_579676 != nil:
    section.add "onBehalfOfContentOwner", valid_579676
  var valid_579677 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579677 = validateParameter(valid_579677, JString, required = false,
                                 default = nil)
  if valid_579677 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579677
  var valid_579678 = query.getOrDefault("alt")
  valid_579678 = validateParameter(valid_579678, JString, required = false,
                                 default = newJString("json"))
  if valid_579678 != nil:
    section.add "alt", valid_579678
  var valid_579679 = query.getOrDefault("userIp")
  valid_579679 = validateParameter(valid_579679, JString, required = false,
                                 default = nil)
  if valid_579679 != nil:
    section.add "userIp", valid_579679
  var valid_579680 = query.getOrDefault("quotaUser")
  valid_579680 = validateParameter(valid_579680, JString, required = false,
                                 default = nil)
  if valid_579680 != nil:
    section.add "quotaUser", valid_579680
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579681 = query.getOrDefault("id")
  valid_579681 = validateParameter(valid_579681, JString, required = true,
                                 default = nil)
  if valid_579681 != nil:
    section.add "id", valid_579681
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
  if body != nil:
    result.add "body", body

proc call*(call_579683: Call_YoutubeLiveStreamsDelete_579670; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a video stream.
  ## 
  let valid = call_579683.validator(path, query, header, formData, body)
  let scheme = call_579683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579683.url(scheme.get, call_579683.host, call_579683.base,
                         call_579683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579683, url, valid)

proc call*(call_579684: Call_YoutubeLiveStreamsDelete_579670; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## youtubeLiveStreamsDelete
  ## Deletes a video stream.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live stream ID for the resource that is being deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579685 = newJObject()
  add(query_579685, "key", newJString(key))
  add(query_579685, "prettyPrint", newJBool(prettyPrint))
  add(query_579685, "oauth_token", newJString(oauthToken))
  add(query_579685, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579685, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579685, "alt", newJString(alt))
  add(query_579685, "userIp", newJString(userIp))
  add(query_579685, "quotaUser", newJString(quotaUser))
  add(query_579685, "id", newJString(id))
  add(query_579685, "fields", newJString(fields))
  result = call_579684.call(nil, query_579685, nil, nil, nil)

var youtubeLiveStreamsDelete* = Call_YoutubeLiveStreamsDelete_579670(
    name: "youtubeLiveStreamsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsDelete_579671, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsDelete_579672, schemes: {Scheme.Https})
type
  Call_YoutubeMembersList_579686 = ref object of OpenApiRestCall_578364
proc url_YoutubeMembersList_579688(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeMembersList_579687(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists members for a channel.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the member resource parts that the API response will include. Supported values are id and snippet.
  ##   mode: JString
  ##       : The mode parameter specifies which channel members to return.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hasAccessToLevel: JString
  ##                   : The hasAccessToLevel parameter specifies, when set, the ID of a pricing level that members from the results set should have access to. When not set, all members will be considered, regardless of their active pricing level.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  section = newJObject()
  var valid_579689 = query.getOrDefault("key")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = nil)
  if valid_579689 != nil:
    section.add "key", valid_579689
  var valid_579690 = query.getOrDefault("prettyPrint")
  valid_579690 = validateParameter(valid_579690, JBool, required = false,
                                 default = newJBool(true))
  if valid_579690 != nil:
    section.add "prettyPrint", valid_579690
  var valid_579691 = query.getOrDefault("oauth_token")
  valid_579691 = validateParameter(valid_579691, JString, required = false,
                                 default = nil)
  if valid_579691 != nil:
    section.add "oauth_token", valid_579691
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579692 = query.getOrDefault("part")
  valid_579692 = validateParameter(valid_579692, JString, required = true,
                                 default = nil)
  if valid_579692 != nil:
    section.add "part", valid_579692
  var valid_579693 = query.getOrDefault("mode")
  valid_579693 = validateParameter(valid_579693, JString, required = false,
                                 default = newJString("all_current"))
  if valid_579693 != nil:
    section.add "mode", valid_579693
  var valid_579694 = query.getOrDefault("alt")
  valid_579694 = validateParameter(valid_579694, JString, required = false,
                                 default = newJString("json"))
  if valid_579694 != nil:
    section.add "alt", valid_579694
  var valid_579695 = query.getOrDefault("userIp")
  valid_579695 = validateParameter(valid_579695, JString, required = false,
                                 default = nil)
  if valid_579695 != nil:
    section.add "userIp", valid_579695
  var valid_579696 = query.getOrDefault("quotaUser")
  valid_579696 = validateParameter(valid_579696, JString, required = false,
                                 default = nil)
  if valid_579696 != nil:
    section.add "quotaUser", valid_579696
  var valid_579697 = query.getOrDefault("hasAccessToLevel")
  valid_579697 = validateParameter(valid_579697, JString, required = false,
                                 default = nil)
  if valid_579697 != nil:
    section.add "hasAccessToLevel", valid_579697
  var valid_579698 = query.getOrDefault("pageToken")
  valid_579698 = validateParameter(valid_579698, JString, required = false,
                                 default = nil)
  if valid_579698 != nil:
    section.add "pageToken", valid_579698
  var valid_579699 = query.getOrDefault("fields")
  valid_579699 = validateParameter(valid_579699, JString, required = false,
                                 default = nil)
  if valid_579699 != nil:
    section.add "fields", valid_579699
  var valid_579700 = query.getOrDefault("maxResults")
  valid_579700 = validateParameter(valid_579700, JInt, required = false,
                                 default = newJInt(5))
  if valid_579700 != nil:
    section.add "maxResults", valid_579700
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579701: Call_YoutubeMembersList_579686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists members for a channel.
  ## 
  let valid = call_579701.validator(path, query, header, formData, body)
  let scheme = call_579701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579701.url(scheme.get, call_579701.host, call_579701.base,
                         call_579701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579701, url, valid)

proc call*(call_579702: Call_YoutubeMembersList_579686; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          mode: string = "all_current"; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; hasAccessToLevel: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 5): Recallable =
  ## youtubeMembersList
  ## Lists members for a channel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the member resource parts that the API response will include. Supported values are id and snippet.
  ##   mode: string
  ##       : The mode parameter specifies which channel members to return.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hasAccessToLevel: string
  ##                   : The hasAccessToLevel parameter specifies, when set, the ID of a pricing level that members from the results set should have access to. When not set, all members will be considered, regardless of their active pricing level.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_579703 = newJObject()
  add(query_579703, "key", newJString(key))
  add(query_579703, "prettyPrint", newJBool(prettyPrint))
  add(query_579703, "oauth_token", newJString(oauthToken))
  add(query_579703, "part", newJString(part))
  add(query_579703, "mode", newJString(mode))
  add(query_579703, "alt", newJString(alt))
  add(query_579703, "userIp", newJString(userIp))
  add(query_579703, "quotaUser", newJString(quotaUser))
  add(query_579703, "hasAccessToLevel", newJString(hasAccessToLevel))
  add(query_579703, "pageToken", newJString(pageToken))
  add(query_579703, "fields", newJString(fields))
  add(query_579703, "maxResults", newJInt(maxResults))
  result = call_579702.call(nil, query_579703, nil, nil, nil)

var youtubeMembersList* = Call_YoutubeMembersList_579686(
    name: "youtubeMembersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/members",
    validator: validate_YoutubeMembersList_579687, base: "/youtube/v3",
    url: url_YoutubeMembersList_579688, schemes: {Scheme.Https})
type
  Call_YoutubeMembershipsLevelsList_579704 = ref object of OpenApiRestCall_578364
proc url_YoutubeMembershipsLevelsList_579706(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeMembershipsLevelsList_579705(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists pricing levels for a channel.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the membershipsLevel resource parts that the API response will include. Supported values are id and snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579707 = query.getOrDefault("key")
  valid_579707 = validateParameter(valid_579707, JString, required = false,
                                 default = nil)
  if valid_579707 != nil:
    section.add "key", valid_579707
  var valid_579708 = query.getOrDefault("prettyPrint")
  valid_579708 = validateParameter(valid_579708, JBool, required = false,
                                 default = newJBool(true))
  if valid_579708 != nil:
    section.add "prettyPrint", valid_579708
  var valid_579709 = query.getOrDefault("oauth_token")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = nil)
  if valid_579709 != nil:
    section.add "oauth_token", valid_579709
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579710 = query.getOrDefault("part")
  valid_579710 = validateParameter(valid_579710, JString, required = true,
                                 default = nil)
  if valid_579710 != nil:
    section.add "part", valid_579710
  var valid_579711 = query.getOrDefault("alt")
  valid_579711 = validateParameter(valid_579711, JString, required = false,
                                 default = newJString("json"))
  if valid_579711 != nil:
    section.add "alt", valid_579711
  var valid_579712 = query.getOrDefault("userIp")
  valid_579712 = validateParameter(valid_579712, JString, required = false,
                                 default = nil)
  if valid_579712 != nil:
    section.add "userIp", valid_579712
  var valid_579713 = query.getOrDefault("quotaUser")
  valid_579713 = validateParameter(valid_579713, JString, required = false,
                                 default = nil)
  if valid_579713 != nil:
    section.add "quotaUser", valid_579713
  var valid_579714 = query.getOrDefault("fields")
  valid_579714 = validateParameter(valid_579714, JString, required = false,
                                 default = nil)
  if valid_579714 != nil:
    section.add "fields", valid_579714
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579715: Call_YoutubeMembershipsLevelsList_579704; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pricing levels for a channel.
  ## 
  let valid = call_579715.validator(path, query, header, formData, body)
  let scheme = call_579715.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579715.url(scheme.get, call_579715.host, call_579715.base,
                         call_579715.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579715, url, valid)

proc call*(call_579716: Call_YoutubeMembershipsLevelsList_579704; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## youtubeMembershipsLevelsList
  ## Lists pricing levels for a channel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the membershipsLevel resource parts that the API response will include. Supported values are id and snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579717 = newJObject()
  add(query_579717, "key", newJString(key))
  add(query_579717, "prettyPrint", newJBool(prettyPrint))
  add(query_579717, "oauth_token", newJString(oauthToken))
  add(query_579717, "part", newJString(part))
  add(query_579717, "alt", newJString(alt))
  add(query_579717, "userIp", newJString(userIp))
  add(query_579717, "quotaUser", newJString(quotaUser))
  add(query_579717, "fields", newJString(fields))
  result = call_579716.call(nil, query_579717, nil, nil, nil)

var youtubeMembershipsLevelsList* = Call_YoutubeMembershipsLevelsList_579704(
    name: "youtubeMembershipsLevelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/membershipsLevels",
    validator: validate_YoutubeMembershipsLevelsList_579705, base: "/youtube/v3",
    url: url_YoutubeMembershipsLevelsList_579706, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsUpdate_579738 = ref object of OpenApiRestCall_578364
proc url_YoutubePlaylistItemsUpdate_579740(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsUpdate_579739(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a playlist item can specify a start time and end time, which identify the times portion of the video that should play when users watch the video in the playlist. If your request is updating a playlist item that sets these values, and the request's part parameter value includes the contentDetails part, the playlist item's start and end times will be updated to whatever value the request body specifies. If the request body does not specify values, the existing start and end times will be removed and replaced with the default settings.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579741 = query.getOrDefault("key")
  valid_579741 = validateParameter(valid_579741, JString, required = false,
                                 default = nil)
  if valid_579741 != nil:
    section.add "key", valid_579741
  var valid_579742 = query.getOrDefault("prettyPrint")
  valid_579742 = validateParameter(valid_579742, JBool, required = false,
                                 default = newJBool(true))
  if valid_579742 != nil:
    section.add "prettyPrint", valid_579742
  var valid_579743 = query.getOrDefault("oauth_token")
  valid_579743 = validateParameter(valid_579743, JString, required = false,
                                 default = nil)
  if valid_579743 != nil:
    section.add "oauth_token", valid_579743
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579744 = query.getOrDefault("part")
  valid_579744 = validateParameter(valid_579744, JString, required = true,
                                 default = nil)
  if valid_579744 != nil:
    section.add "part", valid_579744
  var valid_579745 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579745 = validateParameter(valid_579745, JString, required = false,
                                 default = nil)
  if valid_579745 != nil:
    section.add "onBehalfOfContentOwner", valid_579745
  var valid_579746 = query.getOrDefault("alt")
  valid_579746 = validateParameter(valid_579746, JString, required = false,
                                 default = newJString("json"))
  if valid_579746 != nil:
    section.add "alt", valid_579746
  var valid_579747 = query.getOrDefault("userIp")
  valid_579747 = validateParameter(valid_579747, JString, required = false,
                                 default = nil)
  if valid_579747 != nil:
    section.add "userIp", valid_579747
  var valid_579748 = query.getOrDefault("quotaUser")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = nil)
  if valid_579748 != nil:
    section.add "quotaUser", valid_579748
  var valid_579749 = query.getOrDefault("fields")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "fields", valid_579749
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

proc call*(call_579751: Call_YoutubePlaylistItemsUpdate_579738; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
  ## 
  let valid = call_579751.validator(path, query, header, formData, body)
  let scheme = call_579751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579751.url(scheme.get, call_579751.host, call_579751.base,
                         call_579751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579751, url, valid)

proc call*(call_579752: Call_YoutubePlaylistItemsUpdate_579738; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubePlaylistItemsUpdate
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a playlist item can specify a start time and end time, which identify the times portion of the video that should play when users watch the video in the playlist. If your request is updating a playlist item that sets these values, and the request's part parameter value includes the contentDetails part, the playlist item's start and end times will be updated to whatever value the request body specifies. If the request body does not specify values, the existing start and end times will be removed and replaced with the default settings.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579753 = newJObject()
  var body_579754 = newJObject()
  add(query_579753, "key", newJString(key))
  add(query_579753, "prettyPrint", newJBool(prettyPrint))
  add(query_579753, "oauth_token", newJString(oauthToken))
  add(query_579753, "part", newJString(part))
  add(query_579753, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579753, "alt", newJString(alt))
  add(query_579753, "userIp", newJString(userIp))
  add(query_579753, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579754 = body
  add(query_579753, "fields", newJString(fields))
  result = call_579752.call(nil, query_579753, nil, nil, body_579754)

var youtubePlaylistItemsUpdate* = Call_YoutubePlaylistItemsUpdate_579738(
    name: "youtubePlaylistItemsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsUpdate_579739, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsUpdate_579740, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsInsert_579755 = ref object of OpenApiRestCall_578364
proc url_YoutubePlaylistItemsInsert_579757(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsInsert_579756(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a resource to a playlist.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579758 = query.getOrDefault("key")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "key", valid_579758
  var valid_579759 = query.getOrDefault("prettyPrint")
  valid_579759 = validateParameter(valid_579759, JBool, required = false,
                                 default = newJBool(true))
  if valid_579759 != nil:
    section.add "prettyPrint", valid_579759
  var valid_579760 = query.getOrDefault("oauth_token")
  valid_579760 = validateParameter(valid_579760, JString, required = false,
                                 default = nil)
  if valid_579760 != nil:
    section.add "oauth_token", valid_579760
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579761 = query.getOrDefault("part")
  valid_579761 = validateParameter(valid_579761, JString, required = true,
                                 default = nil)
  if valid_579761 != nil:
    section.add "part", valid_579761
  var valid_579762 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579762 = validateParameter(valid_579762, JString, required = false,
                                 default = nil)
  if valid_579762 != nil:
    section.add "onBehalfOfContentOwner", valid_579762
  var valid_579763 = query.getOrDefault("alt")
  valid_579763 = validateParameter(valid_579763, JString, required = false,
                                 default = newJString("json"))
  if valid_579763 != nil:
    section.add "alt", valid_579763
  var valid_579764 = query.getOrDefault("userIp")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "userIp", valid_579764
  var valid_579765 = query.getOrDefault("quotaUser")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = nil)
  if valid_579765 != nil:
    section.add "quotaUser", valid_579765
  var valid_579766 = query.getOrDefault("fields")
  valid_579766 = validateParameter(valid_579766, JString, required = false,
                                 default = nil)
  if valid_579766 != nil:
    section.add "fields", valid_579766
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

proc call*(call_579768: Call_YoutubePlaylistItemsInsert_579755; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a resource to a playlist.
  ## 
  let valid = call_579768.validator(path, query, header, formData, body)
  let scheme = call_579768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579768.url(scheme.get, call_579768.host, call_579768.base,
                         call_579768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579768, url, valid)

proc call*(call_579769: Call_YoutubePlaylistItemsInsert_579755; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubePlaylistItemsInsert
  ## Adds a resource to a playlist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579770 = newJObject()
  var body_579771 = newJObject()
  add(query_579770, "key", newJString(key))
  add(query_579770, "prettyPrint", newJBool(prettyPrint))
  add(query_579770, "oauth_token", newJString(oauthToken))
  add(query_579770, "part", newJString(part))
  add(query_579770, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579770, "alt", newJString(alt))
  add(query_579770, "userIp", newJString(userIp))
  add(query_579770, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579771 = body
  add(query_579770, "fields", newJString(fields))
  result = call_579769.call(nil, query_579770, nil, nil, body_579771)

var youtubePlaylistItemsInsert* = Call_YoutubePlaylistItemsInsert_579755(
    name: "youtubePlaylistItemsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsInsert_579756, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsInsert_579757, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsList_579718 = ref object of OpenApiRestCall_578364
proc url_YoutubePlaylistItemsList_579720(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsList_579719(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
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
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlistItem resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlistItem resource, the snippet property contains numerous fields, including the title, description, position, and resourceId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   playlistId: JString
  ##             : The playlistId parameter specifies the unique ID of the playlist for which you want to retrieve playlist items. Note that even though this is an optional parameter, every request to retrieve playlist items must specify a value for either the id parameter or the playlistId parameter.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of one or more unique playlist item IDs.
  ##   videoId: JString
  ##          : The videoId parameter specifies that the request should return only the playlist items that contain the specified video.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
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
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579724 = query.getOrDefault("part")
  valid_579724 = validateParameter(valid_579724, JString, required = true,
                                 default = nil)
  if valid_579724 != nil:
    section.add "part", valid_579724
  var valid_579725 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579725 = validateParameter(valid_579725, JString, required = false,
                                 default = nil)
  if valid_579725 != nil:
    section.add "onBehalfOfContentOwner", valid_579725
  var valid_579726 = query.getOrDefault("alt")
  valid_579726 = validateParameter(valid_579726, JString, required = false,
                                 default = newJString("json"))
  if valid_579726 != nil:
    section.add "alt", valid_579726
  var valid_579727 = query.getOrDefault("userIp")
  valid_579727 = validateParameter(valid_579727, JString, required = false,
                                 default = nil)
  if valid_579727 != nil:
    section.add "userIp", valid_579727
  var valid_579728 = query.getOrDefault("playlistId")
  valid_579728 = validateParameter(valid_579728, JString, required = false,
                                 default = nil)
  if valid_579728 != nil:
    section.add "playlistId", valid_579728
  var valid_579729 = query.getOrDefault("quotaUser")
  valid_579729 = validateParameter(valid_579729, JString, required = false,
                                 default = nil)
  if valid_579729 != nil:
    section.add "quotaUser", valid_579729
  var valid_579730 = query.getOrDefault("pageToken")
  valid_579730 = validateParameter(valid_579730, JString, required = false,
                                 default = nil)
  if valid_579730 != nil:
    section.add "pageToken", valid_579730
  var valid_579731 = query.getOrDefault("id")
  valid_579731 = validateParameter(valid_579731, JString, required = false,
                                 default = nil)
  if valid_579731 != nil:
    section.add "id", valid_579731
  var valid_579732 = query.getOrDefault("videoId")
  valid_579732 = validateParameter(valid_579732, JString, required = false,
                                 default = nil)
  if valid_579732 != nil:
    section.add "videoId", valid_579732
  var valid_579733 = query.getOrDefault("fields")
  valid_579733 = validateParameter(valid_579733, JString, required = false,
                                 default = nil)
  if valid_579733 != nil:
    section.add "fields", valid_579733
  var valid_579734 = query.getOrDefault("maxResults")
  valid_579734 = validateParameter(valid_579734, JInt, required = false,
                                 default = newJInt(5))
  if valid_579734 != nil:
    section.add "maxResults", valid_579734
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579735: Call_YoutubePlaylistItemsList_579718; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
  ## 
  let valid = call_579735.validator(path, query, header, formData, body)
  let scheme = call_579735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579735.url(scheme.get, call_579735.host, call_579735.base,
                         call_579735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579735, url, valid)

proc call*(call_579736: Call_YoutubePlaylistItemsList_579718; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; playlistId: string = ""; quotaUser: string = "";
          pageToken: string = ""; id: string = ""; videoId: string = "";
          fields: string = ""; maxResults: int = 5): Recallable =
  ## youtubePlaylistItemsList
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlistItem resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlistItem resource, the snippet property contains numerous fields, including the title, description, position, and resourceId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   playlistId: string
  ##             : The playlistId parameter specifies the unique ID of the playlist for which you want to retrieve playlist items. Note that even though this is an optional parameter, every request to retrieve playlist items must specify a value for either the id parameter or the playlistId parameter.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of one or more unique playlist item IDs.
  ##   videoId: string
  ##          : The videoId parameter specifies that the request should return only the playlist items that contain the specified video.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_579737 = newJObject()
  add(query_579737, "key", newJString(key))
  add(query_579737, "prettyPrint", newJBool(prettyPrint))
  add(query_579737, "oauth_token", newJString(oauthToken))
  add(query_579737, "part", newJString(part))
  add(query_579737, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579737, "alt", newJString(alt))
  add(query_579737, "userIp", newJString(userIp))
  add(query_579737, "playlistId", newJString(playlistId))
  add(query_579737, "quotaUser", newJString(quotaUser))
  add(query_579737, "pageToken", newJString(pageToken))
  add(query_579737, "id", newJString(id))
  add(query_579737, "videoId", newJString(videoId))
  add(query_579737, "fields", newJString(fields))
  add(query_579737, "maxResults", newJInt(maxResults))
  result = call_579736.call(nil, query_579737, nil, nil, nil)

var youtubePlaylistItemsList* = Call_YoutubePlaylistItemsList_579718(
    name: "youtubePlaylistItemsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsList_579719, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsList_579720, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsDelete_579772 = ref object of OpenApiRestCall_578364
proc url_YoutubePlaylistItemsDelete_579774(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsDelete_579773(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a playlist item.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube playlist item ID for the playlist item that is being deleted. In a playlistItem resource, the id property specifies the playlist item's ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579775 = query.getOrDefault("key")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "key", valid_579775
  var valid_579776 = query.getOrDefault("prettyPrint")
  valid_579776 = validateParameter(valid_579776, JBool, required = false,
                                 default = newJBool(true))
  if valid_579776 != nil:
    section.add "prettyPrint", valid_579776
  var valid_579777 = query.getOrDefault("oauth_token")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "oauth_token", valid_579777
  var valid_579778 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "onBehalfOfContentOwner", valid_579778
  var valid_579779 = query.getOrDefault("alt")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = newJString("json"))
  if valid_579779 != nil:
    section.add "alt", valid_579779
  var valid_579780 = query.getOrDefault("userIp")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "userIp", valid_579780
  var valid_579781 = query.getOrDefault("quotaUser")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "quotaUser", valid_579781
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579782 = query.getOrDefault("id")
  valid_579782 = validateParameter(valid_579782, JString, required = true,
                                 default = nil)
  if valid_579782 != nil:
    section.add "id", valid_579782
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
  if body != nil:
    result.add "body", body

proc call*(call_579784: Call_YoutubePlaylistItemsDelete_579772; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a playlist item.
  ## 
  let valid = call_579784.validator(path, query, header, formData, body)
  let scheme = call_579784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579784.url(scheme.get, call_579784.host, call_579784.base,
                         call_579784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579784, url, valid)

proc call*(call_579785: Call_YoutubePlaylistItemsDelete_579772; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## youtubePlaylistItemsDelete
  ## Deletes a playlist item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube playlist item ID for the playlist item that is being deleted. In a playlistItem resource, the id property specifies the playlist item's ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579786 = newJObject()
  add(query_579786, "key", newJString(key))
  add(query_579786, "prettyPrint", newJBool(prettyPrint))
  add(query_579786, "oauth_token", newJString(oauthToken))
  add(query_579786, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579786, "alt", newJString(alt))
  add(query_579786, "userIp", newJString(userIp))
  add(query_579786, "quotaUser", newJString(quotaUser))
  add(query_579786, "id", newJString(id))
  add(query_579786, "fields", newJString(fields))
  result = call_579785.call(nil, query_579786, nil, nil, nil)

var youtubePlaylistItemsDelete* = Call_YoutubePlaylistItemsDelete_579772(
    name: "youtubePlaylistItemsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsDelete_579773, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsDelete_579774, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsUpdate_579809 = ref object of OpenApiRestCall_578364
proc url_YoutubePlaylistsUpdate_579811(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsUpdate_579810(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for mutable properties that are contained in any parts that the request body specifies. For example, a playlist's description is contained in the snippet part, which must be included in the request body. If the request does not specify a value for the snippet.description property, the playlist's existing description will be deleted.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579812 = query.getOrDefault("key")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "key", valid_579812
  var valid_579813 = query.getOrDefault("prettyPrint")
  valid_579813 = validateParameter(valid_579813, JBool, required = false,
                                 default = newJBool(true))
  if valid_579813 != nil:
    section.add "prettyPrint", valid_579813
  var valid_579814 = query.getOrDefault("oauth_token")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "oauth_token", valid_579814
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579815 = query.getOrDefault("part")
  valid_579815 = validateParameter(valid_579815, JString, required = true,
                                 default = nil)
  if valid_579815 != nil:
    section.add "part", valid_579815
  var valid_579816 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579816 = validateParameter(valid_579816, JString, required = false,
                                 default = nil)
  if valid_579816 != nil:
    section.add "onBehalfOfContentOwner", valid_579816
  var valid_579817 = query.getOrDefault("alt")
  valid_579817 = validateParameter(valid_579817, JString, required = false,
                                 default = newJString("json"))
  if valid_579817 != nil:
    section.add "alt", valid_579817
  var valid_579818 = query.getOrDefault("userIp")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = nil)
  if valid_579818 != nil:
    section.add "userIp", valid_579818
  var valid_579819 = query.getOrDefault("quotaUser")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "quotaUser", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
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

proc call*(call_579822: Call_YoutubePlaylistsUpdate_579809; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
  ## 
  let valid = call_579822.validator(path, query, header, formData, body)
  let scheme = call_579822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579822.url(scheme.get, call_579822.host, call_579822.base,
                         call_579822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579822, url, valid)

proc call*(call_579823: Call_YoutubePlaylistsUpdate_579809; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubePlaylistsUpdate
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for mutable properties that are contained in any parts that the request body specifies. For example, a playlist's description is contained in the snippet part, which must be included in the request body. If the request does not specify a value for the snippet.description property, the playlist's existing description will be deleted.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579824 = newJObject()
  var body_579825 = newJObject()
  add(query_579824, "key", newJString(key))
  add(query_579824, "prettyPrint", newJBool(prettyPrint))
  add(query_579824, "oauth_token", newJString(oauthToken))
  add(query_579824, "part", newJString(part))
  add(query_579824, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579824, "alt", newJString(alt))
  add(query_579824, "userIp", newJString(userIp))
  add(query_579824, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579825 = body
  add(query_579824, "fields", newJString(fields))
  result = call_579823.call(nil, query_579824, nil, nil, body_579825)

var youtubePlaylistsUpdate* = Call_YoutubePlaylistsUpdate_579809(
    name: "youtubePlaylistsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsUpdate_579810, base: "/youtube/v3",
    url: url_YoutubePlaylistsUpdate_579811, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsInsert_579826 = ref object of OpenApiRestCall_578364
proc url_YoutubePlaylistsInsert_579828(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsInsert_579827(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a playlist.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579829 = query.getOrDefault("key")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "key", valid_579829
  var valid_579830 = query.getOrDefault("prettyPrint")
  valid_579830 = validateParameter(valid_579830, JBool, required = false,
                                 default = newJBool(true))
  if valid_579830 != nil:
    section.add "prettyPrint", valid_579830
  var valid_579831 = query.getOrDefault("oauth_token")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "oauth_token", valid_579831
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579832 = query.getOrDefault("part")
  valid_579832 = validateParameter(valid_579832, JString, required = true,
                                 default = nil)
  if valid_579832 != nil:
    section.add "part", valid_579832
  var valid_579833 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = nil)
  if valid_579833 != nil:
    section.add "onBehalfOfContentOwner", valid_579833
  var valid_579834 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579834
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("userIp")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "userIp", valid_579836
  var valid_579837 = query.getOrDefault("quotaUser")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "quotaUser", valid_579837
  var valid_579838 = query.getOrDefault("fields")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "fields", valid_579838
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

proc call*(call_579840: Call_YoutubePlaylistsInsert_579826; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a playlist.
  ## 
  let valid = call_579840.validator(path, query, header, formData, body)
  let scheme = call_579840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579840.url(scheme.get, call_579840.host, call_579840.base,
                         call_579840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579840, url, valid)

proc call*(call_579841: Call_YoutubePlaylistsInsert_579826; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubePlaylistsInsert
  ## Creates a playlist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579842 = newJObject()
  var body_579843 = newJObject()
  add(query_579842, "key", newJString(key))
  add(query_579842, "prettyPrint", newJBool(prettyPrint))
  add(query_579842, "oauth_token", newJString(oauthToken))
  add(query_579842, "part", newJString(part))
  add(query_579842, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579842, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579842, "alt", newJString(alt))
  add(query_579842, "userIp", newJString(userIp))
  add(query_579842, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579843 = body
  add(query_579842, "fields", newJString(fields))
  result = call_579841.call(nil, query_579842, nil, nil, body_579843)

var youtubePlaylistsInsert* = Call_YoutubePlaylistsInsert_579826(
    name: "youtubePlaylistsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsInsert_579827, base: "/youtube/v3",
    url: url_YoutubePlaylistsInsert_579828, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsList_579787 = ref object of OpenApiRestCall_578364
proc url_YoutubePlaylistsList_579789(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsList_579788(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
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
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlist resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlist resource, the snippet property contains properties like author, title, description, tags, and timeCreated. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   channelId: JString
  ##            : This value indicates that the API should only return the specified channel's playlists.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube playlist ID(s) for the resource(s) that are being retrieved. In a playlist resource, the id property specifies the playlist's YouTube playlist ID.
  ##   hl: JString
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the snippet part.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: JBool
  ##       : Set this parameter's value to true to instruct the API to only return playlists owned by the authenticated user.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
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
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579793 = query.getOrDefault("part")
  valid_579793 = validateParameter(valid_579793, JString, required = true,
                                 default = nil)
  if valid_579793 != nil:
    section.add "part", valid_579793
  var valid_579794 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "onBehalfOfContentOwner", valid_579794
  var valid_579795 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579795
  var valid_579796 = query.getOrDefault("alt")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = newJString("json"))
  if valid_579796 != nil:
    section.add "alt", valid_579796
  var valid_579797 = query.getOrDefault("userIp")
  valid_579797 = validateParameter(valid_579797, JString, required = false,
                                 default = nil)
  if valid_579797 != nil:
    section.add "userIp", valid_579797
  var valid_579798 = query.getOrDefault("quotaUser")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "quotaUser", valid_579798
  var valid_579799 = query.getOrDefault("pageToken")
  valid_579799 = validateParameter(valid_579799, JString, required = false,
                                 default = nil)
  if valid_579799 != nil:
    section.add "pageToken", valid_579799
  var valid_579800 = query.getOrDefault("channelId")
  valid_579800 = validateParameter(valid_579800, JString, required = false,
                                 default = nil)
  if valid_579800 != nil:
    section.add "channelId", valid_579800
  var valid_579801 = query.getOrDefault("id")
  valid_579801 = validateParameter(valid_579801, JString, required = false,
                                 default = nil)
  if valid_579801 != nil:
    section.add "id", valid_579801
  var valid_579802 = query.getOrDefault("hl")
  valid_579802 = validateParameter(valid_579802, JString, required = false,
                                 default = nil)
  if valid_579802 != nil:
    section.add "hl", valid_579802
  var valid_579803 = query.getOrDefault("fields")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = nil)
  if valid_579803 != nil:
    section.add "fields", valid_579803
  var valid_579804 = query.getOrDefault("mine")
  valid_579804 = validateParameter(valid_579804, JBool, required = false, default = nil)
  if valid_579804 != nil:
    section.add "mine", valid_579804
  var valid_579805 = query.getOrDefault("maxResults")
  valid_579805 = validateParameter(valid_579805, JInt, required = false,
                                 default = newJInt(5))
  if valid_579805 != nil:
    section.add "maxResults", valid_579805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579806: Call_YoutubePlaylistsList_579787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
  ## 
  let valid = call_579806.validator(path, query, header, formData, body)
  let scheme = call_579806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579806.url(scheme.get, call_579806.host, call_579806.base,
                         call_579806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579806, url, valid)

proc call*(call_579807: Call_YoutubePlaylistsList_579787; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          channelId: string = ""; id: string = ""; hl: string = ""; fields: string = "";
          mine: bool = false; maxResults: int = 5): Recallable =
  ## youtubePlaylistsList
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlist resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlist resource, the snippet property contains properties like author, title, description, tags, and timeCreated. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   channelId: string
  ##            : This value indicates that the API should only return the specified channel's playlists.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube playlist ID(s) for the resource(s) that are being retrieved. In a playlist resource, the id property specifies the playlist's YouTube playlist ID.
  ##   hl: string
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the snippet part.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: bool
  ##       : Set this parameter's value to true to instruct the API to only return playlists owned by the authenticated user.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_579808 = newJObject()
  add(query_579808, "key", newJString(key))
  add(query_579808, "prettyPrint", newJBool(prettyPrint))
  add(query_579808, "oauth_token", newJString(oauthToken))
  add(query_579808, "part", newJString(part))
  add(query_579808, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579808, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579808, "alt", newJString(alt))
  add(query_579808, "userIp", newJString(userIp))
  add(query_579808, "quotaUser", newJString(quotaUser))
  add(query_579808, "pageToken", newJString(pageToken))
  add(query_579808, "channelId", newJString(channelId))
  add(query_579808, "id", newJString(id))
  add(query_579808, "hl", newJString(hl))
  add(query_579808, "fields", newJString(fields))
  add(query_579808, "mine", newJBool(mine))
  add(query_579808, "maxResults", newJInt(maxResults))
  result = call_579807.call(nil, query_579808, nil, nil, nil)

var youtubePlaylistsList* = Call_YoutubePlaylistsList_579787(
    name: "youtubePlaylistsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsList_579788, base: "/youtube/v3",
    url: url_YoutubePlaylistsList_579789, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsDelete_579844 = ref object of OpenApiRestCall_578364
proc url_YoutubePlaylistsDelete_579846(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsDelete_579845(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a playlist.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube playlist ID for the playlist that is being deleted. In a playlist resource, the id property specifies the playlist's ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579847 = query.getOrDefault("key")
  valid_579847 = validateParameter(valid_579847, JString, required = false,
                                 default = nil)
  if valid_579847 != nil:
    section.add "key", valid_579847
  var valid_579848 = query.getOrDefault("prettyPrint")
  valid_579848 = validateParameter(valid_579848, JBool, required = false,
                                 default = newJBool(true))
  if valid_579848 != nil:
    section.add "prettyPrint", valid_579848
  var valid_579849 = query.getOrDefault("oauth_token")
  valid_579849 = validateParameter(valid_579849, JString, required = false,
                                 default = nil)
  if valid_579849 != nil:
    section.add "oauth_token", valid_579849
  var valid_579850 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579850 = validateParameter(valid_579850, JString, required = false,
                                 default = nil)
  if valid_579850 != nil:
    section.add "onBehalfOfContentOwner", valid_579850
  var valid_579851 = query.getOrDefault("alt")
  valid_579851 = validateParameter(valid_579851, JString, required = false,
                                 default = newJString("json"))
  if valid_579851 != nil:
    section.add "alt", valid_579851
  var valid_579852 = query.getOrDefault("userIp")
  valid_579852 = validateParameter(valid_579852, JString, required = false,
                                 default = nil)
  if valid_579852 != nil:
    section.add "userIp", valid_579852
  var valid_579853 = query.getOrDefault("quotaUser")
  valid_579853 = validateParameter(valid_579853, JString, required = false,
                                 default = nil)
  if valid_579853 != nil:
    section.add "quotaUser", valid_579853
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579854 = query.getOrDefault("id")
  valid_579854 = validateParameter(valid_579854, JString, required = true,
                                 default = nil)
  if valid_579854 != nil:
    section.add "id", valid_579854
  var valid_579855 = query.getOrDefault("fields")
  valid_579855 = validateParameter(valid_579855, JString, required = false,
                                 default = nil)
  if valid_579855 != nil:
    section.add "fields", valid_579855
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579856: Call_YoutubePlaylistsDelete_579844; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a playlist.
  ## 
  let valid = call_579856.validator(path, query, header, formData, body)
  let scheme = call_579856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579856.url(scheme.get, call_579856.host, call_579856.base,
                         call_579856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579856, url, valid)

proc call*(call_579857: Call_YoutubePlaylistsDelete_579844; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## youtubePlaylistsDelete
  ## Deletes a playlist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube playlist ID for the playlist that is being deleted. In a playlist resource, the id property specifies the playlist's ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579858 = newJObject()
  add(query_579858, "key", newJString(key))
  add(query_579858, "prettyPrint", newJBool(prettyPrint))
  add(query_579858, "oauth_token", newJString(oauthToken))
  add(query_579858, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579858, "alt", newJString(alt))
  add(query_579858, "userIp", newJString(userIp))
  add(query_579858, "quotaUser", newJString(quotaUser))
  add(query_579858, "id", newJString(id))
  add(query_579858, "fields", newJString(fields))
  result = call_579857.call(nil, query_579858, nil, nil, nil)

var youtubePlaylistsDelete* = Call_YoutubePlaylistsDelete_579844(
    name: "youtubePlaylistsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsDelete_579845, base: "/youtube/v3",
    url: url_YoutubePlaylistsDelete_579846, schemes: {Scheme.Https})
type
  Call_YoutubeSearchList_579859 = ref object of OpenApiRestCall_578364
proc url_YoutubeSearchList_579861(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSearchList_579860(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
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
  ##   forContentOwner: JBool
  ##                  : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The forContentOwner parameter restricts the search to only retrieve resources owned by the content owner specified by the onBehalfOfContentOwner parameter. The user must be authenticated using a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   forMine: JBool
  ##          : The forMine parameter restricts the search to only retrieve videos owned by the authenticated user. If you set this parameter to true, then the type parameter's value must also be set to video.
  ##   videoCategoryId: JString
  ##                  : The videoCategoryId parameter filters video search results based on their category. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   order: JString
  ##        : The order parameter specifies the method that will be used to order resources in the API response.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more search resource properties that the API response will include. Set the parameter value to snippet.
  ##   q: JString
  ##    : The q parameter specifies the query term to search for.
  ## 
  ## Your request can also use the Boolean NOT (-) and OR (|) operators to exclude videos or to find videos that are associated with one of several search terms. For example, to search for videos matching either "boating" or "sailing", set the q parameter value to boating|sailing. Similarly, to search for videos matching either "boating" or "sailing" but not "fishing", set the q parameter value to boating|sailing -fishing. Note that the pipe character must be URL-escaped when it is sent in your API request. The URL-escaped value for the pipe character is %7C.
  ##   videoLicense: JString
  ##               : The videoLicense parameter filters search results to only include videos with a particular license. YouTube lets video uploaders choose to attach either the Creative Commons license or the standard YouTube license to each of their videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   topicId: JString
  ##          : The topicId parameter indicates that the API response should only contain resources associated with the specified topic. The value identifies a Freebase topic ID.
  ##   locationRadius: JString
  ##                 : The locationRadius parameter, in conjunction with the location parameter, defines a circular geographic area.
  ## 
  ## The parameter value must be a floating point number followed by a measurement unit. Valid measurement units are m, km, ft, and mi. For example, valid parameter values include 1500m, 5km, 10000ft, and 0.75mi. The API does not support locationRadius parameter values larger than 1000 kilometers.
  ## 
  ## Note: See the definition of the location parameter for more information.
  ##   relevanceLanguage: JString
  ##                    : The relevanceLanguage parameter instructs the API to return search results that are most relevant to the specified language. The parameter value is typically an ISO 639-1 two-letter language code. However, you should use the values zh-Hans for simplified Chinese and zh-Hant for traditional Chinese. Please note that results in other languages will still be returned if they are highly relevant to the search query term.
  ##   videoEmbeddable: JString
  ##                  : The videoEmbeddable parameter lets you to restrict a search to only videos that can be embedded into a webpage. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   relatedToVideoId: JString
  ##                   : The relatedToVideoId parameter retrieves a list of videos that are related to the video that the parameter value identifies. The parameter value must be set to a YouTube video ID and, if you are using this parameter, the type parameter must be set to video.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   videoCaption: JString
  ##               : The videoCaption parameter indicates whether the API should filter video search results based on whether they have captions. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   type: JString
  ##       : The type parameter restricts a search query to only retrieve a particular type of resource. The value is a comma-separated list of resource types.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   eventType: JString
  ##            : The eventType parameter restricts a search to broadcast events. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   channelId: JString
  ##            : The channelId parameter indicates that the API response should only contain resources created by the channel
  ##   forDeveloper: JBool
  ##               : The forDeveloper parameter restricts the search to only retrieve videos uploaded via the developer's application or website. The API server uses the request's authorization credentials to identify the developer. Therefore, a developer can restrict results to videos uploaded through the developer's own app or website but not to videos uploaded through other apps or sites.
  ##   channelType: JString
  ##              : The channelType parameter lets you restrict a search to a particular type of channel.
  ##   location: JString
  ##           : The location parameter, in conjunction with the locationRadius parameter, defines a circular geographic area and also restricts a search to videos that specify, in their metadata, a geographic location that falls within that area. The parameter value is a string that specifies latitude/longitude coordinates e.g. (37.42307,-122.08427).
  ## 
  ## 
  ## - The location parameter value identifies the point at the center of the area.
  ## - The locationRadius parameter specifies the maximum distance that the location associated with a video can be from that point for the video to still be included in the search results.The API returns an error if your request specifies a value for the location parameter but does not also specify a value for the locationRadius parameter.
  ##   safeSearch: JString
  ##             : The safeSearch parameter indicates whether the search results should include restricted content as well as standard content.
  ##   videoDefinition: JString
  ##                  : The videoDefinition parameter lets you restrict a search to only include either high definition (HD) or standard definition (SD) videos. HD videos are available for playback in at least 720p, though higher resolutions, like 1080p, might also be available. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   publishedBefore: JString
  ##                  : The publishedBefore parameter indicates that the API response should only contain resources created before the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   videoSyndicated: JString
  ##                  : The videoSyndicated parameter lets you to restrict a search to only videos that can be played outside youtube.com. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoType: JString
  ##            : The videoType parameter lets you restrict a search to a particular type of videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoDimension: JString
  ##                 : The videoDimension parameter lets you restrict a search to only retrieve 2D or 3D videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return search results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: JString
  ##                 : The publishedAfter parameter indicates that the API response should only contain resources created after the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   videoDuration: JString
  ##                : The videoDuration parameter filters video search results based on their duration. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  section = newJObject()
  var valid_579862 = query.getOrDefault("key")
  valid_579862 = validateParameter(valid_579862, JString, required = false,
                                 default = nil)
  if valid_579862 != nil:
    section.add "key", valid_579862
  var valid_579863 = query.getOrDefault("prettyPrint")
  valid_579863 = validateParameter(valid_579863, JBool, required = false,
                                 default = newJBool(true))
  if valid_579863 != nil:
    section.add "prettyPrint", valid_579863
  var valid_579864 = query.getOrDefault("oauth_token")
  valid_579864 = validateParameter(valid_579864, JString, required = false,
                                 default = nil)
  if valid_579864 != nil:
    section.add "oauth_token", valid_579864
  var valid_579865 = query.getOrDefault("forContentOwner")
  valid_579865 = validateParameter(valid_579865, JBool, required = false, default = nil)
  if valid_579865 != nil:
    section.add "forContentOwner", valid_579865
  var valid_579866 = query.getOrDefault("forMine")
  valid_579866 = validateParameter(valid_579866, JBool, required = false, default = nil)
  if valid_579866 != nil:
    section.add "forMine", valid_579866
  var valid_579867 = query.getOrDefault("videoCategoryId")
  valid_579867 = validateParameter(valid_579867, JString, required = false,
                                 default = nil)
  if valid_579867 != nil:
    section.add "videoCategoryId", valid_579867
  var valid_579868 = query.getOrDefault("order")
  valid_579868 = validateParameter(valid_579868, JString, required = false,
                                 default = newJString("relevance"))
  if valid_579868 != nil:
    section.add "order", valid_579868
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579869 = query.getOrDefault("part")
  valid_579869 = validateParameter(valid_579869, JString, required = true,
                                 default = nil)
  if valid_579869 != nil:
    section.add "part", valid_579869
  var valid_579870 = query.getOrDefault("q")
  valid_579870 = validateParameter(valid_579870, JString, required = false,
                                 default = nil)
  if valid_579870 != nil:
    section.add "q", valid_579870
  var valid_579871 = query.getOrDefault("videoLicense")
  valid_579871 = validateParameter(valid_579871, JString, required = false,
                                 default = newJString("any"))
  if valid_579871 != nil:
    section.add "videoLicense", valid_579871
  var valid_579872 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579872 = validateParameter(valid_579872, JString, required = false,
                                 default = nil)
  if valid_579872 != nil:
    section.add "onBehalfOfContentOwner", valid_579872
  var valid_579873 = query.getOrDefault("topicId")
  valid_579873 = validateParameter(valid_579873, JString, required = false,
                                 default = nil)
  if valid_579873 != nil:
    section.add "topicId", valid_579873
  var valid_579874 = query.getOrDefault("locationRadius")
  valid_579874 = validateParameter(valid_579874, JString, required = false,
                                 default = nil)
  if valid_579874 != nil:
    section.add "locationRadius", valid_579874
  var valid_579875 = query.getOrDefault("relevanceLanguage")
  valid_579875 = validateParameter(valid_579875, JString, required = false,
                                 default = nil)
  if valid_579875 != nil:
    section.add "relevanceLanguage", valid_579875
  var valid_579876 = query.getOrDefault("videoEmbeddable")
  valid_579876 = validateParameter(valid_579876, JString, required = false,
                                 default = newJString("any"))
  if valid_579876 != nil:
    section.add "videoEmbeddable", valid_579876
  var valid_579877 = query.getOrDefault("alt")
  valid_579877 = validateParameter(valid_579877, JString, required = false,
                                 default = newJString("json"))
  if valid_579877 != nil:
    section.add "alt", valid_579877
  var valid_579878 = query.getOrDefault("userIp")
  valid_579878 = validateParameter(valid_579878, JString, required = false,
                                 default = nil)
  if valid_579878 != nil:
    section.add "userIp", valid_579878
  var valid_579879 = query.getOrDefault("relatedToVideoId")
  valid_579879 = validateParameter(valid_579879, JString, required = false,
                                 default = nil)
  if valid_579879 != nil:
    section.add "relatedToVideoId", valid_579879
  var valid_579880 = query.getOrDefault("quotaUser")
  valid_579880 = validateParameter(valid_579880, JString, required = false,
                                 default = nil)
  if valid_579880 != nil:
    section.add "quotaUser", valid_579880
  var valid_579881 = query.getOrDefault("videoCaption")
  valid_579881 = validateParameter(valid_579881, JString, required = false,
                                 default = newJString("any"))
  if valid_579881 != nil:
    section.add "videoCaption", valid_579881
  var valid_579882 = query.getOrDefault("type")
  valid_579882 = validateParameter(valid_579882, JString, required = false,
                                 default = newJString("video,channel,playlist"))
  if valid_579882 != nil:
    section.add "type", valid_579882
  var valid_579883 = query.getOrDefault("pageToken")
  valid_579883 = validateParameter(valid_579883, JString, required = false,
                                 default = nil)
  if valid_579883 != nil:
    section.add "pageToken", valid_579883
  var valid_579884 = query.getOrDefault("eventType")
  valid_579884 = validateParameter(valid_579884, JString, required = false,
                                 default = newJString("completed"))
  if valid_579884 != nil:
    section.add "eventType", valid_579884
  var valid_579885 = query.getOrDefault("channelId")
  valid_579885 = validateParameter(valid_579885, JString, required = false,
                                 default = nil)
  if valid_579885 != nil:
    section.add "channelId", valid_579885
  var valid_579886 = query.getOrDefault("forDeveloper")
  valid_579886 = validateParameter(valid_579886, JBool, required = false, default = nil)
  if valid_579886 != nil:
    section.add "forDeveloper", valid_579886
  var valid_579887 = query.getOrDefault("channelType")
  valid_579887 = validateParameter(valid_579887, JString, required = false,
                                 default = newJString("any"))
  if valid_579887 != nil:
    section.add "channelType", valid_579887
  var valid_579888 = query.getOrDefault("location")
  valid_579888 = validateParameter(valid_579888, JString, required = false,
                                 default = nil)
  if valid_579888 != nil:
    section.add "location", valid_579888
  var valid_579889 = query.getOrDefault("safeSearch")
  valid_579889 = validateParameter(valid_579889, JString, required = false,
                                 default = newJString("moderate"))
  if valid_579889 != nil:
    section.add "safeSearch", valid_579889
  var valid_579890 = query.getOrDefault("videoDefinition")
  valid_579890 = validateParameter(valid_579890, JString, required = false,
                                 default = newJString("any"))
  if valid_579890 != nil:
    section.add "videoDefinition", valid_579890
  var valid_579891 = query.getOrDefault("publishedBefore")
  valid_579891 = validateParameter(valid_579891, JString, required = false,
                                 default = nil)
  if valid_579891 != nil:
    section.add "publishedBefore", valid_579891
  var valid_579892 = query.getOrDefault("videoSyndicated")
  valid_579892 = validateParameter(valid_579892, JString, required = false,
                                 default = newJString("any"))
  if valid_579892 != nil:
    section.add "videoSyndicated", valid_579892
  var valid_579893 = query.getOrDefault("videoType")
  valid_579893 = validateParameter(valid_579893, JString, required = false,
                                 default = newJString("any"))
  if valid_579893 != nil:
    section.add "videoType", valid_579893
  var valid_579894 = query.getOrDefault("videoDimension")
  valid_579894 = validateParameter(valid_579894, JString, required = false,
                                 default = newJString("2d"))
  if valid_579894 != nil:
    section.add "videoDimension", valid_579894
  var valid_579895 = query.getOrDefault("regionCode")
  valid_579895 = validateParameter(valid_579895, JString, required = false,
                                 default = nil)
  if valid_579895 != nil:
    section.add "regionCode", valid_579895
  var valid_579896 = query.getOrDefault("fields")
  valid_579896 = validateParameter(valid_579896, JString, required = false,
                                 default = nil)
  if valid_579896 != nil:
    section.add "fields", valid_579896
  var valid_579897 = query.getOrDefault("publishedAfter")
  valid_579897 = validateParameter(valid_579897, JString, required = false,
                                 default = nil)
  if valid_579897 != nil:
    section.add "publishedAfter", valid_579897
  var valid_579898 = query.getOrDefault("videoDuration")
  valid_579898 = validateParameter(valid_579898, JString, required = false,
                                 default = newJString("any"))
  if valid_579898 != nil:
    section.add "videoDuration", valid_579898
  var valid_579899 = query.getOrDefault("maxResults")
  valid_579899 = validateParameter(valid_579899, JInt, required = false,
                                 default = newJInt(5))
  if valid_579899 != nil:
    section.add "maxResults", valid_579899
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579900: Call_YoutubeSearchList_579859; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
  ## 
  let valid = call_579900.validator(path, query, header, formData, body)
  let scheme = call_579900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579900.url(scheme.get, call_579900.host, call_579900.base,
                         call_579900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579900, url, valid)

proc call*(call_579901: Call_YoutubeSearchList_579859; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          forContentOwner: bool = false; forMine: bool = false;
          videoCategoryId: string = ""; order: string = "relevance"; q: string = "";
          videoLicense: string = "any"; onBehalfOfContentOwner: string = "";
          topicId: string = ""; locationRadius: string = "";
          relevanceLanguage: string = ""; videoEmbeddable: string = "any";
          alt: string = "json"; userIp: string = ""; relatedToVideoId: string = "";
          quotaUser: string = ""; videoCaption: string = "any";
          `type`: string = "video,channel,playlist"; pageToken: string = "";
          eventType: string = "completed"; channelId: string = "";
          forDeveloper: bool = false; channelType: string = "any";
          location: string = ""; safeSearch: string = "moderate";
          videoDefinition: string = "any"; publishedBefore: string = "";
          videoSyndicated: string = "any"; videoType: string = "any";
          videoDimension: string = "2d"; regionCode: string = ""; fields: string = "";
          publishedAfter: string = ""; videoDuration: string = "any";
          maxResults: int = 5): Recallable =
  ## youtubeSearchList
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   forContentOwner: bool
  ##                  : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The forContentOwner parameter restricts the search to only retrieve resources owned by the content owner specified by the onBehalfOfContentOwner parameter. The user must be authenticated using a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   forMine: bool
  ##          : The forMine parameter restricts the search to only retrieve videos owned by the authenticated user. If you set this parameter to true, then the type parameter's value must also be set to video.
  ##   videoCategoryId: string
  ##                  : The videoCategoryId parameter filters video search results based on their category. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   order: string
  ##        : The order parameter specifies the method that will be used to order resources in the API response.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more search resource properties that the API response will include. Set the parameter value to snippet.
  ##   q: string
  ##    : The q parameter specifies the query term to search for.
  ## 
  ## Your request can also use the Boolean NOT (-) and OR (|) operators to exclude videos or to find videos that are associated with one of several search terms. For example, to search for videos matching either "boating" or "sailing", set the q parameter value to boating|sailing. Similarly, to search for videos matching either "boating" or "sailing" but not "fishing", set the q parameter value to boating|sailing -fishing. Note that the pipe character must be URL-escaped when it is sent in your API request. The URL-escaped value for the pipe character is %7C.
  ##   videoLicense: string
  ##               : The videoLicense parameter filters search results to only include videos with a particular license. YouTube lets video uploaders choose to attach either the Creative Commons license or the standard YouTube license to each of their videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   topicId: string
  ##          : The topicId parameter indicates that the API response should only contain resources associated with the specified topic. The value identifies a Freebase topic ID.
  ##   locationRadius: string
  ##                 : The locationRadius parameter, in conjunction with the location parameter, defines a circular geographic area.
  ## 
  ## The parameter value must be a floating point number followed by a measurement unit. Valid measurement units are m, km, ft, and mi. For example, valid parameter values include 1500m, 5km, 10000ft, and 0.75mi. The API does not support locationRadius parameter values larger than 1000 kilometers.
  ## 
  ## Note: See the definition of the location parameter for more information.
  ##   relevanceLanguage: string
  ##                    : The relevanceLanguage parameter instructs the API to return search results that are most relevant to the specified language. The parameter value is typically an ISO 639-1 two-letter language code. However, you should use the values zh-Hans for simplified Chinese and zh-Hant for traditional Chinese. Please note that results in other languages will still be returned if they are highly relevant to the search query term.
  ##   videoEmbeddable: string
  ##                  : The videoEmbeddable parameter lets you to restrict a search to only videos that can be embedded into a webpage. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   relatedToVideoId: string
  ##                   : The relatedToVideoId parameter retrieves a list of videos that are related to the video that the parameter value identifies. The parameter value must be set to a YouTube video ID and, if you are using this parameter, the type parameter must be set to video.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   videoCaption: string
  ##               : The videoCaption parameter indicates whether the API should filter video search results based on whether they have captions. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   type: string
  ##       : The type parameter restricts a search query to only retrieve a particular type of resource. The value is a comma-separated list of resource types.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   eventType: string
  ##            : The eventType parameter restricts a search to broadcast events. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   channelId: string
  ##            : The channelId parameter indicates that the API response should only contain resources created by the channel
  ##   forDeveloper: bool
  ##               : The forDeveloper parameter restricts the search to only retrieve videos uploaded via the developer's application or website. The API server uses the request's authorization credentials to identify the developer. Therefore, a developer can restrict results to videos uploaded through the developer's own app or website but not to videos uploaded through other apps or sites.
  ##   channelType: string
  ##              : The channelType parameter lets you restrict a search to a particular type of channel.
  ##   location: string
  ##           : The location parameter, in conjunction with the locationRadius parameter, defines a circular geographic area and also restricts a search to videos that specify, in their metadata, a geographic location that falls within that area. The parameter value is a string that specifies latitude/longitude coordinates e.g. (37.42307,-122.08427).
  ## 
  ## 
  ## - The location parameter value identifies the point at the center of the area.
  ## - The locationRadius parameter specifies the maximum distance that the location associated with a video can be from that point for the video to still be included in the search results.The API returns an error if your request specifies a value for the location parameter but does not also specify a value for the locationRadius parameter.
  ##   safeSearch: string
  ##             : The safeSearch parameter indicates whether the search results should include restricted content as well as standard content.
  ##   videoDefinition: string
  ##                  : The videoDefinition parameter lets you restrict a search to only include either high definition (HD) or standard definition (SD) videos. HD videos are available for playback in at least 720p, though higher resolutions, like 1080p, might also be available. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   publishedBefore: string
  ##                  : The publishedBefore parameter indicates that the API response should only contain resources created before the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   videoSyndicated: string
  ##                  : The videoSyndicated parameter lets you to restrict a search to only videos that can be played outside youtube.com. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoType: string
  ##            : The videoType parameter lets you restrict a search to a particular type of videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoDimension: string
  ##                 : The videoDimension parameter lets you restrict a search to only retrieve 2D or 3D videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return search results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: string
  ##                 : The publishedAfter parameter indicates that the API response should only contain resources created after the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   videoDuration: string
  ##                : The videoDuration parameter filters video search results based on their duration. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_579902 = newJObject()
  add(query_579902, "key", newJString(key))
  add(query_579902, "prettyPrint", newJBool(prettyPrint))
  add(query_579902, "oauth_token", newJString(oauthToken))
  add(query_579902, "forContentOwner", newJBool(forContentOwner))
  add(query_579902, "forMine", newJBool(forMine))
  add(query_579902, "videoCategoryId", newJString(videoCategoryId))
  add(query_579902, "order", newJString(order))
  add(query_579902, "part", newJString(part))
  add(query_579902, "q", newJString(q))
  add(query_579902, "videoLicense", newJString(videoLicense))
  add(query_579902, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579902, "topicId", newJString(topicId))
  add(query_579902, "locationRadius", newJString(locationRadius))
  add(query_579902, "relevanceLanguage", newJString(relevanceLanguage))
  add(query_579902, "videoEmbeddable", newJString(videoEmbeddable))
  add(query_579902, "alt", newJString(alt))
  add(query_579902, "userIp", newJString(userIp))
  add(query_579902, "relatedToVideoId", newJString(relatedToVideoId))
  add(query_579902, "quotaUser", newJString(quotaUser))
  add(query_579902, "videoCaption", newJString(videoCaption))
  add(query_579902, "type", newJString(`type`))
  add(query_579902, "pageToken", newJString(pageToken))
  add(query_579902, "eventType", newJString(eventType))
  add(query_579902, "channelId", newJString(channelId))
  add(query_579902, "forDeveloper", newJBool(forDeveloper))
  add(query_579902, "channelType", newJString(channelType))
  add(query_579902, "location", newJString(location))
  add(query_579902, "safeSearch", newJString(safeSearch))
  add(query_579902, "videoDefinition", newJString(videoDefinition))
  add(query_579902, "publishedBefore", newJString(publishedBefore))
  add(query_579902, "videoSyndicated", newJString(videoSyndicated))
  add(query_579902, "videoType", newJString(videoType))
  add(query_579902, "videoDimension", newJString(videoDimension))
  add(query_579902, "regionCode", newJString(regionCode))
  add(query_579902, "fields", newJString(fields))
  add(query_579902, "publishedAfter", newJString(publishedAfter))
  add(query_579902, "videoDuration", newJString(videoDuration))
  add(query_579902, "maxResults", newJInt(maxResults))
  result = call_579901.call(nil, query_579902, nil, nil, nil)

var youtubeSearchList* = Call_YoutubeSearchList_579859(name: "youtubeSearchList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/search",
    validator: validate_YoutubeSearchList_579860, base: "/youtube/v3",
    url: url_YoutubeSearchList_579861, schemes: {Scheme.Https})
type
  Call_YoutubeSponsorsList_579903 = ref object of OpenApiRestCall_578364
proc url_YoutubeSponsorsList_579905(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSponsorsList_579904(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists sponsors for a channel.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the sponsor resource parts that the API response will include. Supported values are id and snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   filter: JString
  ##         : The filter parameter specifies which channel sponsors to return.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  section = newJObject()
  var valid_579906 = query.getOrDefault("key")
  valid_579906 = validateParameter(valid_579906, JString, required = false,
                                 default = nil)
  if valid_579906 != nil:
    section.add "key", valid_579906
  var valid_579907 = query.getOrDefault("prettyPrint")
  valid_579907 = validateParameter(valid_579907, JBool, required = false,
                                 default = newJBool(true))
  if valid_579907 != nil:
    section.add "prettyPrint", valid_579907
  var valid_579908 = query.getOrDefault("oauth_token")
  valid_579908 = validateParameter(valid_579908, JString, required = false,
                                 default = nil)
  if valid_579908 != nil:
    section.add "oauth_token", valid_579908
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579909 = query.getOrDefault("part")
  valid_579909 = validateParameter(valid_579909, JString, required = true,
                                 default = nil)
  if valid_579909 != nil:
    section.add "part", valid_579909
  var valid_579910 = query.getOrDefault("alt")
  valid_579910 = validateParameter(valid_579910, JString, required = false,
                                 default = newJString("json"))
  if valid_579910 != nil:
    section.add "alt", valid_579910
  var valid_579911 = query.getOrDefault("userIp")
  valid_579911 = validateParameter(valid_579911, JString, required = false,
                                 default = nil)
  if valid_579911 != nil:
    section.add "userIp", valid_579911
  var valid_579912 = query.getOrDefault("quotaUser")
  valid_579912 = validateParameter(valid_579912, JString, required = false,
                                 default = nil)
  if valid_579912 != nil:
    section.add "quotaUser", valid_579912
  var valid_579913 = query.getOrDefault("filter")
  valid_579913 = validateParameter(valid_579913, JString, required = false,
                                 default = newJString("newest"))
  if valid_579913 != nil:
    section.add "filter", valid_579913
  var valid_579914 = query.getOrDefault("pageToken")
  valid_579914 = validateParameter(valid_579914, JString, required = false,
                                 default = nil)
  if valid_579914 != nil:
    section.add "pageToken", valid_579914
  var valid_579915 = query.getOrDefault("fields")
  valid_579915 = validateParameter(valid_579915, JString, required = false,
                                 default = nil)
  if valid_579915 != nil:
    section.add "fields", valid_579915
  var valid_579916 = query.getOrDefault("maxResults")
  valid_579916 = validateParameter(valid_579916, JInt, required = false,
                                 default = newJInt(5))
  if valid_579916 != nil:
    section.add "maxResults", valid_579916
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579917: Call_YoutubeSponsorsList_579903; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists sponsors for a channel.
  ## 
  let valid = call_579917.validator(path, query, header, formData, body)
  let scheme = call_579917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579917.url(scheme.get, call_579917.host, call_579917.base,
                         call_579917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579917, url, valid)

proc call*(call_579918: Call_YoutubeSponsorsList_579903; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          filter: string = "newest"; pageToken: string = ""; fields: string = "";
          maxResults: int = 5): Recallable =
  ## youtubeSponsorsList
  ## Lists sponsors for a channel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the sponsor resource parts that the API response will include. Supported values are id and snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   filter: string
  ##         : The filter parameter specifies which channel sponsors to return.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_579919 = newJObject()
  add(query_579919, "key", newJString(key))
  add(query_579919, "prettyPrint", newJBool(prettyPrint))
  add(query_579919, "oauth_token", newJString(oauthToken))
  add(query_579919, "part", newJString(part))
  add(query_579919, "alt", newJString(alt))
  add(query_579919, "userIp", newJString(userIp))
  add(query_579919, "quotaUser", newJString(quotaUser))
  add(query_579919, "filter", newJString(filter))
  add(query_579919, "pageToken", newJString(pageToken))
  add(query_579919, "fields", newJString(fields))
  add(query_579919, "maxResults", newJInt(maxResults))
  result = call_579918.call(nil, query_579919, nil, nil, nil)

var youtubeSponsorsList* = Call_YoutubeSponsorsList_579903(
    name: "youtubeSponsorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sponsors",
    validator: validate_YoutubeSponsorsList_579904, base: "/youtube/v3",
    url: url_YoutubeSponsorsList_579905, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsInsert_579945 = ref object of OpenApiRestCall_578364
proc url_YoutubeSubscriptionsInsert_579947(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsInsert_579946(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a subscription for the authenticated user's channel.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
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
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579951 = query.getOrDefault("part")
  valid_579951 = validateParameter(valid_579951, JString, required = true,
                                 default = nil)
  if valid_579951 != nil:
    section.add "part", valid_579951
  var valid_579952 = query.getOrDefault("alt")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = newJString("json"))
  if valid_579952 != nil:
    section.add "alt", valid_579952
  var valid_579953 = query.getOrDefault("userIp")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "userIp", valid_579953
  var valid_579954 = query.getOrDefault("quotaUser")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "quotaUser", valid_579954
  var valid_579955 = query.getOrDefault("fields")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "fields", valid_579955
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

proc call*(call_579957: Call_YoutubeSubscriptionsInsert_579945; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a subscription for the authenticated user's channel.
  ## 
  let valid = call_579957.validator(path, query, header, formData, body)
  let scheme = call_579957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579957.url(scheme.get, call_579957.host, call_579957.base,
                         call_579957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579957, url, valid)

proc call*(call_579958: Call_YoutubeSubscriptionsInsert_579945; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## youtubeSubscriptionsInsert
  ## Adds a subscription for the authenticated user's channel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579959 = newJObject()
  var body_579960 = newJObject()
  add(query_579959, "key", newJString(key))
  add(query_579959, "prettyPrint", newJBool(prettyPrint))
  add(query_579959, "oauth_token", newJString(oauthToken))
  add(query_579959, "part", newJString(part))
  add(query_579959, "alt", newJString(alt))
  add(query_579959, "userIp", newJString(userIp))
  add(query_579959, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579960 = body
  add(query_579959, "fields", newJString(fields))
  result = call_579958.call(nil, query_579959, nil, nil, body_579960)

var youtubeSubscriptionsInsert* = Call_YoutubeSubscriptionsInsert_579945(
    name: "youtubeSubscriptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsInsert_579946, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsInsert_579947, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsList_579920 = ref object of OpenApiRestCall_578364
proc url_YoutubeSubscriptionsList_579922(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsList_579921(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns subscription resources that match the API request criteria.
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
  ##   mySubscribers: JBool
  ##                : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in no particular order.
  ##   order: JString
  ##        : The order parameter specifies the method that will be used to sort resources in the API response.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more subscription resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a subscription resource, the snippet property contains other properties, such as a display title for the subscription. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   forChannelId: JString
  ##               : The forChannelId parameter specifies a comma-separated list of channel IDs. The API response will then only contain subscriptions matching those channels.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   channelId: JString
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's subscriptions.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube subscription ID(s) for the resource(s) that are being retrieved. In a subscription resource, the id property specifies the YouTube subscription ID.
  ##   myRecentSubscribers: JBool
  ##                      : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in reverse chronological order (newest first).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's subscriptions.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  section = newJObject()
  var valid_579923 = query.getOrDefault("key")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "key", valid_579923
  var valid_579924 = query.getOrDefault("prettyPrint")
  valid_579924 = validateParameter(valid_579924, JBool, required = false,
                                 default = newJBool(true))
  if valid_579924 != nil:
    section.add "prettyPrint", valid_579924
  var valid_579925 = query.getOrDefault("oauth_token")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = nil)
  if valid_579925 != nil:
    section.add "oauth_token", valid_579925
  var valid_579926 = query.getOrDefault("mySubscribers")
  valid_579926 = validateParameter(valid_579926, JBool, required = false, default = nil)
  if valid_579926 != nil:
    section.add "mySubscribers", valid_579926
  var valid_579927 = query.getOrDefault("order")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = newJString("relevance"))
  if valid_579927 != nil:
    section.add "order", valid_579927
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579928 = query.getOrDefault("part")
  valid_579928 = validateParameter(valid_579928, JString, required = true,
                                 default = nil)
  if valid_579928 != nil:
    section.add "part", valid_579928
  var valid_579929 = query.getOrDefault("forChannelId")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "forChannelId", valid_579929
  var valid_579930 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "onBehalfOfContentOwner", valid_579930
  var valid_579931 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_579931
  var valid_579932 = query.getOrDefault("alt")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = newJString("json"))
  if valid_579932 != nil:
    section.add "alt", valid_579932
  var valid_579933 = query.getOrDefault("userIp")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "userIp", valid_579933
  var valid_579934 = query.getOrDefault("quotaUser")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "quotaUser", valid_579934
  var valid_579935 = query.getOrDefault("pageToken")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "pageToken", valid_579935
  var valid_579936 = query.getOrDefault("channelId")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "channelId", valid_579936
  var valid_579937 = query.getOrDefault("id")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "id", valid_579937
  var valid_579938 = query.getOrDefault("myRecentSubscribers")
  valid_579938 = validateParameter(valid_579938, JBool, required = false, default = nil)
  if valid_579938 != nil:
    section.add "myRecentSubscribers", valid_579938
  var valid_579939 = query.getOrDefault("fields")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "fields", valid_579939
  var valid_579940 = query.getOrDefault("mine")
  valid_579940 = validateParameter(valid_579940, JBool, required = false, default = nil)
  if valid_579940 != nil:
    section.add "mine", valid_579940
  var valid_579941 = query.getOrDefault("maxResults")
  valid_579941 = validateParameter(valid_579941, JInt, required = false,
                                 default = newJInt(5))
  if valid_579941 != nil:
    section.add "maxResults", valid_579941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579942: Call_YoutubeSubscriptionsList_579920; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns subscription resources that match the API request criteria.
  ## 
  let valid = call_579942.validator(path, query, header, formData, body)
  let scheme = call_579942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579942.url(scheme.get, call_579942.host, call_579942.base,
                         call_579942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579942, url, valid)

proc call*(call_579943: Call_YoutubeSubscriptionsList_579920; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          mySubscribers: bool = false; order: string = "relevance";
          forChannelId: string = ""; onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          channelId: string = ""; id: string = ""; myRecentSubscribers: bool = false;
          fields: string = ""; mine: bool = false; maxResults: int = 5): Recallable =
  ## youtubeSubscriptionsList
  ## Returns subscription resources that match the API request criteria.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   mySubscribers: bool
  ##                : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in no particular order.
  ##   order: string
  ##        : The order parameter specifies the method that will be used to sort resources in the API response.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more subscription resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a subscription resource, the snippet property contains other properties, such as a display title for the subscription. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   forChannelId: string
  ##               : The forChannelId parameter specifies a comma-separated list of channel IDs. The API response will then only contain subscriptions matching those channels.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   channelId: string
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's subscriptions.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube subscription ID(s) for the resource(s) that are being retrieved. In a subscription resource, the id property specifies the YouTube subscription ID.
  ##   myRecentSubscribers: bool
  ##                      : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in reverse chronological order (newest first).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's subscriptions.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_579944 = newJObject()
  add(query_579944, "key", newJString(key))
  add(query_579944, "prettyPrint", newJBool(prettyPrint))
  add(query_579944, "oauth_token", newJString(oauthToken))
  add(query_579944, "mySubscribers", newJBool(mySubscribers))
  add(query_579944, "order", newJString(order))
  add(query_579944, "part", newJString(part))
  add(query_579944, "forChannelId", newJString(forChannelId))
  add(query_579944, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579944, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_579944, "alt", newJString(alt))
  add(query_579944, "userIp", newJString(userIp))
  add(query_579944, "quotaUser", newJString(quotaUser))
  add(query_579944, "pageToken", newJString(pageToken))
  add(query_579944, "channelId", newJString(channelId))
  add(query_579944, "id", newJString(id))
  add(query_579944, "myRecentSubscribers", newJBool(myRecentSubscribers))
  add(query_579944, "fields", newJString(fields))
  add(query_579944, "mine", newJBool(mine))
  add(query_579944, "maxResults", newJInt(maxResults))
  result = call_579943.call(nil, query_579944, nil, nil, nil)

var youtubeSubscriptionsList* = Call_YoutubeSubscriptionsList_579920(
    name: "youtubeSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsList_579921, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsList_579922, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsDelete_579961 = ref object of OpenApiRestCall_578364
proc url_YoutubeSubscriptionsDelete_579963(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsDelete_579962(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a subscription.
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
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube subscription ID for the resource that is being deleted. In a subscription resource, the id property specifies the YouTube subscription ID.
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
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579970 = query.getOrDefault("id")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "id", valid_579970
  var valid_579971 = query.getOrDefault("fields")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "fields", valid_579971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579972: Call_YoutubeSubscriptionsDelete_579961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a subscription.
  ## 
  let valid = call_579972.validator(path, query, header, formData, body)
  let scheme = call_579972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579972.url(scheme.get, call_579972.host, call_579972.base,
                         call_579972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579972, url, valid)

proc call*(call_579973: Call_YoutubeSubscriptionsDelete_579961; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## youtubeSubscriptionsDelete
  ## Deletes a subscription.
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
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube subscription ID for the resource that is being deleted. In a subscription resource, the id property specifies the YouTube subscription ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579974 = newJObject()
  add(query_579974, "key", newJString(key))
  add(query_579974, "prettyPrint", newJBool(prettyPrint))
  add(query_579974, "oauth_token", newJString(oauthToken))
  add(query_579974, "alt", newJString(alt))
  add(query_579974, "userIp", newJString(userIp))
  add(query_579974, "quotaUser", newJString(quotaUser))
  add(query_579974, "id", newJString(id))
  add(query_579974, "fields", newJString(fields))
  result = call_579973.call(nil, query_579974, nil, nil, nil)

var youtubeSubscriptionsDelete* = Call_YoutubeSubscriptionsDelete_579961(
    name: "youtubeSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsDelete_579962, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsDelete_579963, schemes: {Scheme.Https})
type
  Call_YoutubeSuperChatEventsList_579975 = ref object of OpenApiRestCall_578364
proc url_YoutubeSuperChatEventsList_579977(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSuperChatEventsList_579976(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Super Chat events for a channel.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the superChatEvent resource parts that the API response will include. Supported values are id and snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  section = newJObject()
  var valid_579978 = query.getOrDefault("key")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "key", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
  var valid_579980 = query.getOrDefault("oauth_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "oauth_token", valid_579980
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579981 = query.getOrDefault("part")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "part", valid_579981
  var valid_579982 = query.getOrDefault("alt")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("json"))
  if valid_579982 != nil:
    section.add "alt", valid_579982
  var valid_579983 = query.getOrDefault("userIp")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "userIp", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("pageToken")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "pageToken", valid_579985
  var valid_579986 = query.getOrDefault("hl")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "hl", valid_579986
  var valid_579987 = query.getOrDefault("fields")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "fields", valid_579987
  var valid_579988 = query.getOrDefault("maxResults")
  valid_579988 = validateParameter(valid_579988, JInt, required = false,
                                 default = newJInt(5))
  if valid_579988 != nil:
    section.add "maxResults", valid_579988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579989: Call_YoutubeSuperChatEventsList_579975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists Super Chat events for a channel.
  ## 
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_YoutubeSuperChatEventsList_579975; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; hl: string = ""; fields: string = ""; maxResults: int = 5): Recallable =
  ## youtubeSuperChatEventsList
  ## Lists Super Chat events for a channel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the superChatEvent resource parts that the API response will include. Supported values are id and snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  var query_579991 = newJObject()
  add(query_579991, "key", newJString(key))
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  add(query_579991, "oauth_token", newJString(oauthToken))
  add(query_579991, "part", newJString(part))
  add(query_579991, "alt", newJString(alt))
  add(query_579991, "userIp", newJString(userIp))
  add(query_579991, "quotaUser", newJString(quotaUser))
  add(query_579991, "pageToken", newJString(pageToken))
  add(query_579991, "hl", newJString(hl))
  add(query_579991, "fields", newJString(fields))
  add(query_579991, "maxResults", newJInt(maxResults))
  result = call_579990.call(nil, query_579991, nil, nil, nil)

var youtubeSuperChatEventsList* = Call_YoutubeSuperChatEventsList_579975(
    name: "youtubeSuperChatEventsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/superChatEvents",
    validator: validate_YoutubeSuperChatEventsList_579976, base: "/youtube/v3",
    url: url_YoutubeSuperChatEventsList_579977, schemes: {Scheme.Https})
type
  Call_YoutubeThumbnailsSet_579992 = ref object of OpenApiRestCall_578364
proc url_YoutubeThumbnailsSet_579994(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeThumbnailsSet_579993(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   videoId: JString (required)
  ##          : The videoId parameter specifies a YouTube video ID for which the custom video thumbnail is being provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579995 = query.getOrDefault("key")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "key", valid_579995
  var valid_579996 = query.getOrDefault("prettyPrint")
  valid_579996 = validateParameter(valid_579996, JBool, required = false,
                                 default = newJBool(true))
  if valid_579996 != nil:
    section.add "prettyPrint", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "onBehalfOfContentOwner", valid_579998
  var valid_579999 = query.getOrDefault("alt")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("json"))
  if valid_579999 != nil:
    section.add "alt", valid_579999
  var valid_580000 = query.getOrDefault("userIp")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "userIp", valid_580000
  var valid_580001 = query.getOrDefault("quotaUser")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "quotaUser", valid_580001
  assert query != nil, "query argument is necessary due to required `videoId` field"
  var valid_580002 = query.getOrDefault("videoId")
  valid_580002 = validateParameter(valid_580002, JString, required = true,
                                 default = nil)
  if valid_580002 != nil:
    section.add "videoId", valid_580002
  var valid_580003 = query.getOrDefault("fields")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "fields", valid_580003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_YoutubeThumbnailsSet_579992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_YoutubeThumbnailsSet_579992; videoId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## youtubeThumbnailsSet
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   videoId: string (required)
  ##          : The videoId parameter specifies a YouTube video ID for which the custom video thumbnail is being provided.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580006 = newJObject()
  add(query_580006, "key", newJString(key))
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580006, "alt", newJString(alt))
  add(query_580006, "userIp", newJString(userIp))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(query_580006, "videoId", newJString(videoId))
  add(query_580006, "fields", newJString(fields))
  result = call_580005.call(nil, query_580006, nil, nil, nil)

var youtubeThumbnailsSet* = Call_YoutubeThumbnailsSet_579992(
    name: "youtubeThumbnailsSet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/thumbnails/set",
    validator: validate_YoutubeThumbnailsSet_579993, base: "/youtube/v3",
    url: url_YoutubeThumbnailsSet_579994, schemes: {Scheme.Https})
type
  Call_YoutubeVideoAbuseReportReasonsList_580007 = ref object of OpenApiRestCall_578364
proc url_YoutubeVideoAbuseReportReasonsList_580009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideoAbuseReportReasonsList_580008(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the videoCategory resource parts that the API response will include. Supported values are id and snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580010 = query.getOrDefault("key")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "key", valid_580010
  var valid_580011 = query.getOrDefault("prettyPrint")
  valid_580011 = validateParameter(valid_580011, JBool, required = false,
                                 default = newJBool(true))
  if valid_580011 != nil:
    section.add "prettyPrint", valid_580011
  var valid_580012 = query.getOrDefault("oauth_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "oauth_token", valid_580012
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580013 = query.getOrDefault("part")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "part", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("userIp")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "userIp", valid_580015
  var valid_580016 = query.getOrDefault("quotaUser")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "quotaUser", valid_580016
  var valid_580017 = query.getOrDefault("hl")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = newJString("en_US"))
  if valid_580017 != nil:
    section.add "hl", valid_580017
  var valid_580018 = query.getOrDefault("fields")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "fields", valid_580018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_YoutubeVideoAbuseReportReasonsList_580007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_YoutubeVideoAbuseReportReasonsList_580007;
          part: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; hl: string = "en_US"; fields: string = ""): Recallable =
  ## youtubeVideoAbuseReportReasonsList
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the videoCategory resource parts that the API response will include. Supported values are id and snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580021 = newJObject()
  add(query_580021, "key", newJString(key))
  add(query_580021, "prettyPrint", newJBool(prettyPrint))
  add(query_580021, "oauth_token", newJString(oauthToken))
  add(query_580021, "part", newJString(part))
  add(query_580021, "alt", newJString(alt))
  add(query_580021, "userIp", newJString(userIp))
  add(query_580021, "quotaUser", newJString(quotaUser))
  add(query_580021, "hl", newJString(hl))
  add(query_580021, "fields", newJString(fields))
  result = call_580020.call(nil, query_580021, nil, nil, nil)

var youtubeVideoAbuseReportReasonsList* = Call_YoutubeVideoAbuseReportReasonsList_580007(
    name: "youtubeVideoAbuseReportReasonsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videoAbuseReportReasons",
    validator: validate_YoutubeVideoAbuseReportReasonsList_580008,
    base: "/youtube/v3", url: url_YoutubeVideoAbuseReportReasonsList_580009,
    schemes: {Scheme.Https})
type
  Call_YoutubeVideoCategoriesList_580022 = ref object of OpenApiRestCall_578364
proc url_YoutubeVideoCategoriesList_580024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideoCategoriesList_580023(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of categories that can be associated with YouTube videos.
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
  ##   part: JString (required)
  ##       : The part parameter specifies the videoCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of video category IDs for the resources that you are retrieving.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return the list of video categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580025 = query.getOrDefault("key")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "key", valid_580025
  var valid_580026 = query.getOrDefault("prettyPrint")
  valid_580026 = validateParameter(valid_580026, JBool, required = false,
                                 default = newJBool(true))
  if valid_580026 != nil:
    section.add "prettyPrint", valid_580026
  var valid_580027 = query.getOrDefault("oauth_token")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "oauth_token", valid_580027
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580028 = query.getOrDefault("part")
  valid_580028 = validateParameter(valid_580028, JString, required = true,
                                 default = nil)
  if valid_580028 != nil:
    section.add "part", valid_580028
  var valid_580029 = query.getOrDefault("alt")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("json"))
  if valid_580029 != nil:
    section.add "alt", valid_580029
  var valid_580030 = query.getOrDefault("userIp")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "userIp", valid_580030
  var valid_580031 = query.getOrDefault("quotaUser")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "quotaUser", valid_580031
  var valid_580032 = query.getOrDefault("id")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "id", valid_580032
  var valid_580033 = query.getOrDefault("regionCode")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "regionCode", valid_580033
  var valid_580034 = query.getOrDefault("hl")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("en_US"))
  if valid_580034 != nil:
    section.add "hl", valid_580034
  var valid_580035 = query.getOrDefault("fields")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "fields", valid_580035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580036: Call_YoutubeVideoCategoriesList_580022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of categories that can be associated with YouTube videos.
  ## 
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_YoutubeVideoCategoriesList_580022; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          id: string = ""; regionCode: string = ""; hl: string = "en_US";
          fields: string = ""): Recallable =
  ## youtubeVideoCategoriesList
  ## Returns a list of categories that can be associated with YouTube videos.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter specifies the videoCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of video category IDs for the resources that you are retrieving.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return the list of video categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580038 = newJObject()
  add(query_580038, "key", newJString(key))
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "part", newJString(part))
  add(query_580038, "alt", newJString(alt))
  add(query_580038, "userIp", newJString(userIp))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "id", newJString(id))
  add(query_580038, "regionCode", newJString(regionCode))
  add(query_580038, "hl", newJString(hl))
  add(query_580038, "fields", newJString(fields))
  result = call_580037.call(nil, query_580038, nil, nil, nil)

var youtubeVideoCategoriesList* = Call_YoutubeVideoCategoriesList_580022(
    name: "youtubeVideoCategoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videoCategories",
    validator: validate_YoutubeVideoCategoriesList_580023, base: "/youtube/v3",
    url: url_YoutubeVideoCategoriesList_580024, schemes: {Scheme.Https})
type
  Call_YoutubeVideosUpdate_580065 = ref object of OpenApiRestCall_578364
proc url_YoutubeVideosUpdate_580067(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosUpdate_580066(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a video's metadata.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a video's privacy setting is contained in the status part. As such, if your request is updating a private video, and the request's part parameter value includes the status part, the video's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the video will revert to the default privacy setting.
  ## 
  ## In addition, not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580068 = query.getOrDefault("key")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "key", valid_580068
  var valid_580069 = query.getOrDefault("prettyPrint")
  valid_580069 = validateParameter(valid_580069, JBool, required = false,
                                 default = newJBool(true))
  if valid_580069 != nil:
    section.add "prettyPrint", valid_580069
  var valid_580070 = query.getOrDefault("oauth_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "oauth_token", valid_580070
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580071 = query.getOrDefault("part")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "part", valid_580071
  var valid_580072 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "onBehalfOfContentOwner", valid_580072
  var valid_580073 = query.getOrDefault("alt")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("json"))
  if valid_580073 != nil:
    section.add "alt", valid_580073
  var valid_580074 = query.getOrDefault("userIp")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "userIp", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("fields")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "fields", valid_580076
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

proc call*(call_580078: Call_YoutubeVideosUpdate_580065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a video's metadata.
  ## 
  let valid = call_580078.validator(path, query, header, formData, body)
  let scheme = call_580078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580078.url(scheme.get, call_580078.host, call_580078.base,
                         call_580078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580078, url, valid)

proc call*(call_580079: Call_YoutubeVideosUpdate_580065; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubeVideosUpdate
  ## Updates a video's metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a video's privacy setting is contained in the status part. As such, if your request is updating a private video, and the request's part parameter value includes the status part, the video's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the video will revert to the default privacy setting.
  ## 
  ## In addition, not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580080 = newJObject()
  var body_580081 = newJObject()
  add(query_580080, "key", newJString(key))
  add(query_580080, "prettyPrint", newJBool(prettyPrint))
  add(query_580080, "oauth_token", newJString(oauthToken))
  add(query_580080, "part", newJString(part))
  add(query_580080, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580080, "alt", newJString(alt))
  add(query_580080, "userIp", newJString(userIp))
  add(query_580080, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580081 = body
  add(query_580080, "fields", newJString(fields))
  result = call_580079.call(nil, query_580080, nil, nil, body_580081)

var youtubeVideosUpdate* = Call_YoutubeVideosUpdate_580065(
    name: "youtubeVideosUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosUpdate_580066, base: "/youtube/v3",
    url: url_YoutubeVideosUpdate_580067, schemes: {Scheme.Https})
type
  Call_YoutubeVideosInsert_580082 = ref object of OpenApiRestCall_578364
proc url_YoutubeVideosInsert_580084(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosInsert_580083(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Uploads a video to YouTube and optionally sets the video's metadata.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   autoLevels: JBool
  ##             : The autoLevels parameter indicates whether YouTube should automatically enhance the video's lighting and color.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   notifySubscribers: JBool
  ##                    : The notifySubscribers parameter indicates whether YouTube should send a notification about the new video to users who subscribe to the video's channel. A parameter value of True indicates that subscribers will be notified of newly uploaded videos. However, a channel owner who is uploading many videos might prefer to set the value to False to avoid sending a notification about each new video to the channel's subscribers.
  ##   stabilize: JBool
  ##            : The stabilize parameter indicates whether YouTube should adjust the video to remove shaky camera motions.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580085 = query.getOrDefault("key")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "key", valid_580085
  var valid_580086 = query.getOrDefault("prettyPrint")
  valid_580086 = validateParameter(valid_580086, JBool, required = false,
                                 default = newJBool(true))
  if valid_580086 != nil:
    section.add "prettyPrint", valid_580086
  var valid_580087 = query.getOrDefault("oauth_token")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "oauth_token", valid_580087
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580088 = query.getOrDefault("part")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "part", valid_580088
  var valid_580089 = query.getOrDefault("autoLevels")
  valid_580089 = validateParameter(valid_580089, JBool, required = false, default = nil)
  if valid_580089 != nil:
    section.add "autoLevels", valid_580089
  var valid_580090 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "onBehalfOfContentOwner", valid_580090
  var valid_580091 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580091
  var valid_580092 = query.getOrDefault("alt")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("json"))
  if valid_580092 != nil:
    section.add "alt", valid_580092
  var valid_580093 = query.getOrDefault("userIp")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "userIp", valid_580093
  var valid_580094 = query.getOrDefault("quotaUser")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "quotaUser", valid_580094
  var valid_580095 = query.getOrDefault("notifySubscribers")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "notifySubscribers", valid_580095
  var valid_580096 = query.getOrDefault("stabilize")
  valid_580096 = validateParameter(valid_580096, JBool, required = false, default = nil)
  if valid_580096 != nil:
    section.add "stabilize", valid_580096
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
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

proc call*(call_580099: Call_YoutubeVideosInsert_580082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a video to YouTube and optionally sets the video's metadata.
  ## 
  let valid = call_580099.validator(path, query, header, formData, body)
  let scheme = call_580099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580099.url(scheme.get, call_580099.host, call_580099.base,
                         call_580099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580099, url, valid)

proc call*(call_580100: Call_YoutubeVideosInsert_580082; part: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          autoLevels: bool = false; onBehalfOfContentOwner: string = "";
          onBehalfOfContentOwnerChannel: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; notifySubscribers: bool = true;
          body: JsonNode = nil; stabilize: bool = false; fields: string = ""): Recallable =
  ## youtubeVideosInsert
  ## Uploads a video to YouTube and optionally sets the video's metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   autoLevels: bool
  ##             : The autoLevels parameter indicates whether YouTube should automatically enhance the video's lighting and color.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   notifySubscribers: bool
  ##                    : The notifySubscribers parameter indicates whether YouTube should send a notification about the new video to users who subscribe to the video's channel. A parameter value of True indicates that subscribers will be notified of newly uploaded videos. However, a channel owner who is uploading many videos might prefer to set the value to False to avoid sending a notification about each new video to the channel's subscribers.
  ##   body: JObject
  ##   stabilize: bool
  ##            : The stabilize parameter indicates whether YouTube should adjust the video to remove shaky camera motions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580101 = newJObject()
  var body_580102 = newJObject()
  add(query_580101, "key", newJString(key))
  add(query_580101, "prettyPrint", newJBool(prettyPrint))
  add(query_580101, "oauth_token", newJString(oauthToken))
  add(query_580101, "part", newJString(part))
  add(query_580101, "autoLevels", newJBool(autoLevels))
  add(query_580101, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580101, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_580101, "alt", newJString(alt))
  add(query_580101, "userIp", newJString(userIp))
  add(query_580101, "quotaUser", newJString(quotaUser))
  add(query_580101, "notifySubscribers", newJBool(notifySubscribers))
  if body != nil:
    body_580102 = body
  add(query_580101, "stabilize", newJBool(stabilize))
  add(query_580101, "fields", newJString(fields))
  result = call_580100.call(nil, query_580101, nil, nil, body_580102)

var youtubeVideosInsert* = Call_YoutubeVideosInsert_580082(
    name: "youtubeVideosInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosInsert_580083, base: "/youtube/v3",
    url: url_YoutubeVideosInsert_580084, schemes: {Scheme.Https})
type
  Call_YoutubeVideosList_580039 = ref object of OpenApiRestCall_578364
proc url_YoutubeVideosList_580041(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosList_580040(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a list of videos that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   myRating: JString
  ##           : Set this parameter's value to like or dislike to instruct the API to only return videos liked or disliked by the authenticated user.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : DEPRECATED
  ##   videoCategoryId: JString
  ##                  : The videoCategoryId parameter identifies the video category for which the chart should be retrieved. This parameter can only be used in conjunction with the chart parameter. By default, charts are not restricted to a particular category.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more video resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a video resource, the snippet property contains the channelId, title, description, tags, and categoryId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxHeight: JInt
  ##            : The maxHeight parameter specifies a maximum height of the embedded player. If maxWidth is provided, maxHeight may not be reached in order to not violate the width request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxWidth: JInt
  ##           : The maxWidth parameter specifies a maximum width of the embedded player. If maxHeight is provided, maxWidth may not be reached in order to not violate the height request.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) that are being retrieved. In a video resource, the id property specifies the video's ID.
  ##   chart: JString
  ##        : The chart parameter identifies the chart that you want to retrieve.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to select a video chart available in the specified region. This parameter can only be used in conjunction with the chart parameter. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  section = newJObject()
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("myRating")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("dislike"))
  if valid_580043 != nil:
    section.add "myRating", valid_580043
  var valid_580044 = query.getOrDefault("prettyPrint")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "prettyPrint", valid_580044
  var valid_580045 = query.getOrDefault("oauth_token")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "oauth_token", valid_580045
  var valid_580046 = query.getOrDefault("locale")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "locale", valid_580046
  var valid_580047 = query.getOrDefault("videoCategoryId")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("0"))
  if valid_580047 != nil:
    section.add "videoCategoryId", valid_580047
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580048 = query.getOrDefault("part")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "part", valid_580048
  var valid_580049 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "onBehalfOfContentOwner", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("userIp")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "userIp", valid_580051
  var valid_580052 = query.getOrDefault("maxHeight")
  valid_580052 = validateParameter(valid_580052, JInt, required = false, default = nil)
  if valid_580052 != nil:
    section.add "maxHeight", valid_580052
  var valid_580053 = query.getOrDefault("quotaUser")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "quotaUser", valid_580053
  var valid_580054 = query.getOrDefault("maxWidth")
  valid_580054 = validateParameter(valid_580054, JInt, required = false, default = nil)
  if valid_580054 != nil:
    section.add "maxWidth", valid_580054
  var valid_580055 = query.getOrDefault("pageToken")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "pageToken", valid_580055
  var valid_580056 = query.getOrDefault("id")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "id", valid_580056
  var valid_580057 = query.getOrDefault("chart")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("mostPopular"))
  if valid_580057 != nil:
    section.add "chart", valid_580057
  var valid_580058 = query.getOrDefault("regionCode")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "regionCode", valid_580058
  var valid_580059 = query.getOrDefault("hl")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "hl", valid_580059
  var valid_580060 = query.getOrDefault("fields")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "fields", valid_580060
  var valid_580061 = query.getOrDefault("maxResults")
  valid_580061 = validateParameter(valid_580061, JInt, required = false,
                                 default = newJInt(5))
  if valid_580061 != nil:
    section.add "maxResults", valid_580061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580062: Call_YoutubeVideosList_580039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of videos that match the API request parameters.
  ## 
  let valid = call_580062.validator(path, query, header, formData, body)
  let scheme = call_580062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580062.url(scheme.get, call_580062.host, call_580062.base,
                         call_580062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580062, url, valid)

proc call*(call_580063: Call_YoutubeVideosList_580039; part: string;
          key: string = ""; myRating: string = "dislike"; prettyPrint: bool = true;
          oauthToken: string = ""; locale: string = ""; videoCategoryId: string = "0";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; maxHeight: int = 0; quotaUser: string = "";
          maxWidth: int = 0; pageToken: string = ""; id: string = "";
          chart: string = "mostPopular"; regionCode: string = ""; hl: string = "";
          fields: string = ""; maxResults: int = 5): Recallable =
  ## youtubeVideosList
  ## Returns a list of videos that match the API request parameters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   myRating: string
  ##           : Set this parameter's value to like or dislike to instruct the API to only return videos liked or disliked by the authenticated user.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : DEPRECATED
  ##   videoCategoryId: string
  ##                  : The videoCategoryId parameter identifies the video category for which the chart should be retrieved. This parameter can only be used in conjunction with the chart parameter. By default, charts are not restricted to a particular category.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more video resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a video resource, the snippet property contains the channelId, title, description, tags, and categoryId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxHeight: int
  ##            : The maxHeight parameter specifies a maximum height of the embedded player. If maxWidth is provided, maxHeight may not be reached in order to not violate the width request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxWidth: int
  ##           : The maxWidth parameter specifies a maximum width of the embedded player. If maxHeight is provided, maxWidth may not be reached in order to not violate the height request.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) that are being retrieved. In a video resource, the id property specifies the video's ID.
  ##   chart: string
  ##        : The chart parameter identifies the chart that you want to retrieve.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to select a video chart available in the specified region. This parameter can only be used in conjunction with the chart parameter. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  var query_580064 = newJObject()
  add(query_580064, "key", newJString(key))
  add(query_580064, "myRating", newJString(myRating))
  add(query_580064, "prettyPrint", newJBool(prettyPrint))
  add(query_580064, "oauth_token", newJString(oauthToken))
  add(query_580064, "locale", newJString(locale))
  add(query_580064, "videoCategoryId", newJString(videoCategoryId))
  add(query_580064, "part", newJString(part))
  add(query_580064, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580064, "alt", newJString(alt))
  add(query_580064, "userIp", newJString(userIp))
  add(query_580064, "maxHeight", newJInt(maxHeight))
  add(query_580064, "quotaUser", newJString(quotaUser))
  add(query_580064, "maxWidth", newJInt(maxWidth))
  add(query_580064, "pageToken", newJString(pageToken))
  add(query_580064, "id", newJString(id))
  add(query_580064, "chart", newJString(chart))
  add(query_580064, "regionCode", newJString(regionCode))
  add(query_580064, "hl", newJString(hl))
  add(query_580064, "fields", newJString(fields))
  add(query_580064, "maxResults", newJInt(maxResults))
  result = call_580063.call(nil, query_580064, nil, nil, nil)

var youtubeVideosList* = Call_YoutubeVideosList_580039(name: "youtubeVideosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosList_580040, base: "/youtube/v3",
    url: url_YoutubeVideosList_580041, schemes: {Scheme.Https})
type
  Call_YoutubeVideosDelete_580103 = ref object of OpenApiRestCall_578364
proc url_YoutubeVideosDelete_580105(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosDelete_580104(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a YouTube video.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube video ID for the resource that is being deleted. In a video resource, the id property specifies the video's ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580106 = query.getOrDefault("key")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "key", valid_580106
  var valid_580107 = query.getOrDefault("prettyPrint")
  valid_580107 = validateParameter(valid_580107, JBool, required = false,
                                 default = newJBool(true))
  if valid_580107 != nil:
    section.add "prettyPrint", valid_580107
  var valid_580108 = query.getOrDefault("oauth_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "oauth_token", valid_580108
  var valid_580109 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "onBehalfOfContentOwner", valid_580109
  var valid_580110 = query.getOrDefault("alt")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = newJString("json"))
  if valid_580110 != nil:
    section.add "alt", valid_580110
  var valid_580111 = query.getOrDefault("userIp")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "userIp", valid_580111
  var valid_580112 = query.getOrDefault("quotaUser")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "quotaUser", valid_580112
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580113 = query.getOrDefault("id")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "id", valid_580113
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580115: Call_YoutubeVideosDelete_580103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a YouTube video.
  ## 
  let valid = call_580115.validator(path, query, header, formData, body)
  let scheme = call_580115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580115.url(scheme.get, call_580115.host, call_580115.base,
                         call_580115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580115, url, valid)

proc call*(call_580116: Call_YoutubeVideosDelete_580103; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## youtubeVideosDelete
  ## Deletes a YouTube video.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube video ID for the resource that is being deleted. In a video resource, the id property specifies the video's ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580117 = newJObject()
  add(query_580117, "key", newJString(key))
  add(query_580117, "prettyPrint", newJBool(prettyPrint))
  add(query_580117, "oauth_token", newJString(oauthToken))
  add(query_580117, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580117, "alt", newJString(alt))
  add(query_580117, "userIp", newJString(userIp))
  add(query_580117, "quotaUser", newJString(quotaUser))
  add(query_580117, "id", newJString(id))
  add(query_580117, "fields", newJString(fields))
  result = call_580116.call(nil, query_580117, nil, nil, nil)

var youtubeVideosDelete* = Call_YoutubeVideosDelete_580103(
    name: "youtubeVideosDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosDelete_580104, base: "/youtube/v3",
    url: url_YoutubeVideosDelete_580105, schemes: {Scheme.Https})
type
  Call_YoutubeVideosGetRating_580118 = ref object of OpenApiRestCall_578364
proc url_YoutubeVideosGetRating_580120(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosGetRating_580119(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) for which you are retrieving rating data. In a video resource, the id property specifies the video's ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580121 = query.getOrDefault("key")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "key", valid_580121
  var valid_580122 = query.getOrDefault("prettyPrint")
  valid_580122 = validateParameter(valid_580122, JBool, required = false,
                                 default = newJBool(true))
  if valid_580122 != nil:
    section.add "prettyPrint", valid_580122
  var valid_580123 = query.getOrDefault("oauth_token")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "oauth_token", valid_580123
  var valid_580124 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "onBehalfOfContentOwner", valid_580124
  var valid_580125 = query.getOrDefault("alt")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("json"))
  if valid_580125 != nil:
    section.add "alt", valid_580125
  var valid_580126 = query.getOrDefault("userIp")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "userIp", valid_580126
  var valid_580127 = query.getOrDefault("quotaUser")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "quotaUser", valid_580127
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580128 = query.getOrDefault("id")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "id", valid_580128
  var valid_580129 = query.getOrDefault("fields")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "fields", valid_580129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580130: Call_YoutubeVideosGetRating_580118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
  ## 
  let valid = call_580130.validator(path, query, header, formData, body)
  let scheme = call_580130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580130.url(scheme.get, call_580130.host, call_580130.base,
                         call_580130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580130, url, valid)

proc call*(call_580131: Call_YoutubeVideosGetRating_580118; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## youtubeVideosGetRating
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) for which you are retrieving rating data. In a video resource, the id property specifies the video's ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580132 = newJObject()
  add(query_580132, "key", newJString(key))
  add(query_580132, "prettyPrint", newJBool(prettyPrint))
  add(query_580132, "oauth_token", newJString(oauthToken))
  add(query_580132, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580132, "alt", newJString(alt))
  add(query_580132, "userIp", newJString(userIp))
  add(query_580132, "quotaUser", newJString(quotaUser))
  add(query_580132, "id", newJString(id))
  add(query_580132, "fields", newJString(fields))
  result = call_580131.call(nil, query_580132, nil, nil, nil)

var youtubeVideosGetRating* = Call_YoutubeVideosGetRating_580118(
    name: "youtubeVideosGetRating", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videos/getRating",
    validator: validate_YoutubeVideosGetRating_580119, base: "/youtube/v3",
    url: url_YoutubeVideosGetRating_580120, schemes: {Scheme.Https})
type
  Call_YoutubeVideosRate_580133 = ref object of OpenApiRestCall_578364
proc url_YoutubeVideosRate_580135(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosRate_580134(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Add a like or dislike rating to a video or remove a rating from a video.
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
  ##   rating: JString (required)
  ##         : Specifies the rating to record.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube video ID of the video that is being rated or having its rating removed.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580136 = query.getOrDefault("key")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "key", valid_580136
  var valid_580137 = query.getOrDefault("prettyPrint")
  valid_580137 = validateParameter(valid_580137, JBool, required = false,
                                 default = newJBool(true))
  if valid_580137 != nil:
    section.add "prettyPrint", valid_580137
  var valid_580138 = query.getOrDefault("oauth_token")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "oauth_token", valid_580138
  assert query != nil, "query argument is necessary due to required `rating` field"
  var valid_580139 = query.getOrDefault("rating")
  valid_580139 = validateParameter(valid_580139, JString, required = true,
                                 default = newJString("dislike"))
  if valid_580139 != nil:
    section.add "rating", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("userIp")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "userIp", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("id")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "id", valid_580143
  var valid_580144 = query.getOrDefault("fields")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "fields", valid_580144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580145: Call_YoutubeVideosRate_580133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a like or dislike rating to a video or remove a rating from a video.
  ## 
  let valid = call_580145.validator(path, query, header, formData, body)
  let scheme = call_580145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580145.url(scheme.get, call_580145.host, call_580145.base,
                         call_580145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580145, url, valid)

proc call*(call_580146: Call_YoutubeVideosRate_580133; id: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; rating: string = "dislike";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## youtubeVideosRate
  ## Add a like or dislike rating to a video or remove a rating from a video.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   rating: string (required)
  ##         : Specifies the rating to record.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube video ID of the video that is being rated or having its rating removed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580147 = newJObject()
  add(query_580147, "key", newJString(key))
  add(query_580147, "prettyPrint", newJBool(prettyPrint))
  add(query_580147, "oauth_token", newJString(oauthToken))
  add(query_580147, "rating", newJString(rating))
  add(query_580147, "alt", newJString(alt))
  add(query_580147, "userIp", newJString(userIp))
  add(query_580147, "quotaUser", newJString(quotaUser))
  add(query_580147, "id", newJString(id))
  add(query_580147, "fields", newJString(fields))
  result = call_580146.call(nil, query_580147, nil, nil, nil)

var youtubeVideosRate* = Call_YoutubeVideosRate_580133(name: "youtubeVideosRate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/videos/rate",
    validator: validate_YoutubeVideosRate_580134, base: "/youtube/v3",
    url: url_YoutubeVideosRate_580135, schemes: {Scheme.Https})
type
  Call_YoutubeVideosReportAbuse_580148 = ref object of OpenApiRestCall_578364
proc url_YoutubeVideosReportAbuse_580150(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosReportAbuse_580149(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Report abuse for a video.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580151 = query.getOrDefault("key")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "key", valid_580151
  var valid_580152 = query.getOrDefault("prettyPrint")
  valid_580152 = validateParameter(valid_580152, JBool, required = false,
                                 default = newJBool(true))
  if valid_580152 != nil:
    section.add "prettyPrint", valid_580152
  var valid_580153 = query.getOrDefault("oauth_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "oauth_token", valid_580153
  var valid_580154 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "onBehalfOfContentOwner", valid_580154
  var valid_580155 = query.getOrDefault("alt")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("json"))
  if valid_580155 != nil:
    section.add "alt", valid_580155
  var valid_580156 = query.getOrDefault("userIp")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "userIp", valid_580156
  var valid_580157 = query.getOrDefault("quotaUser")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "quotaUser", valid_580157
  var valid_580158 = query.getOrDefault("fields")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "fields", valid_580158
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

proc call*(call_580160: Call_YoutubeVideosReportAbuse_580148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report abuse for a video.
  ## 
  let valid = call_580160.validator(path, query, header, formData, body)
  let scheme = call_580160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580160.url(scheme.get, call_580160.host, call_580160.base,
                         call_580160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580160, url, valid)

proc call*(call_580161: Call_YoutubeVideosReportAbuse_580148; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubeVideosReportAbuse
  ## Report abuse for a video.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580162 = newJObject()
  var body_580163 = newJObject()
  add(query_580162, "key", newJString(key))
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580162, "alt", newJString(alt))
  add(query_580162, "userIp", newJString(userIp))
  add(query_580162, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580163 = body
  add(query_580162, "fields", newJString(fields))
  result = call_580161.call(nil, query_580162, nil, nil, body_580163)

var youtubeVideosReportAbuse* = Call_YoutubeVideosReportAbuse_580148(
    name: "youtubeVideosReportAbuse", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/videos/reportAbuse",
    validator: validate_YoutubeVideosReportAbuse_580149, base: "/youtube/v3",
    url: url_YoutubeVideosReportAbuse_580150, schemes: {Scheme.Https})
type
  Call_YoutubeWatermarksSet_580164 = ref object of OpenApiRestCall_578364
proc url_YoutubeWatermarksSet_580166(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeWatermarksSet_580165(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a watermark image to YouTube and sets it for a channel.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   channelId: JString (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580167 = query.getOrDefault("key")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "key", valid_580167
  var valid_580168 = query.getOrDefault("prettyPrint")
  valid_580168 = validateParameter(valid_580168, JBool, required = false,
                                 default = newJBool(true))
  if valid_580168 != nil:
    section.add "prettyPrint", valid_580168
  var valid_580169 = query.getOrDefault("oauth_token")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "oauth_token", valid_580169
  var valid_580170 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "onBehalfOfContentOwner", valid_580170
  var valid_580171 = query.getOrDefault("alt")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = newJString("json"))
  if valid_580171 != nil:
    section.add "alt", valid_580171
  var valid_580172 = query.getOrDefault("userIp")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "userIp", valid_580172
  var valid_580173 = query.getOrDefault("quotaUser")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "quotaUser", valid_580173
  assert query != nil,
        "query argument is necessary due to required `channelId` field"
  var valid_580174 = query.getOrDefault("channelId")
  valid_580174 = validateParameter(valid_580174, JString, required = true,
                                 default = nil)
  if valid_580174 != nil:
    section.add "channelId", valid_580174
  var valid_580175 = query.getOrDefault("fields")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "fields", valid_580175
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

proc call*(call_580177: Call_YoutubeWatermarksSet_580164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a watermark image to YouTube and sets it for a channel.
  ## 
  let valid = call_580177.validator(path, query, header, formData, body)
  let scheme = call_580177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580177.url(scheme.get, call_580177.host, call_580177.base,
                         call_580177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580177, url, valid)

proc call*(call_580178: Call_YoutubeWatermarksSet_580164; channelId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## youtubeWatermarksSet
  ## Uploads a watermark image to YouTube and sets it for a channel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   channelId: string (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being provided.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580179 = newJObject()
  var body_580180 = newJObject()
  add(query_580179, "key", newJString(key))
  add(query_580179, "prettyPrint", newJBool(prettyPrint))
  add(query_580179, "oauth_token", newJString(oauthToken))
  add(query_580179, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580179, "alt", newJString(alt))
  add(query_580179, "userIp", newJString(userIp))
  add(query_580179, "quotaUser", newJString(quotaUser))
  add(query_580179, "channelId", newJString(channelId))
  if body != nil:
    body_580180 = body
  add(query_580179, "fields", newJString(fields))
  result = call_580178.call(nil, query_580179, nil, nil, body_580180)

var youtubeWatermarksSet* = Call_YoutubeWatermarksSet_580164(
    name: "youtubeWatermarksSet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/watermarks/set",
    validator: validate_YoutubeWatermarksSet_580165, base: "/youtube/v3",
    url: url_YoutubeWatermarksSet_580166, schemes: {Scheme.Https})
type
  Call_YoutubeWatermarksUnset_580181 = ref object of OpenApiRestCall_578364
proc url_YoutubeWatermarksUnset_580183(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeWatermarksUnset_580182(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a channel's watermark image.
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
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   channelId: JString (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being unset.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580184 = query.getOrDefault("key")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "key", valid_580184
  var valid_580185 = query.getOrDefault("prettyPrint")
  valid_580185 = validateParameter(valid_580185, JBool, required = false,
                                 default = newJBool(true))
  if valid_580185 != nil:
    section.add "prettyPrint", valid_580185
  var valid_580186 = query.getOrDefault("oauth_token")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "oauth_token", valid_580186
  var valid_580187 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "onBehalfOfContentOwner", valid_580187
  var valid_580188 = query.getOrDefault("alt")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = newJString("json"))
  if valid_580188 != nil:
    section.add "alt", valid_580188
  var valid_580189 = query.getOrDefault("userIp")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "userIp", valid_580189
  var valid_580190 = query.getOrDefault("quotaUser")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "quotaUser", valid_580190
  assert query != nil,
        "query argument is necessary due to required `channelId` field"
  var valid_580191 = query.getOrDefault("channelId")
  valid_580191 = validateParameter(valid_580191, JString, required = true,
                                 default = nil)
  if valid_580191 != nil:
    section.add "channelId", valid_580191
  var valid_580192 = query.getOrDefault("fields")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "fields", valid_580192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580193: Call_YoutubeWatermarksUnset_580181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a channel's watermark image.
  ## 
  let valid = call_580193.validator(path, query, header, formData, body)
  let scheme = call_580193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580193.url(scheme.get, call_580193.host, call_580193.base,
                         call_580193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580193, url, valid)

proc call*(call_580194: Call_YoutubeWatermarksUnset_580181; channelId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## youtubeWatermarksUnset
  ## Deletes a channel's watermark image.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   channelId: string (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being unset.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580195 = newJObject()
  add(query_580195, "key", newJString(key))
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "userIp", newJString(userIp))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(query_580195, "channelId", newJString(channelId))
  add(query_580195, "fields", newJString(fields))
  result = call_580194.call(nil, query_580195, nil, nil, nil)

var youtubeWatermarksUnset* = Call_YoutubeWatermarksUnset_580181(
    name: "youtubeWatermarksUnset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/watermarks/unset",
    validator: validate_YoutubeWatermarksUnset_580182, base: "/youtube/v3",
    url: url_YoutubeWatermarksUnset_580183, schemes: {Scheme.Https})
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
